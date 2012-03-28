/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.api {
	public interface IUI {
		function get autoFlow():Boolean;
		function set autoFlow(value:Boolean):void;
		
		function initialize():void;
		function destroy():void;
		function reset():void;
	}
}