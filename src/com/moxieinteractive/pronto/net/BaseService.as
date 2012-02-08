/*
* AJ Savino
*/
package com.moxieinteractive.pronto.net {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.net.requests.ASyncRequest;
	import com.moxieinteractive.pronto.events.ServiceEvent;
	
	import flash.events.EventDispatcher;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class BaseService extends EventDispatcher {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _requestQueue:Array;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function BaseService(){
			init();
		}
		
		protected function init():void {
			_requestQueue = new Array();
		}
		
		protected function queueRequest(request:ASyncRequest, topPriority:Boolean = false):void {
			if (!topPriority){
				_requestQueue.push(request);
			} else {
				_requestQueue.unshift(request);
			}
			
			if (_requestQueue.length == 1 || topPriority){
				queueNextRequest();
			}
		}
		
		protected function queueNextRequest():void {
			if (!_requestQueue.length){
				return;
			}
			
			var request:ASyncRequest = _requestQueue.shift();
			request.addEventListener(ServiceEvent.SUCCESS, handler_success);
			request.addEventListener(ServiceEvent.ERROR, handler_error);
			request.execute();
		}
		
		protected function handler_success(evt:ServiceEvent):void {
			var request:ASyncRequest = evt.target as ASyncRequest;
			request.removeEventListener(ServiceEvent.SUCCESS, handler_success);
			request.removeEventListener(ServiceEvent.ERROR, handler_error);
			
			queueNextRequest();
		}
		
		protected function handler_error(evt:ServiceEvent):void {
			var request:ASyncRequest = evt.target as ASyncRequest;
			request.removeEventListener(ServiceEvent.SUCCESS, handler_success);
			request.removeEventListener(ServiceEvent.ERROR, handler_error);
			
			queueNextRequest();
		}
	}
}