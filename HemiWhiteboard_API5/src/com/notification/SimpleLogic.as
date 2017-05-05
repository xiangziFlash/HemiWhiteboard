package com.notification
{
	/**
	 * 逻辑类的基类
	 * */
	public class SimpleLogic implements ILogic
	{
		public static const NAME:String = "Logic";
		
		protected var logicName:String;
		
		public function SimpleLogic(logicName:String=null)
		{
			this.logicName = (logicName != null)?logicName:NAME;
		}
		
		/**
		 * 获得该逻辑的名字
		 * @return 
		 */		
		public function getLogicName():String
		{
			return logicName;
		}
		
		
		public function onRegister():void{}
		public function onRemove():void{}
		
		
		/**
		 * 这个逻辑类感兴趣的消息列表
		 * @return 
		 * 
		 */		
		public function listNotificationInterests():Array
		{
			return null;
		}
		
		
		/**
		 * 当广播注册过的消息时，执行这个方法
		 * @param notification
		 * 
		 */		
		public function handleNotification( notification:SimpleNotification):void
		{
			
		}
		
		
		
		
		
		//
		//常用的接口
		//
		protected function sendNotification(notificationID:int, body:Object=null):void
		{
			NotificationFactory.sendNotification(notificationID, body);
		}
		protected function getProxy(proxyName:String):SimpleProxy
		{
			return NotificationFactory.getProxy(proxyName);
		}
		protected function getProxyData(proxyName:String):Object
		{
			return NotificationFactory.getProxyData(proxyName);
		}
		protected function getLogic(logicName:String):ILogic
		{
			return NotificationFactory.getLogic(logicName);
		}
	}
}