/*
* AJ Savino
*/
package com.moxieinteractive.pronto.views {
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	import flash.display.MovieClip;
	import flash.geom.Point;
	//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
	
	/*
	* A ViewLayer contains an array of views (used for referencing by ids) and a displayList (used to keep an order to display views in)
	* Only one view can be up and active at a time
	*/
	public class ViewLayer extends MovieClip {
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public var id:String;
		
		protected var _views:Array;
		protected var _displayedView:View;
		
		protected var _displayList:Array;
		protected var _displayListIndex:int;
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		public function get displayedView():View {
			return _displayedView
		}
		//-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
		
		public function ViewLayer(layerId:String = ""){
			id = layerId;
			
			init();
		}
		
		public function init():void {
			_views = new Array();
			_displayList = new Array();
			_displayListIndex = -1;
		}
		
		public function destroy():void {
			_views = null;
			_displayList = null;
		}
		
		/* @description - Adds a view to the views array if it is not already there */
		public function addView(view:View):void {
			var index:int = _views.indexOf(view);
			if (index == -1){
				_views.push(view);
			}
		}
		
		/* @description - Removes a view from the views array
		*  @param view - can be an id of a view already in the views array or a view instance */
		public function removeView(view:*):void {
			view = resolveView(view);
			if (!view){
				return;
			}
			
			var index:int = _views.indexOf(view);
			if (index != -1){
				_views.splice(index, 1);
			}
		}
		
		/* @description - Clears all views from the views array and removes the displayedView */
		public function clearViews():void {
			hideView();
			
			if (_views){
				while (_views.length > 0){
					_views.pop();
				}
			} else {
				_views = new Array();
			}
		}
		
		/* @description - Sets the displayedView on this layer and makes the view visible
		*  @param view - can be an id of a view already in the views array or a view instance. If the passed in view instance is not in the views array it will be added. If null is passed in the view will be removed
		*  @param offset - amount to offset the view */
		public function showView(view:*, offset:Point = null):View {
			var tmpView:View = resolveView(view);
			if (!tmpView){
				if (view is View){
					addView(view);
				} else {
					hideView();
					return null;
				}
			} else {
				view = tmpView;
			}
			if (offset){
				view.x = offset.x;
				view.y = offset.y;
			}
			
			if (view != _displayedView){
				hideView();
				
				_displayedView = view;
				addChild(_displayedView);
			}
			if (_displayList) {
				var index:int = _displayList.indexOf(_displayedView);
				if (index != -1) {
					_displayListIndex = index;
				}
			}
			
			return _displayedView;
		}
		
		/* @description - Hides the currently displayed view */
		public function hideView():void {
			if (_displayedView){
				_displayedView.transitionOut();
				_displayedView = null;
			}
		}
		
		/* @description - Set the displayList array order for views
		*  @param args - Multi-parameter view instances (which will be added to views array if they are not there currently) or view ids that are in the views array or a Single-parameter that contains an array of ids or instances. Passing null will clear the displayList array */
		public function setDisplayList(... args):void {
			clearDisplayList();
			
			if (!args || !args.length > 0){
				return;
			}
			if (args[0] is Array){
				_displayList = args[0];
				return;
			}
			
			var argsLength:uint = args.length;
			for (var i:uint = 0; i < argsLength; i++){
				var arg:* = args[i];
				
				var view:View = resolveView(arg);
				if (!view){
					if (arg is View){
						addView(arg);
						view = arg;
					}
				}
				if (view){
					_displayList.push(view);
				}
			}
		}
		
		/* @description - Clears the displayList array */
		public function clearDisplayList():void {
			if (_displayList){
				while (_displayList.length > 0){
					_displayList.pop();
				}
			} else {
				_displayList = new Array();
			}
		}
		
		/* @description - Displays the first view in the displayList array */
		public function displayFirstView():void {
			displayIndex(0);
		}
		
		/* @description - Displays the last view in the displayList array */
		public function displayLastView():void {
			if (_displayList && _displayList.length > 0){
				displayIndex(_displayList.length - 1);
			}
		}
		
		/* @description - Displays the next view in the displayList array. Cycles back to front of array */
		public function displayNextView():void {
			if (_displayList && _displayList.length > 0){
				if (_displayListIndex + 1 == _displayList.length){
					displayFirstView();
				} else {
					displayIndex(_displayListIndex + 1);
				}
			}
		}
		
		/* @description - Displays the last view in the displayList array. Cycles forward to back of array */
		public function displayPreviousView():void {
			if (_displayList && _displayList.length > 0){
				if (_displayListIndex - 1 == -1){
					displayLastView();
				} else {
					displayIndex(_displayListIndex - 1);
				}
			}
		}
		
		/* @description - Displays the specified displayList index
		*  @param index - The index to jump to in the displayList array */
		public function displayIndex(index:int):void {
			if (_displayList && _displayList.length > 0){
				if (index >= 0 && index < _displayList.length){
					showView(_displayList[index]);
				}
			}
		}
		
		/* @description - Searches through the views array for a view with the specifid id and returns that view
		*  @param queryId - The id to search for */
		public function getViewById(queryId:String):View {
			var viewsLength:uint = _views.length;
			for (var i:uint = 0; i < viewsLength; i++){
				var view:View = _views[i];
				if (view.id == queryId){
					return view;
				}
			}
			
			return null;
		}
		
		/* @description - Resolves the passed in view to a view instance from the views array, or if it does not exist in the array returns null 
		*  @param view - Can be a view instance or an id. Either way the view must be in the views array */
		public function resolveView(view:*):View {
			if (view is String){
				return getViewById(view);
			} else if (view is View){
				var index:int = _views.indexOf(view);
				if (index != -1){
					return view;
				} else {
					return null;
				}
			}
			
			return null;
		}
	}
}