/*
* AJ Savino
*/
package com.moxieinteractive.pronto.utils {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.utils.getTimer;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class NormalTimer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _currentTime:Number;
		protected var _lastTime:Number;
		protected var _delta:Number;
		protected var _frameRate:Number;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get delta():Number {
			return _delta;
		}
		
		public function get frameRate():Number {
			return _frameRate;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function NormalTimer():void {
			_lastTime = getTimer();
		}
		
		public function tick():Number {
			_currentTime = getTimer();
			_delta = (_currentTime - _lastTime) / 1000;
			_frameRate = 1000 / (_currentTime - _lastTime);
			_lastTime = _currentTime;
			
			return _delta;
		}
	}
}