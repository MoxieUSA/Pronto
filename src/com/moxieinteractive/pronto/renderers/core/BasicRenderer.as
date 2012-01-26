/*
* AJ Savino
*/
package com.moxieinteractive.pronto.renderers.core {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.renderers.api.IRenderer;
	import com.moxieinteractive.pronto.events.RendererEvent;
	
	import com.moxieinteractive.pronto.ui.core.UIMovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class BasicRenderer extends UIMovieClip implements IRenderer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const PROP_RENDER:String = "prop_render";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const WIDTH:Number = 64;
		public static const HEIGHT:Number = 64;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=
		protected var _data:*;
		//-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get data():* {
			return _data;
		}
		public function set data(value:*):void {
			_data = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get defaultData():* {
			var defaultData:Object = new Object();
			defaultData.x = 0;
			defaultData.y = 0;
			defaultData.width = WIDTH;
			defaultData.height = HEIGHT;
			defaultData.color = uint(Math.random() * 0xFFFFFF);
			defaultData.alpha = (Math.random() * 0.5) + 0.5;
			
			return defaultData;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		override public function init():void {
			super.init();
			
			_data = defaultData;
		}
		
		override public function destroy():void {
			_data = null;
			
			super.destroy();
		}
		
		public function render():void {
			if (!_data){
				return;
			}
			dispatchEvent(new RendererEvent(RendererEvent.BEGIN_RENDER));
			
			graphics.clear();
			graphics.beginFill(_data.color, _data.alpha);
				graphics.drawRect(_data.x, _data.y, _data.width, _data.height);
			graphics.endFill();
			
			validateProperty(PROP_RENDER);
			dispatchEvent(new RendererEvent(RendererEvent.END_RENDER));
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid(PROP_RENDER)){
				render();
			}
		}
	}
}