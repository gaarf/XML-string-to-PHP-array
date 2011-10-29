One common need when working in PHP is a way to convert an XML document
into a serializable array. If you ever tried to serialize() and then
unserialize() a SimpleXML or DOMDocument object, you know what I’m
talking about.

Assume the following XML snippet:

> <tv\> <show name=“Family Guy”\> <dog\>Brian</dog\> <kid\>Chris</kid\>
> <kid\>Meg</kid\> </show\> </tv\>

There’s a quick and dirty way to do convert such a document to an array,
using type casting and the JSON functions to ensure there are no exotic
values that would cause problems when unserializing:

    <?php
      $a = json_decode(json_encode((array) simplexml_load_string($s)),1);
    ?>

Here is the result for our sample XML, eg if we `print_r($a)`:

    Array
    (
        [show] => Array
            (
                [@attributes] => Array
                    (
                        [name] => Family Guy
                    )
                [dog] => Brian
                [kid] => Array
                    (
                        [0] => Chris
                        [1] => Meg
                    )
            )
    )

Pretty nifty, eh? But maybe we want to embed some HTML tags or something
crazy along those lines. then we need a CDATA node…

> <tv\> <show name=“Family Guy”\> <dog\>Brian</dog\> <kid\>Chris</kid\>
> <kid\>Meg</kid\> <kid\><![CDATA[<em\>Stewie</em\>]]\></kid\> </show\>
> </tv\>

The snippet of XML above would yield the following:

    Array
    (
        [show] => Array
            (
                [@attributes] => Array
                    (
                        [name] => Family Guy
                    )
                [dog] => Brian
                [kid] => Array
                    (
                        [0] => Chris
                        [1] => Meg
                        [2] => Array
                            (
                            )
                    )
            )
    )

That’s not very useful. We got in trouble because the CDATA node, a
SimpleXMLElement, is being cast to an array instead of a string. To
handle this case while still keeping the nice @attributes notation, we
need a slightly more verbose conversion function. This is my version,
hereby released under a do-whatever-but-dont-sue-me license.

The result, for our *Stewie* snippet:

    Array
    (
        [show] => Array
            (
                [@attributes] => Array
                    (
                        [name] => Family Guy
                    )
                [dog] => Brian
                [kid] => Array
                    (
                        [0] => Chris
                        [1] => Meg
                        [2] => <em>Stewie</em>
                    )
            )
    )

Victory is mine! :D
