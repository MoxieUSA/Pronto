/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.vo.VO;
	import com.moxieinteractive.pronto.vo.MetaDataVO;
	
	import flash.text.TextField;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	//By extending the base VO class and tracing an instance you can see all name/value pairs
	public class VOExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var txtOutput:TextField;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function VOExample(){
			super();
		}
		
		override protected function init():void {
			var vo:VO = new MetaDataVO();
			
			trace (vo);
			txtOutput.text = vo.toString();
		}
	}
}