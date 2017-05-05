package com.models.msgs
{
	import com.models.ApplicationData;

	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-8-14 上午1:19:59
	 * 
	 */
	public class AddMediaMSG implements IMSG
	{
		private var _msgType:String=MSGType.ADD_MEDIA_MSG;
		private var _clientType:String = ClientType.CLIENT;
		private var _mediaPath:String = "";
		private var _controlType:String;
		
		public function getUserType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		private var _msgHeader:String = "";
		private var _userName:String="";//  用户名
		private var _userThumb:String="";
		//  用户图标
		private var _userIP:String="";//  用户的IP地址
		
		public function AddMediaMSG()
		{
			 
		}
		
		public function getAnswer():String
		{
			// TODO Auto Generated method stub
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
			return _userThumb;
		}
		
		public function getVoteType():String
		{
			return null;
		}
		
		
		public function HandleMSG(value:String):void
		{
			_msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			_clientType=value.split("&clientType=")[1].split("&")[0];
			_controlType=value.split("&controlType=")[1].split("&")[0];
		//	trace(_controlType,"_controlType")
			try
			{
				_mediaPath=value.split("&MediaPath=")[1].split("&")[0];
				/*var str1:String = _mediaPath.split("/photos/")[0];
				var str2:String = _mediaPath.split("/photos/")[1];
				_mediaPath = str1 + ":10000" + "/photos/" + str2;*/
//				trace(">>>>>>>>>>>>>>>>11",_mediaPath)
			} 
			catch(error:Error) 
			{
				trace(error.message);
			}
			try
			{
				_userName = value.split("&userName=")[1].split("&")[0];
			} 
			catch(error:Error) 
			{
				_userName = "";
			}
			
			try
			{
				_userIP=value.split("&userIP=")[1].split("&")[0];
			} 
			catch(error:Error) 
			{
				_userIP = "";
			}
		}
		
		public function formatMsg():String
		{
			return "condrage%" + _msgType+ "-" +"&MediaPath="+ _mediaPath+"&clientType=" + _clientType + "&userName=" + _userName +
				   "&userThumb=" + _userThumb + "&userIP=" + _userIP + "&end";
		}
		
		public function getMediaPath():String
		{
			return _mediaPath;
		}
		
		public function setMediaPath(value:String):void
		{
			_mediaPath = value;
		}
		
		
		public function getSendClient():String
		{
			return _clientType;
		}
		
		public function getMsgType():String
		{
			return _msgType;
		}
		
		public function getControlType():String
		{
			return _controlType;
		}
		
		
		public function setMsgType(value:String):void
		{
			_msgType = value;
		}
		
		public function getMsgHeader():String
		{
			return _msgHeader;
		}
		
	}
}