/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.ToggleComponent;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.video.api.IFullscreenable;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class FullscreenToggle extends ToggleComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const LABEL_RESTORED:String = "restored";
		public static const LABEL_MAXIMIZED:String = "maximized";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//Proxy functions for controlling the state
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get isMaximized():Boolean {
			return state;
		}
		
		public function set isMaximized(value:Boolean):void {
			state = value;
		}
		
		public function get isRestored():Boolean {
			return !state;
		}
		
		public function set isRestored(value:Boolean):void {
			state = !value;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function FullscreenToggle(){
			super();
		}
		
		override public function render():void {
			if (_state){
				gotoAndStop(LABEL_MAXIMIZED);
			} else {
				gotoAndStop(LABEL_RESTORED);
			}
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			_controlled.addEventListener(VideoEvent.ENTER_FULLSCREEN, handler_video_maximize);
			_controlled.addEventListener(VideoEvent.EXIT_FULLSCREEN, handler_video_restore);
			_controlled.addEventListener(MouseEvent.DOUBLE_CLICK, handler_mouseClick);
			
			setState();
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			_controlled.removeEventListener(VideoEvent.ENTER_FULLSCREEN, handler_video_maximize);
			_controlled.removeEventListener(VideoEvent.EXIT_FULLSCREEN, handler_video_restore);
			_controlled.removeEventListener(MouseEvent.DOUBLE_CLICK, handler_mouseClick);
			_controlled = null;
			
			return true;
		}
		
		//Fullscreen MUST happen on a user interaction
		override protected function handler_mouseClick(evt:MouseEvent):void {
			super.handler_mouseClick(evt);
			
			var fullscreenControlled:IFullscreenable = _controlled as IFullscreenable;
			if (!fullscreenControlled){
				return;
			}
			
			if (_state){
				fullscreenControlled.enterFullscreen();
				dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_ENTER_FULLSCREEN, this));
			} else {
				fullscreenControlled.exitFullscreen();
				dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_EXIT_FULLSCREEN, this));
			}
		}
		
		protected function handler_video_maximize(evt:VideoEvent):void {
			setState();
		}
		
		protected function handler_video_restore(evt:VideoEvent):void {
			setState();
		}
		
		protected function setState():void {
			var fullscreenControlled:IFullscreenable = _controlled as IFullscreenable;
			if (!fullscreenControlled){
				return;
			}
			state = fullscreenControlled.isFullscreen;
		}
	}
}