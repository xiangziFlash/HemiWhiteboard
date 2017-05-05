package com.controls 
{

	import com.models.ApplicationData;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author wang
	 */	
	public class PingBaoTime extends Sprite
	{
		private var _pingBaoTime:Number = 600;
		//private static var _isOne:Boolean = true; 
		private static var _isTime:Boolean = true; 
		public static var isPingBao:Boolean = true; 
		private static var _time:Timer; 
		
		public function PingBaoTime() 
		{
			
		}
		/**
		 * 用户是否存在控制
		 */
		public function userExistController():void {
			NativeApplication.nativeApplication.idleThreshold = _pingBaoTime;	
			NativeApplication.nativeApplication.addEventListener(Event.USER_IDLE, handleUserIdle);
			NativeApplication.nativeApplication.addEventListener(Event.USER_PRESENT, handleUserPresent);
			
		}	
		
		/**
		 * 处于空闲状态
		 */
		private function handleUserIdle(e:Event):void 
		{
			if (isPingBao) {
				dispatchEvent(new Event(Event.COMPLETE));
			}
			
			//ApplicationFacade.getInstance().sendNotification(ApplicationFacade.QIE_HUAN, null, StageNames.MainStage);
		}
		
		/**
		 * 激活空闲状态
		 */
		private function handleUserPresent(e:Event):void 
		{
			//trace("激活空闲状态");
			this.dispatchEvent(new Event(Event.CLEAR));
		}
		
		/**
		 * 设置屏保时间
		 */
		public function set pingBaoTime(value:Number):void 
		{
			_pingBaoTime = value * 60;
			NativeApplication.nativeApplication.idleThreshold = _pingBaoTime;
			userExistController();
			//trace("屏保的时间",NativeApplication.nativeApplication.idleThreshold);
		}
	}

}