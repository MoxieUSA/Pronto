/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.greensock.TweenLite;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class HVolumeControl extends VolumeControl {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_DELAY:Number = 1;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		override public function get width():Number {
			return _initialSliderX + (slider.width * 2);
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function HVolumeControl(){
			super();
		}
		
		override public function openSlider():void {
			super.openSlider();
			
			_tween = new TweenLite(slider, timing, {x:_initialSliderX + slider.width});
		}
		
		override public function closeSlider():void {
			super.closeSlider();
			
			_tween = new TweenLite(slider, timing, {x:_initialSliderX, delay:DEFAULT_DELAY});
		}
	}
}