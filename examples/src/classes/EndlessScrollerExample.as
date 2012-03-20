/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.renderers.EndlessScroller;
	import com.moxieinteractive.pronto.events.EndlessScrollerEvent;
	
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	//Creates an "endless" horizontal scroller of renderers
	public class EndlessScrollerExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const RENDERER:Class = ScrollerRenderer_Library;	//The renderer class to use
		private static const PRODUCT_WIDTH:Number = 200;					//The width of the renderer
		private static const PRODUCT_HEIGHT:Number = 100;					//The height of the renderer
		private static const SPACING:Number = 32;							//The spacing between renderers
		private static const ENDS_COUNT:Number = 2;						//How many renderers to duplicate on the ends (default is 1 this is what makes it endless)
		private static const TIMING:Number = 0.5;							//The amount of time to cycle to another renderer
		private static const EASING:Function = Quad.easeOut;				//Easing equation when cycling renderers
		
		private static const LIGHT_OFFSET_X:Number = 300;
		private static const LIGHT_OFFSET_Y:Number = 350;
		private static const LIGHT_SPACING:Number = 32;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var btn_prev:SimpleButton;
		public var btn_next:SimpleButton;
		public var scrollerAttach:MovieClip;
		
		protected var _rendererTotalFrames:uint;
		protected var _scroller:EndlessScroller;
		protected var _lights:Array;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function EndlessScrollerExample(){
			super();
		}
		
		override protected function init():void {
			_rendererTotalFrames = new RENDERER().totalFrames;
			
			//Set our data to contain an array of frame numbers
			var scrollerData:Array = new Array();
			for (var i:uint = 0; i < _rendererTotalFrames; i++){
				scrollerData.push(i + 1);
			}
			
			_scroller = new EndlessScroller();
			_scroller.renderer = RENDERER;
			_scroller.itemWidth = PRODUCT_WIDTH;
			_scroller.itemHeight = PRODUCT_HEIGHT;
			_scroller.hSpacing = SPACING;
			_scroller.endsCount = ENDS_COUNT;
			_scroller.data = scrollerData;			//Set data to our frame array. A renderer will get created for each item in the array.
			_scroller.timing = TIMING
			_scroller.easing = EASING;
			_scroller.addEventListener(EndlessScrollerEvent.BEGIN_SELECT, handler_scroller_beginSelect);
			scrollerAttach.addChild(_scroller);
			
			initUI();
		}
		
		protected function initUI():void {
			btn_prev.addEventListener(MouseEvent.CLICK, handler_prev_click);
			btn_next.addEventListener(MouseEvent.CLICK, handler_next_click);
			
			_lights = new Array();
			for (var i:uint = 0; i < _rendererTotalFrames; i++){
				var light:MovieClip = new Light_Library();
				light.x = LIGHT_OFFSET_X + ((i - Math.floor((_rendererTotalFrames * 0.5))) * (light.width + LIGHT_SPACING));
				light.y = LIGHT_OFFSET_Y;
				light.buttonMode = true;
				light.useHandCursor = true;
				light.mouseChildren = false;
				light.addEventListener(MouseEvent.CLICK, handler_light_click);
				addChild(light);
				
				_lights.push(light);
			}
		}
		
		protected function handler_prev_click(evt:MouseEvent):void {
			_scroller.selectPrev();
		}
		
		protected function handler_next_click(evt:MouseEvent):void {
			_scroller.selectNext();
		}
		
		protected function handler_light_click(evt:MouseEvent):void {
			var index:int = _lights.indexOf(evt.target);
			if (index == -1){
				return;
			}
			_scroller.selectIndex(index);
		}
		
		//Updates the light status indication
		protected function handler_scroller_beginSelect(evt:EndlessScrollerEvent):void {
			var index:int = _scroller.selectedIndex;
			var lightsLength:uint = _lights.length;
			for (var i:uint = 0; i < lightsLength; i++){
				if (i == index){
					_lights[i].gotoAndStop("on");
				} else {
					_lights[i].gotoAndStop("off");
				}
			}
		}
	}
}