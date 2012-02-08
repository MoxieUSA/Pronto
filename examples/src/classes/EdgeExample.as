/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.utils.ObjUtil;
	
	import flash.display.MovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	//Edge detection regardless of registration location
	public class EdgeExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var square:MovieClip;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function EdgeExample(){
			super();
		}
		
		override protected function init():void {
			graphics.lineStyle(2, 0xFF0000);
			graphics.moveTo(0, ObjUtil.getTopEdge(square));
			graphics.lineTo(stage.stageWidth, ObjUtil.getTopEdge(square));
			graphics.moveTo(0, ObjUtil.getBottomEdge(square));
			graphics.lineTo(stage.stageWidth, ObjUtil.getBottomEdge(square));
			graphics.moveTo(ObjUtil.getLeftEdge(square), 0);
			graphics.lineTo(ObjUtil.getLeftEdge(square), stage.stageHeight);
			graphics.moveTo(ObjUtil.getRightEdge(square), 0);
			graphics.lineTo(ObjUtil.getRightEdge(square), stage.stageHeight);
		}
	}
}