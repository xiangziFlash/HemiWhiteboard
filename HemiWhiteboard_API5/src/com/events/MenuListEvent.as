package com.events
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author xiangzi
	 */
	public class MenuListEvent extends Event 
	{
		public static var SELECT_MENU:String = "SELECT_MENU";//改变内容
		public var data:Object;
		public var itemID:int;
		public var listID:int;
		public var name:String="";
		public var arr:Array=[];
		public function MenuListEvent(type:String,data:Object, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			this.data = data;
			super(type, bubbles, cancelable);
		} 
		
		public override function clone():Event 
		{ 
			return new MenuListEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MenuListEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
	}
	
}