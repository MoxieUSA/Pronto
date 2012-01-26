/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	public interface ISeekable {
		function get playheadPercent():Number;
		function set playheadPercent(value:Number):void;
		function get isSeeking():Boolean;
		
		function seekTo(scale:Number):void;
	}
}