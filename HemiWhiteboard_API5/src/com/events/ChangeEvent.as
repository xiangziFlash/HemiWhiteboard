package com.events
{
	import com.models.vo.MediaVO;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ChangeEvent extends Event
	{
		public static const CHANGE_END:String = "change_end";	
		/**
		 *切换荧光笔模式 
		 */		
		public static const CHANGE_YGB:String = "change_ygb";
		/**
		 * 切换荧光笔笔触  还有笔触的粗细之类的变化
		 */		
		public static const CHANGE_STYLE:String = "change_style";
		/**
		 * 改变荧光笔的alpha值 
		 */		
		public static const CHANGE_ALPHA:String = "change_alpha";	
		/**
		 * 
		 */
		public static const BOARD_CLOSE:String = "board_close";
		/**
		 * 
		 */
		public static const FIT_WEIZHI:String = "fit_weizhi";
		public static const CLEAR:String = "clear";
		public static const CHANGE_CLICK:String = "change_click";
		public var id:int;
		public var targetName:String="";
		public var obj:MovieClip;
		public var style:String="";
		public var alpha:Number;
		public var index:int;
		public var targetObj:Sprite;
		public var mediaVO:MediaVO;
		public var currTarget:Sprite;
		public var currTargetName:String="";
		public var currentFrame:int;
		
		public function ChangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}