/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UISprite;
	import com.moxieinteractive.pronto.video.api.IVideoScreen;
	import com.moxieinteractive.pronto.utils.VideoUtils;
	import com.moxieinteractive.pronto.vo.MetaDataVO;
	import com.moxieinteractive.pronto.vo.CuePointVO;
	import com.moxieinteractive.pronto.events.VideoEvent;
	
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.StageDisplayState;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.media.Video;
	import flash.media.SoundTransform;
	import flash.events.NetStatusEvent;
	import flash.events.AsyncErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.FullScreenEvent;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class VideoScreen extends UISprite implements IVideoScreen {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected static const PROP_SOURCE:String = "source";
		protected static const PROP_SIZESCALE:String = "sizescale";
		protected static const PROP_PLAY:String = "play";
		protected static const PROP_PAUSE:String = "pause";
		protected static const PROP_RESUME:String = "resume";
		protected static const PROP_STOP:String = "stop";
		protected static const PROP_VOLUME:String = "volume";
		protected static const PROP_SEEK:String = "seek";
		protected static const PROP_BUFFER_TIME:String = "buffertime";
		protected static const PROP_CUE_POINTS:String = "cue_points";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected static const PERCENT_WATCHED_PREFIX:String = "percentWatched_";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var bg:MovieClip;
		public var buffering:MovieClip;
		
		protected var _autoPlay:Boolean = true;
		protected var _autoClear:Boolean = true;
		protected var _source:String;
		protected var _protocol:String;
		protected var _metaData:MetaDataVO;
		protected var _width:Number;
		protected var _height:Number;
		protected var _scaleMode:String = VideoScaleMode.EXACT_FIT;
		protected var _volume:Number;
		protected var _volumeBeforeMute:Number;
		protected var _playheadPercent:Number;
		protected var _isPlayingBack:Boolean;
		protected var _isPaused:Boolean;
		protected var _isSeeking:Boolean;
		protected var _isBuffering:Boolean;
		protected var _isMuted:Boolean;
		protected var _isFullscreen:Boolean;
		protected var _bufferTime:Number = 3;
		protected var _lastWidth:Number;
		protected var _lastHeight:Number;
		protected var _intervalDivisions:uint;
		protected var _asCuePoints:Array;
		protected var _lastStreamTime:Number;
		
		protected var _connection:NetConnection;
		protected var _stream:NetStream;
		protected var _video:Video;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		override public function get width():Number {
			return _width;
		}
		override public function set width(value:Number):void {
			setSize(value, height);
		}
		
		override public function get height():Number {
			return _height;
		}
		override public function set height(value:Number):void {
			setSize(width, value);
		}
		
		public function get autoPlay():Boolean {
			return _autoPlay;
		}
		public function set autoPlay(value:Boolean):void{
			_autoPlay = value;
		}
		
		public function get autoClear():Boolean {
			return _autoClear;
		}
		public function set autoClear(value:Boolean):void{
			_autoClear = value;
		}
		
		public function get source():String {
			return _source;
		}
		public function set source(value:String):void {
			setSource(value);
		}
		
		public function get scaleMode():String {
			return _scaleMode;
		}
		public function set scaleMode(value:String):void {
			setScaleMode(value);
		}
		
		public function get volume():Number {
			return _volume;
		}
		public function set volume(value:Number):void {
			setVolume(value);
		}
		
		public function get playheadPercent():Number {
			return _playheadPercent;
		}
		public function set playheadPercent(value:Number):void {
			seekTo(value);
		}
		
		public function get currentTime():Number {
			if (_stream){
				return _stream.time;
			}
			return 0;
		}
		public function get totalTime():Number {
			if (_metaData){
				return _metaData.duration;
			}
			return 0;
		}
		
		//Stupid method name... adobe decided to add an "isPlaying" method in FP11 that creates conflicts when overriding in FP10
		public function get isPlayingBack():Boolean {
			return _isPlayingBack;
		}
		
		public function get isPaused():Boolean {
			return _isPaused;
		}
		
		public function get isSeeking():Boolean {
			return _isSeeking;
		}
		
		public function get isBuffering():Boolean {
			return _isBuffering;
		}
		
		public function get isMuted():Boolean {
			return _isMuted;
		}
		
		public function get isFullscreen():Boolean {
			return _isFullscreen;
		}
		public function set isFullscreen(value:Boolean):void {
			if (value){
				enterFullscreen();
			} else {
				exitFullscreen();
			}
		}
		
		public function get bufferTime():Number {
			return _bufferTime;
		}
		public function set bufferTime(value:Number):void {
			_bufferTime = value;
			invalidateProperty(PROP_BUFFER_TIME);
		}
		
		public function get metaData():MetaDataVO {
			return _metaData;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VideoScreen(){
			super();
		}
		
		override public function init():void {
			super.init();
			
			_lastWidth = super.width;
			_lastHeight = super.height;
			_width = _lastWidth;
			_height = _lastHeight;
			
			_isFullscreen = false;
			_volume = 1;
			_playheadPercent = 0;
			_intervalDivisions = 0;
			_asCuePoints = new Array();
			
			mouseChildren = false;
			doubleClickEnabled = true;
			
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, handler_netStatus, false, 1, true);
			_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, handler_error, false, 1, true);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_error, false, 1, true);
			_connection.client = this;
			
			_video = new Video();
			addChildAt(_video, numChildren);
			
			_isBuffering = false;
			if (buffering){
				buffering.visible = false; //Hide buffering initially
			}
			
			addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage, false, 1, true);
			addEventListener(Event.ENTER_FRAME, handler_enterFrame, false, 1, true);
		}
		
		override public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
			removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			if (stage){
				stage.removeEventListener(FullScreenEvent.FULL_SCREEN, handler_fullScreen);
			}
			
			_metaData = null;
			clearASCuePoints();
			_asCuePoints = null;
			
			_connection.close();
			_connection.removeEventListener(NetStatusEvent.NET_STATUS, handler_netStatus);
			_connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handler_error);
			_connection = null;
			if (_stream){
				_stream.close();
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, handler_netStatus);
				_stream = null;
			}
			removeChild(_video);
			_video.clear();
			_video = null;
			
			super.destroy();
		}
		
		public function handler_addedToStage(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			
			stage.addEventListener(FullScreenEvent.FULL_SCREEN, handler_fullScreen, false, 1, true);
		}
		
		public function setSource(src:String):void {
			_source = src;
			_metaData = null;
			
			stop();
			clearASCuePoints();
			if (_source){
				invalidateProperty(PROP_SOURCE);
				invalidateProperty(PROP_SIZESCALE);
				invalidateProperty(PROP_VOLUME);
				invalidateProperty(PROP_BUFFER_TIME);
			}
		}
		
		protected function doSource():void {
			_connection.close();
			if (_stream){
				_stream.close();
				_stream.removeEventListener(NetStatusEvent.NET_STATUS, handler_netStatus);
				_stream = null;
			}
			
			_protocol = VideoUtils.getVideoProtocol(_source); //trace (_protocol);
			switch (_protocol){
				case VideoUtils.PROTOCOL_HTTP:
					_connection.connect(null);
					break;
				case VideoUtils.PROTOCOL_RTMP:
					var videoPath:String = VideoUtils.getVideoPath(_source); //trace (videoPath);
					if (videoPath){
						_connection.connect(videoPath);
					}
					break;
				default:
					throw new Error("Invalid protocol specified");
			}
			trackPercentWatched(_intervalDivisions);
			
			validateProperty(PROP_SOURCE);
			dispatchEvent(new VideoEvent(VideoEvent.SOURCE));
		}
		
		public function setSize(w:Number, h:Number):void {
			_width = w;
			_height = h;
			if (bg){
				bg.width = _width;
				bg.height = _height;
			}
			if (buffering){
				buffering.x = _width * 0.5;
				buffering.y = _height * 0.5;
			}
			
			invalidateProperty(PROP_SIZESCALE);
		}
		
		public function setScaleMode(mode:String):void {
			switch (mode){
				case VideoScaleMode.EXACT_FIT:
				case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
				case VideoScaleMode.NO_SCALE:
					_scaleMode = mode;
					break;
			}
			
			invalidateProperty(PROP_SIZESCALE);
		}
		
		protected function doSizeScale():void {
			var maintainAspectRatio:Boolean;
			if (!_isFullscreen){
				x = 0;
				y = 0;
				switch (_scaleMode){
					case VideoScaleMode.NO_SCALE:
						if (_metaData){
							_video.width = _metaData.width;
							_video.height = _metaData.height;
						} else {
							return;
						}
						break;
					case VideoScaleMode.EXACT_FIT:
						_video.width = _width;
						_video.height = _height;
						break;
					case VideoScaleMode.MAINTAIN_ASPECT_RATIO:
						maintainAspectRatio = true;
						break;
				}
			} else {
				var position:Point = localToGlobal(new Point());
				x = -x - position.x;
				y = -y - position.y;
				maintainAspectRatio = true;
			}
			if (maintainAspectRatio){
				if (_metaData){
					var aspected:Object = VideoUtils.applyAspectRatio(width, height, _metaData.width, _metaData.height);
					_video.width = aspected.width;
					_video.height = aspected.height;
				} else {
					return;
				}
			}
			_video.x = (_width - _video.width) * 0.5;
			_video.y = (_height - _video.height) * 0.5;
			
			validateProperty(PROP_SIZESCALE);
			dispatchEvent(new VideoEvent(VideoEvent.SIZE_SCALE));
		}
		
		public function play():void {
			if (!_source){
				return;
			}
			if (_isPlayingBack){
				if (_isPaused){
					resume();
				}
				return;
			}
			_isPlayingBack = true;
			
			invalidateProperty(PROP_PLAY);
		}
		
		protected function doPlay():void {
			if (!_stream){
				return;
			}
			switch (_protocol){
				case VideoUtils.PROTOCOL_HTTP:
					_stream.play(_source);
					break;
				case VideoUtils.PROTOCOL_RTMP:
					var videoName:String = VideoUtils.getVideoName(_source); //trace (videoName);
					if (videoName){
						_stream.play(videoName);
					}
					break;
			}
			_lastStreamTime = 0;
			
			validateProperty(PROP_PLAY);
			dispatchEvent(new VideoEvent(VideoEvent.PLAY));
		}
		
		public function pause():void {
			if (_isPaused || !_isPlayingBack){
				return;
			}
			_isPaused = true;
			
			invalidateProperty(PROP_PAUSE);
		}
		
		protected function doPause():void {
			if (!_stream){
				return;
			}
			_stream.pause();
			
			validateProperty(PROP_PAUSE);
			dispatchEvent(new VideoEvent(VideoEvent.PAUSE));
		}
		
		public function resume():void {
			if (!_isPaused || !_isPlayingBack){
				return;
			}
			_isPaused = false;
			
			invalidateProperty(PROP_RESUME);
		}
		
		protected function doResume():void {
			if (!_stream){
				return;
			}
			_stream.resume();
			
			validateProperty(PROP_RESUME);
			dispatchEvent(new VideoEvent(VideoEvent.RESUME));
		}
		
		public function stop():void {
			if (!_isPlayingBack){
				return;
			}
			_isPlayingBack = false;
			_isPaused = false;
			_isSeeking = false;
			
			invalidateProperty(PROP_STOP);
		}
		
		protected function doStop():void {
			if (!_stream){
				return;
			}
			if (_autoClear){
				_video.clear();
			}
			_stream.close();
			
			validateProperty(PROP_STOP);
			dispatchEvent(new VideoEvent(VideoEvent.STOP));
		}
		
		public function rewind():void {
			seekTo(0);
			dispatchEvent(new VideoEvent(VideoEvent.REWIND));
		}
		
		public function mute():void {
			if (_isMuted){
				return;
			}
			_isMuted = true;
			_volumeBeforeMute = _volume;
			setVolume(0);
			dispatchEvent(new VideoEvent(VideoEvent.MUTE));
		}
		
		public function unmute():void {
			if (!_isMuted){
				return;
			}
			setVolume(_volumeBeforeMute);
		}
		
		public function setVolume(scale:Number):void {
			_volume = Math.max(Math.min(scale, 1), 0);
			if (_isMuted && _volume){
				_isMuted = false;
				dispatchEvent(new VideoEvent(VideoEvent.UNMUTE));
			}
			
			invalidateProperty(PROP_VOLUME);
		}
		
		protected function doVolume():void {
			if (!_stream){
				return;
			}
			var transform:SoundTransform = new SoundTransform();
			transform.volume = _volume;
			_stream.soundTransform = transform;
			
			validateProperty(PROP_VOLUME);
			dispatchEvent(new VideoEvent(VideoEvent.VOLUME, _volume));
		}
		
		public function seekTo(scale:Number):void {
			if (_isSeeking || !_isPlayingBack){
				return;
			}
			_isSeeking = true;
			
			_playheadPercent = Math.max(Math.min(scale, 0.999), 0); //don't seek to 1
			
			invalidateProperty(PROP_SEEK);
		}
		
		protected function doSeek():void {
			if (!_stream || !_metaData){
				return;
			}
			if (_playheadPercent < 1){
				var time:Number = _metaData.duration * _playheadPercent;
				_stream.seek(time);
				_lastStreamTime = time;
			}
			switch (_protocol){
				case VideoUtils.PROTOCOL_HTTP:
					_isSeeking = false;
					break;
			}
			
			validateProperty(PROP_SEEK);
			dispatchEvent(new VideoEvent(VideoEvent.SEEK));
		}
		
		public function enterFullscreen():void {
			if (_isFullscreen || _isBuffering || !_stream || !stage){
				return;
			}
			
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}
		
		public function exitFullscreen():void {
			if (!_isFullscreen || !_stream || !stage){
				return;
			}
			
			stage.displayState = StageDisplayState.NORMAL;
		}
		
		public function trackPercentWatched(every:Number):void {
			every = Math.max(Math.min(every, 100), 0);
			
			if (_intervalDivisions){
				var i:uint;
				var startAt:uint = 1;
				var spacing:Number = Math.floor(100 / _intervalDivisions);
				for (i = startAt; i < _intervalDivisions + startAt; i++){
					removeASCuePoint(PERCENT_WATCHED_PREFIX + i);
				}
			}
			
			_intervalDivisions = (every) ? Math.floor(100 / every) : 0;
			if (_intervalDivisions){
				spacing = Math.floor(100 / _intervalDivisions);
				for (i = startAt; i < _intervalDivisions + startAt; i++){
					var cuePoint:CuePointVO = addASCuePoint((spacing * i) + "%", PERCENT_WATCHED_PREFIX + i);
					cuePoint.interval = i;
				}
			}
		}
		
		public function addASCuePoint(time:*, name:String):CuePointVO {
			var cuePoint:CuePointVO = new CuePointVO();
			if (time is String){
				if (time.substr(time.length - 1, 1) == "%"){
					cuePoint.percent = time.substr(0, time.length - 1);
				} else {
					time = Number(time);
					if (time){
						cuePoint.time = time;
					}
				}
			} else if (time is Number){
				cuePoint.time = time;
			}
			cuePoint.name = name;
			_asCuePoints.push(cuePoint);
			
			invalidateProperty(PROP_CUE_POINTS);
			
			return cuePoint;
		}
		
		public function removeASCuePoint(identifier:*):void {
			var cuePointsLength:uint = _asCuePoints.length;
			for (var i:uint = 0; i < cuePointsLength; i++){
				var cuePoint:CuePointVO = _asCuePoints[i];
				if (identifier is Number){
					if (cuePoint.time == identifier){
						_asCuePoints.splice(i, 1);
					}
				} else if (identifier is String){
					if (cuePoint.name == identifier || cuePoint.time == identifier){
						_asCuePoints.splice(i, 1);
					} else if (identifier.substr(identifier.length - 1, 1) == "%") {
						if (cuePoint.percent == identifier.substr(0, identifier.length - 1)){
							_asCuePoints.splice(i, 1);
						}
					}
				}
			}
		}
		
		public function clearASCuePoints():void {
			while (_asCuePoints.length){
				_asCuePoints.shift();
			}
		}
		
		protected function doInitASCuePoints():void {
			if (!_metaData){
				return;
			}
			var cuePointsLength:uint = _asCuePoints.length;
			for (var i:uint = 0; i < cuePointsLength; i++){
				var cuePoint:CuePointVO = _asCuePoints[i];
				if (cuePoint.percent && !cuePoint.time){
					cuePoint.time = cuePoint.percent * _metaData.duration * .01;
				} else if (cuePoint.time && !cuePoint.percent){
					cuePoint.percent = Math.floor((cuePoint.time / _metaData.duration) * 100);
				}
			}
			_asCuePoints.sortOn("time", Array.NUMERIC);
			
			validateProperty(PROP_CUE_POINTS);
		}
		
		protected function handler_enterFrame(evt:Event):void {
			if (_isSeeking){
				return;
			}
			doPlayheadPercent();
			doProgressiveBuffering();
			doASCuePoints();
		}
		
		protected function doPlayheadPercent():void {
			if (!_stream){
				return;
			}
			if (_metaData){
				_playheadPercent = _stream.time / _metaData.duration;
			} else {
				_playheadPercent = 0;
			}
		}
		
		protected function doProgressiveBuffering():void {
			if (!_stream){
				return;
			}
			switch (_protocol){
				case VideoUtils.PROTOCOL_HTTP:
					if (_playheadPercent >= (_stream.bytesLoaded / _stream.bytesTotal)){
						if (!_isBuffering){
							_isBuffering = true;
							if (buffering){
								buffering.visible = true;
							}
							dispatchEvent(new VideoEvent(VideoEvent.START_BUFFERING));
						}
					} else {
						if (_isBuffering){
							_isBuffering = false;
							if (buffering){
								buffering.visible = false;
							}
							dispatchEvent(new VideoEvent(VideoEvent.STOP_BUFFERING));
						}
					}
					break;
			}
		}
		
		protected function doASCuePoints():void {
			if (!_stream){
				return;
			}
			if (_stream.time == _lastStreamTime){
				return;
			}
			var cuePointsLength:uint = _asCuePoints.length;
			for (var i:uint = 0; i < cuePointsLength; i++){
				var cuePoint:CuePointVO = _asCuePoints[i];
				if (_lastStreamTime < cuePoint.time && _stream.time >= cuePoint.time){
					onCuePoint(cuePoint);
				}
			}
			_lastStreamTime = _stream.time;
		}
		
		protected function handler_fullScreen(evt:FullScreenEvent):void {
			if (!stage){
				return;
			}
			if (stage.displayState == StageDisplayState.FULL_SCREEN){
				_isFullscreen = true;
				
				stage.fullScreenSourceRect = new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight);
				
				_lastWidth = width;
				_lastHeight = height;
				width = stage.fullScreenWidth;
				height = stage.fullScreenHeight;
				
				dispatchEvent(new VideoEvent(VideoEvent.ENTER_FULLSCREEN));
			} else {
				_isFullscreen = false;
				
				width = _lastWidth;
				height = _lastHeight;
				
				dispatchEvent(new VideoEvent(VideoEvent.EXIT_FULLSCREEN));
			}
		}
		
		protected function handler_error(evt:Event):void {
			//trace ("VideoScreen::handler_error: " + evt);
		}
		
		protected function handler_netStatus(evt:NetStatusEvent):void {
			//trace ("VideoScreen::handler_netStatus: " + evt.info.code);
			switch (evt.info.code){
				case "NetConnection.Connect.Success":
					connect();
					break;
				case "NetStream.Play.Stop":
					switch (_protocol){
						case VideoUtils.PROTOCOL_HTTP:
							if (_playheadPercent >= 0.99){
								dispatchEvent(new VideoEvent(VideoEvent.COMPLETE));
							}
							stop();
							break;
					}
					break;
				case "NetStream.Play.Start":
					switch (_protocol){
						case VideoUtils.PROTOCOL_RTMP:
							if (!_isBuffering){
								_isBuffering = true;
								if (buffering){
									buffering.visible = true;
								}
								dispatchEvent(new VideoEvent(VideoEvent.START_BUFFERING));
							}
							break;
					}
					break;
				case "NetStream.Buffer.Flush":
				case "NetStream.Buffer.Full":
					switch (_protocol){
						case VideoUtils.PROTOCOL_RTMP:
							if (_isBuffering){
								_isBuffering = false;
								if (buffering){
									buffering.visible = false;
								}
								dispatchEvent(new VideoEvent(VideoEvent.STOP_BUFFERING));
							}
							break;
					}
					break;
			}
		}
		
		protected function connect():void {
			_stream = new NetStream(_connection);
			_stream.addEventListener(NetStatusEvent.NET_STATUS, handler_netStatus, false, 1, true);
			_stream.client = this;
			_video.attachNetStream(_stream);
			
			if (_autoPlay){
				play();
			}
			validateNow();
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid(PROP_STOP)){ 				//trace (PROP_STOP);
				doStop();
			}
			if (!isPropertyValid(PROP_SOURCE)){ 			//trace (PROP_SOURCE);
				doSource();
			}
			if (!isPropertyValid(PROP_SIZESCALE)){ 			//trace (PROP_SIZESCALE);
				doSizeScale();
			}
			if (!isPropertyValid(PROP_SEEK)){ 				//trace (PROP_SEEK);
				doSeek();
			}
			if (!isPropertyValid(PROP_PLAY)){ 				//trace (PROP_PLAY);
				doPlay();
			}
			if (!isPropertyValid(PROP_PAUSE)){ 				//trace (PROP_PAUSE);
				doPause();
			}
			if (!isPropertyValid(PROP_RESUME)){			 	//trace (PROP_RESUME);
				doResume();
			}
			if (!isPropertyValid(PROP_VOLUME)){ 			//trace (PROP_VOLUME);
				doVolume();
			}
			if (!isPropertyValid(PROP_BUFFER_TIME)){ 		//trace (PROP_BUFFER_TIME);
				doBufferTime();
			}
			if (!isPropertyValid(PROP_CUE_POINTS)){			//trace (PROP_CUE_POINTS);
				doInitASCuePoints();
			}
		}
		
		protected function doBufferTime():void {
			if (!_stream){
				return;
			}
			_stream.bufferTime = _bufferTime;
			
			validateProperty(PROP_BUFFER_TIME);
		}
		
		//Required for NetConnection/NetStream clients
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function onBWDone():void {
			//trace ("VideoScreen::onBWDone");
		}
		
		public function close():void {
			//trace ("VideoScreen::close");
		}
		
		public function onMetaData(info:Object):void {
			//trace ("VideoScreen::onMetaData");
			if (_isSeeking){
				_isSeeking = false;
			}
			_metaData = new MetaDataVO(info); //trace (_metaData);
			
			validateNow();
		}
		
		public function onXMPData(info:Object):void {
			//trace ("VideoScreen::onXMPData");
		}
		
		public function onPlayStatus(info:Object):void {
			//trace ("VideoScreen::onPlayStatus: " + info.code);
			switch (info.code){
				case "NetStream.Play.Complete":
					switch (_protocol){
						case VideoUtils.PROTOCOL_RTMP:
							if (_playheadPercent >= 0.99){
								dispatchEvent(new VideoEvent(VideoEvent.COMPLETE));
							}
							stop();
							break;
					}
					break;
			}
		}
		
		public function onCuePoint(info:*):void {
			//trace ("VideoScreen::onCuePoint");
			if (!(info is CuePointVO)){ //encoded cue point
				var cuePoint:CuePointVO = new CuePointVO();
				cuePoint.time = info.time;
				cuePoint.name = info.name;
			} else if (info is CuePointVO){ //cue point vo
				cuePoint = info as CuePointVO;
			}
			
			dispatchEvent(new VideoEvent(VideoEvent.CUE_POINT, cuePoint));
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	}
}