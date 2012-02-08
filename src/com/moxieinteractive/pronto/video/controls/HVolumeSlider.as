/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.ScrubComponent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class HVolumeSlider extends VolumeSlider {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const RENDER_DIRECTION:String = ScrubComponent.RENDER_HORIZONTAL;
		private static const INVERTED:Boolean = false;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function HVolumeSlider(){
			super(RENDER_DIRECTION, INVERTED);
		}
	}
}