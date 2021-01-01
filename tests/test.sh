#!/usr/bin/env php
<?php

include __DIR__ . '/../src/Convertor.php';
include __DIR__ . '/../src/Helper.php';

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

$expected = [
  'show' => [
    [
      'dog' => 'Brian',
      'kid' => [
        'Chris',
        'Meg',
        '<em>Stewie</em>',
      ],
      '@attributes' => [
        'name' => 'Family Guy',
      ],
    ],
    [
      'pet' => [
        '@content' => 'Klaus',
        '@attributes' => [
          'type' => 'fish',
        ],
      ],
      'alien' => [
        'persona' => [
          'Roger Smith',
          'Sidney Huffman',
        ],
        '@attributes' => [
          'nick' => 'The Decider',
        ],
      ],
      '@attributes' => [
        'name' => 'American Dad!',
      ],
    ],
    [
      'empty' => '',
      'foo' => [
        '@attributes' => [
          'empty' => '',
        ],
      ],
      'zero' => '0',
      '@attributes' => [
        'name' => 'Edge Cases',
        'zero' => '0',
        'empty' => '',
      ],
    ],
  ],
  '@attributes' => [
    'type' => 'cartoon',
  ],
  '@root' => 'tv',
];

$result = \Gaarf\XmlToPhp\Convertor::covertToArray($xmlstr);

if ($result === $expected) {
	prettyPrint('Result', 'SUCCESS :-)');
} else {
	prettyPrint('Result', 'FAILURE :-(');
	prettyPrint('Input', $xmlstr);
  prettyPrint('Expected', $expected);
  prettyPrint('Output', $result);
	prettyPrint('Result', 'FAILURE :-(');
  exit(1);
}
