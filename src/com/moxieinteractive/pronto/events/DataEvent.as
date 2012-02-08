/*
* AJ Savino
*/
package com.moxieinteractive.pronto.events {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class DataEvent extends Event {
		//-=-=-=-=-=-=-=-=-=
		public var data:*;
		//-=-=-=-=-=-=-=-=-=
		
		public function DataEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false){
			super(type, bubbles, cancelable);
			this.data = data;
		}
	}
}