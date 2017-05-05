package com.events
{
	import flash.events.Event;
	
	public class ImageTurnComEvent extends Event
	{
		public static const MOVE_END:String = "move_end";
		
		public var picID:int=0;
		
		public function ImageTurnComEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}