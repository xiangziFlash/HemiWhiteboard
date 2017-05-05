package com.notification
{
	/**
	 * 中继器  管理器
	 * */
	public class NotificationFactory
	{
		
		static private var _logicMgr:LogicMgr = LogicMgr.getInstance();
		static private var _proxyMgr:ProxyMgr = ProxyMgr.getInstance();
		
		public function NotificationFactory()
		{
			throw("这个类不能被实例化");
		}
		
		
		
		
		/**
		 * 广播消息
		 * 注册过这个消息的 Command 会被执行
		 * 注册过这个消息的 Logic 会被执行
		 * @param notificationID
		 * @param body
		 * 
		 */		
		static public function sendNotification(notificationID:int, body:Object=null):void
		{
			//trace("广播消息：notificationID="+notificationID);
			
			var notification:SimpleNotification = new SimpleNotification(notificationID,body);
			
			//找到注册过这个notificationID的多个Logic实例
			var logicList:Array = _logicMgr.getLogicListByNotificationID( notificationID );
			for each (var logic:ILogic in logicList) 
			{
				logic.handleNotification( notification );
			}
			
			logicList = null;
			notification = null;
		}
		
		
		
		/**
		 * 注册逻辑
		 * @param logic
		 */		
		static public function registerLogic( logic:ILogic ):void
		{
			_logicMgr.registerLogic( logic );
		}
		
		/**
		 * 删除一个逻辑
		 * @param logicName
		 */
		static public function unRegisterLogic(logicName:String):void
		{
			_logicMgr.unRegisterLogic(logicName);
		}
		
		/**
		 * 获得逻辑列表
		 * @return 
		 */
		static public function getLogicList():Array
		{
			return _logicMgr.getLogicList();
		}
		
		/**
		 * 获得一个逻辑
		 * @param logicName	
		 * @return 
		 */		
		static public function getLogic(logicName:String):ILogic
		{
			return _logicMgr.getLogic(logicName);
		}
		
		
		
		
		
		static public function registerProxy(proxy:SimpleProxy):void
		{
			_proxyMgr.registerProxy( proxy );
		}
		static public function unRegisterProxy( proxyName:String ):void
		{
			_proxyMgr.unRegisterProxy( proxyName );
		}
		static public function getProxy( proxyName:String ):SimpleProxy
		{
			return _proxyMgr.getProxy( proxyName );
		}
		static public function getProxyData( proxyName:String ):Object
		{
			return getProxy(proxyName).getData();
		}
	}
}

class S{}