package com.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author wang
	 */
	public class ImageTurnEvent extends Event 
	{
		public static const IMAGE_TURN:String = "image_turn";//图片切换了
		public static const POSTER_TURN:String = "poster_turn";//海报图片切换了
		public static const PIC_TURN:String = "pic_turn";//右下角图片切换了
		public var pic_id:int;
		public function ImageTurnEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ImageTurnEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ImageTurnEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}