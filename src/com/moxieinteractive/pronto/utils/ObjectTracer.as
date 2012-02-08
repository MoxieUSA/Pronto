/*
* AJ Savino
*/
package com.moxieinteractive.pronto.utils {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ObjectTracer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const INDENT_SIZE:uint = ObjUtil.OUTLINE_INDENT_SIZE;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
		public function toString(indentSize:int = -1):String {
			if (indentSize == -1){
				indentSize = INDENT_SIZE;
			}
			
			return ObjUtil.outlineObject(this, indentSize);
		}
	}
}