/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	public interface IPlayable {
		function get isPlayingBack():Boolean;
		function get isPaused():Boolean;
		
		function play():void;
		function pause():void;
		function resume():void;
		function stop():void;
	}
}