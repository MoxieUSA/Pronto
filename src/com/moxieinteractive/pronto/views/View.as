/*
* AJ Savino
*/
package com.moxieinteractive.pronto.views {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.ui.core.UIComponent;
	import com.moxieinteractive.pronto.utils.ObjUtil;
	
	import com.greensock.TweenLite;
	
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	//If the extending library asset has all of the frame labels defined in the constants below then timeline transitions will be used
	public class View extends UIComponent {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const LABEL_IDLE:String = "idle";
		private static const LABEL_IN:String = "transitionIn";
		private static const LABEL_IN_COMPLETE:String = "transitionInComplete";
		private static const LABEL_OUT:String = "transitionOut";
		private static const LABEL_OUT_COMPLETE:String = "transitionOutComplete";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static var traceFlow:Boolean = false;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var id:String;
		
		protected var _transitionInTime:Number = 0.73;
		protected var _transitionOutTime:Number = 0.37;
		protected var _timelineTransitions:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function View(viewId:String){
			super();
			
			id = viewId;
		}
		
		//Called once from the constructor
		override protected function init():void {
			if (traceFlow){
				trace ("View::init: " + this);
			}
			super.init();
			
			if (ObjUtil.hasLabels(this, LABEL_IDLE, LABEL_IN, LABEL_IN_COMPLETE, LABEL_OUT, LABEL_OUT_COMPLETE)){
				stop();
				_timelineTransitions = true;
			}
		}
		
		override public function initialize():void {
			if (traceFlow){
				trace ("View::initialize: " + this);
			}
			if (!_invalidatedProps){
				_invalidatedProps = new Array();
			}
			
			alpha = 0;
			visible = false;
			
			if (_timelineTransitions){
				gotoAndStop(LABEL_IDLE);
			}
			transitionIn();
		}
		
		public function transitionIn():void {
			if (traceFlow){
				trace ("View::transitionIn: " + this);
			}
			visible = true;
			
			if (_timelineTransitions){
				alpha = 1;
				ObjUtil.addFrameScript(this, LABEL_IN_COMPLETE, transitionInComplete);
				gotoAndPlay(LABEL_IN);
			} else {
				TweenLite.to(this, _transitionInTime, {alpha:1, onComplete:transitionInComplete});
			}
		}
		
		protected function transitionInComplete():void {
			if (traceFlow){
				trace ("View::transitionInComplete: " + this);
			}
			if (_timelineTransitions){
				ObjUtil.removeFrameScript(this, LABEL_IN_COMPLETE);
				stop();
			}
			
			if (_autoActivate){
				activate();
			}
		}
		
		override public function activate():Boolean {
			if (!super.activate()){
				return false;
			}
			if (traceFlow){
				trace ("View::activate: " + this);
			}
			
			return true;
		}
		
		public function transitionOut():void {
			if (traceFlow){
				trace ("View::transitionOut: " + this);
			}
			if (_autoActivate){
				deactivate();
			}
			
			if (_timelineTransitions){
				ObjUtil.addFrameScript(this, LABEL_OUT_COMPLETE, transitionOutComplete);
				gotoAndPlay(LABEL_OUT);
			} else {
				TweenLite.to(this, _transitionOutTime, {alpha:0, onComplete:transitionOutComplete});
			}
		}
		
		override public function deactivate():Boolean {
			if (!super.deactivate()){
				return false;
			}
			if (traceFlow){
				trace ("View::deactivate: " + this);
			}
			
			return true;
		}
		
		protected function transitionOutComplete():void {
			if (traceFlow){
				trace ("View::transitionOutComplete: " + this);
			}
			if (_timelineTransitions){
				ObjUtil.removeFrameScript(this, LABEL_OUT_COMPLETE);
				gotoAndStop(LABEL_IDLE);
			}
			
			destroy();
			
			if (parent){
				removeEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
				parent.removeChild(this);
				if (_autoFlow){
					addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
				}
			}
		}
		
		override public function destroy():void {
			if (traceFlow){
				trace ("View::destroy: " + this);
			}
			if (_timelineTransitions){
				ObjUtil.removeFrameScript(this, LABEL_IN_COMPLETE);
				ObjUtil.removeFrameScript(this, LABEL_OUT_COMPLETE);
			}
			
			TweenLite.killTweensOf(this);
			
			alpha = 0;
			visible = false;
			
			super.destroy();
		}
		
		override public function reset():void {
			if (traceFlow){
				trace ("View::reset: " + this);
			}
			super.reset();
		}
	}
}