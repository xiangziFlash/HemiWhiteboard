package com.models.msgs
{
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-4-14 下午1:54:47
	 * 
	 */
	public class AddHimiMediaMSG implements IMSG
	{
		private var _msgType:String=MSGType.ADD_HIMIMEDIA_MSG;
		public var mediaPath:String = "";
		private var msgHeader:String;
		public var userName:String;
		public var isHimi:String = "";
		public var thumb:String = "";
		
		public function AddHimiMediaMSG()
		{
			
		}
		
		public function HandleMSG(value:String):void
		{
			msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			mediaPath=value.split("&MediaPath=")[1].split("&")[0];
			userName = value.split("&userName=")[1].split("&")[0];
			isHimi = value.split("&isHimi=")[1].split("&")[0];
			thumb = value.split("&thumb=")[1].split("&")[0];
		}
		
		public function formatMsg():String
		{
			return "condrage%" + _msgType+ "-" +"&thumb="+thumb+"&isHimi="+isHimi+"&MediaPath="+ mediaPath+"&userName=" + userName +"&end";
		}
		
		public function getAnswer():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getControlType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getMediaPath():String
		{
			// TODO Auto Generated method stub
			return mediaPath;
		}
		
		public function getMsgHeader():String
		{
			// TODO Auto Generated method stub
			return msgHeader;
		}
		
		public function getMsgType():String
		{
			// TODO Auto Generated method stub
			return _msgType;
		}
		
		public function getQuestionsType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getSendClient():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getUserIP():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getUserName():String
		{
			// TODO Auto Generated method stub
			return userName;
		}
		
		public function getUserThumb():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getUserType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getVoteQuestions():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getVoteType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function setMediaPath(value:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
		public function setMsgType(value:String):void
		{
			// TODO Auto Generated method stub
			
		}
		
	}
}