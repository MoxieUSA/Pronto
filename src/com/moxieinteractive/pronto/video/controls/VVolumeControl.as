/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.greensock.TweenLite;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class VVolumeControl extends VolumeControl {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_DELAY:Number = 1;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VVolumeControl(){
			super();
		}
		
		override public function openSlider():void {
			super.openSlider();
			
			_tween = new TweenLite(slider, timing, {y:_initialSliderY - slider.height});
		}
		
		override public function closeSlider():void {
			super.closeSlider();
			
			_tween = new TweenLite(slider, timing, {y:_initialSliderY, delay:DEFAULT_DELAY});
		}
	}
}