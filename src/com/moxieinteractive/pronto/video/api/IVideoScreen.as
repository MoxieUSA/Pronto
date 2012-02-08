/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.api {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.api.IDisplayObject;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.ui.api.IUI;
	import com.moxieinteractive.pronto.vo.MetaDataVO;
	import com.moxieinteractive.pronto.vo.CuePointVO;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public interface IVideoScreen extends IDisplayObject, IUIControllable, IUI, IPlayable, ISeekable, ITimeable, IAudible, IRewindable, IFullscreenable {
		function get autoPlay():Boolean;
		function set autoPlay(value:Boolean):void;
		function get autoClear():Boolean;
		function set autoClear(value:Boolean):void;
		function get source():String;
		function set source(value:String):void;
		function get scaleMode():String;
		function set scaleMode(value:String):void;
		function get metaData():MetaDataVO;
		function get isBuffering():Boolean;
		function get bufferTime():Number;
		function set bufferTime(value:Number):void;
		
		function setSource(src:String):void;
		function setSize(w:Number, h:Number):void;
		function setScaleMode(mode:String):void;
		function trackPercentWatched(every:Number):void
		function addASCuePoint(time:*, name:String):CuePointVO;
		function removeASCuePoint(identifier:*):void
		function clearASCuePoints():void
	}
}