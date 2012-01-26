/*
* AJ Savino
*/
package com.moxieinteractive.pronto.utils {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.DisplayObject;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	import flash.utils.describeType;
	
	import fl.motion.Color;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ObjUtil {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const OUTLINE_INDENT_SIZE:uint = 4;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static var _lastDispObj:DisplayObject;
		private static var _lastBounds:Rectangle;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//Returns back a string representation of an objects properties (formated as xml with proper indentations for nested objects) 
		public static function outlineObject(obj:*, indentSize:uint = OUTLINE_INDENT_SIZE):String {
			var indent:String = "";
			for (var i:uint = 0; i < indentSize; i++){
				indent += " ";
			}
			
			var className:String = getQualifiedClassName(obj);
			var properties:XMLList = describeType(obj).variable;
			
			var output:String = "<" + className + "\n";
			for each (var variableNode:XML in properties){
				var value:* = obj[variableNode.@name]
				if (value is ObjectTracer){
					output += indent + variableNode.@name + "='" + value.toString(indentSize + OUTLINE_INDENT_SIZE) + "'" + "\n";
				} else {
					output += indent + variableNode.@name + "='" + value + "'" + "\n";
				}
			}
			output += indent.substr(0, indent.length - OUTLINE_INDENT_SIZE) + "/>";
			
			return output;
		}
		
		//Populates an object instance's properties from an xml node's attributes
		//xml is a generic type so that you can pass in either XML or XMLList
		public static function populateFromXML(obj:*, fromXML:*):void {
			var xmlAttribute:XML;
			for each (xmlAttribute in fromXML.attributes()) {
				var attributeName:String = String(xmlAttribute.name());
				
				if (obj.hasOwnProperty(attributeName)){
					if (typeof(obj[attributeName]) == "boolean"){ //See if the attribute is a boolean
						obj[attributeName] = (xmlAttribute.toString() == "true");
					} else { //Any other type of attribute
						obj[attributeName] = xmlAttribute.toString();
					}
				}
			}
		}
		
		//Populates an object instance's properties from another object containing name/value pairs
		public static function populateFromObject(obj:*, fromObj:Object):void {
			for (var prop:String in fromObj){
				if (obj.hasOwnProperty(prop)){
					obj[prop] = fromObj[prop];
				}
			}
		}
		
		//gotoAndStop without throwing errors for frames/labels that don't exist
		public static function gotoAndStop(clip:MovieClip, frameID:*):Boolean {
			var frame:int = resolveFrameID(clip, frameID);
			if (frame != -1){
				clip.gotoAndStop(frame);
				return true;
			}
			
			return false;
		}
		
		//gotoAndPlay without throwing errors for frames/labels that don't exist
		public static function gotoAndPlay(clip:MovieClip, frameID:*):Boolean {
			var frame:int = resolveFrameID(clip, frameID);
			if (frame != -1){
				clip.gotoAndPlay(frame);
				return true;
			}
			
			return false;
		}
		
		//When the frameID (frame/label) of the specified clip is hit the method will be called
		//Note: Will replace any existing frameScript on the specified frameID
		public static function addFrameScript(clip:MovieClip, frameID:*, method:Function):Boolean {
			var frame:int = resolveFrameID(clip, frameID);
			if (frame != -1){
				clip.addFrameScript(frame - 1, method);
				return true;
			}
			
			return false;
		}
		
		//Removes any existing frameScript on the specified frameID
		public static function removeFrameScript(clip:MovieClip, frameID:*):Boolean {
			return addFrameScript(clip, frameID, null);
		}
		
		//Resolves a frameID (frame/label) to a frame number or -1 if it does not exist for the specified clip
		public static function resolveFrameID(clip:MovieClip, frameID:*):int {
			if (frameID is String){
				var labels:Array = clip.currentLabels;
				var labelsLength:uint = labels.length;
				for (var i:uint = 0; i < labelsLength; i++){
					var label:Object = labels[i];
					if (label.name == frameID){
						return label.frame;
					}
				}
			} else if (frameID is uint){
				if (frameID <= clip.totalFrames){
					return frameID;
				}
			} else {
				throw new Error("frameID must be either a String or uint");
			}
			
			return -1;
		}
		
		//Returns true if the specified clip contains ALL of the compareLabels
		public static function hasLabels(clip:MovieClip, ... compareLabels):Boolean {
			if (!compareLabels){
				return false;
			}
			if (compareLabels[0] is Array){
				compareLabels = compareLabels[0];
			}
			var labelCount:uint;
			var compareLabelsLength:uint = compareLabels.length;
			var labels:Array = clip.currentLabels;
			var labelsLength:uint = labels.length;
			for (var i:uint = 0; i < labelsLength; i++){
				for (var j:uint = 0; j < compareLabelsLength; j++){
					if (labels[i].name == compareLabels[j]){
						labelCount++;
						break;
					}
				}
				if (labelCount == compareLabelsLength){
					return true;
				}
			}
			
			return false;
		}
		
		//Returns true if the specified relative coordinate falls within the displayObject's bounding box AND the pixel at the coordinate is not 100% alpha
		public static function hitTestPixel(dispObj:DisplayObject, relativeX:Number, relativeY:Number):Boolean {
			if (relativeX > 0 && relativeX < dispObj.width){
				if (relativeY > 0 && relativeY < dispObj.height){
					var bmpd:BitmapData = new BitmapData(dispObj.width, dispObj.height, true, 0x00000000);
					bmpd.draw(dispObj);
					var argb:uint = bmpd.getPixel32(relativeX, relativeY);
					bmpd.dispose();
					var alpha:uint = (argb >> 24) & 0xFF;
					if (alpha){
						return true;
					}
				}
			}
			
			return false;
		}
		
		public static function tint(dispObj:DisplayObject, color:uint, amount:Number = 0.73):void {
			var c:Color = new Color();
			c.setTint(color, amount);
			dispObj.transform.colorTransform = c;
		}
		
		public static function getTopEdge(dispObj:DisplayObject):Number {
			return dispObj.y + getTopEdgeOffset(dispObj);
		}
		
		public static function getBottomEdge(dispObj:DisplayObject):Number {
			return dispObj.y + getBottomEdgeOffset(dispObj);
		}
		
		public static function getLeftEdge(dispObj:DisplayObject):Number {
			return dispObj.x + getLeftEdgeOffset(dispObj);
		}
		
		public static function getRightEdge(dispObj:DisplayObject):Number {
			return dispObj.x + getRightEdgeOffset(dispObj);
		}
		
		public static function getTopEdgeOffset(dispObj:DisplayObject):Number {
			return getObjBounds(dispObj).y;
		}
		
		public static function getBottomEdgeOffset(dispObj:DisplayObject):Number {
			return getObjBounds(dispObj).y + getObjBounds(dispObj).height;
		}
		
		public static function getLeftEdgeOffset(dispObj:DisplayObject):Number {
			return getObjBounds(dispObj).x;
		}
		
		public static function getRightEdgeOffset(dispObj:DisplayObject):Number {
			return getObjBounds(dispObj).x + getObjBounds(dispObj).width;
		}
		
		public static function getFullWidth(dispObj:DisplayObject):Number {
			return getRightEdgeOffset(dispObj) - getLeftEdgeOffset(dispObj);
		}
		
		public static function getFullHeight(dispObj:DisplayObject):Number {
			return getBottomEdgeOffset(dispObj) - getTopEdgeOffset(dispObj);
		}
		
		private static function getObjBounds(dispObj:DisplayObject):Rectangle {
			if (dispObj != _lastDispObj){
				_lastDispObj = dispObj;
				_lastBounds = dispObj.getBounds(dispObj);
			}
			return _lastBounds;
		}
	}
}