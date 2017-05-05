package com.models.msgs
{
	public class ClientCloseMSG implements IMSG
	{
		private var _msgHeader:String;
		private var _msgType:String=MSGType.Vote_MSG;
		private var _clientType:String = ClientType.CLIENT;
		
		public function ClientCloseMSG()
		{
		}
		
		public function HandleMSG(value:String):void
		{
			_msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			_clientType=value.split("&clientType=")[1].split("&")[0];
		}
		
		public function formatMsg():String
		{
			// TODO Auto Generated method stub
			return null;
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
			return null;
		}
		
		public function getMsgHeader():String
		{
			// TODO Auto Generated method stub
			return _msgHeader;
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
			return _clientType;
		}
		
		public function getUserIP():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		public function getUserName():String
		{
			// TODO Auto Generated method stub
			return null;
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