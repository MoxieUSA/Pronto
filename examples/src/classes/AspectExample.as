/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.utils.VideoUtils;
	
	import flash.display.MovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	//Fits the content into the view regardless of eithers size
	public class AspectExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var view:MovieClip;
		public var content:MovieClip;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function AspectExample(){
			super();
		}
		
		override protected function init():void {
			var wh:Object = VideoUtils.applyAspectRatio(view.width, view.height, content.width, content.height);
			content.width *= wh.scale;
			content.height *= wh.scale;
			content.x = view.x + ((view.width - content.width) * 0.5);
			content.y = view.y + ((view.height - content.height) * 0.5);
		}
	}
}