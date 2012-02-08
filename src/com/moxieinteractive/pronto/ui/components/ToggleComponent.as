/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.components {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIController;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ToggleComponent extends UIController {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_STATE:Boolean = false;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const LABEL_ON:String = "on";
		public static const LABEL_OFF:String = "off";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _state:Boolean;
		protected var _userInteraction:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get state():Boolean {
			return _state;
		}
		public function set state(value:Boolean):void {
			_state = value;
			invalidateProperty("state");
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ToggleComponent(){
			super();
		}
		
		override public function init():void {
			super.init();
			
			_state = DEFAULT_STATE;
			_userInteraction = false;
		}
		
		override public function activate():Boolean {
			if (!super.activate()){
				return false;
			}
			buttonMode = true;
			useHandCursor = true;
			addEventListener(MouseEvent.CLICK, handler_mouseClick, false, 1, true);
			
			return true;
		}
		
		override public function deactivate():Boolean {
			if (!super.deactivate()){
				return false;
			}
			buttonMode = false;
			useHandCursor = false;
			removeEventListener(MouseEvent.CLICK, handler_mouseClick);
			
			return true;
		}
		
		public function render():void {
			if (_state){
				gotoAndStop(LABEL_ON);
			} else {
				gotoAndStop(LABEL_OFF);
			}
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid("state")){
				render();
				if (_userInteraction){
					dispatchEvent(new UIComponentEvent(UIComponentEvent.USER_CHANGED_STATE, _state));
					_userInteraction = false;
				}
				dispatchEvent(new UIComponentEvent(UIComponentEvent.STATE_CHANGED, _state));
			}
			
			super.commitProperties();
		}
		
		protected function handler_mouseClick(evt:MouseEvent):void {
			_userInteraction = true;
			toggle();
		}
		
		public function toggle():void {
			state = Boolean(!state);
		}
	}
}