package com.models.msgs
{
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-12 下午2:47:30
	 * 
	 */
	public class VoteMSG implements IMSG
	{
		private var _msgHeader:String;
		private var _msgType:String=MSGType.Vote_MSG;
		private var _clientType:String = ClientType.CLIENT;
		private var _voteType:String="";// 0开始投票 1手机投票 2结束投票
		private var _questionsType:String="";//  投票题目的类型 0 == ABCD型 1 == 是否型
		private var _voteQuestions:String="";//  投票题目图片路径
		private var _userName:String="";//  用户名
		private var _userThumb:String="";
		//  用户图标
		private var _userID:String="";//  用户的ID
		private var _answer:String="";
		public function getUserType():String
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		//  用户选择的答案 A==0 B==1 C==2 D==3 是 == 0 否 == 1
		
		public function VoteMSG()
		{
			//condragon%VoteMSG-&voteType=1&clientType=phone&answer=0&end
		}
		
		
		public function HandleMSG(value:String):void
		{
			//condragon%VoteMSG-&voteType=1&clientType=phone&userName=xiangzi&userIP=userIP&answer=3&end
			_msgHeader = value.split("%")[0];
			_msgType=value.split("%")[1].split("-")[0];
			_clientType=value.split("&clientType=")[1].split("&")[0];
			_voteType=value.split("&voteType=")[1].split("&")[0];
			
			if(_voteType == "0")
			{
				_questionsType=value.split("&questionsType=")[1].split("&")[0];
			}else if(_voteType == "2") {
				
			} else if(_voteType == "1") {
				_userName = value.split("&userName=")[1].split("&")[0];
				_answer = value.split("&answer=")[1].split("&")[0];
				_userID=value.split("&userID=")[1].split("&")[0];
			} 
			//condragon%VoteMSG-&voteType=1&clientType=phone&userName=鏂逛涵&userID=o09Gps0J1kqgLI4kzjjjzYVaA4ps&answer=0&end
			
		}
		
		public function formatMsg():String
		{
			//开始投票 condragon%VoteMS-&voteType=0&titleType=0&voteTitle=voteTitle&end
		//	投票 condragon%VoteMSG-&voteType=1&clientType=phone&userName=xiangzi&userThumb=userThumb&userIP=userIP&titleType=0&answer=A&end
		//	结束投票condragon%VoteMS-&voteType=2&end
			var str:String = "";
			if(_voteType == "0")
			{
				str = "condragon%VoteMSG-" + "&voteType=" + _voteType + "&clientType="+_clientType+"&questionsType="+_questionsType+"&end";
			}else if(_voteType == "2") {
				str = "condragon%VoteMSG-" + "&voteType=" + _voteType + "&clientType="+_clientType+"&end";
			} else {
				str = "condragon%VoteMSG-" + "&voteType=" + _voteType + "&clientType="+_clientType+"&userName="+
					_userName+"&userThumb="+_userThumb+"&userIP="+_userID+"&questionsType="+_questionsType+"&answer="+_answer+"&end";
			} 
			return str;
		}
		
		public function getVoteType():String
		{
			return _voteType;
		}
		
		public function getAnswer():String
		{
			return _answer;
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
		
		public function getQuestionsType():String
		{
			return _questionsType;
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
			return _userThumb;
		}
		
		public function getVoteQuestions():String
		{
			return _voteQuestions;
		}
		
		public function getControlType():String
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