<?php

declare(strict_types=1);

namespace Gaarf\XmlToPhp;


class Convertor
{

	/**
	 * Convert xml string to php array - useful to get a serializable value.
	 *
	 * @author Adrien aka Gaarf & contributors
	 * @see http://gaarf.info/2009/08/13/xml-string-to-php-array/
	 *
	 * @param string $xml
	 * @return mixed[]
	 */
	public static function covertToArray(string $xml): array
	{
		assert(\class_exists('\DOMDocument'));
		$doc = new \DOMDocument();
		$doc->loadXML($xml);
		$root = $doc->documentElement;
		$output = (array) Helper::domNodeToArray($root);
		$output['@root'] = $root->tagName;

		return $output ?? [];
	}

}