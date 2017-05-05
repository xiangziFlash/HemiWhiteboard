package com.models.msgs
{
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-12 下午2:49:18
	 * 
	 */
	public class PPTMSG implements IMSG
	{
		private var _msgType:String=MSGType.PHONE_SUCCESS_MSG;
		private var _clientType:String = ClientType.CLIENT;
		private var _msgHeader:String;
		private var _controlType:String;
		private var _userName:String="";//  用户名
		private var _userIP:String="";//  用户的IP地址
		
		public function PPTMSG()
		{
			
		}
		
		public function HandleMSG(value:String):void
		{
			_msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			_clientType=value.split("&clientType=")[1].split("&")[0];
			_controlType=value.split("&controlType=")[1].split("&")[0];
			if(_controlType == ControlType.OPEN||_controlType == ControlType.STOP)
			{
				try
				{
					_userName = value.split("&userName=")[1].split("&")[0];
					_userIP=value.split("&userIP=")[1].split("&")[0];
				} 
				catch(error:Error) 
				{
					trace("PPT-"+error.message);
				}
			} else {
				_userName = "";
				_userIP = "";
			}
			
			
		}
		
		public function getControlType():String
		{
			return _controlType;
		}
		
		
		public function formatMsg():String
		{
			// condragon%PPTMSG-&controlType=UP&end
			return "condragon%PPTMSG-"+"&clientType-" +_clientType+"&controlType=" + _controlType  + "&userName=" + _userName + "&userIP=" + _userIP + "&end";
		}
		
		public function getAnswer():String
		{
			return null;
		}
		
		public function getMediaPath():String
		{
			return null;
		}
		
		public function getMsgHeader():String
		{
			return _msgHeader;
		}
		
		public function getMsgType():String
		{
			return _msgType;
		}
		
		public function getSendClient():String
		{
			return null;
		}
		
		public function getQuestionsType():String
		{
			return null;
		}
		
		public function getUserIP():String
		{
			return _userIP;
		}
		
		public function getUserName():String
		{
			return _userName;
		}
		
		public function getUserThumb():String
		{
			return null;
		}
		
		public function getVoteQuestions():String
		{
			return null;
		}
		
		public function getVoteType():String
		{
			return null;
		}
		
		public function setMediaPath(value:String):void
		{
			
		}
		
		public function setMsgType(value:String):void
		{
			
		}
		
		public function getUserType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
	}
}