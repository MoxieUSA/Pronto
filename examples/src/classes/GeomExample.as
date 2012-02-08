/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.geom.Calc;
	import com.moxieinteractive.pronto.geom.Vector2D;
	import com.moxieinteractive.pronto.utils.NormalTimer;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class GeomExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const START_ANGLE:Number = 0;
		private static const DEGREES_PER_SECOND:Number = 90;
		private static const DISTANCE:Number = 100;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var center:MovieClip;
		public var ball:MovieClip;
		
		protected var _angle:Number;
		protected var _timer:NormalTimer;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function GeomExample(){
			super();
		}
		
		override protected function init():void {
			_angle = START_ANGLE;
			
			_timer = new NormalTimer();
			_timer.tick();
			
			addEventListener(Event.ENTER_FRAME, handler_enterFrame);
			
			doPositionBall();
		}
		
		protected function handler_enterFrame(evt:Event):void {
			var delta:Number = _timer.tick(); //Get time elapse
			_angle += DEGREES_PER_SECOND * delta;
			
			doPositionBall();
		}
		
		protected function doPositionBall():void {
			var position:Vector2D = Calc.calcVector(_angle, DISTANCE);
			
			ball.x = center.x + position.x;
			ball.y = center.y + position.y;
		}
	}
}