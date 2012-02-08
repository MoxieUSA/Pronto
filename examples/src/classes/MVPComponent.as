/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.video.MoxieVideoPlayer;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class MVPComponent extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const SRC_STREAMING:String = "rtmp://loreal.fcod.llnwd.net/a1685/o15/garnier_usa/loreal-fc-garnier_usa_fructis/AntiDandruff/898x512/monkeyFull.flv";
		private static const SRC_PROGRESSIVE:String = "http://products.verizonwireless.com/flash/featured_shows/shows/flm_esp/videos/Video_01.flv";
		private static const SRC_LOCAL:String = "../videos/Pirates_AppDemo_755x472.f4v";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var videoPlayer:MoxieVideoPlayer;
		
		public var btn_streaming:SimpleButton;
		public var btn_progressive:SimpleButton;
		public var btn_local:SimpleButton;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function MVPComponent(){
			//Track percentages
			//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			videoPlayer.trackPercentWatched(10); //Every 10%
			videoPlayer.addEventListener(VideoEvent.CUE_POINT, handler_cuePoint);
			//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			
			//Track controls
			//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			videoPlayer.addEventListener(VideoControlEvent.SHOW_CONTROLS, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.HIDE_CONTROLS, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_LOGO, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_REWIND, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_PLAY, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_PAUSE, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_SEEK, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_MUTE, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_UNMUTE, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_VOLUME, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_ENTER_FULLSCREEN, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_EXIT_FULLSCREEN, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_TWITTER_ICON, handler_trackControl);
			videoPlayer.addEventListener(VideoControlEvent.CLICK_FACEBOOK_ICON, handler_trackControl);
			//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
			
			btn_streaming.addEventListener(MouseEvent.CLICK, handler_btnStreaming_click);
			btn_progressive.addEventListener(MouseEvent.CLICK, handler_btnProgressive_click);
			btn_local.addEventListener(MouseEvent.CLICK, handler_btnLocal_click);
		}
		
		protected function handler_cuePoint(evt:VideoEvent):void {
			trace (evt.data);
		}
		
		protected function handler_trackControl(evt:VideoControlEvent):void {
			trace ("TRACK: " + evt.type);
		}
		
		protected function handler_btnStreaming_click(evt:MouseEvent):void {
			videoPlayer.source = SRC_STREAMING;
		}
		
		protected function handler_btnProgressive_click(evt:MouseEvent):void {
			videoPlayer.source = SRC_PROGRESSIVE;
		}
		
		protected function handler_btnLocal_click(evt:MouseEvent):void {
			videoPlayer.source = SRC_LOCAL;
		}
	}
}