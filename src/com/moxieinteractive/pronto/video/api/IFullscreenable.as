/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	public interface IFullscreenable {
		function get isFullscreen():Boolean;
		function set isFullscreen(value:Boolean):void;
		
		function enterFullscreen():void;
		function exitFullscreen():void;
	}
}