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
		
		public function HVolumeControl(){
			super();
		}
		
		override public function openSlider():void {
			super.openSlider();
			
			_tween = new TweenLite(slider, timing, {x:0});
		}
		
		override public function closeSlider():void {
			super.closeSlider();
			
			_tween = new TweenLite(slider, timing, {x:-slider.width, delay:DEFAULT_DELAY});
		}
	}
}