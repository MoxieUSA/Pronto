/*
* AJ Savino
*/
package com.moxieinteractive.pronto.video {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.DisplayObject;
	import flash.system.ApplicationDomain;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class VideoPlayerFactory {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static var appDomain:ApplicationDomain = ApplicationDomain.currentDomain;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public static function constructFromXML(fromXML:XML, useClass:Class = null):MoxieVideoPlayer {
			if (!useClass){
				useClass = MoxieVideoPlayer;
			}
			var videoPlayer:MoxieVideoPlayer = new useClass() as MoxieVideoPlayer;
			if (!videoPlayer){
				throw new Error("useClass parameter is not a MoxieVideoPlayer");
				return null;
			}
			
			if (fromXML.controlBarLocation){
				videoPlayer.controlBarLocation = fromXML.controlBarLocation.toString();
			}
			if (fromXML.autoSpaceControls){
				videoPlayer.autoSpaceControls = fromXML.autoSpaceControls.toString() == "true";
			}
			if (fromXML.autoHideControls){
				videoPlayer.autoHideControls = fromXML.autoHideControls.toString() == "true";
			}
			if (fromXML.controlsHideTime){
				videoPlayer.controlsHideTime = Number(fromXML.controlsHideTime);
			}
			if (fromXML.autoPlay){
				videoPlayer.autoPlay = fromXML.autoPlay.toString() == "true";
			}
			if (fromXML.autoClear){
				videoPlayer.autoClear = fromXML.autoClear.toString() == "true";
			}
			if (fromXML.bufferTime){
				videoPlayer.bufferTime = Number(fromXML.bufferTime);
			}
			if (fromXML.scaleMode){
				videoPlayer.scaleMode = fromXML.scaleMode.toString();
			}
			if (fromXML.deblocking){
				videoPlayer.deblocking = uint(fromXML.deblocking);
			}
			if (fromXML.smoothing){
				videoPlayer.smoothing = fromXML.smoothing.toString() == "true";
			}
			if (fromXML.controls){
				for each (var control:XML in fromXML.controls.elements()){
					var controlName:String = control.name().toString();
					if (appDomain.hasDefinition(controlName)){
						var controlClass:Class = appDomain.getDefinition(controlName) as Class;
						var controlDispObj:DisplayObject = new controlClass() as DisplayObject;
						if (controlDispObj){
							for each (var prop:XML in control.attributes()){
								var propName:String = prop.name().toString();
								if (controlDispObj.hasOwnProperty(propName)){
									if (typeof(controlDispObj[propName]) == "boolean"){
										controlDispObj[propName] = prop.toString() == "true";
									} else {
										controlDispObj[propName] = prop.toString();
									}
								}
							}
							videoPlayer.controlBar.addChild(controlDispObj);
						}
					}
				}
			}
			
			return videoPlayer;
		}
	}
}