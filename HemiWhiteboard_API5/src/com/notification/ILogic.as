package com.notification
{
	/**
	 * 逻辑类的接口
	 * */
	public interface ILogic
	{
		/**
		 * 获得该逻辑的名字。
		 * @return 
		 */
		function getLogicName():String;
		
		/**
		 * 当逻辑被注册时，会调用该方法。
		 */		
		function onRegister():void;
		
		/**
		 * 当该逻辑被移除时，回到用该方法。
		 */		
		function onRemove():void;
		
		/**
		 * 这个逻辑类感兴趣的消息列表
		 * @return NotificationID的数组
		 */	
		function listNotificationInterests():Array;
		
		/**
		 * 当广播注册过的消息时，执行这个方法
		 * @param notification
		 */	
		function handleNotification( notification:SimpleNotification):void
	}
}