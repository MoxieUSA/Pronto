/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.api {
	public interface ISprite extends IDisplayObject, IUI {
		function get buttonMode():Boolean;
		function set buttonMode(value:Boolean):void;
		function get useHandCursor():Boolean;
		function set useHandCursor(value:Boolean):void;
		function get mouseEnabled():Boolean;
		function set mouseEnabled(value:Boolean):void;
	}
}