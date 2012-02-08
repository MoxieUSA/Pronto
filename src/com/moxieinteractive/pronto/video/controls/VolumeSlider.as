/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.ScrubComponent;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.video.api.IAudible;
	import com.moxieinteractive.pronto.events.UIComponentEvent;
	import com.moxieinteractive.pronto.events.VideoEvent;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class VolumeSlider extends ScrubComponent {
		public function VolumeSlider(renderDirection:String, inverted:Boolean){
			super(renderDirection, inverted);
		}
		
		override public function init():void {
			super.init();
			
			isDynamic = false;
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			super.addEventListener(UIComponentEvent.USER_CHANGED_SCALE, handler_userChangedScale);
			_controlled.addEventListener(VideoEvent.VOLUME, handler_volume);
			
			setScale();
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			super.removeEventListener(UIComponentEvent.USER_CHANGED_SCALE, handler_userChangedScale);
			_controlled.removeEventListener(VideoEvent.VOLUME, handler_volume);
			_controlled = null;
			
			return true;
		}
		
		protected function handler_volume(evt:VideoEvent):void {
			setScale();
		}
		
		protected function handler_userChangedScale(evt:UIComponentEvent):void {
			var audibleControlled:IAudible = _controlled as IAudible;
			if (!audibleControlled){
				return;
			}
			audibleControlled.setVolume(_scale);
			
			dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_VOLUME, this));
		}
		protected function setScale():void {
			var audibleControlled:IAudible = _controlled as IAudible;
			if (!audibleControlled){
				return;
			}
			scale = audibleControlled.volume;
		}
	}
}