/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import views.*;
	
	import com.moxieinteractive.pronto.Main;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ViewsExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _viewMgr:ExViewManager;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ViewsExample(){
			super();
		}
		
		override protected function init():void {
			_viewMgr = ExViewManager.getInstance();
			_viewMgr.initialize(this);
			_viewMgr.showView(ExViewManager.VIEW_BG_1);
			_viewMgr.showView(ExViewManager.VIEW_MAIN_1);
		}
	}
}