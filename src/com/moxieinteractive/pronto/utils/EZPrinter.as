/*
* AJ Savino
*/
package com.moxieinteractive.pronto.utils {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.printing.PrintJob;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class EZPrinter {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static function get isSupported():Boolean {
			return PrintJob.isSupported;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//Orients the content (portrait or landscape), scales it to fit within the page's aspectRatio, centers it on the page, and sends it to the printer
		public static function print(content:DisplayObject, backgroundColor:uint = 0x00FFFFFF):void {
			if (!PrintJob.isSupported){
				throw new Error("Printing is not supported");
			}
			var pj:PrintJob = new PrintJob();
			if (pj.start()){
				var rotated:Boolean = false;
				var pjWidth:Number = pj.pageWidth;
				var pjHeight:Number = pj.pageHeight;
				if (pjWidth > pjHeight){
					if (content.width < content.height){
						rotated = true;
					}
				} else if (pjHeight > pjWidth){
					if (content.height < content.width){
						rotated = true;
					}
				}
				
				var wh:Object;
				var offsetX:Number;
				var offsetY:Number;
				var mat:Matrix = new Matrix();
				var rect:Rectangle;
				if (rotated){ //Landscape
					wh = VideoUtils.applyAspectRatio(pjHeight, pjWidth, content.width, content.height);
					offsetX = (pjWidth - (content.height * wh.scale)) * 0.5;
					offsetY = (pjHeight - (content.width * wh.scale)) * 0.5;
					
					mat.translate(-content.width * 0.5, -content.height * 0.5);
					mat.rotate(Math.PI * 0.5);
					mat.translate(content.height * 0.5, content.width * 0.5);
				} else { //Portrait
					wh = VideoUtils.applyAspectRatio(pjWidth, pjHeight, content.width, content.height);
					offsetX = (pjWidth - (content.width * wh.scale)) * 0.5;
					offsetY = (pjHeight - (content.height * wh.scale)) * 0.5;
				}
				mat.scale(wh.scale, wh.scale);
				mat.translate(offsetX, offsetY);
				rect = new Rectangle(0, 0, pjWidth, pjHeight);
				
				var bmpd:BitmapData = new BitmapData(pjWidth, pjHeight, false, backgroundColor);
				bmpd.draw(content, mat);
				var page:Sprite = new Sprite();
				page.addChild(new Bitmap(bmpd));
				
				pj.addPage(page, rect);
				pj.send();
			}
		}
	}
}