/*
* AJ Savino
*/
package com.moxieinteractive.pronto.events {
	public class EndlessScrollerEvent extends RendererEvent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const CYCLE_COMPLETE:String = "cycle_complete";
		public static const BEGIN_SELECT:String = "begin_select";
		public static const END_SELECT:String = "end_select";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function EndlessScrollerEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false){
			super(type, data, bubbles, cancelable);
		}
	}
}