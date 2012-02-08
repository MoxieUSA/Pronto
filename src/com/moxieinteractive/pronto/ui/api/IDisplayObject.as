/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.api {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public interface IDisplayObject extends IEventDispatcher {
		function get x():Number;
		function set x(value:Number):void;
		function get y():Number;
		function set y(value:Number):void;
		function get width():Number;
		function set width(value:Number):void;
		function get height():Number;
		function set height(value:Number):void;
		function get alpha():Number;
		function set alpha(value:Number):void;
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		function get mask():DisplayObject;
		function set mask(value:DisplayObject):void;
		function get mouseChildren():Boolean;
		function set mouseChildren(value:Boolean):void;
		function get filters():Array;
		function set filters(value:Array):void;
	}
}