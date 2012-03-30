/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIComponent;
	import com.moxieinteractive.pronto.video.api.IVideoPlayer;
	import com.moxieinteractive.pronto.video.VideoControlBar;
	import com.moxieinteractive.pronto.video.VideoScreen;
	import com.moxieinteractive.pronto.utils.NormalTimer;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.vo.MetaDataVO;
	import com.moxieinteractive.pronto.vo.CuePointVO;
	
	import flash.display.MovieClip;
	import flash.geom.Point
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class MoxieVideoPlayer extends UIComponent implements IVideoPlayer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const PROP_AUTO_HIDE_CONTROLS:String = "auto_hide_controls";
		private static const PROP_AUTO_SIZE:String = "auto_size";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var controlBarMask:MovieClip;
		public var controlBar:VideoControlBar;
		public var videoScreen:VideoScreen;
		
		protected var _autoHideControls:Boolean = true;
		protected var _lastMousePosition:Point;
		protected var _timer:NormalTimer;
		protected var _currentTime:Number;
		protected var _controlsHideTime:Number = 2;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		override public function get width():Number {
			return videoScreen.width;
		}
		override public function set width(value:Number):void {
			videoScreen.width = value;
			invalidateProperty(PROP_AUTO_SIZE);
		}
		
		override public function get height():Number {
			return videoScreen.height;
		}
		override public function set height(value:Number):void {
			videoScreen.height = value;
			invalidateProperty(PROP_AUTO_SIZE);
		}
		
		[Inspectable (name="autoHideControls", variable="autoHideControls", type="Boolean", defaultValue="true")]
		public function get autoHideControls():Boolean {
			return _autoHideControls;
		}
		public function set autoHideControls(value:Boolean):void {
			_autoHideControls = value;
			invalidateProperty(PROP_AUTO_HIDE_CONTROLS);
		}
		
		[Inspectable (name="controlsHideTime", variable="controlsHideTime", type="Number", defaultValue="2")]
		public function get controlsHideTime():Number {
			return _controlsHideTime;
		}
		public function set controlsHideTime(value:Number):void {
			_controlsHideTime = value;
		}
		
		[Inspectable (name="controlBarLocation", variable="controlBarLocation", type="List", enumeration="onTop,below", defaultValue="onTop")]
		public function get controlBarLocation():String {
			return controlBar.controlBarLocation;
		}
		public function set controlBarLocation(value:String):void {
			controlBar.controlBarLocation = value;
		}
		
		[Inspectable (name="autoSpaceControls", variable="autoSpaceControls", type="Boolean", defaultValue="false")]
		public function get autoSpaceControls():Boolean {
			return controlBar.autoSpaceControls;
		}
		public function set autoSpaceControls(value:Boolean):void {
			controlBar.autoSpaceControls = value;
		}
		
		[Inspectable (name="autoPlay", variable="autoPlay", type="Boolean", defaultValue="true")]
		public function get autoPlay():Boolean {
			return videoScreen.autoPlay;
		}
		public function set autoPlay(value:Boolean):void {
			videoScreen.autoPlay = value;
		}
		
		[Inspectable (name="autoClear", variable="autoClear", type="Boolean", defaultValue="true")]
		public function get autoClear():Boolean {
			return videoScreen.autoClear;
		}
		public function set autoClear(value:Boolean):void {
			videoScreen.autoClear = value;
		}
		
		[Inspectable (name="source", variable="source", type="String", defaultValue="")]
		public function get source():String {
			return videoScreen.source;
		}
		public function set source(value:String):void {
			videoScreen.source = value;
		}
		
		[Inspectable (name="scaleMode", variable="scaleMode", type="List", enumeration="noScale,exactFit,maintainAspectRatio", defaultValue="exactFit")]
		public function get scaleMode():String {
			return videoScreen.scaleMode;
		}
		public function set scaleMode(value:String):void {
			videoScreen.scaleMode = value;
		}
		
		[Inspectable (name="bufferTime", variable="bufferTime", type="Number", defaultValue="3")]
		public function get bufferTime():Number {
			return videoScreen.bufferTime;
		}
		public function set bufferTime(value:Number):void {
			videoScreen.bufferTime = value;
		}
		
		[Inspectable (name="deblocking", variable="deblocking", type="uint", defaultValue="0")]
		public function get deblocking():uint {
			return videoScreen.deblocking;
		}
		public function set deblocking(value:uint):void {
			videoScreen.deblocking = value;
		}
		
		[Inspectable (name="smoothing", variable="smoothing", type="Boolean", defaultValue="false")]
		public function get smoothing():Boolean {
			return videoScreen.smoothing;
		}
		public function set smoothing(value:Boolean):void {
			videoScreen.smoothing = value;
		}
		
		public function get volume():Number {
			return videoScreen.volume;
		}
		public function set volume(value:Number):void {
			videoScreen.volume = value;
		}
		
		public function get playheadPercent():Number {
			return videoScreen.playheadPercent;
		}
		public function set playheadPercent(value:Number):void {
			videoScreen.playheadPercent = value;
		}
		
		public function get currentTime():Number {
			return videoScreen.currentTime;
		}
		public function get totalTime():Number {
			return videoScreen.totalTime;
		}
		
		public function get isPlayingBack():Boolean {
			return videoScreen.isPlayingBack;
		}
		
		public function get isPaused():Boolean {
			return videoScreen.isPaused;
		}
		
		public function get isSeeking():Boolean {
			return videoScreen.isSeeking;
		}
		
		public function get isBuffering():Boolean {
			return videoScreen.isBuffering;
		}
		
		public function get isMuted():Boolean {
			return videoScreen.isMuted;
		}
		
		public function get isFullscreen():Boolean {
			return videoScreen.isFullscreen;
		}
		public function set isFullscreen(value:Boolean):void {
			videoScreen.isFullscreen = value;
		}
		
		public function get metaData():MetaDataVO {
			return videoScreen.metaData;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function MoxieVideoPlayer(){
			super();
			
			controlBar.mask = controlBarMask;
		}
		
		override public function initialize():void {
			_timer = new NormalTimer();
			_currentTime = 0;
			
			controlBar.initialize();
			videoScreen.initialize();
			
			super.initialize();
			
			invalidateProperty(PROP_AUTO_SIZE);
			invalidateProperty(PROP_AUTO_HIDE_CONTROLS);
		}
		
		override public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			
			controlBar.destroy();
			videoScreen.destroy();
			
			super.destroy();
			
			_timer = null;
		}
		
		override public function activate():Boolean {
			if (!super.activate()){
				return false;
			} 
			controlBar.issueControl(videoScreen);
			controlBar.activate();
			
			return true;
		}
		
		override public function deactivate():Boolean {
			if (!super.deactivate()){
				return false;
			}
			controlBar.revokeControl();
			controlBar.deactivate();
			
			return true;
		}
		
		public function setSource(src:String):void {
			videoScreen.setSource(src);
		}
		
		public function setSize(w:Number, h:Number):void {
			videoScreen.setSize(w, h);
		}
		
		public function setScaleMode(mode:String):void {
			videoScreen.setScaleMode(mode);
		}
		
		override public function play():void {
			videoScreen.play();
		}
		
		public function pause():void {
			videoScreen.pause();
		}
		
		public function resume():void {
			videoScreen.resume();
		}
		
		override public function stop():void {
			videoScreen.stop();
		}
		
		public function rewind():void {
			videoScreen.rewind();
		}
		
		public function mute():void {
			videoScreen.mute();
		}
		
		public function unmute():void {
			videoScreen.unmute();
		}
		
		public function setVolume(scale:Number):void {
			videoScreen.setVolume(scale);
		}
		
		public function seekTo(scale:Number):void {
			videoScreen.seekTo(scale);
		}
		
		public function enterFullscreen():void {
			videoScreen.enterFullscreen();
		}
		
		public function exitFullscreen():void {
			videoScreen.exitFullscreen();
		}
		
		public function trackPercentWatched(every:Number):void {
			videoScreen.trackPercentWatched(every);
		}
		
		public function addASCuePoint(time:*, name:String):CuePointVO {
			return videoScreen.addASCuePoint(time, name);
		}
		
		public function removeASCuePoint(identifier:*):void {
			videoScreen.removeASCuePoint(identifier);
		}
		
		public function clearASCuePoints():void {
			videoScreen.clearASCuePoints();
		}
		
		public function showControls(timing:Number = NaN, delay:Number = NaN):void {
			controlBar.showControls(timing, delay);
		}
		
		public function hideControls(timing:Number = NaN, delay:Number = NaN):void {
			controlBar.hideControls(timing, delay);
		}
		
		public function layoutControls():void {
			controlBar.layoutControls();
		}
		
		public function autoSize():void {
			videoScreen.width = videoScreen.width * scaleX;
			videoScreen.height = videoScreen.height * scaleY;
			scaleX = 1;
			scaleY = 1;
			
			validateProperty(PROP_AUTO_SIZE);
		}
		
		protected function initAutoHideControls():void {
			if (_autoHideControls){
				_timer.tick();
				addEventListener(Event.ENTER_FRAME, handler_enterFrame);
			} else {
				removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			}
			
			validateProperty(PROP_AUTO_HIDE_CONTROLS);
		}
		
		protected function handler_enterFrame(evt:Event):void {
			_currentTime += _timer.tick();
			if (_currentTime >= _controlsHideTime){
				_currentTime = 0;
				hideControls();
			}
			if (isMouseOver()){
				_currentTime = 0;
				showControls();
			}
		}
		
		protected function isMouseOver():Boolean {
			var mousePosition:Point = localToGlobal(new Point(mouseX, mouseY));
			if (_lastMousePosition){
				if (mousePosition.x == _lastMousePosition.x && mousePosition.y == _lastMousePosition.y){
					if (controlBar.hitTestPoint(mousePosition.x, mousePosition.y, true)){
						return true;
					} else {
						return false;
					}
				}
			}
			_lastMousePosition = mousePosition;
			
			var w:Number = videoScreen.width;
			var h:Number = videoScreen.height;
			switch (controlBar.controlBarLocation){
				case ControlBarLocation.BELOW:
					h += controlBar.height;
					break;
			}
			var screenPosition:Point = localToGlobal(new Point(videoScreen.x, videoScreen.y));
			if (mousePosition.x >= screenPosition.x && mousePosition.x <= screenPosition.x + w){
				if (mousePosition.y >= screenPosition.y && mousePosition.y <= screenPosition.y + h){
					return true;
				}
			}
			
			return false;
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid(PROP_AUTO_SIZE)){
				autoSize();
			}
			if (!isPropertyValid(PROP_AUTO_HIDE_CONTROLS)){
				initAutoHideControls();
			}
		}
	}
}