/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import events.MVPJSEvent;
	
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.video.VideoPlayerFactory;
	import com.moxieinteractive.pronto.video.MoxieVideoPlayer;
	import com.moxieinteractive.pronto.video.ControlBarLocation;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	import com.moxieinteractive.pronto.events.DataEvent;
	import com.moxieinteractive.pronto.vo.VO;
	
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class MVPStandAlone extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _loader:URLLoader;
		protected var _videoPlayer:MoxieVideoPlayer;
		protected var _jsEventHandler:String;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function MVPStandAlone(){
			super();
		}
		
		override protected function init():void {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var flashVars:Object = stage.loaderInfo.parameters;
			if (!flashVars.configXML){
				throw new Error("configXML flashVar parameter was not specified and is required for the standalone player.");
			}
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, handler_loader_complete);
			_loader.load(new URLRequest(flashVars.configXML));
		}
		
		protected function handler_loader_complete(evt:Event):void {
			_loader.removeEventListener(Event.COMPLETE, handler_loader_complete);
			
			var loaderData:XML = XML(_loader.data);
			_jsEventHandler = loaderData.jsEventHandler.toString();
			_videoPlayer = VideoPlayerFactory.constructFromXML(loaderData, MVP);
			if (!_videoPlayer){
				return;
			}
			_videoPlayer.width = stage.stageWidth;
			switch (_videoPlayer.controlBar.controlBarLocation){
				case ControlBarLocation.BELOW:
					_videoPlayer.height = stage.stageHeight - _videoPlayer.controlBar.height;
					break;
				case ControlBarLocation.ON_TOP:
				default:
					_videoPlayer.height = stage.stageHeight;
					break;
			}
			addChild(_videoPlayer);
			
			if (_jsEventHandler){
				initExternal();
			}
		}
		
		protected function initExternal():void {
			if (!ExternalInterface.available){
				return;
			}
			ExternalInterface.addCallback("getSource", getSource);
			ExternalInterface.addCallback("setSource", _videoPlayer.setSource);
			ExternalInterface.addCallback("getScaleMode", getScaleMode);
			ExternalInterface.addCallback("setScaleMode", _videoPlayer.setScaleMode);
			ExternalInterface.addCallback("play", _videoPlayer.play);
			ExternalInterface.addCallback("pause", _videoPlayer.pause);
			ExternalInterface.addCallback("resume", _videoPlayer.resume);
			ExternalInterface.addCallback("stop", _videoPlayer.stop);
			ExternalInterface.addCallback("mute", _videoPlayer.mute);
			ExternalInterface.addCallback("unmute", _videoPlayer.unmute);
			ExternalInterface.addCallback("getVolume", getVolume);
			ExternalInterface.addCallback("setVolume", _videoPlayer.setVolume);
			ExternalInterface.addCallback("seekTo", _videoPlayer.seekTo);
			ExternalInterface.addCallback("trackPercentWatched", _videoPlayer.trackPercentWatched);
			ExternalInterface.addCallback("addASCuePoint", _videoPlayer.addASCuePoint);
			ExternalInterface.addCallback("removeASCuePoint", _videoPlayer.removeASCuePoint);
			ExternalInterface.addCallback("clearASCuePoints", _videoPlayer.clearASCuePoints);
			ExternalInterface.addCallback("getAutoHideControls", getAutoHideControls);
			ExternalInterface.addCallback("setAutoHideControls", setAutoHideControls);
			ExternalInterface.addCallback("getControlsHideTime", getControlsHideTime);
			ExternalInterface.addCallback("setControlsHideTime", setControlsHideTime);
			ExternalInterface.addCallback("getControlBarLocation", getControlBarLocation);
			ExternalInterface.addCallback("getAutoSpaceControls", getAutoSpaceControls);
			ExternalInterface.addCallback("setAutoSpaceControls", setAutoSpaceControls);
			ExternalInterface.addCallback("getAutoPlay", getAutoPlay);
			ExternalInterface.addCallback("setAutoPlay", setAutoPlay);
			ExternalInterface.addCallback("getAutoClear", getAutoClear);
			ExternalInterface.addCallback("setAutoClear", setAutoClear);
			ExternalInterface.addCallback("getBufferTime", getBufferTime);
			ExternalInterface.addCallback("setBufferTime", setBufferTime);
			ExternalInterface.addCallback("getCurrentTime", getCurrentTime);
			ExternalInterface.addCallback("getTotalTime", getTotalTime);
			ExternalInterface.addCallback("getIsPlayingBack", getIsPlayingBack);
			ExternalInterface.addCallback("getIsPaused", getIsPaused);
			ExternalInterface.addCallback("getIsSeeking", getIsSeeking);
			ExternalInterface.addCallback("getIsMuted", getIsMuted);
			ExternalInterface.addCallback("getIsFullscreen", getIsFullscreen);
			ExternalInterface.addCallback("getMetaData", getMetaData);
			
			_videoPlayer.addEventListener(VideoEvent.SOURCE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.SIZE_SCALE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.PLAY, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.PAUSE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.RESUME, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.STOP, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.START_BUFFERING, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.STOP_BUFFERING, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.REWIND, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.MUTE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.UNMUTE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.VOLUME, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.SEEK, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.ENTER_FULLSCREEN, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.EXIT_FULLSCREEN, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.CUE_POINT, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoEvent.COMPLETE, handler_trackingProxy);
			
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_LOGO, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_REWIND, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_PLAY, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_PAUSE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_MUTE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_UNMUTE, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_VOLUME, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_SEEK, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_ENTER_FULLSCREEN, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_EXIT_FULLSCREEN, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_TWITTER_ICON, handler_trackingProxy);
			_videoPlayer.addEventListener(VideoControlEvent.CLICK_FACEBOOK_ICON, handler_trackingProxy);
			
			eventToJS(new MVPJSEvent(MVPJSEvent.READY));
		}
		
		protected function getAutoHideControls():Boolean {
			return _videoPlayer.autoHideControls;
		}
		protected function setAutoHideControls(value:Boolean):void {
			_videoPlayer.autoHideControls = value;
		}
		
		protected function getControlBarLocation():String {
			return _videoPlayer.controlBarLocation;
		}
		
		protected function getAutoSpaceControls():Boolean {
			return _videoPlayer.autoSpaceControls;
		}
		protected function setAutoSpaceControls(value:Boolean):void {
			_videoPlayer.autoSpaceControls = value;
		}
		
		protected function getControlsHideTime():Number {
			return _videoPlayer.controlsHideTime;
		}
		protected function setControlsHideTime(value:Number):void {
			_videoPlayer.controlsHideTime = value;
		}
		
		protected function getAutoPlay():Boolean {
			return _videoPlayer.autoPlay;
		}
		protected function setAutoPlay(value:Boolean):void {
			_videoPlayer.autoPlay = value;
		}
		
		protected function getAutoClear():Boolean {
			return _videoPlayer.autoClear;
		}
		protected function setAutoClear(value:Boolean):void {
			_videoPlayer.autoClear = value;
		}
		
		protected function getSource():String {
			return _videoPlayer.source;
		}
		
		protected function getScaleMode():String {
			return _videoPlayer.scaleMode;
		}
		
		protected function getBufferTime():Number {
			return _videoPlayer.bufferTime;
		}
		protected function setBufferTime(value:Number):void {
			_videoPlayer.bufferTime = value;
		}
		
		protected function getVolume():Number {
			return _videoPlayer.volume;
		}
		
		protected function getCurrentTime():Number {
			return _videoPlayer.currentTime;
		}
		
		protected function getTotalTime():Number {
			return _videoPlayer.totalTime;
		}
		
		protected function getIsPlayingBack():Boolean {
			return _videoPlayer.isPlayingBack;
		}
		
		protected function getIsPaused():Boolean {
			return _videoPlayer.isPaused;
		}
		
		protected function getIsSeeking():Boolean {
			return _videoPlayer.isSeeking;
		}
		
		protected function getIsMuted():Boolean {
			return _videoPlayer.isMuted;
		}
		
		protected function getIsFullscreen():Boolean {
			return _videoPlayer.isFullscreen;
		}
		
		protected function getMetaData():Object {
			return _videoPlayer.metaData;
		}
		
		protected function handler_trackingProxy(evt:Event):void {
			eventToJS(new MVPJSEvent(MVPJSEvent.TRACKING, evt));
		}
		
		protected function eventToJS(evt:DataEvent):void {
			if (!evt){
				return;
			}
			var jsEvent:Object = new Object();
			jsEvent.type = evt.type;
			jsEvent.data = evt.data;
			
			var eventRef:Object = jsEvent;
			while (eventRef.data is DataEvent){
				var subEvent:Object = new Object();
				subEvent.type = eventRef.data.type;
				subEvent.data = eventRef.data.data;
				eventRef.data = subEvent;
				eventRef = subEvent;
			}
			if (!(eventRef.data is Number) &&
				!(eventRef.data is String) &&
				!(eventRef.data is VO)){
				eventRef.data = null;
			}
			
			ExternalInterface.call(_jsEventHandler, jsEvent);
		}
	}
}