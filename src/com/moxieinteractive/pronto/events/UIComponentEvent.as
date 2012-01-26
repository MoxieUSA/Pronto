/*
* AJ Savino
*/
package com.moxieinteractive.pronto.events {
	public class UIComponentEvent extends DataEvent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const SCALE_CHANGED:String = "scale_changed";
		public static const STATE_CHANGED:String = "state_changed";
		public static const TEXT_CHANGED:String = "text_changed";
		
		public static const USER_CHANGED_SCALE:String = "user_changed_scale";
		public static const USER_CHANGED_STATE:String = "user_changed_state";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function UIComponentEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false){
			super(type, data, bubbles, cancelable);
		}
	}
}