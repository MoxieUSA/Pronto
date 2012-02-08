/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.ToggleComponent;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.video.api.IMutable;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class AudioToggle extends ToggleComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const LABEL_UNMUTED:String = "unmuted";
		public static const LABEL_MUTED:String = "muted";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//Proxy functions for controlling the state
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get isMuted():Boolean {
			return state;
		}
		public function set isMuted(value:Boolean):void {
			state = value;
		}
		
		public function get isUnmuted():Boolean {
			return !state;
		}
		public function set isUnmuted(value:Boolean):void {
			state = !value;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function AudioToggle(){
			super();
		}
		
		override public function render():void {
			if (_state){
				gotoAndStop(LABEL_MUTED);
			} else {
				gotoAndStop(LABEL_UNMUTED);
			}
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			super.addEventListener(UIComponentEvent.USER_CHANGED_STATE, handler_stateChanged);
			_controlled.addEventListener(VideoEvent.MUTE, handler_video_mute);
			_controlled.addEventListener(VideoEvent.UNMUTE, handler_video_unmute);
			
			setState();
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			super.removeEventListener(UIComponentEvent.USER_CHANGED_STATE, handler_stateChanged);
			_controlled.removeEventListener(VideoEvent.MUTE, handler_video_mute);
			_controlled.removeEventListener(VideoEvent.UNMUTE, handler_video_unmute);
			_controlled = null;
			
			return true;
		}
		
		protected function handler_stateChanged(evt:UIComponentEvent):void {
			var audioControlled:IMutable = _controlled as IMutable;
			if (!audioControlled){
				return;
			}
			
			if (_state){
				audioControlled.mute();
				dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_MUTE, this));
			} else {
				audioControlled.unmute();
				dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_UNMUTE, this));
			}
		}
		
		protected function handler_video_mute(evt:VideoEvent):void {
			setState();
		}
		
		protected function handler_video_unmute(evt:VideoEvent):void {
			setState();
		}
		
		protected function setState():void {
			var audioControlled:IMutable = _controlled as IMutable;
			if (!audioControlled){
				return;
			}
			state = audioControlled.isMuted;
		}
	}
}