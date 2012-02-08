/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.utils.EZPrinter;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class PrintExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=
		public var p1:MovieClip;
		public var p2:MovieClip;
		//-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function PrintExample(){
			super();
		}
		
		override protected function init():void {
			p1.buttonMode = true;
			p1.useHandCursor= true;
			p1.addEventListener(MouseEvent.CLICK, handler_print_click);
			p2.buttonMode = true;
			p2.useHandCursor= true;
			p2.addEventListener(MouseEvent.CLICK, handler_print_click);
		}
		
		protected function handler_print_click(evt:MouseEvent):void {
			var clip:MovieClip = evt.target as MovieClip;
			if (clip){
				EZPrinter.print(clip);
			}
		}
	}
}