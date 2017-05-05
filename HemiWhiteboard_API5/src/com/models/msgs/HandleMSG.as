package com.models.msgs
{
	import flash.utils.getDefinitionByName;

	/**
	 * 处理消息
	 * @author wang
	 */
	public class HandleMSG 
	{
		
		public function HandleMSG() 
		{
			new AddMediaMSG();
			new PhoneSuccessMSG();
			new VoteMSG();
			new PPTMSG();
			new PhoneCloseMSG();
			new ClientCloseMSG();
			new AddHimiMediaMSG();
			new LoginMSG();
		}
		
		static public function getObj(msg:String):IMSG
		{
//			var className:String = msg.split("-")[0];
			if(msg.indexOf("%") == -1) return null;
			var className:String = msg.split("%")[1].split("-")[0];
			try
			{
				var MsgClass:Class = getDefinitionByName("com.models.msgs."+className) as Class;
				trace("className",className)
			}
			catch(err:ReferenceError)
			{
				//trace(className,"className");
				throw("没有找到"+className+"的定义");
				return null;
			}
			
			var obj:Object = new MsgClass();
			obj.HandleMSG(msg);
			return obj as IMSG;
			
		}
		
	}

}