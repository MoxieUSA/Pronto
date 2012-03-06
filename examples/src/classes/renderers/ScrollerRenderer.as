/*
* AJ Savino
*/
package renderers {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.renderers.core.BasicRenderer;
	import com.moxieinteractive.pronto.events.RendererEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ScrollerRenderer extends BasicRenderer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const PROP_RENDER:String = "prop_render";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ScrollerRenderer(){
			super();
		}
		
		override public function render():void {
			if (!_data){
				return;
			}
			dispatchEvent(new RendererEvent(RendererEvent.BEGIN_RENDER));
			
			gotoAndStop(_data);
			
			validateProperty(PROP_RENDER);
			dispatchEvent(new RendererEvent(RendererEvent.END_RENDER));
		}
	}
}