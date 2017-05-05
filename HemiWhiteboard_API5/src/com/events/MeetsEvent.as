package com.events
{
	import flash.events.Event;
	
	public class MeetsEvent extends Event
	{
		public static const FIT_WEIZHI:String = "fit_weizhi";
		public static const OPEN_MEDIAS:String = "open_medias";
		public static const OPEN_MEDIAS_MENU:String = "open_medias_menu";
		public var arr:Array=[];
		
		public function MeetsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}