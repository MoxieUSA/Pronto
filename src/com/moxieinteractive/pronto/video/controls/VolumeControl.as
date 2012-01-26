/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video.controls {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIController;
	import com.moxieinteractive.pronto.ui.api.IUIControllable;
	
	import com.greensock.TweenLite;
	
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class VolumeControl extends UIController {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const DEFAULT_TIMING:Number = 0.5;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var toggle:AudioToggle;
		public var slider:VolumeSlider;
		
		public var timing:Number;
		
		protected var _tween:TweenLite;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		override public function get width():Number {
			return toggle.width;
		}
		
		override public function get height():Number {
			return toggle.height;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VolumeControl(){
			super();
		}
		
		override public function init():void {
			super.init();
			
			timing = DEFAULT_TIMING;
		}
		
		override public function activate():Boolean {
			if (!super.activate()){
				return false;
			}
			toggle.activate();
			slider.activate();
			addEventListener(MouseEvent.ROLL_OVER, handler_rollOver, false, 1, true);
			addEventListener(MouseEvent.ROLL_OUT, handler_rollOut, false, 1, true);
			
			return true;
		}
		
		override public function deactivate():Boolean {
			if (!super.deactivate()){
				return false;
			}
			toggle.deactivate();
			slider.deactivate();
			removeEventListener(MouseEvent.ROLL_OVER, handler_rollOver);
			removeEventListener(MouseEvent.ROLL_OUT, handler_rollOut);
			
			return true;
		}
		
		override public function issueControl(controlled:IUIControllable):Boolean {
			if (!super.issueControl(controlled)){
				return false;
			}
			toggle.issueControl(controlled);
			slider.issueControl(controlled);
			
			return true;
		}
		
		override public function revokeControl():Boolean {
			if (!super.revokeControl()){
				return false;
			}
			toggle.revokeControl();
			slider.revokeControl();
			_controlled = null;
			
			return true;
		}
		
		protected function handler_rollOver(evt:MouseEvent):void {
			openSlider();
		}
		
		protected function handler_rollOut(evt:MouseEvent):void {
			closeSlider();
		}
		
		public function openSlider():void {
			if (_tween){
				_tween.kill();
				_tween = null;
			}
		}
		
		public function closeSlider():void {
			if (_tween){
				_tween.kill();
				_tween = null;
			}
		}
	}
}