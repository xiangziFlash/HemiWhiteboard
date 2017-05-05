package com.notification
{
	/**
	 * 代理类的基类
	 * */
	public class SimpleProxy
	{
		private var _proxyName:String;
		private var _data:Object;
		
		public function SimpleProxy(name:String, data:Object=null)
		{
			_proxyName = name;
			
			this.setData( data );
		}
		
		public function onRegister():void
		{
			
		}
		
		public function onRemove():void
		{
			
		}

		public function getData():Object
		{
			return _data;
		}
		public function setData(value:Object):void
		{
			_data = value;
		}

		public function getProxyName():String
		{
			return _proxyName;
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