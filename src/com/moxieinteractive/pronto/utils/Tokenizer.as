/*
* AJ Savino
*/
package com.moxieinteractive.pronto.utils {
	public class Tokenizer {
		/*
		* @description - Takes in a source and an object composed of dynamic name/value pairs. A replace is then performed on the source to replace all object names with the coorsponding values
		*
		* @param source - Either an XMLList, XML, or String. Anything else will just be returned
		* @param tokens - An object consisting of dynamic name/value pairs to replace the name with the value
		*
		* @returns - The replaced source (same type as source)
		*/
		public static function replaceTokens(source:*, tokens:Object, preRegEx:String = "", postRegEx:String = "", flags:String = "g"):* {
			var typeOfSource:Class;
			var sourceAsString:String;
			
			if (source is XMLList){
				typeOfSource = XMLList;
				sourceAsString = source.toXMLString();
			} else if (source is XML){
				typeOfSource = XML;
				sourceAsString = source.toXMLString();
			} else if (source is String){
				typeOfSource = String;
				sourceAsString = source;
			} else {
				return source;
			}
			
			var replacedSource:String = sourceAsString;
			for (var prop:String in tokens){
				replacedSource = replacedSource.replace(new RegExp(preRegEx + prop + postRegEx, flags), tokens[prop]);
			}
			
			return new typeOfSource(replacedSource);
		}
	}
}