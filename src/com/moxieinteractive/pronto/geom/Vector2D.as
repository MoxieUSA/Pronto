/*
* AJ Savino
*/
package com.moxieinteractive.pronto.geom {
	//-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.geom.Point;
	//-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class Vector2D extends Point {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static function add(v1:*, v2:*):Vector2D {
			if (v1 is Point){
				if (v2 is Point){
					return new Vector2D(v1.x + v2.x, v1.y + v2.y);
				} else {
					return new Vector2D(v1.x + v2, v1.y + v2);
				}
			} else if (v2 is Point){
				return new Vector2D(v1 + v2.x, v1 + v2.y);
			} else {
				return new Vector2D(v1 + v2, v1 + v2);
			}
		}
		
		public static function subtract(v1:*, v2:*):Vector2D {
			if (v1 is Point){
				if (v2 is Point){
					return new Vector2D(v1.x - v2.x, v1.y - v2.y);
				} else {
					return new Vector2D(v1.x - v2, v1.y - v2);
				}
			} else if (v2 is Point){
				return new Vector2D(v1 - v2.x, v1 - v2.y);
			} else {
				return new Vector2D(v1 - v2, v1 - v2);
			}
		}
		
		public static function multiply(v1:*, v2:*):Vector2D {
			if (v1 is Point){
				if (v2 is Point){
					return new Vector2D(v1.x * v2.x, v1.y * v2.y);
				} else {
					return new Vector2D(v1.x * v2, v1.y * v2);
				}
			} else if (v2 is Point){
				return new Vector2D(v1 * v2.x, v1 * v2.y);
			} else {
				return new Vector2D(v1 * v2, v1 * v2);
			}
		}
		
		public static function divide(v1:*, v2:*):Vector2D {
			if (v1 is Point){
				if (v2 is Point){
					return new Vector2D(v1.x / v2.x, v1.y / v2.y);
				} else {
					return new Vector2D(v1.x / v2, v1.y / v2);
				}
			} else if (v2 is Point){
				return new Vector2D(v1 / v2.x, v1 / v2.y);
			} else {
				return new Vector2D(v1 / v2, v1 / v2);
			}
		}
		
		public static function dotProduct(p1:Point, p2:Point):Number {
			return (p1.x * p2.x) + (p1.y * p2.y);
		}
		
		//Parses a comma delimeted x,y pair from a string
		public static function parseString(vector:String):Vector2D {
			var components:Array = vector.split(",");
			
			return new Vector2D(components[0], components[1]);
		}
		
		public static function parsePoint(p:Point):Vector2D {
			return new Vector2D(p.x, p.y);
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get magnitude():Number {
			return Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));
		}
		public function set magnitude(value:Number):void {
			normalize(value);
		}
		
		public function get angle():Number {
			return Calc.toDegrees(Math.atan2(y, x));
		}
		public function set angle(value:Number):void {
			x = Math.sin(Calc.toDegrees(90 - value));
			y = Math.sin(Calc.toDegrees(value));
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function Vector2D(x:Number = 0, y:Number = 0){
			super(x, y);
		}
		
		override public function add(v:Point):Point {
			x += v.x;
			y += v.y;
			
			return this;
		}
		
		override public function subtract(v:Point):Point {
			x -= v.x;
			y -= v.y;
			
			return this;
		}
		
		public function multiply(v:*):void {
			if (v is Point){
				x *= v.x;
				y *= v.y;
			} else if (v is Number){
				x *= v;
				y *= v;
			}
		}
		
		public function divide(v:*):void {
			if (v is Point){
				x /= v.x;
				y /= v.y;
			} else if (v is Number){
				x /= v;
				y /= v;
			}
		}
		
		public function normal():void {
			normalize(1);
		}
		
		public function compare(compareTo:Point):Boolean {
			if (x == compareTo.x && y == compareTo.y){
				return true;
			}
			return false;
		}
		
		override public function normalize(thickness:Number):void {
			divide(magnitude);
			multiply(thickness);
		}
		
		override public function clone():Point{
			return new Vector2D(x, y);
		}
		
		override public function toString():String {
			return "<" + x + ", " + y + ">";
		}
	}
}