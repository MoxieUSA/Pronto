/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.core {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IUI;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class UIMovieClip extends MovieClip implements IUI {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_AUTO_FLOW:Boolean = true;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _invalidatedProps:Array;		//Array containing string values of properties that have been invalidated
		protected var _autoFlow:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get autoFlow():Boolean {
			return _autoFlow;
		}
		public function set autoFlow(value:Boolean):void {
			_autoFlow = value;
			if (_autoFlow){
				if (!stage){
					addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage, false, 1, true);
				} else {
					addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage, false, 1, true);
				}
			} else {
				removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			}
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function UIMovieClip(){
			autoFlow = DEFAULT_AUTO_FLOW;
			
			init();
			
			if (_autoFlow && stage){
				handler_addedToStage();
			}
		}
		
		protected function init():void {
			if (!_invalidatedProps){
				_invalidatedProps = new Array();
			}
		}
		
		public function initialize():void {
			if (!_invalidatedProps){
				_invalidatedProps = new Array();
			}
		}
		
		public function destroy():void {
			_invalidatedProps = null;
		}
		
		public function reset():void {
			destroy();
			initialize();
		}
		
		protected function handler_addedToStage(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			
			initialize();
		}
		
		protected function handler_removedFromStage(evt:Event = null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			
			destroy();
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