/*
* AJ Savino
*/
package events {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.events.DataEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class MVPJSEvent extends DataEvent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const READY:String = "ready";
		public static const TRACKING:String = "tracking";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function MVPJSEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false){
			super(type, data, bubbles, cancelable);
		}
	}
}