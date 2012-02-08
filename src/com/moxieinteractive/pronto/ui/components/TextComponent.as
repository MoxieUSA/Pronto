/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.components {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIController;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class TextComponent extends UIController {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _text:String;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get text():String {
			return _text;
		}
		public function set text(value:String):void {
			_text = value;
			invalidateProperty("text");
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function TextComponent(){
			super();
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid("text")){
				render();
				dispatchEvent(new UIComponentEvent(UIComponentEvent.TEXT_CHANGED, _text));
			}
			
			super.commitProperties();
		}
		
		public function render():void {
			//Override
		}
	}
}