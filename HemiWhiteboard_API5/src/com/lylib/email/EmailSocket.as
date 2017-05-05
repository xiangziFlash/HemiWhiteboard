package com.lylib.email
{
	import com.lylib.codec.Base64;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	[Event(type="flash.events.Event", name="complete")]
	
	public class EmailSocket extends BaseSocket
	{
		private var _popHost:String;
		private var _popPort:int;
		private var _smtpHost:String;
		private var _smtpPort:int;
		private var _delay:int;
		
		private var _userName:String;
		private var _passWord:String;
		
		private var _isLogin:Boolean = false;
		
		private var _toEmail:String;
		private var _subject:String;
		private var _content:String;
		
		private var _commArr:Array;
		private var _time:Timer;
		
		
		/**
		 * 用来发邮件和收邮件
		 * @param popHost		收邮件的pop地址
		 * @param popPort		收邮件的pop端口号
		 * @param smtpHost	发邮件的smtp地址
		 * @param smtpPort	发邮件的smtp端口号
		 */		
		public function EmailSocket(userName:String,
									passWord:String,
									popHost:String="pop3.163.com", 
									popPort:int=110, 
									smtpHost:String="smtp.163.com", 
									smtpPort:int=25, 
									delay:int=800)
		{
			super();
			_popHost = popHost;
			_popPort = popPort;
			_smtpHost = smtpHost;
			_smtpPort = smtpPort;
			_userName = userName;
			_passWord = passWord;
			_delay = delay;
			
			_time = new Timer(delay);
			_time.addEventListener(TimerEvent.TIMER, onTimer);
			
			_commArr = [];
		}
		
		
		private function onTimer(e:TimerEvent):void
		{
			if(_commArr.length > 0)
			{trace("timer");
				sendMessage( _commArr[0] );
				_commArr.shift();
			}else
			{
				_time.stop();
				_time.reset();
				state = SocketState.NONE;
				this.dispatchEvent( new Event(Event.COMPLETE) );
			}
		}
		
		
		public function sendEmail(toEmal:String, subject:String, content:String):void
		{
			if(state != SocketState.NONE)return;
			
			state = SocketState.SEND_EMAILING;
			
			_toEmail = toEmal;
			_subject = subject;
			_content = content;
			
			this.doConnect(_smtpHost, _smtpPort);
			
			_commArr.push( "HELO mail" );
			_commArr.push( "AUTH LOGIN" );
			//_commArr.push( "NOOP" );
			_commArr.push( Base64.encode(_userName) );
			_commArr.push( Base64.encode(_passWord) );
			_commArr.push( "MAIL FROM: <"+_userName+">" );
			_commArr.push( "RCPT TO: <"+_toEmail+">" );
			_commArr.push( "DATA" );
			_commArr.push( "Date: " + new Date().toString() );
			_commArr.push( "From: " + _userName);
			_commArr.push( "To: " +  toEmal);
			_commArr.push( "Content-Type: text/html" );
			_commArr.push( "Subject: " + _subject);
			_commArr.push( "");
			_commArr.push( _content );
			_commArr.push( "." );
		}
		
		override protected function connectHandler(e:Event):void
		{
			super.connectHandler(e);
			
			_time.start();
		}
		
		override protected function socketDataHandler(e:ProgressEvent):void
		{
			super.socketDataHandler(e);
			
			var msg:String='';
			while(_socket.bytesAvailable)
			{
				msg += _socket.readMultiByte(_socket.bytesAvailable,"gb2312");
			}
			trace("--",msg);
			if( msg.split("Error").length>1 )
			{
				_commArr = [];
				
				_time.stop();
				_time.reset();
				var evt:IOErrorEvent = new IOErrorEvent(IOErrorEvent.IO_ERROR);
				evt.text = msg;
				this.dispatchEvent(evt);
				
				state = SocketState.NONE;
			}
		}
		
		override public function sendMessage(msg:String):void
		{
			if(!isConnected)return;
			
			//新建一个ByteArray来存放数据
			_sendMsgByteArray = new ByteArray();
			_sendMsgByteArray.writeMultiByte(msg+"\r\n", "gb2312");
			
			//写入socket缓冲区
			_socket.writeBytes(_sendMsgByteArray);
			_socket.flush();
		}
	}
}