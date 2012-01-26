/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.utils.Tokenizer;
	
	import flash.text.TextField;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class TokenizerExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const TOKEN_WOOD:String = "{WOOD}";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=
		public var txt:TextField;
		//-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function TokenizerExample(){
			super();
		}
		
		override protected function init():void {
			var obj:Object = new Object();
			obj[TOKEN_WOOD] = "PINE";
			
			txt.text = Tokenizer.replaceTokens(txt.text, obj);
		}
	}
}