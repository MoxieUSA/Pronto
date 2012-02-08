/*
* AJ Savino
*/
package views {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.views.View;
	import com.moxieinteractive.pronto.views.ViewLayer;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class BaseView extends View {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _viewMgr:ExViewManager;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function BaseView(viewId:String){
			super(viewId);
		}
		
		override public function initialize():void {
			_viewMgr = ExViewManager.getInstance();
			
			super.initialize();
		}
		
		override public function destroy():void {
			super.destroy();
			
			_viewMgr = null;
		}
		
		public function displayNextView():void {
			var layer:ViewLayer = getCurrentLayer();
			if (layer) {
				layer.displayNextView();
			}
		}
		
		public function displayPreviousView():void {
			var layer:ViewLayer = getCurrentLayer();
			if (layer) {
				layer.displayPreviousView();
			}
		}
		
		protected function getCurrentLayer():ViewLayer {
			return _viewMgr.resolveViewToLayer(this);
		}
	}
}