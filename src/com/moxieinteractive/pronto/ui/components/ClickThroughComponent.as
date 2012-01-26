/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.components {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIController;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ClickThroughComponent extends UIController {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_URL:String = "http://moxieinteractive.com";	//Update Inspectable definitions as well
		private static const DEFAULT_SCOPE:String = "_blank";						//Update Inspectable definitions as well
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		[Inspectable (name="url", variable="url", type="String", defaultValue="http://moxieinteractive.com")]
		public var url:String = DEFAULT_URL;
		[Inspectable (name="scope", variable="scope", type="String", defaultValue="_blank")]
		public var scope:String = DEFAULT_SCOPE;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ClickThroughComponent(){
			super();
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
		
		protected function handler_mouseClick(evt:MouseEvent):void {
			navigateToURL(new URLRequest(url), scope);
		}
	}
}