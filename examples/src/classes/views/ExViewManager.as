/*
* AJ Savino
*/
package views {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.views.*;
	
	import flash.display.MovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ExViewManager extends ViewManager {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		//Layers
		public static const LAYER_BG:String = "layer_bg";
		public static const LAYER_MAIN:String = "layer_main";
		public static const LAYER_OVER:String = "layer_over";
		
		//Background views
		public static const VIEW_BG_1:String = ViewBG1.ID;
		
		//Main views
		public static const VIEW_MAIN_1:String = ViewMain1.ID;
		public static const VIEW_MAIN_2:String = ViewMain2.ID;
		public static const VIEW_MAIN_3:String = ViewMain3.ID;
		
		//Over views
		public static const VIEW_LOADING:String = ViewLoading.ID;
		
		public static var _instance:ExViewManager;
		
		public var bgLayer:ViewLayer;
		public var mainLayer:ViewLayer;
		public var overLayer:ViewLayer;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public static function getInstance():ExViewManager {
			if (!_instance){
				_instance = new ExViewManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		public static function destroyInstance():void {
			_instance.destroy();
			_instance = null;
		}
		
		public function ExViewManager(enforcer:SingletonEnforcer){
			super();
		}
		
		override public function initialize(container:MovieClip):void {
			super.initialize(container);
			
			bgLayer = new ViewLayer(LAYER_BG);
			mainLayer = new ViewLayer(LAYER_MAIN);
			overLayer = new ViewLayer(LAYER_OVER);
			
			addLayer(bgLayer);
			addLayer(mainLayer);
			addLayer(overLayer);
			
			bgLayer.addView(new ViewBG1_Library());
			
			mainLayer.addView(new ViewMain1_Library());
			mainLayer.addView(new ViewMain2_Library());
			mainLayer.addView(new ViewMain3_Library());
			mainLayer.setDisplayList(VIEW_MAIN_1, VIEW_MAIN_2, VIEW_MAIN_3);
			
			overLayer.addView(new ViewLoading_Library());
		}
	}
}

class SingletonEnforcer {}