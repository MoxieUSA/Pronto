/*
* AJ Savino
*/
package com.moxieinteractive.pronto.ui.api {
	public interface IUIController extends IUIComponent {
		function get controlled():IUIControllable;
		function set controlled(value:IUIControllable):void;
		
		function issueControl(controlled:IUIControllable):Boolean;
		function revokeControl():Boolean;
	}
}