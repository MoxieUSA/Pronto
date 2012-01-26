/*
* AJ Savino
*/
package com.moxieinteractive.pronto.audio {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class AudioManager {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const MAX_SUPPORTED_CHANNELS:uint = 32;	//As supported by flash
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static var _instance:AudioManager;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public static function getInstance():AudioManager {
			if (!_instance){
				_instance = new AudioManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		public static function destroyInstance():void {
			_instance = null;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _appDomain:ApplicationDomain;
		
		protected var _music:Sound;
		protected var _musicChannel:SoundChannel;
		protected var _maxSFXChannels:uint = 3;		//Max concurrent sfx channels
		protected var _sfxChannels:Array;
		
		protected var _musicTransform:SoundTransform;
		protected var _sfxTransform:SoundTransform;
		protected var _musicVolume:Number;
		protected var _sfxVolume:Number;
		protected var _globalVolume:Number;
		
		protected var _lastGlobalVolume:Number;
		protected var _isMuted:Boolean;
		protected var _isMusicPlaying:Boolean;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get maxSFXChannels():uint {
			return _maxSFXChannels;
		}
		public function set maxSFXChannels(value:uint):void {
			_maxSFXChannels = Math.max(Math.min(value, MAX_SUPPORTED_CHANNELS - 1), 1); //Subtract one for music channel
		}
		
		public function get musicVolume():Number {
			return _musicVolume;
		}
		public function set musicVolume(value:Number):void {
			setMusicVolume(value);
		}
		
		public function get sfxVolume():Number {
			return _sfxVolume;
		}
		public function set sfxVolume(value:Number):void {
			setSFXVolume(value);
		}
		
		public function get globalVolume():Number {
			return _globalVolume;
		}
		public function set globalVolume(value:Number):void {
			setGlobalVolume(value);
		}
		
		public function get isMuted():Boolean {
			return _isMuted;
		}
		public function set isMuted(value:Boolean):void {
			if (value){
				mute();
			} else {
				unmute();
			}
		}
		
		public function get isMusicPlaying():Boolean {
			return _isMusicPlaying;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function AudioManager(enforcer:SingletonEnforcer){
			init();
		}
		
		protected function init():void {
			_appDomain = ApplicationDomain.currentDomain;
			
			_sfxChannels = new Array();
			
			_musicTransform = new SoundTransform();
			_sfxTransform = new SoundTransform();
			
			setMusicVolume(1);
			setSFXVolume(1);
			setGlobalVolume(1);
		}
		
		public function playMusic(sound:*, loops:uint = 9999):void {
			if (_isMusicPlaying){
				stopMusic();
			}
			_isMusicPlaying = true;
			
			_music = resolveSound(sound);
			if (_music){
				_musicChannel = _music.play(0, 9999);
				_musicChannel.soundTransform = _musicTransform;
			}
		}
		
		public function stopMusic():void {
			if (!_isMusicPlaying){
				return;
			}
			_isMusicPlaying = false;
			
			_musicChannel.stop();
			_musicChannel = null;
		}
		
		public function playSFX(sound:*):void {
			var sfx:Sound = resolveSound(sound);
			if (sfx){
				requestSFXChannel(sfx);
			}
		}
		
		public function mute():void {
			if (_isMuted){
				return;
			}
			_isMuted = true;
			
			_lastGlobalVolume = _globalVolume;
			setGlobalVolume(0);
		}
		
		public function unmute():void {
			if (!_isMuted){
				return;
			}
			_isMuted = false;
			
			setGlobalVolume(_lastGlobalVolume);
		}
		
		public function setMusicVolume(scale:Number):void {
			_musicVolume = Math.max(Math.min(scale, 1), 0);
			_musicTransform.volume = _musicVolume * _globalVolume;
			if (_musicChannel){
				_musicChannel.soundTransform = _musicTransform;
			}
		}
		
		public function setSFXVolume(scale:Number):void {
			_sfxVolume = Math.max(Math.min(scale, 1), 0);
			_sfxTransform.volume = _sfxVolume * _globalVolume;
			
			var sfxChannelsLength:uint = _sfxChannels.length;
			for (var i:uint = 0; i < sfxChannelsLength; i++){
				_sfxChannels[i].soundTransform = _sfxTransform;
			}
		}
		
		public function setGlobalVolume(scale:Number):void {
			_globalVolume = Math.max(Math.min(scale, 1), 0);
			_musicTransform.volume = _musicVolume * _globalVolume;
			_sfxTransform.volume = _sfxVolume * _globalVolume;
			
			if (_musicChannel){
				_musicChannel.soundTransform = _musicTransform;
			}
			var sfxChannelsLength:uint = _sfxChannels.length;
			for (var i:uint = 0; i < sfxChannelsLength; i++){
				_sfxChannels[i].soundTransform = _sfxTransform;
			}
		}
		
		protected function resolveSound(sound:*):Sound {
			if (sound is Sound){
				return sound;
			} else if (sound is String){
				if (_appDomain.hasDefinition(sound)){
					sound = _appDomain.getDefinition(sound) as Class;
				}
			}
			if (sound is Class){
				return new sound();
			}
			
			return null;
		}
		
		public function stopAllSFX():void {
			var sfxChannelsLength:uint = _sfxChannels.length;
			for (var i:uint = 0; i < sfxChannelsLength; i++){
				var channel:SoundChannel = _sfxChannels[i];
				channel.removeEventListener(Event.SOUND_COMPLETE, handler_sfx_soundComplete);
				channel.stop();
				_sfxChannels.splice(i, 1);
				i--;
				sfxChannelsLength--;
			}
		}
		
		public function stopAll():void {
			stopMusic();
			stopAllSFX();
		}
		
		protected function requestSFXChannel(sound:Sound):void {
			var channel:SoundChannel;
			if (_sfxChannels.length < _maxSFXChannels){
				channel = sound.play();
			} else { //No avaliable channels so kill oldest sfx
				channel = _sfxChannels.shift();
				channel.removeEventListener(Event.SOUND_COMPLETE, handler_sfx_soundComplete);
				channel.stop();
				channel = sound.play();
			}
			channel.soundTransform = _sfxTransform;
			channel.addEventListener(Event.SOUND_COMPLETE, handler_sfx_soundComplete);
			_sfxChannels.push(channel);
		}
		
		protected function handler_sfx_soundComplete(evt:Event):void {
			var channel:SoundChannel = evt.target as SoundChannel;
			channel.removeEventListener(Event.SOUND_COMPLETE, handler_sfx_soundComplete);
			
			var sfxChannelsLength:uint = _sfxChannels.length;
			for (var i:uint = 0; i < sfxChannelsLength; i++){
				if (_sfxChannels[i] == channel){
					_sfxChannels.splice(i, 1);
					i--;
					sfxChannelsLength--;
					break;
				}
			}
		}
	}
}

class SingletonEnforcer {}