package com.models.msgs
{
	import com.notification.ILogic;
	import com.notification.SimpleNotification;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-5-3 下午8:56:38
	 * 
	 */
	public class LoginMSG implements IMSG
	{
		private var _msgType:String=MSGType.Login_MSG;
		private var _clientType:String = ClientType.CLIENT;
		private var _msgHeader:String;
		private var _controlType:String;
		private var _userName:String="";//  用户名
		private var _userID:String="";//  用户的IP地址
		private var _userHard:String="";//  用户的IP地址
		
		public function LoginMSG()
		{
			//condragon%LoginMSG-&userID=1&clientType=phone&userName=xiangzi&userHard=userHard&end
		}
		
		public function HandleMSG(value:String):void
		{
			_msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			_userID=value.split("&userID=")[1].split("&")[0];
			_userHard=value.split("&userHard=")[1].split("&")[0];
			_userName=value.split("&userName=")[1].split("&")[0];
		}
		
		public function formatMsg():String
		{
			return "condragon%LoginMSG-"+"&clientType-" +_clientType+"&userID=" + _userID  + "&userHard=" + _userHard + "&userName=" + _userName + "&end";
		}
		
		public function getAnswer():String
		{
			return null;
		}
		
		public function getControlType():String
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
		
		public function getQuestionsType():String
		{
			return null;
		}
		
		public function getSendClient():String
		{
			return null;
		}
		
		public function getUserIP():String
		{
			return _userID;
		}
		
		public function getUserName():String
		{
			return _userName;
		}
		
		public function getUserThumb():String
		{
			return _userHard;
		}
		
		public function getUserType():String
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
		
	}
}