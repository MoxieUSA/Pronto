/*
* AJ Savino
*/
package com.moxieinteractive.pronto.events {
	public class VideoEvent extends DataEvent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const SOURCE:String = "source";
		public static const SIZE_SCALE:String = "size_scale";
		public static const PLAY:String = "play";
		public static const PAUSE:String = "pause";
		public static const RESUME:String = "resume";
		public static const STOP:String = "stop";
		public static const START_BUFFERING:String = "start_buffering";
		public static const STOP_BUFFERING:String = "stop_buffering";
		public static const REWIND:String = "rewind";
		public static const MUTE:String = "mute";
		public static const UNMUTE:String = "unmute";
		public static const VOLUME:String = "volume";
		public static const SEEK:String = "seek";
		public static const ENTER_FULLSCREEN:String = "enter_fullscreen";
		public static const EXIT_FULLSCREEN:String = "exit_fullscreen";
		public static const CUE_POINT:String = "cue_point";
		public static const COMPLETE:String = "complete";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VideoEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false){
			super(type, data, bubbles, cancelable);
		}
	}
}