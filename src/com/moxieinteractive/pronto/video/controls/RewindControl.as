/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIController;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.video.api.IRewindable;
	import com.moxieinteractive.pronto.events.VideoControlEvent;
	
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class RewindControl extends UIController {
		public function RewindControl(){
			super();
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			super.addEventListener(MouseEvent.CLICK, handler_mouseClicked, false, 1, true);
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			super.removeEventListener(MouseEvent.CLICK, handler_mouseClicked);
			_controlled = null;
			
			return true;
		}
		
		protected function handler_mouseClicked(evt:MouseEvent):void {
			var rewindControlled:IRewindable = _controlled as IRewindable;
			if (!rewindControlled){
				return;
			}
			rewindControlled.rewind();
			
			dispatchEvent(new VideoControlEvent(VideoControlEvent.CLICK_REWIND, this));
		}
	}
}