/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.core {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IUIController;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class UIController extends UIComponent implements IUIController {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _controlled:IUIControllable;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get controlled():IUIControllable {
			return _controlled;
		}
		
		public function set controlled(value:IUIControllable):void {
			issueControl(value);
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function UIController(){
			super();
		}
		
		override public function destroy():void {
			revokeControl();
			
			super.destroy();
		}
		
		public function issueControl(controlled:IUIControllable):Boolean {
			revokeControl();
			
			_controlled = controlled;
			if (!_controlled){
				return false;
			}
			
			return true;
		}
		
		public function revokeControl():Boolean {
			if (!_controlled){
				return false;
			}
			
			return true;
		}
	}
}