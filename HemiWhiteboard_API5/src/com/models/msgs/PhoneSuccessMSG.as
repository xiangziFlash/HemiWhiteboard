package com.models.msgs
{
	import com.models.ApplicationData;

	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-8-15 上午1:23:01
	 * 
	 */
	public class PhoneSuccessMSG implements IMSG
	{
		private var _msgType:String=MSGType.PHONE_SUCCESS_MSG;
		private var _clientType:String = ClientType.PHONE;
		private var _userName:String="";//  用户名
		private var _userThumb:String="";
		//  用户图标
		private var _userIP:String="";//  用户的IP地址
		private var _userType:String="";
		
		public function getControlType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		private var _msgHeader:String;
		
		public function PhoneSuccessMSG()
		{
			
		}
		
		public function HandleMSG(value:String):void
		{
			_msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			_clientType=value.split("&clientType=")[1].split("&")[0];
			_userName = value.split("&userName=")[1].split("&")[0];
			_userIP=value.split("&userIP=")[1].split("&")[0];
			_userThumb=value.split("&userThumb=")[1].split("&")[0];
			//_userType=value.split("&userType=")[1].split("&")[0];
		}
		
		public function formatMsg():String
		{
			//condragon%PhoneSuccessMSG-&clientType=phone&userName=userName&userThumb=userThumb&userIP=userIP&end
			return "condrage%" + _msgType+ "-" + "&clientType=" + _clientType + "&userName=" + _userName + "&userThumb=" + _userThumb + "&userIP=" + _userIP + "&end";
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
			return _clientType;
		}
		
		public function setMediaPath(value:String):void
		{
			
		}
		
		public function setMsgType(value:String):void
		{
			_msgType = value;
		}
		
		public function getAnswer():String
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
			return _userThumb;
		}
		
		public function getVoteQuestions():String
		{
			return null;
		}
		
		public function getVoteType():String
		{
			return null;
		}
		
		public function getUserType():String
		{
			return _userType;
		}
		
	}
}