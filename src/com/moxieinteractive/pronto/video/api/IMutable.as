/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	public interface IMutable {
		function get isMuted():Boolean;
		
		function mute():void;
		function unmute():void;
	}
}