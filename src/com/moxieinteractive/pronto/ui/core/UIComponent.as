/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.core {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IUIComponent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class UIComponent extends UIMovieClip implements IUIComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_AUTO_ACTIVATE:Boolean = true;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _autoActivate:Boolean;			//Setting autoActivate to true will cause the component to activate/deactivate as soon as it is added/removed from stage
		protected var _enabled:Boolean;				//Getter/Setter for activate/deactivate
		
		protected var _isDynamic:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get autoActivate():Boolean {
			return _autoActivate;
		}
		public function set autoActivate(value:Boolean):void {
			_autoActivate = value;
			if (_autoActivate){
				if (!stage){
					addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
				} else {
					addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
				}
			} else {
				removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
				removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			}
		}
		
		override public function get enabled():Boolean {
			return _enabled;
		}
		override public function set enabled(value:Boolean):void { //The _enabled property will be set in one of the functions below
			if (value){
				activate();
			} else {
				deactivate();
			}
		}
		
		public function get isDynamic():Boolean {
			return _isDynamic;
		}
		public function set isDynamic(value:Boolean):void {
			_isDynamic = value;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function UIComponent(){
			autoActivate = DEFAULT_AUTO_ACTIVATE;
			
			super();
			
			if (_autoActivate && stage){
				handler_addedToStage();
			}
		}
		
		override public function init():void {
			super.init();
		}
		
		override public function destroy():void {
			deactivate();
			
			super.destroy();
		}
		
		protected function handler_addedToStage(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			
			activate();
		}
		
		protected function handler_removedFromStage(evt:Event = null):void {
			removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			
			destroy();
		}
		
		public function activate():Boolean {
			if (_enabled){
				return false;
			}
			_enabled = true;
			
			return true;
		}
		
		public function deactivate():Boolean {
			if (!_enabled){
				return false;
			}
			_enabled = false;
			
			return true;
		}
	}
}