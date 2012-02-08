/*
* AJ Savino
*/
package {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.Main;
	import com.moxieinteractive.pronto.audio.AudioManager;
	
	import flash.events.MouseEvent;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class AudioExample extends Main {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _audioMan:AudioManager;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function AudioExample(){
			super();
		}
		
		override protected function init():void {
			_audioMan = AudioManager.getInstance();
			_audioMan.maxSFXChannels = 2; //Only allow a max of two sound effects playing at once
			_audioMan.globalVolume = 0.75;
			_audioMan.musicVolume = 0.5;
			_audioMan.sfxVolume = 0.8;
			_audioMan.playMusic("music"); //Pass sound instance, linkage, or a sound as a class
			
			stage.addEventListener(MouseEvent.CLICK, handler_click);
		}
		
		protected function handler_click(evt:MouseEvent):void {
			_audioMan.playSFX("sfx_" + (uint(Math.random() * 3) + 1)); //Pass sound instance, linkage, or a sound as a class
			
			/*if (_audioMan.isMuted){
				_audioMan.unmute();
			} else {
				_audioMan.mute();
			}*/
		}
	}
}