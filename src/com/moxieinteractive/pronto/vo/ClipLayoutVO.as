/*
* AJ Savino
*/
package com.moxieinteractive.pronto.vo {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.MovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ClipLayoutVO extends VO {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var clip:MovieClip;			//The clip that the properties reference
		public var xFromLeft:Number;		//The x position from the left edge of the control to the left edge of the control bar
		public var xFromRight:Number;		//The x position from the right edge of the control to the right edge of the control bar
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	}
}