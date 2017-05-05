package com.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author shi
	 */
	public class LoginEvent extends Event 
	{
		public static const LOGIN:String = "login";
		public static const AGAINLOGIN:String = "againlogin";
		public static const DETER:String = "deter";
		public static const PIANHAO:String = "pianhao";
		public var userID:int;
		public var xml:XML;
		
		public function LoginEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new LoginEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("LoginEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}