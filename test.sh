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
  <tv>
    <show name="Family Guy">
      <dog type="beagle">Brian</dog>
      <kid>Chris</kid>
      <kid>Meg</kid>
      <kid><![CDATA[<em>Stewie</em>]]></kid>
    </show>
    <show name="Edge Cases" zero="0" empty="">
      <empty></empty>
      <foo empty=""></foo>
      <zero>0</zero>
    </show>
  </tv>
EOD;

$expected = array(
  "show" => array(

    array(
      "dog" => array(
      	array(
				"dog"=>"Brian",
				"@attributes" => array(
					"type"=>"beagle"
				)
			)
	  ),
      "kid" => array(
        "Chris",
        "Meg",
        "<em>Stewie</em>"
      ),
      "@attributes" => array( "name" => "Family Guy" )
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
