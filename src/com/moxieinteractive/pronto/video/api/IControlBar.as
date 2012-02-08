/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	public interface IControlBar {
		function get controlBarLocation():String;
		function set controlBarLocation(value:String):void;
		function get autoSpaceControls():Boolean;
		function set autoSpaceControls(value:Boolean):void;
		
		function showControls(timing:Number = NaN, delay:Number = NaN):void;
		function hideControls(timing:Number = NaN, delay:Number = NaN):void;
		function layoutControls():void;
	}
}