/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.api {
	public interface IUIComponent extends IMovieClip, IUI {
		function get autoActivate():Boolean;
		function set autoActivate(value:Boolean):void;
		function get enabled():Boolean;
		function set enabled(value:Boolean):void;
		function get isDynamic():Boolean;
		function set isDynamic(value:Boolean):void;
		
		function activate():Boolean;
		function deactivate():Boolean;
	}
}