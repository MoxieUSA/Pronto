/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IUIComponent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public interface IVideoPlayer extends IVideoScreen, IControlBar {
		function get autoHideControls():Boolean
		function set autoHideControls(value:Boolean):void;
		
		function autoSize():void;
	}
}