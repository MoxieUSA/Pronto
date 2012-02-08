/*
* AJ Savino
*/
package com.moxieinteractive.pronto.events {
	public class ServiceEvent extends DataEvent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const SUCCESS:String = "success";
		public static const ERROR:String = "error";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ServiceEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false){
			super(type, data, bubbles, cancelable);
		}
	}
}