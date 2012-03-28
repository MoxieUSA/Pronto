/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.components {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIController;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	
	import com.greensock.TweenLite;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ScrubComponent extends UIController {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_TIMING:Number = 0.2;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const RENDER_HORIZONTAL:String = "horizontal";
		public static const RENDER_VERTICAL:String = "vertical";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var thumb:MovieClip;
		public var trailMask:MovieClip;
		public var trail:MovieClip;
		public var track:MovieClip;
		public var bg:MovieClip;
		
		public var timing:Number;					//The time to tween to the correct position (in seconds)
		
		protected var _renderDirection:String;
		protected var _inverted:Boolean;			//Invert the direction it scales (assumes registration is right vs left and bottom vs top)
		protected var _scale:Number;
		protected var _isDragging:Boolean;
		protected var _userInteraction:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		override public function get width():Number {
			if (bg){
				return bg.width;
			} else {
				return track.width;
			}
		}
		override public function set width(value:Number):void {
			var scale:Number = value / (track.width / track.scaleX);
			var newSize:Number = scale * (track.width / track.scaleX);
			if (bg){
				var sizeDiff:Number = (bg.width / bg.scaleX) - (track.width / track.scaleX);
				bg.width = newSize;
				newSize -= sizeDiff;
			}
			track.width = newSize;
			if (trailMask){
				trailMask.width = newSize;
			}
			if (trail){
				trail.width = newSize;
			}
			invalidateProperty("scale");
		}
		
		override public function get height():Number {
			if (bg){
				return bg.height;
			} else {
				return track.height;
			}
		}
		override public function set height(value:Number):void {
			var scale:Number = value / (track.height / track.scaleY);
			var newSize:Number = scale * (track.height / track.scaleY);
			if (bg){
				var sizeDiff:Number = (bg.height / bg.scaleY) - (track.height / track.scaleY);
				bg.height = newSize;
				newSize -= sizeDiff;
			}
			track.height = newSize;
			if (trailMask){
				trailMask.height = newSize;
			}
			if (trail){
				trail.height = newSize;
			}
			invalidateProperty("scale");
		}
		
		public function get renderDirection():String {
			return _renderDirection;
		}
		public function set renderDirection(value:String):void {
			_renderDirection = value;
			invalidateProperty("renderDirection");
		}
		
		public function get inverted():Boolean {
			return _inverted;
		}
		public function set inverted(value:Boolean):void {
			_inverted = value;
			invalidateProperty("inverted");
		}
		
		public function get scale():Number {
			return _scale;
		}
		public function set scale(value:Number):void {
			if (isNaN(value)){
				return;
			}
			if (value == _scale){
				return;
			}
			_scale = Math.max(Math.min(value, 1), 0);
			invalidateProperty("scale");
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ScrubComponent(renderDirection:String = RENDER_HORIZONTAL, inverted:Boolean = false){
			_renderDirection = renderDirection;
			_inverted = inverted;
			
			super();
		}
		
		override protected function init():void {
			super.init();
			
			timing = DEFAULT_TIMING;
			
			_isDynamic = true;
		}
		
		override public function initialize():void {
			_scale = 0;
			_isDragging = false;
			_userInteraction = false;
			
			super.initialize();
		}
		
		override public function destroy():void {
			stopThumbDrag();
			
			super.destroy();
		}
		
		override public function activate():Boolean {
			if (!super.activate()){
				return false;
			}
			prepareMouse();
			track.addEventListener(MouseEvent.MOUSE_DOWN, handler_track_mouseDown, false, 1, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, handler_mouseUp, false, 1, true);
			
			return true;
		}
		
		override public function deactivate():Boolean {
			if (!super.deactivate()){
				return false;
			}
			prepareMouse();
			track.removeEventListener(MouseEvent.MOUSE_DOWN, handler_track_mouseDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handler_mouseUp);
			
			return true;
		}
		
		protected function prepareMouse():void {
			buttonMode = _enabled;
			useHandCursor = _enabled;
			
			thumb.mouseEnabled = !_enabled;
			if (trail){
				trail.mouseEnabled = !_enabled;
			}
			track.mouseChildren = !_enabled;
		}
		
		public function render():void {
			if (!thumb){
				throw new Error("Thumb was never set.");
			}
			if (!track){
				throw new Error("Track was never set.");
			}
			if (_renderDirection != RENDER_HORIZONTAL && _renderDirection != RENDER_VERTICAL){
				throw new Error("Invalid render direction specified.");
			}
			
			positionThumb(_scale);
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid("renderDirection")){
				render();
			}
			if (!isPropertyValid("inverted")){
				render();
			}
			if (!isPropertyValid("scale")){
				positionThumb(_scale);
				dispatchEvent(new UIComponentEvent(UIComponentEvent.SCALE_CHANGED, _scale));
			}
			
			super.commitProperties();
		}
		
		protected function handler_track_mouseDown(evt:MouseEvent):void {
			beginUserInteraction();
			startThumbDrag();
		}
		
		protected function handler_mouseUp(evt:MouseEvent):void {
			stopThumbDrag();
			endUserInteraction();
		}
		
		public function startThumbDrag():void {
			if (_isDragging) {
				return;
			}
			_isDragging = true;
							
			addEventListener(Event.ENTER_FRAME, handler_enterFrame, false, 1, true);
		}
		
		public function stopThumbDrag():void {
			if (!_isDragging) {
				return;
			}
			_isDragging = false;
			
			removeEventListener(Event.ENTER_FRAME, handler_enterFrame);
		}
		
		protected function beginUserInteraction():void {
			if (_userInteraction){
				return;
			}
			_userInteraction = true;
		}
		
		protected function endUserInteraction():void {
			if (!_userInteraction){
				return;
			}
			_userInteraction = false;
			dispatchEvent(new UIComponentEvent(UIComponentEvent.USER_CHANGED_SCALE, _scale));
		}
		
		private function handler_enterFrame(evt:Event):void {
			doDrag();
		}
		
		protected function doDrag():void {
			if (!_isDragging){
				stopThumbDrag();
				return;
			}
			
			var trackLowerBound:Number;
			var trackUpperBound:Number;
			if (_renderDirection == RENDER_HORIZONTAL){
				var xMouse:Number;
				if (!inverted){
					trackLowerBound = thumb.width * .5;
					trackUpperBound = track.width - (thumb.width * .5);
					xMouse = Math.max(Math.min((track.mouseX * track.scaleX), trackUpperBound), trackLowerBound); //Force the mouse value to be in the proper range
					scale = (xMouse - trackLowerBound) / (track.width - thumb.width); //Calculate the percent of the thumb along the track
				} else {
					trackLowerBound = -(track.width - (thumb.width * .5));
					trackUpperBound = -(thumb.width * .5);
					xMouse = Math.max(Math.min((track.mouseX * track.scaleX), trackUpperBound), trackLowerBound); //Force the mouse value to be in the proper range
					scale = 1 - ((xMouse - trackLowerBound) / (track.width - thumb.width)); //Calculate the percent of the thumb along the track
				}
			} else if (_renderDirection == RENDER_VERTICAL){
				var yMouse:Number;
				if (!inverted){
					trackLowerBound = thumb.height * .5;
					trackUpperBound = track.height - (thumb.height * .5);
					yMouse = Math.max(Math.min((track.mouseY * track.scaleY), trackUpperBound), trackLowerBound); //Force the mouse value to be in the proper range
					scale = (yMouse - trackLowerBound) / (track.height - thumb.height); //Calculate the percent of the thumb along the track
				} else {
					trackLowerBound = -(track.height - (thumb.height * .5));
					trackUpperBound = -(thumb.height * .5);
					yMouse = Math.max(Math.min((track.mouseY * track.scaleY), trackUpperBound), trackLowerBound); //Force the mouse value to be in the proper range
					scale = 1 - ((yMouse - trackLowerBound) / (track.height - thumb.height)); //Calculate the percent of the thumb along the track
				}
			}
		}
		
		protected function positionThumb(toScale:Number):void {
			var thumbPos:Number;
			if (_renderDirection == RENDER_HORIZONTAL){
				if (thumb){
					if (!inverted){
						thumbPos = track.x + (toScale * (track.width - thumb.width)); //Set the thumbs position
					} else {
						thumbPos = track.x - (toScale * (track.width - thumb.width)); //Set the thumbs position
					}
					TweenLite.to(thumb, timing, {x:thumbPos});
					if (trail){
						TweenLite.to(trail, timing, {x:thumbPos});
					}
				}
			} else if (_renderDirection == RENDER_VERTICAL){
				if (thumb){
					if (!inverted){
						thumbPos = track.y + (toScale * (track.height - thumb.height)); //Set the thumbs position
					} else {
						thumbPos = track.y - (toScale * (track.height - thumb.height)); //Set the thumbs position
					}
					TweenLite.to(thumb, timing, {y:thumbPos});
					if (trail){
						TweenLite.to(trail, timing, {y:thumbPos});
					}
				}
			}
		}
	}
}