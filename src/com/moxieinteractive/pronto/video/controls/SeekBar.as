/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.ScrubComponent;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.video.api.ISeekable;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class SeekBar extends ScrubComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const RENDER_DIRECTION:String = ScrubComponent.RENDER_HORIZONTAL;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function SeekBar(){
			super(RENDER_DIRECTION);
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			super.addEventListener(UIComponentEvent.USER_CHANGED_SCALE, handler_userChangedScale);
			_controlled.addEventListener(Event.ENTER_FRAME, handler_controlled_enterFrame);
			
			setScale();
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			super.removeEventListener(UIComponentEvent.USER_CHANGED_SCALE, handler_userChangedScale);
			_controlled.removeEventListener(Event.ENTER_FRAME, handler_controlled_enterFrame);
			_controlled = null;
			
			return true;
		}
		
		protected function handler_userChangedScale(evt:UIComponentEvent):void {
			var seekControlled:ISeekable = _controlled as ISeekable;
			if (!seekControlled){
				return;
			}
			seekControlled.seekTo(_scale);
			
			dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_SEEK, _scale));
		}
		
		protected function handler_controlled_enterFrame(evt:Event):void {
			if (_isDragging || !isPropertyValid("scale")){
				return;
			}
			setScale();
		}
		
		protected function setScale():void {
			var seekControlled:ISeekable = _controlled as ISeekable;
			if (!seekControlled){
				return;
			}
			scale = seekControlled.playheadPercent;
		}
	}
}