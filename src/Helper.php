<?php

declare(strict_types=1);

namespace Gaarf\XmlToPhp;


class Helper
{

	/**
	 * @param \DOMElement $node
	 * @return array|string
	 */
	public static function domNodeToArray($node)
	{
		$output = [];
		switch ($node->nodeType) {
			case 4: // XML_CDATA_SECTION_NODE
			case 3: // XML_TEXT_NODE
				$output = trim($node->textContent);
				break;
			case 1: // XML_ELEMENT_NODE
				for ($i = 0, $m = $node->childNodes->length; $i < $m; $i++) {
					$child = $node->childNodes->item($i);
					$v = self::domNodeToArray($child);
					if (isset($child->tagName)) {
						$t = $child->tagName;
						if (!isset($output[$t])) {
							$output[$t] = [];
						}
						$output[$t][] = $v;
					} elseif ($v || $v === '0') {
						$output = (string) $v;
					}
				}
				if ($node->attributes->length && !is_array($output)) { // has attributes but isn't an array
					$output = ['@content' => $output]; // change output into an array.
				}
				if (is_array($output)) {
					if ($node->attributes->length) {
						$a = [];
						foreach ($node->attributes as $attrName => $attrNode) {
							$a[$attrName] = (string) $attrNode->value;
						}
						$output['@attributes'] = $a;
					}
					foreach ($output as $t => $v) {
						if ($t !== '@attributes' && is_array($v) && count($v) === 1) {
							$output[$t] = $v[0];
						}
					}
				}
				break;
		}

		return $output;
	}


}