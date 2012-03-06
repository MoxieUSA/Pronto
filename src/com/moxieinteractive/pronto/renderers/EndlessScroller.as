/*
* AJ Savino
*/
package com.moxieinteractive.pronto.renderers {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.events.EndlessScrollerEvent;
	import com.moxieinteractive.pronto.renderers.core.BasicRenderer;
	import com.moxieinteractive.pronto.renderers.api.IRenderer;
	import com.moxieinteractive.pronto.geom.Calc;
	import com.moxieinteractive.pronto.events.RendererEvent;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class EndlessScroller extends BasicRenderer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const PROP_RENDER:String = "prop_render";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var timing:Number = 0.5;
		public var easing:Function = Linear.easeOut;
		
		protected var _renderer:Class = BasicRenderer;			//Will cause a re-render
		protected var _itemWidth:Number;						//Will cause a re-render
		protected var _itemHeight:Number;						//Will cause a re-render
		protected var _hSpacing:Number = 16;					//Will cause a re-render
		protected var _endsCount:uint = 1;						//Will cause a re-render
		
		protected var _lastIndex:int;
		protected var _selectedIndex:int;
		
		protected var _container:MovieClip;
		protected var _renderers:Array;
		protected var _isTweening:Boolean;
		protected var _isCycling:Boolean;
		protected var _cycleDirection:int;
		protected var _beginCycleIndex:int;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get renderer():Class {
			return _renderer;
		}
		public function set renderer(value:Class):void {
			setRenderer(value);
		}
		
		public function get itemWidth():Number {
			return _itemWidth;
		}
		public function set itemWidth(value:Number):void {
			_itemWidth = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get itemHeight():Number {
			return _itemHeight;
		}
		public function set itemHeight(value:Number):void {
			_itemHeight = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get hSpacing():Number {
			return _hSpacing;
		}
		public function set hSpacing(value:Number):void {
			_hSpacing = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get endsCount():Number {
			return _endsCount;
		}
		public function set endsCount(value:Number):void {
			_endsCount = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get lastIndex():int {
			return _lastIndex;
		}
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		public function set selectedIndex(value:int):void {
			selectIndex(value);
		}
		
		public function get renderers():Array {
			return _renderers;
		}
		
		public function get selectedData():* {
			if (!_data is Array){
				return null;
			}
			return _data[resolveIndex(_selectedIndex)];
		}
		
		public function get selectedRenderers():Array {
			var selectedData:* = this.selectedData;
			var selectedRenderers:Array = new Array();
			var renderersLength:uint = _renderers.length;
			for (var i:uint = 0; i < renderersLength; i++){
				var renderer:IRenderer = _renderers[i];
				if (renderer.data == selectedData){
					selectedRenderers.push(renderer);
				}
			}
			return selectedRenderers;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function EndlessScroller(renderer:Class = null){
			super();
			
			if (renderer){
				setRenderer(renderer);
			}
		}
		
		override public function init():void {
			super.init();
			
			_selectedIndex = 0;
			_container = new MovieClip();
			addChild(_container);
			
			_renderers = new Array();
		}
		
		override public function destroy():void {
			TweenLite.killTweensOf(_container);
			
			super.destroy();
			
			destroyRenderers();
			_renderers = null;
			
			removeChild(_container);
			_container = null;
		}
		
		public function setRenderer(renderer:Class = null):void {
			_renderer = renderer;
			if (_renderer){
				var template:IRenderer = new _renderer();
				_itemWidth = template.width;
				_itemHeight = template.height;
			}
			
			invalidateProperty(PROP_RENDER);
		}
		
		public function destroyRenderers():void {
			while (_renderers.length){
				var renderer:IRenderer = _renderers.shift();
				renderer.data = null;
				_container.removeChild(renderer as DisplayObject);
			}
		}
		
		public function selectPrev():void {
			selectIndex(_selectedIndex - 1);
		}
		
		public function selectNext():void {
			selectIndex(_selectedIndex + 1);
		}
		
		public function selectIndex(index:int):void {
			if (!(_data is Array)){
				return;
			}
			if (_isTweening){
				return;
			}
			index = Math.max(Math.min(index, _data.length), -1);
			
			var offset:Number = index - _selectedIndex;
			var direction:int = offset / Math.abs(offset);
			if (!direction){
				return;
			}
			_isTweening = true;
			_lastIndex = _selectedIndex;
			_selectedIndex = index;
			
			dispatchEvent(new EndlessScrollerEvent(EndlessScrollerEvent.BEGIN_SELECT));
			TweenLite.to(_container, timing, {x:-getXOffset(index), onComplete:handler_selectIndex_complete, ease:easing});
		}
		
		protected function handler_selectIndex_complete():void {
			_isTweening = false;
			
			_lastIndex = resolveIndex(_lastIndex);
			_selectedIndex = resolveIndex(_selectedIndex);
			_container.x = -getXOffset(_selectedIndex);
			
			dispatchEvent(new EndlessScrollerEvent(EndlessScrollerEvent.END_SELECT, selectedRenderers));
			if (_isCycling){
				if (_selectedIndex == _beginCycleIndex){
					_isCycling = false;
					dispatchEvent(new EndlessScrollerEvent(EndlessScrollerEvent.CYCLE_COMPLETE, selectedRenderers));
				} else {
					if (_cycleDirection == -1){
						selectPrev();
					} else if (_cycleDirection == 1){
						selectNext();
					}
				}
			}
		}
		
		override public function render():void {
			if (!(_data is Array) || !_renderer){
				return;
			}
			dispatchEvent(new RendererEvent(RendererEvent.BEGIN_RENDER));
			
			destroyRenderers();
			
			var dataLength:uint = _data.length;
			for (var i:int = -_endsCount; i < dataLength + _endsCount; i++){
				var index:int = resolveIndex(i);
				var renderer:IRenderer = new _renderer();
				renderer.data = _data[index];
				renderer.x = getXOffset(i);
				
				_container.addChild(renderer as DisplayObject);
				_renderers.push(renderer);
			}
			selectIndex(0);
			
			validateProperty(PROP_RENDER);
			dispatchEvent(new RendererEvent(RendererEvent.END_RENDER));
		}
		
		protected function getXOffset(index:int):Number {
			return index * (_itemWidth + _hSpacing);
		}
		
		public function cyclePrev():void {
			if (_isCycling){
				return;
			}
			_isCycling = true;
			_cycleDirection = -1;
			_beginCycleIndex = resolveIndex(_selectedIndex);
			
			selectPrev();
		}
		
		public function cycleNext():void {
			if (_isCycling){
				return;
			}
			_isCycling = true;
			_cycleDirection = 1;
			_beginCycleIndex = resolveIndex(_selectedIndex);
			
			selectNext();
		}
		
		protected function resolveIndex(index:int):uint {
			return Calc.coterminal(index, _data.length);
		}
	}
}