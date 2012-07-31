#!/usr/bin/env php
<?php

include("xmlstr_to_array.php");

function prettyPrint($title, $thing)
{
  echo "\n-- $title: ---------------------------------------------\n";
  print_r($thing);
  echo "\n";
}

$xmlstr = <<<EOD
  <tv type="cartoon">
    <show name="Family Guy">
      <dog>Brian</dog>
      <kid>Chris</kid>
      <kid>Meg</kid>
      <kid><![CDATA[<em>Stewie</em>]]></kid>
    </show>
    <show name="American Dad!">
      <pet type="fish">Klaus</pet>
      <alien nick="The Decider">
        <persona>Roger Smith</persona>
        <persona>Sidney Huffman</persona>
      </alien>
    </show>
    <show name="Edge Cases" zero="0" empty="">
      <empty></empty>
      <foo empty=""></foo>
      <zero>0</zero>
    </show>
  </tv>
EOD;

$expected = array(

  "@root" => 'tv',

  "@attributes" => array( "type" => "cartoon" ),

  "show" => array(

    array(
      "dog" => 'Brian',
      "kid" => array(
        "Chris",
        "Meg",
        "<em>Stewie</em>"
      ),
      "@attributes" => array( "name" => "Family Guy" )
    ),

    array(
      'pet' => array(
        "@content" => 'Klaus',
        "@attributes" => array( "type" => "fish" )
      ),
      'alien' => array(
        'persona' => array(
          'Roger Smith',
          'Sidney Huffman'
        ),
        "@attributes" => array( "nick" => "The Decider" )
      ),
      "@attributes" => array( "name" => "American Dad!" )
    ),

    array(
      "empty" => array(),
      "foo" => array(
        "@attributes" => array( 
          "empty" => ""
        )
      ),
      "zero" => "0",
      "@attributes" => array( 
        "name" => "Edge Cases",
        "empty" => "",
        "zero" => "0"
      )
    )

  )
);

$result = xmlstr_to_array($xmlstr);


prettyPrint("Input", $xmlstr);
prettyPrint("Expected", $expected);
prettyPrint("Output", $result);
prettyPrint("Result", $result == $expected ? "SUCCESS :-)" : "FAILURE :-(");
