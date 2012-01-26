/*
* AJ Savino
*/
package com.moxieinteractive.pronto.renderers.api {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IMovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public interface IRenderer extends IMovieClip {
		function get data():*;
		function set data(value:*):void;
		function get defaultData():*;
		
		function render():void;
	}
}