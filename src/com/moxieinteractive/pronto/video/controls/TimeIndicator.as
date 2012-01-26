/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.components.TextComponent;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	import com.moxieinteractive.pronto.video.api.ITimeable;
	
	import flash.text.TextField;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class TimeIndicator extends TextComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var txt_label:TextField;
		
		protected var _currentTime:Number;
		protected var _totalTime:Number;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function TimeIndicator(){
			super();
		}
		
		override public function render():void {
			if (_text){
				txt_label.text = _text;
			} else {
				txt_label.text = "";
			}
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			_controlled.addEventListener(Event.ENTER_FRAME, handler_controlled_enterFrame);
			
			setText();
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			_controlled.removeEventListener(Event.ENTER_FRAME, handler_controlled_enterFrame);
			_controlled = null;
			
			return true;
		}
		
		protected function handler_controlled_enterFrame(evt:Event):void {
			if (!isPropertyValid("text")){
				return;
			}
			setText();
		}
		
		protected function setText():void {
			var timeControlled:ITimeable = _controlled as ITimeable;
			if (!timeControlled){
				return;
			}
			if (_currentTime == timeControlled.currentTime && _totalTime == timeControlled.totalTime){
				return;
			}
			_currentTime = timeControlled.currentTime;
			_totalTime = timeControlled.totalTime;
			
			text = formatTime(_currentTime) + " / " + formatTime(_totalTime);
		}
		
		protected function formatTime(time:Number):String {
			var minutes:String = String(Math.floor(time / 60));
			if (minutes.length == 1){
				minutes = "0" + minutes;
			}
			var seconds:String = String(Math.floor(time % 60));
			if (seconds.length == 1){
				seconds = "0" + seconds;
			}
			
			return minutes + ":" + seconds;
		}
	}
}