/*
* AJ Savino
*/
package com.moxieinteractive.pronto.geom {
	//-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.geom.Point;
	//-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class Calc {
		public static function toDegrees(angle:Number):Number {
			return angle * (0.01745329251994); //Math.PI / 180 optimized for speed
		}
		
		public static function toRadians(angle:Number):Number {
			return angle * (57.29577951308232); //180 / Math.PI optimized for speed
		}
		
		public static function getDistance(p1:Point, p2:Point):Number {
			return Math.sqrt(Math.pow(Math.abs(p2.x - p1.x), 2) + Math.pow(Math.abs(p2.y - p1.y), 2));
		}
		
		public static function getAngle(p1:Point, p2:Point):Number {
			return coterminal(toRadians(Math.atan2(p2.y - p1.y, p2.x - p1.x)));
		}
		
		public static function calcVector(angle:Number, distance:Number = 1):Vector2D {
			angle = coterminal(angle);
			
			var vec:Vector2D = new Vector2D();
			vec.x = Math.sin(toDegrees(90 - angle)) * distance;
			vec.y = Math.sin(toDegrees(angle)) * distance;
			
			return vec;
		}
		
		public static function coterminal(angle:Number, max:Number = 360):Number {
			return ((angle %= max) >= 0) ? angle : angle + max;
		}
		
		public static function halfAngle(angle:Number):Number {
			angle = coterminal(angle);
			if (angle > 180){
				angle -= 360;
			}
			
			return angle;
		}
	}
}