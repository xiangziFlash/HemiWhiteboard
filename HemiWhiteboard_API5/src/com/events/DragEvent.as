package com.events
{
	import flash.events.Event;
	
	public class DragEvent extends Event
	{
		public static const IMAGE_LOCK:String = "image_lock";
		public var isLock:Boolean;
		public var isFull:Boolean;
		
		public function DragEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}