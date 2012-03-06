/*
* AJ Savino
*/
package com.moxieinteractive.pronto.utils {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ObjTracer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const INDENT_SIZE:uint = 4;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function toString(indentSize:int = -1):String {
			if (indentSize == -1){
				indentSize = INDENT_SIZE;
			}
			
			return outlineObject(this, indentSize);
		}
		
		//Returns back a string representation of an objects properties (formated as xml with proper indentations for nested objects) 
		public static function outlineObject(obj:*, indentSize:uint = INDENT_SIZE):String {
			var indent:String = "";
			for (var i:uint = 0; i < indentSize; i++){
				indent += " ";
			}
			
			var className:String = getQualifiedClassName(obj);
			var properties:XMLList = describeType(obj).variable;
			
			var output:String = "<" + className + "\n";
			for each (var variableNode:XML in properties){
				var value:* = obj[variableNode.@name]
				if (value is ObjTracer){
					output += indent + variableNode.@name + "='" + value.toString(indentSize + INDENT_SIZE) + "'" + "\n";
				} else {
					output += indent + variableNode.@name + "='" + value + "'" + "\n";
				}
			}
			output += indent.substr(0, indent.length - INDENT_SIZE) + "/>";
			
			return output;
		}
	}
}