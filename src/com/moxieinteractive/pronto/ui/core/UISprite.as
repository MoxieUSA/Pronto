/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.core {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IUI;
	
	import flash.display.Sprite;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class UISprite extends Sprite implements IUI {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _invalidatedProps:Array;		//Array containing string values of properties that have been invalidated
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function UISprite(){
			init();
		}
		
		public function init():void {
			if (!_invalidatedProps){
				_invalidatedProps = new Array();
			}
		}
		
		public function destroy():void {
			_invalidatedProps = null;
		}
		
		public function reset():void {
			destroy();
			init();
		}
		
		protected function invalidateProperty(prop:String):void {
			if (_invalidatedProps.indexOf(prop) == -1){
				_invalidatedProps.push(prop);
				validateNow();
			}
		}
		
		protected function validateProperty(prop:String):void {
			var index:int = _invalidatedProps.indexOf(prop);
			if (index != -1){
				_invalidatedProps.splice(index, 1);
				validateNow();
			}
		}
		
		protected function validateNow():Boolean {
			if (_invalidatedProps && _invalidatedProps.length){ //Invalid
				addEventListener(Event.ENTER_FRAME, handler_validation_enterFrame, false, 1, true);
				return false;
			} else { //Valid
				removeEventListener(Event.ENTER_FRAME, handler_validation_enterFrame);
				return true;
			}
		}
		
		protected function isPropertyValid(prop:String):Boolean {
			if (_invalidatedProps.indexOf(prop) != -1){
				return false;
			}
			
			return true;
		}
		
		protected function validateAll():void {
			while (_invalidatedProps.length){
				_invalidatedProps.shift();
			}
			validateNow();
		}
		
		protected function commitProperties():void {
			validateAll();
		}
		
		protected function handler_validation_enterFrame(evt:Event):void {
			if (!validateNow()){
				commitProperties();
			}
		}
	}
}