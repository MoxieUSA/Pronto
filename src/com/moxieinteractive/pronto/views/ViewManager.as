/*
* AJ Savino
*/
package com.moxieinteractive.pronto.views {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.MovieClip;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	public class ViewManager {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		protected var _container:MovieClip;
		protected var _layers:Array;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function initialize(container:MovieClip):void {
			_layers = new Array();
			_container = container;
		}
		
		public function destroy():void {
			clearLayers();
			_layers = null;
			
			_container = null;
		}
		
		public function addLayer(layer:ViewLayer):void {
			var index:int = _layers.indexOf(layer);
			if (index == -1){
				_layers.push(layer);
			}
			
			_container.addChild(layer);
		}
		
		public function removeLayer(layer:*):void {
			layer = resolveLayer(layer);
			if (!layer){
				return;
			}
			
			_container.removeChild(layer);
			
			var index:int = _layers.indexOf(layer);
			if (index != -1){
				_layers.splice(index, 1);
			}
		}
		
		public function clearLayers():void {
			if (_layers){
				while (_layers.length > 0){
					var layer:ViewLayer = _layers.shift();
					layer.destroy();
					_container.removeChild(layer);
				}
			} else {
				_layers = new Array();
			}
		}
		
		public function resolveLayer(layer:*):ViewLayer {
			if (layer is String){
				return getLayerById(layer);
			} else if (layer is ViewLayer){
				var index:int = _layers.indexOf(layer);
				if (index != -1){
					return layer;
				} else {
					return null;
				}
			}
			
			return null;
		}
		
		public function getLayerById(queryId:String):ViewLayer {
			var layersLength:uint = _layers.length;
			for (var i:uint = 0; i < layersLength; i++){
				var layer:ViewLayer = _layers[i];
				if (layer.id == queryId){
					return layer;
				}
			}
			
			return null;
		}
		
		public function showView(view:*):View {
			var layer:ViewLayer = resolveViewToLayer(view);
			if (layer){
				return layer.showView(view);
			}
			
			return null;
		}
		
		public function hideView(view:*):void {
			var layer:ViewLayer = resolveViewToLayer(view);
			if (layer){
				if (layer.displayedView == layer.resolveView(view)){
					layer.hideView();
				}
			}
		}
		
		public function getView(view:*):View {
			var layer:ViewLayer = resolveViewToLayer(view);
			if (layer) {
				return layer.resolveView(view);
			}
			
			return null;
		}
		
		public function resolveViewToLayer(view:*):ViewLayer {
			var layersLength:uint = _layers.length;
			for (var i:uint = 0; i < layersLength; i++){
				var layer:ViewLayer = _layers[i];
				if (layer.resolveView(view)){
					return layer;
				}
			}
			
			return null;
		}
	}
}