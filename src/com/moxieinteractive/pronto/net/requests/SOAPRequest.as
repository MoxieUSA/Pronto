/*
* AJ Savino
*/
package com.moxieinteractive.pronto.net.requests {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.utils.Tokenizer;
	
	import flash.net.URLRequestHeader;
	import flash.net.URLRequest;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class SOAPRequest extends ASyncRequest {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const TOKEN_XMLNS_SOAPENV:String = "{TOKEN_XMLNS_SOAPENV}";
		public static const TOKEN_XMLNS_DEFAULT:String = "{TOKEN_XMLNS_DEFAULT}";
		public static const TOKEN_XMLNS_ACTION:String = "{TOKEN_XMLNS_ACTION}";
		public static const TOKEN_ADDITIONAL_NAMESPACES:String = "{TOKEN_ADDITIONAL_NAMESPACES}";
		public static const TOKEN_BODY_CONTENT:String = "{TOKEN_BODY_CONTENT}";
		
		protected static const REQUEST_CONTENT_TYPE:String = "text/xml; charset=utf-8";
		
		protected static const XMLNS_SOAPENV:String = "http://schemas.xmlsoap.org/soap/envelope/";
		
		protected static const XMLNS_DEFAULT:String = "moxie";
		protected static const ACTION_HEADER_DEFAULT:String = "http://moxieinteractive.com";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var defaultNamespace:String;
		public var actionHeader:String;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function SOAPRequest(serviceURL:String = null, serviceCall:String = null, defaultNamespace:String = XMLNS_DEFAULT, actionHeader:String = ACTION_HEADER_DEFAULT){
			this.defaultNamespace = defaultNamespace;
			this.actionHeader = actionHeader;
			
			super(serviceURL, serviceCall);
		}
		
		override protected function init():void {
			super.init();
			
			requestContentType = REQUEST_CONTENT_TYPE;
		}
		
		override public function execute(headers:Array = null):void {
			if (!headers){
				headers = new Array();
			}
			headers.push(new URLRequestHeader("SOAPAction", actionHeader + serviceCall));
		
			super.execute(headers);
		}
		
		override protected function generateRequest():URLRequest {
			var request:URLRequest = super.generateRequest();
			request.data = XML(parseTokens(getRequestData()));
			
			return request;
		}
		
		override protected function getRequestURL():String {
			return serviceURL;
		}
		
		override protected function getRequestData():* {
			var data:String = ""
			data += "<soapenv:Envelope xmlns:soapenv='" + TOKEN_XMLNS_SOAPENV + "' xmlns:" + TOKEN_XMLNS_DEFAULT + "='" + TOKEN_XMLNS_ACTION + "' " + TOKEN_ADDITIONAL_NAMESPACES + ">" + "\n";
			data += "    <soapenv:Header/>" + "\n";
			data += "    <soapenv:Body>" + "\n";
			data += "        " + TOKEN_BODY_CONTENT + "\n";
			data += "    </soapenv:Body>" + "\n";
			data += "</soapenv:Envelope>"
			
			return data;
		}
		
		protected function parseTokens(inText:String):String {
			var tokens:Object = new Object();
			tokens[TOKEN_XMLNS_SOAPENV] = XMLNS_SOAPENV;
			tokens[TOKEN_XMLNS_DEFAULT] = defaultNamespace;
			tokens[TOKEN_XMLNS_ACTION] = actionHeader;
			tokens[TOKEN_ADDITIONAL_NAMESPACES] = getAdditionalNamespaces();
			tokens[TOKEN_BODY_CONTENT] = getBodyContent();
			
			return Tokenizer.replaceTokens(inText, tokens);
		}
		
		//Override to add additional namespaces to the envelope header
		protected function getAdditionalNamespaces():String {
			return "";
		}
		
		protected function getBodyContent():String {
			return "<" + TOKEN_XMLNS_DEFAULT + ":" + serviceCall + "/>";
		}
		
		override public function toString():String {
			return "SOAPRequest - " + getRequestURL();
		}
	}
}