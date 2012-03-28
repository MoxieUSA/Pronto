/*
* AJ Savino
*/
package com.moxieinteractive.pronto.renderers {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import com.moxieinteractive.pronto.renderers.api.IRenderer;
	import com.moxieinteractive.pronto.renderers.core.BasicRenderer;
	import com.moxieinteractive.pronto.events.RendererEvent;
	
	import flash.display.DisplayObject;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class PageRenderer extends BasicRenderer {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		private static const PROP_RENDER:String = "prop_render";
		private static const PROP_DATA:String = "prop_data";
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _renderer:Class = BasicRenderer;			//Will cause a re-render
		protected var _itemWidth:Number;						//Will cause a re-render
		protected var _itemHeight:Number;						//Will cause a re-render
		protected var _rows:uint = 2;							//Will cause a re-render
		protected var _cols:uint = 3;							//Will cause a re-render
		protected var _hSpacing:Number = 16;					//Will cause a re-render
		protected var _vSpacing:Number = 16;					//Will cause a re-render
		
		protected var _renderers:Array;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		override public function get width():Number {
			return (_cols * (_itemWidth + hSpacing)) - hSpacing;
		}
		
		override public function get height():Number {
			return (_rows * (_itemHeight + vSpacing)) - vSpacing;
		}
		
		public function get renderer():Class {
			return _renderer;
		}
		public function set renderer(value:Class):void {
			_renderer = value;
			
			var template:IRenderer = new _renderer();
			_itemWidth = template.width;
			_itemHeight = template.height;
			
			invalidateProperty(PROP_RENDER);
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
		
		public function get rows():uint {
			return _rows;
		}
		public function set rows(value:uint):void {
			_rows = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get cols():uint {
			return _cols;
		}
		public function set cols(value:uint):void {
			_cols = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get hSpacing():Number {
			return _hSpacing;
		}
		public function set hSpacing(value:Number):void {
			_hSpacing = value;
			invalidateProperty(PROP_RENDER);
		}
		
		public function get vSpacing():Number {
			return _vSpacing;
		}
		public function set vSpacing(value:Number):void {
			_vSpacing = value;
			invalidateProperty(PROP_RENDER);
		}
		
		override public function set data(value:*):void {
			_data = value;
			invalidateProperty(PROP_DATA);
		}
		
		public function get pageSize():uint {
			return _rows * _cols;
		}
		
		public function get renderers():Array {
			return _renderers;
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function PageRenderer(){
			super();
		}
		
		override public function initialize():void {
			_renderers = new Array();
			
			super.initialize();
		}
		
		override public function destroy():void {
			super.destroy();
			
			destroyRenderers();
			_renderers = null;
		}
		
		public function destroyRenderers():void {
			while (_renderers.length){
				var renderer:IRenderer = _renderers.shift();
				renderer.data = null;
				removeChild(renderer as DisplayObject);
				renderer.destroy();
			}
		}
		
		override public function render():void {
			dispatchEvent(new RendererEvent(RendererEvent.BEGIN_RENDER));
			
			destroyRenderers();
			for (var i:uint = 0; i < _rows; i++){
				for (var j:uint = 0; j < _cols; j++){
					var renderer:IRenderer = new _renderer();
					renderer.x = j * (_itemWidth + _hSpacing);
					renderer.y = i * (_itemHeight + _vSpacing);
					
					_renderers.push(renderer);
					addChild(renderer as DisplayObject);
				}
			}
			
			validateProperty(PROP_RENDER);
			dispatchEvent(new RendererEvent(RendererEvent.END_RENDER));
		}
		
		protected function initData():void {
			if (!(_data is Array)){
				validateProperty(PROP_DATA);
				return;
			}
			var dataLength:uint = _data.length;
			var renderersLength:uint = _renderers.length;
			for (var i:uint = 0; i < pageSize; i++){
				if (i >= renderersLength){
					continue;
				}
				var renderer:IRenderer = _renderers[i];
				if (i < dataLength){
					renderer.visible = true;
					renderer.data = _data[i];
				} else {
					renderer.visible = false;
				}
			}
			
			validateProperty(PROP_DATA);
		}
		
		public function clone():PageRenderer {
			var page:PageRenderer = new PageRenderer();
			page.renderer = _renderer;
			page.itemWidth = _itemWidth;
			page.itemHeight = _itemHeight;
			page.rows = _rows;
			page.cols = _cols;
			page.hSpacing = _hSpacing;
			page.vSpacing = _vSpacing;
			
			return page;
		}
		
		override protected function commitProperties():void {
			if (!isPropertyValid(PROP_RENDER)){
				render();
			}
			if (!isPropertyValid(PROP_DATA)){
				initData();
			}
		}
	}
}