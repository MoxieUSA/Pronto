/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	public interface IAudible extends IMutable {
		function get volume():Number;
		function set volume(value:Number):void;
		
		function setVolume(scale:Number):void;
	}
}