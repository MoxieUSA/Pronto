/*
* AJ Savino
*/
package com.moxieinteractive.pronto.events {
	public class VideoControlEvent extends UIComponentEvent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const SHOW_CONTROLS:String = "show_controls";
		public static const HIDE_CONTROLS:String = "hide_controls";
		
		public static const CLICK_LOGO:String = "click_logo";
		public static const CLICK_REWIND:String = "click_rewind";
		public static const CLICK_PLAY:String = "click_play";
		public static const CLICK_PAUSE:String = "click_pause";
		public static const CLICK_SEEK:String = "click_seek";
		public static const CLICK_MUTE:String = "click_mute";
		public static const CLICK_UNMUTE:String = "click_unmute";
		public static const CLICK_VOLUME:String = "click_volume";
		public static const CLICK_ENTER_FULLSCREEN:String = "click_enter_fullscreen";
		public static const CLICK_EXIT_FULLSCREEN:String = "click_exit_fullscreen";
		public static const CLICK_TWITTER_ICON:String = "click_twitter_icon";
		public static const CLICK_FACEBOOK_ICON:String = "click_facebook_icon";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VideoControlEvent(type:String, data:* = null, bubbles:Boolean = true, cancelable:Boolean = false){
			super(type, data, bubbles, cancelable);
		}
	}
}