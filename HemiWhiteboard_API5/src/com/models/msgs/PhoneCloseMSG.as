package com.models.msgs
{
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-25 上午11:26:44
	 * 
	 */
	public class PhoneCloseMSG implements IMSG
	{
		private var _msgType:String=MSGType.PHONE_CLOSE_MSG;
		private var _userIP:String="";//  用户的IP地址
		private var _msgHeader:String;
		
		public function PhoneCloseMSG()
		{
			
		}
		
		public function HandleMSG(value:String):void
		{
			_msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			_userIP=value.split("&userIP=")[1].split("&")[0];
		}
		
		public function formatMsg():String
		{
			return null;
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
			return _userIP;
		}
		
		public function getUserName():String
		{
			return null;
		}
		
		public function getUserThumb():String
		{
			return null;
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