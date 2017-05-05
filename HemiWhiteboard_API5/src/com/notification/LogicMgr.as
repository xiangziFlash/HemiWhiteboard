package com.notification
{
	import flash.utils.getQualifiedClassName;

	/**
	 * 逻辑类的管理
	 * */
	public class LogicMgr
	{
		static private var _instance:LogicMgr;
		
		private var names:Array;
		private var logicList:Array;
		
		public function LogicMgr(s:S)
		{
			names = [];
			logicList = [];
		}
		
		static internal function getInstance():LogicMgr
		{
			if(_instance==null){
				_instance = new LogicMgr(new S());
			}
			return _instance;
		}
		
		/**
		 * 注册逻辑
		 * @param ILogic
		 */		
		internal function registerLogic(logic:ILogic):void
		{
			if(logic.getLogicName()==null || logic.getLogicName()=="")
			{
				throw("error：LogicName不能为空！");
				return;
			}
			
			if(names.indexOf(logic.getLogicName())==-1)
			{
				trace("注册逻辑：" + logic.getLogicName());
				
				names.push(logic.getLogicName());
				logicList.push(logic);
				logic.onRegister();
			}
			else
			{
				throw("error：逻辑"+logic.getLogicName()+"，已经注册过了");
			}
		}
		
		
		/**
		 * 删除一个逻辑
		 * @param logicName
		 */		
		internal function unRegisterLogic(logicName:String):void
		{
			var index:int = names.indexOf(logicName);
			if(index!=-1)
			{
				trace("删除逻辑：" + logicName);
				
				(logicList[index] as ILogic).onRemove();
				logicList[index] = null;
				logicList.splice(index,1);
				
				names.splice(index , 1);
			}
			else
			{
				throw("error：逻辑"+logicName+"，不在逻辑列表里");
			}
		}
		
		
		/**
		 * 获得注册过这个notificationID的logic数组
		 * @param notificationID
		 * @return 
		 * 
		 */		
		internal function getLogicListByNotificationID(notificationID:int):Array
		{
			var length:int = names.length;
			var logic:ILogic;
			var arr:Array;
			for(var i:int=0; i<length; i++)
			{
				logic = logicList[i];
				
				if(logic.listNotificationInterests()==null)
				{
					trace("警告："+ logic.getLogicName() +"逻辑没有关注任何一个notification，需要实现listNotificationInterests方法！");
					continue;
				}
				
				if(logic.listNotificationInterests().indexOf(notificationID)!=-1)
				{
					if(arr==null)
						arr = [];
					arr.push(logic);
				}
			}
			
			if(arr==null)
				trace("警告：notificationID="+ notificationID +"，没有任何一个逻辑关注它，请检查！");
			
			return arr;
		}
		
		/**
		 * 获得逻辑列表
		 * @return 
		 */		
		internal function getLogicList():Array
		{
			return logicList;
		}
		
		/**
		 * 获得一个逻辑
		 * @param logicName	
		 * @return 
		 */		
		internal function getLogic(logicName:String):ILogic
		{
			var index:int = names.indexOf(logicName);
			if(index==-1)
				return null;
			else
				return logicList[index];
		}
	}
}

class S{}