/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.ToggleComponent;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.video.api.IPlayable;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class VideoToggle extends ToggleComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const LABEL_PAUSED:String = "paused";
		public static const LABEL_PLAYING:String = "playing";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//Proxy functions for controlling the state
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get isPlayingBack():Boolean {
			return state;
		}
		public function set isPlayingBack(value:Boolean):void {
			state = value;
		}
		
		public function get isPaused():Boolean {
			return !state;
		}
		public function set isPaused(value:Boolean):void {
			state = !value;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VideoToggle(){
			super();
		}
		
		override public function render():void {
			if (_state){
				gotoAndStop(LABEL_PLAYING);
			} else {
				gotoAndStop(LABEL_PAUSED);
			}
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			super.addEventListener(UIComponentEvent.USER_CHANGED_STATE, handler_stateChanged);
			_controlled.addEventListener(VideoEvent.PLAY, handler_video_play);
			_controlled.addEventListener(VideoEvent.PAUSE, handler_video_pause);
			_controlled.addEventListener(VideoEvent.RESUME, handler_video_resume);
			_controlled.addEventListener(VideoEvent.STOP, handler_video_stop);
			
			setState();
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			super.removeEventListener(UIComponentEvent.USER_CHANGED_STATE, handler_stateChanged);
			_controlled.removeEventListener(VideoEvent.PLAY, handler_video_play);
			_controlled.removeEventListener(VideoEvent.PAUSE, handler_video_pause);
			_controlled.removeEventListener(VideoEvent.RESUME, handler_video_resume);
			_controlled.removeEventListener(VideoEvent.STOP, handler_video_stop);
			_controlled = null;
			
			return true;
		}
		
		public function handler_stateChanged(evt:UIComponentEvent):void {
			var playControlled:IPlayable = _controlled as IPlayable;
			if (!playControlled){
				return;
			}
			
			if (_state){
				playControlled.play();
				dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_PLAY, this));
			} else {
				playControlled.pause();
				dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_PAUSE, this));
			}
		}
		
		protected function handler_video_play(evt:VideoEvent):void {
			setState(); //true
		}
		
		protected function handler_video_pause(evt:VideoEvent):void {
			setState(); //false
		}
		
		protected function handler_video_resume(evt:VideoEvent):void {
			setState(); //true
		}
		
		protected function handler_video_stop(evt:VideoEvent):void {
			setState(); //false
		}
		
		protected function setState():void {
			var playControlled:IPlayable = _controlled as IPlayable;
			if (!playControlled){
				return;
			}
			state = playControlled.isPlayingBack && !playControlled.isPaused;
		}
	}
}