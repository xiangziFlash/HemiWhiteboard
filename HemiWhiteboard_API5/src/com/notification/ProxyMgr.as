package com.notification
{
	/**
	 * 数据代理管理器，负责代理的注册和注销
	 * @author bluesliu
	 * 
	 */	
	public class ProxyMgr
	{
		private var _proxyList:Array;
		
		private static var _instance:ProxyMgr;
		
		public function ProxyMgr(s:S)
		{
			_proxyList = [];
		}
		
		static public function getInstance():ProxyMgr
		{
			if(_instance == null)
				_instance = new ProxyMgr(new S());
			return _instance;
		}
		
		public function registerProxy( proxy:SimpleProxy ) : void
		{
			_proxyList[ proxy.getProxyName() ] = proxy;
			proxy.onRegister();
		}
		
		public function unRegisterProxy( proxyName:String ):void
		{
			var proxy:SimpleProxy = _proxyList[proxyName];
			if(proxy)
			{
				proxy.onRemove();
				proxy = null;
			}
			_proxyList[proxyName] = null;
			delete(_proxyList[proxyName]);
		}
		
		
		public function getProxy( proxyName:String):SimpleProxy
		{
			var proxy:SimpleProxy = _proxyList[proxyName];
			if(proxy)
			{
				return proxy;
			}
			return null;
		}
	}
}

class S{}