/*
* AJ Savino
*/
package com.moxieinteractive.pronto.vo {
	public class MetaDataVO extends VO {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const VIDEO_CODEC_SORENSON_H263:uint = 2;
		public static const VIDEO_CODEC_SCREEN_VIDEO:uint = 3;
		public static const VIDEO_CODEC_VP6:uint = 4;
		public static const VIDEO_CODEC_VP6_ALPHA:uint = 5;
		
		public static const AUDIO_CODEC_UNCOMPRESSED:uint = 0;
		public static const AUDIO_CODEC_ADPCM:uint = 1;
		public static const AUDIO_CODEC_MP3:uint = 2;
		public static const AUDIO_CODEC_NELLYMOSER_8K_MONO:uint = 5;
		public static const AUDIO_CODEC_NELLYMOSER:uint = 6;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var audioCodecId:Number;
		public var audioDataRate:Number;
		public var audioDelay:Number;
		public var canSeekToEnd:Boolean;
		public var cuePoints:Array;
		public var duration:Number;
		public var frameRate:Number;
		public var height:Number;
		public var videoCodecId:Number;
		public var videoDataRate:Number;
		public var width:Number;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function MetaDataVO(metaInfo:Object = null){
			super();
			if (metaInfo){
				parseMetaInfo(metaInfo);
			}
		}
		
		public function parseMetaInfo(metaInfo:Object):void {
			audioCodecId = metaInfo.audiocodecid;
			audioDataRate = metaInfo.audiodatarate;
			audioDelay = metaInfo.audiodelay;
			canSeekToEnd = metaInfo.canSeekToEnd;
			cuePoints = metaInfo.cuePoints;
			duration = metaInfo.duration;
			frameRate = metaInfo.framerate;
			height = metaInfo.height;
			videoCodecId = metaInfo.videocodecid;
			videoDataRate = metaInfo.videodatarate;
			width = metaInfo.width;
		}
	}
}