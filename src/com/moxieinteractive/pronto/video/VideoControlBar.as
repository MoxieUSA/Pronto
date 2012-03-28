/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIController;
	import com.moxieinteractive.pronto.ui.api.IUIController;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.ui.api.IUIComponent;
	import com.moxieinteractive.pronto.video.api.IControlBar;
	import com.moxieinteractive.pronto.video.api.IVideoScreen;
	import com.moxieinteractive.pronto.utils.ObjUtil;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	import com.moxieinteractive.pronto.vo.ClipLayoutVO;
	
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	//The control layout is designed to maintain control SPACING reguardless of the width
	public class VideoControlBar extends UIController implements IControlBar {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const PROP_LAYOUT:String = "init_layout";
		private static const PROP_INIT_LAYOUT:String = "init_init_layout";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var bg:MovieClip;
		
		public var showControlsEase:String = "Quad.easeOut";
		public var hideControlsEase:String = "Quad.easeIn";
		public var controlsHideDelay:Number = 0;
		public var controlsShowDelay:Number = 0;
		public var controlsTweenTime:Number = 0.25;
		
		protected var _controlBarLocation:String = ControlBarLocation.ON_TOP;
		protected var _controls:Array;
		protected var _layouts:Array;
		protected var _isHidden:Boolean;
		protected var _autoSpaceControls:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		override public function set autoFlow(value:Boolean):void {
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].autoFlow = value;
				}
			}
			
			super.autoFlow = value;
		}
		
		override public function set autoActivate(value:Boolean):void {
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].autoActivate = value;
				}
			}
			
			super.autoActivate = value;
		}
		
		override public function set enabled(value:Boolean):void {
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].enabled = value;
				}
			}
			
			super.enabled = value;
		}
		
		override public function get width():Number {
			return bg.width;
		}
		override public function get height():Number {
			return bg.height;
		}
		
		public function get controlBarLocation():String {
			return _controlBarLocation;
		}
		public function set controlBarLocation(value:String):void {
			_controlBarLocation = value;
		}
		
		public function get autoSpaceControls():Boolean {
			return _autoSpaceControls;
		}
		public function set autoSpaceControls(value:Boolean):void {
			_autoSpaceControls = value;
			invalidateProperty(PROP_INIT_LAYOUT);
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VideoControlBar(){
			super();
		}
		
		override protected function init():void {
			super.init();
			
			autoFlow = false;
			autoActivate = true;
			
			_isDynamic = true;
		}
		
		override public function initialize():void {
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].initialize();
				}
			}
			hideControls(0, 0);
			
			super.initialize()
			
			invalidateProperty(PROP_INIT_LAYOUT);
		}
		
		override public function destroy():void {
			super.destroy();
			
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].destroy();
				}
			}
		}
		
		override public function activate():Boolean {
			if (!super.activate()){
				return false;
			}
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].activate();
				}
			}
			showControls();
			
			return true;
		}
		
		override public function deactivate():Boolean {
			if (!super.deactivate()){
				return false;
			}
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].deactivate();
				}
			}
			hideControls();
			
			return true;
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].issueControl(_controlled);
				}
			}
			_controlled.addEventListener(VideoEvent.SIZE_SCALE, handler_layout);
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			if (_controls){
				var controlsLength:uint = _controls.length;
				for (var i:uint = 0; i < controlsLength; i++){
					_controls[i].revokeControl();
				}
			}
			_controlled.removeEventListener(VideoEvent.SIZE_SCALE, handler_layout);
			_controlled = null;
			
			return true;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			invalidateProperty(PROP_INIT_LAYOUT);
			
			return super.addChild(child);
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			invalidateProperty(PROP_INIT_LAYOUT);
			
			return super.removeChild(child);
		}
		
		public function showControls(timing:Number = NaN, delay:Number = NaN):void {
			if (isNaN(timing)){
				timing = controlsTweenTime;
			}
			if (isNaN(delay)){
				delay = controlsShowDelay;
			}
			if (!_isHidden){
				return;
			}
			_isHidden = false;
			
			var screen:IVideoScreen = _controlled as IVideoScreen;
			if (!screen){
				return;
			}
			
			var tweenProps:Object = new Object();
			tweenProps.delay = delay;
			if (showControlsEase && showControlsEase != ""){
				tweenProps.ease = showControlsEase;
			}
			switch (controlBarLocation){
				case ControlBarLocation.BELOW:
					tweenProps.alpha = 1;
					break;
				case ControlBarLocation.ON_TOP:
				default:
					tweenProps.y = getControlsY();
					break;
			}
			TweenLite.to(this, timing, tweenProps);
			
			dispatchEvent(new VideoControlEvent(VideoControlEvent.SHOW_CONTROLS));
		}
		
		public function hideControls(timing:Number = NaN, delay:Number = NaN):void {
			if (isNaN(timing)){
				timing = controlsTweenTime;
			}
			if (isNaN(delay)){
				delay = controlsHideDelay;
			}
			if (_isHidden){
				return;
			}
			_isHidden = true;
			
			var screen:IVideoScreen = _controlled as IVideoScreen;
			if (!screen){
				return;
			}
			
			var tweenProps:Object = new Object();
			tweenProps.delay = delay;
			if (hideControlsEase && hideControlsEase != ""){
				tweenProps.ease = hideControlsEase;
			}
			switch (controlBarLocation){
				case ControlBarLocation.BELOW:
					tweenProps.alpha = 0;
					break;
				case ControlBarLocation.ON_TOP:
				default:
					tweenProps.y = getControlsY();
					break;
			}
			TweenLite.to(this, timing, tweenProps);
			
			dispatchEvent(new VideoControlEvent(VideoControlEvent.HIDE_CONTROLS));
		}
		
		protected function initControlLayout():void {
			_controls = new Array();
			_layouts = new Array();
			
			var numChildrenLength:uint = numChildren;
			for (var i:uint = 0; i < numChildrenLength; i++){
				var child:DisplayObject = getChildAt(i);
				if (child == bg){
					continue;
				}
				if (child is MovieClip){
					var layout:ClipLayoutVO = new ClipLayoutVO();
					layout.clip = child as MovieClip;
					layout.xFromLeft = child.x;
					layout.xFromRight = bg.width - (child.x + child.width);
					if (child is IUIComponent){
						var component:IUIComponent = child as IUIComponent;
						component.autoFlow = _autoFlow;
						component.autoActivate = _autoActivate;
						if (component is IUIController){
							var controller:IUIController = component as IUIController;
							if (controller.controlled != _controlled){
								controller.controlled = _controlled;
							}
							_controls.push(controller);
						}
					}
					_layouts.push(layout);
				}
			}
			_controls.sortOn(["x", "y"], Array.DESCENDING | Array.NUMERIC);
			_controls.reverse();
			
			validateProperty(PROP_INIT_LAYOUT);
		}
		
		public function layoutControls():void {
			var screen:IVideoScreen = _controlled as IVideoScreen;
			if (!screen){
				return;
			}
			layoutMask();
			
			bg.width = screen.width;
			x = screen.x;
			y = getControlsY();
			
			var layoutsLength:uint = _layouts.length;
			for (var i:uint = 0; i < layoutsLength; i++){
				var layout:ClipLayoutVO = _layouts[i];
				var clip:MovieClip = layout.clip;
				if (!clip){
					continue;
				}
				
				var component:IUIComponent;
				if (clip is IUIComponent){
					component = clip as IUIComponent;
					if (component.isDynamic){
						component.width = (bg.width - layout.xFromRight) - layout.xFromLeft;
					}
				}
				if (!_autoSpaceControls){
					if (layout.xFromLeft <= layout.xFromRight){ //Anchor to left side
						clip.x = layout.xFromLeft;
					} else { //Anchor to right side
						clip.x = bg.width - (clip.width + layout.xFromRight);
					}
				}
			}
			if (_autoSpaceControls){
				autoSpace();
			}
			showControls();
			
			validateProperty(PROP_LAYOUT);
		}
		
		protected function layoutMask():void {
			var screen:IVideoScreen = _controlled as IVideoScreen;
			if (!screen){
				return;
			}
			if (!this.mask){
				return;
			}
			var msk:MovieClip = this.mask as MovieClip;
			msk.x = screen.x;
			msk.y = screen.y;
			msk.width = screen.width;
			
			switch (controlBarLocation){
				case ControlBarLocation.BELOW:
					if (!screen.isFullscreen){
						msk.height = screen.height + bg.height;
					} else {
						msk.height = screen.height;
					}
					break;
				case ControlBarLocation.ON_TOP:
				default:
					msk.height = screen.height;
					break;
			}
		}
		
		protected function getControlsY():Number {
			var screen:IVideoScreen = _controlled as IVideoScreen;
			if (!screen){
				return y;
			}
			var posY:Number = y;
			
			switch (controlBarLocation){
				case ControlBarLocation.BELOW:
					if (!screen.isFullscreen){
						posY = screen.y + screen.height;
					} else {
						posY = screen.y + screen.height - bg.height;
					}
					break;
				case ControlBarLocation.ON_TOP:
				default:
					if (!_isHidden){
						posY = screen.y + screen.height - bg.height;
					} else {
						posY = screen.y + screen.height;
					}
					break;
			}
			
			return posY;
		}
		
		protected function autoSpace():void {
			var i:uint = 0;
			var layoutsLength:uint = _layouts.length;
			var clip:MovieClip;
			
			var widthSum:Number = 0;
			for (i = 0; i < layoutsLength; i++){
				clip = _layouts[i].clip;
				if (clip){
					widthSum += clip.width;
				}
			}
			
			var spacingX:Number = (bg.width - widthSum) / (layoutsLength + 1);
			var nextX:Number = spacingX;
			for (i = 0; i < layoutsLength; i++){
				clip = _layouts[i].clip;
				if (clip){
					clip.x = nextX;
					clip.y = (bg.height - clip.height) * 0.5;
					nextX += clip.width + spacingX;
				}
			}
		}
		
		protected function handler_layout(evt:Event):void {
			invalidateProperty(PROP_LAYOUT);
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid(PROP_INIT_LAYOUT)){
				initControlLayout();
			}
			if (!isPropertyValid(PROP_LAYOUT)){
				layoutControls();
			}
		}
	}
}