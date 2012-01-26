/*
* AJ Savino
*/
package com.moxieinteractive.pronto.net.requests {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.events.ServiceEvent;
	
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLVariables;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ASyncRequest extends EventDispatcher {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const DEFAULT_REQUEST_METHOD:String = URLRequestMethod.POST;
		public static const DEFAULT_REQUEST_CONTENT_TYPE:String = "application/x-www-form-urlencoded";
		
		protected static const LOADER_DATA_FORMAT:String = URLLoaderDataFormat.TEXT;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var serviceURL:String;
		public var serviceCall:String;
		
		public var requestMethod:String;
		public var requestContentType:String;
		
		protected var _request:URLRequest;
		protected var _loader:URLLoader;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ASyncRequest(serviceURL:String = "", serviceCall:String = ""){
			this.serviceURL = serviceURL;
			this.serviceCall = serviceCall;
			
			init();
		}
		
		protected function init():void {
			requestMethod = URLRequestMethod.POST;
			requestContentType = DEFAULT_REQUEST_CONTENT_TYPE;
		}
		
		public function execute(headers:Array = null):void {
			var request:URLRequest = getRequest();
			if (!request){
				throw new Error("Invalid request");
				return;
			}
			if (headers){
				request.requestHeaders = headers;
			}
			
			_loader = getLoader();
			_loader.load(request);
		}
		
		protected function getLoader():URLLoader {
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = LOADER_DATA_FORMAT;
			loader.addEventListener(Event.COMPLETE, handler_execute_success);
			loader.addEventListener(IOErrorEvent.IO_ERROR, handler_execute_error);
			
			return loader;
		}
		
		public function getRequest():URLRequest {
			if (!serviceURL){
				throw new Error("serviceURL is not defined");
				return null;
			}
			if (!serviceCall){
				throw new Error("serviceCall is not defined");
				return null;
			}
			
			return generateRequest();
		}
		
		protected function generateRequest():URLRequest {
			var request:URLRequest = new URLRequest(getRequestURL());
			request.method = requestMethod;
			request.contentType = requestContentType;
			request.data = getRequestData();
			
			return request;
		}
		
		protected function getRequestURL():String {
			return serviceURL + serviceCall;
		}
		
		protected function getRequestData():* {
			return new URLVariables();
		}
		
		protected function parseResponse(response:*):* {
			return response;
		}
		
		private function handler_execute_success(evt:Event):void {
			_loader.removeEventListener(Event.COMPLETE, handler_execute_success);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, handler_execute_error);
			
			var data:*;
			try {
				data = parseResponse(XML(unescape(evt.target.data)));
			} catch (e:Error){
				doError(e);
				return;
			}
			
			dispatchEvent(new ServiceEvent(ServiceEvent.SUCCESS, data));
		}
		
		private function handler_execute_error(evt:IOErrorEvent):void {
			_loader.removeEventListener(Event.COMPLETE, handler_execute_success);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, handler_execute_error);
			
			doError(new Error(evt.text));
		}
		
		protected function doError(e:Error):void {
			dispatchEvent(new ServiceEvent(ServiceEvent.ERROR, e));
		}
		
		override public function toString():String {
			return "ASyncRequest - " + getRequestURL();
		}
	}
}