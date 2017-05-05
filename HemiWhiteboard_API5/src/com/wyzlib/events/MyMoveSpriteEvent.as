package com.wyzlib.events 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author wang
	 */
	public class MyMoveSpriteEvent extends Event 
	{
		/**
		 * 当显示子项被点击后
		 */
		public static const CON_CLICK:String = "con_click";
		/**
		 * 当显示子项被双击后
		 */
		public static const CON_DOUBLE_CLICK:String = "con_double_click";
		/**
		 * 整个容器向右移动
		 */
		public static const CON_RIGHT_MOVE:String = "con_right_move";
		/**
		 * 整个容器向左移动
		 */
		public static const CON_LEFT_MOVE:String = "con_left_move";		
		/**
		 * 整个容器向上移动
		 */
		public static const CON_TOP_MOVE:String = "con_top_move";		
		/**
		 * 整个容器向下移动
		 */
		public static const CON_BOTTOM_MOVE:String = "con_bottom_move";	
		/**
		 * 容器显示更多的移动动画结束
		 */
		public static const CON_MORE_MOVE_END:String = "con_more_move_end";
		/**
		 * 容器移动动画结束
		 */
		public static const CON_MOVE_END:String = "con_move_end";
		
				
		public var targetName:String;
		public var currentTargetName:String;
		public var obj:DisplayObject;
		public function MyMoveSpriteEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new MyMoveSpriteEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("MyMoveSpriteEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}