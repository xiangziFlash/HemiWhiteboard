package com.models.msgs
{
	
	/**
	 * ...
	 * @author wang
	 */
	public interface IMSG 
	{
		//信息类别		
		function getMsgType():String;
		function setMsgType(value:String):void;
		//处理对外发送消息
		function formatMsg():String;
		//将接受到的信息处理成MSG对象
		function HandleMSG(value:String):void;
		function getSendClient():String;
		
		//信息类别		
		function getMediaPath():String;
		function getMsgHeader():String;
		function setMediaPath(value:String):void;
		function getUserName():String
		function getUserThumb():String
		function getUserIP():String
		function getAnswer():String
		function getVoteType():String
		function getQuestionsType():String
		function getVoteQuestions():String
		function getControlType():String
		function getUserType():String;
	}
	
}