/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.ClickThroughComponent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	
	import flash.display.Loader;
	import flash.display.Bitmap;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class Logo extends ClickThroughComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const PROP_IMAGE:String = "image";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _imageURL:String;
		protected var _loader:Loader;
		protected var _image:Bitmap;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get imageURL():String {
			return _imageURL;
		}
		public function set imageURL(value:String):void {
			_imageURL = value;
			visible = false;
			
			invalidateProperty(PROP_IMAGE);
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function Logo(){
			super();
		}
		
		override public function init():void {
			super.init();
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handler_loader_complete);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handler_loader_error);
		}
		
		override public function destroy():void {
			super.destroy();
			
			removeImage();
			
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handler_loader_complete);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handler_loader_error);
			_loader = null;
		}
		
		protected function removeImage():void {
			if (_image){
				removeChild(_image);
				_image = null;
				_loader.unload();
			}
		}
		
		protected function loadImage():void {
			removeImage();
			
			_loader.load(new URLRequest(_imageURL));
			
			validateProperty(PROP_IMAGE);
		}
		
		protected function handler_loader_complete(evt:Event):void {
			_image = _loader.contentLoaderInfo.content as Bitmap;
			if (!_image){
				return;
			}
			addChild(_image);
			visible = true;
		}
		
		protected function handler_loader_error(evt:IOErrorEvent):void {
			trace ("Logo::handler_loader_error:\n" + evt);
		}
		
		override protected function handler_mouseClick(evt:MouseEvent):void {
			super.handler_mouseClick(evt);
			
			dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_LOGO, this));
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid(PROP_IMAGE)){
				loadImage();
			}
		}
	}
}