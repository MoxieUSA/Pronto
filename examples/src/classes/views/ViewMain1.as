/*
* AJ Savino
*/
package views {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ViewMain1 extends BaseView {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static const ID:String = "view_main_1";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var btn_prev:SimpleButton;
		public var btn_next:SimpleButton;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ViewMain1(){
			super(ID);
		}
		
		//This method only gets called once from the constructor
		override public function init():void {
			super.init();
		}
		
		//Called from addedToStage (if _autoActivate is false then this will need to be called manually)
		//This method gets called each time the view is displayed
		override public function initialize():void {
			super.initialize();
		}
		
		//This method gets called after initialize
		override public function transitionIn():void {
			_viewMgr.showView(ExViewManager.VIEW_LOADING);
			
			super.transitionIn();
		}
		
		//This method gets called after the transitionIn is complete
		override protected function transitionInComplete():void {
			_viewMgr.hideView(ExViewManager.VIEW_LOADING);
			
			super.transitionInComplete();
		}
		
		//This method gets called after transitionInComplete
		//Use this method to addEventListeners
		override public function activate():Boolean {
			if (!super.activate()){
				return false;
			}
			btn_prev.addEventListener(MouseEvent.CLICK, handler_prev_click);
			btn_next.addEventListener(MouseEvent.CLICK, handler_next_click);
			
			return true;
		}
		
		//This method is called to trigger the transitionOut process
		override public function transitionOut():void {
			super.transitionOut();
		}
		
		//This method is called from transitionOut and destroy
		//Use this method to removeEventListeners
		override public function deactivate():Boolean {
			if (!super.deactivate()){
				return false;
			}
			btn_prev.removeEventListener(MouseEvent.CLICK, handler_prev_click);
			btn_next.removeEventListener(MouseEvent.CLICK, handler_next_click);
			
			return true;
		}
		
		//This method is called after transitionOut is complete
		override protected function transitionOutComplete():void {
			super.transitionOutComplete();
		}
		
		//This method is called from transitionOutComplete
		//Use this method to clean up initialization
		override public function destroy():void {
			super.destroy();
		}
		
		//This method calls destroy followed by initialize
		override public function reset():void {
			super.reset();
		}
		
		protected function handler_prev_click(evt:MouseEvent):void {
			displayPreviousView();
		}
		
		protected function handler_next_click(evt:MouseEvent):void {
			displayNextView();
		}
	}
}