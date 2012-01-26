/*
* AJ Savino
*/
package com.moxieinteractive.pronto.utils {
	public class VideoUtils {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const PROTOCOL_HTTP:String = "http://";
		public static const PROTOCOL_RTMP:String = "rtmp://";
		protected static const PROTOCOLS:Array = [PROTOCOL_HTTP,
													PROTOCOL_RTMP];
		
		public static const EXTENSION_FLV:String = ".flv";
		public static const EXTENSION_F4V:String = ".f4v";
		public static const EXTENSION_MOV:String = ".mov";
		public static const EXTENSION_MP4:String = ".mp4";
		public static const EXTENSION_3GP:String = ".3gp";
		public static const EXTENSION_3G2:String = ".3g2";
		protected static const EXTENSIONS:Array = [EXTENSION_FLV,
													 EXTENSION_F4V,
													 EXTENSION_MOV,
													 EXTENSION_MP4,
													 EXTENSION_3GP,
													 EXTENSION_3G2];
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public static function getVideoProtocol(source:String):String {
			var protocolsLength:uint = PROTOCOLS.length;
			for (var i:uint = 0; i < protocolsLength; i++){
				var protocol:String = PROTOCOLS[i];
				var protocolLength:uint = protocol.length;
				if (source.length < protocolLength){
					continue;
				} else if (source.substr(0, protocolLength).toLowerCase() == protocol){
					return protocol;
				}
			}
			
			return PROTOCOL_HTTP;
		}
		
		public static function getVideoPath(source:String):String {
			var index:int = source.lastIndexOf("/");
			if (index != -1){
				return source.substr(0, index);
			}
			
			return null;
		}
		
		public static function getVideoFileName(source:String):String {
			var index:int = source.lastIndexOf("/");
			if (index != -1){
				return source.substr(index + 1, source.length - index);
			}
			
			return null;
		}
		
		public static function getVideoExtension(source:String):String {
			var sourceLength:uint = source.length;
			var extensionsLength:uint = EXTENSIONS.length;
			for (var i:uint = 0; i < extensionsLength; i++){
				var extension:String = EXTENSIONS[i];
				var extensionLength:uint = extension.length;
				if (sourceLength < extensionLength){
					continue;
				} else if (source.substr(sourceLength - extensionLength, extensionLength).toLowerCase() == extension){
					return extension;
				}
			}
			
			return null;
		}
		
		public static function getVideoName(source:String):String {
			var filename:String = getVideoFileName(source);
			var extension:String = getVideoExtension(source);
			if (filename && extension){
				var index:int = filename.lastIndexOf(extension);
				if (index != -1){
					return filename.substr(0, index);
				}
			}
			
			return null;
		}
		
		public static function applyAspectRatio(viewWidth:Number, viewHeight:Number, contentWidth:Number, contentHeight:Number):Object {
			var w:Number = viewWidth;
			var h:Number = viewHeight;
			var scaleXY:Number;
			
			var contentAspectRatio:Number = contentWidth / contentHeight;
			var viewAspectRatio:Number = viewWidth / viewHeight;
			if (contentAspectRatio >= viewAspectRatio){ //Wider
				w = Math.max(w, viewWidth);
				h = w / contentAspectRatio;
				scaleXY = h / contentHeight;
			} else if (contentAspectRatio < viewAspectRatio){ //Taller
				h = Math.max(h, viewHeight);
				w = h * contentAspectRatio;
				scaleXY = w / contentWidth;
			}
			
			return {width:w, height:h, scale:scaleXY};
		}
	}
}