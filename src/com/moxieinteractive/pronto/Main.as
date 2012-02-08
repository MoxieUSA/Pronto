/*
* AJ Savino
*/
package com.moxieinteractive.pronto {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.events.ErrorEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class Main extends MovieClip {
		public function Main(){
			loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handler_uncaughtError);
			
			if (stage){
				handler_addedToStage();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			}
		}
		
		protected function handler_addedToStage(evt:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
			
			init();
		}
		
		protected function handler_removedFromStage(evt:Event = null):void {
			addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			
			destroy();
		}
		
		protected function init():void {
			//Override
		}
		
		protected function destroy():void {
			//Override
		}
		
		protected function handler_uncaughtError(evt:UncaughtErrorEvent):void {
			if (evt.error is Error){
				trace ("*** ERROR *** \n" + evt.error.message);
			} else if (evt.error is ErrorEvent){
				trace ("*** ERROR *** \n" + evt.error.error.message);
			}
		}
	}
}