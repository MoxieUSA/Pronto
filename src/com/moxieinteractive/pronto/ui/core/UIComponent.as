/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.core {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IUIComponent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class UIComponent extends UIMovieClip implements IUIComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_AUTO_ACTIVATE:Boolean = true;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _autoActivate:Boolean;			//Setting autoActivate to true will cause the component to activate/deactivate as soon as it is added/removed from stage
		protected var _enabled:Boolean;				//Getter/Setter for activate/deactivate
		
		protected var _isDynamic:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get autoActivate():Boolean {
			return _autoActivate;
		}
		public function set autoActivate(value:Boolean):void {
			_autoActivate = value;
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
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function UIComponent(){
			autoActivate = DEFAULT_AUTO_ACTIVATE;
			
			super();
		}
		
		override public function initialize():void {
			super.initialize();
			
			if (_autoActivate){
				activate();
			}
		}
		
		override public function destroy():void {
			if (_autoActivate){
				deactivate();
			}
			
			super.destroy();
		}
		
		override public function reset():void {
			destroy();
			initialize();
		}
		
		public function activate():Boolean {
			if (_enabled || !stage){
				return false;
			}
			_enabled = true;
			
			return true;
		}
		
		public function deactivate():Boolean {
			if (!_enabled || !stage){
				return false;
			}
			_enabled = false;
			
			return true;
		}
	}
}