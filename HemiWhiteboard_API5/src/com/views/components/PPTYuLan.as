package com.views.components
{
	import com.models.ApplicationData;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.Socket;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	/**
	 * @author xiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2014-10-28 上午10:33:45
	 * 
	 */
	public class PPTYuLan extends Sprite
	{
		private var _process:NativeProcess;
		private var _socket:Socket;
		private var _nectioned:Boolean;
		private var _timer:Timer;
		public var command:String="";
		private var _ipAddress:String;
		public function PPTYuLan()
		{
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT,onCONNECT);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onseError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onSOCKET_DATA);
			connectServer();
			_ipAddress = ApplicationData.getInstance().pptAddress;
			
			/*_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();*/
		}
		
		private function onTimer(event:TimerEvent):void
		{
			_socket.connect(_ipAddress,6666);
			_timer.stop();
		}
		
		public function openServer():void
		{
			
		}
		
		private function onClose(event:Event):void
		{
			trace("onClose");
		}
		
		private function onExit(event:NativeProcessExitEvent):void
		{
			
		}
		
		private function onCONNECT(e:Event):void 
		{
			trace("连接成功--");
			/*_timer.stop();
			_nectioned = true;
			trace("连接成功--",command);
			if(command != "")
			{trace("send--");
				_socket.writeUTFBytes(command);
				_socket.flush();
			}*/
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			trace("连接失败,服务器没打开!");
			_nectioned = false;
			/*_timer.reset();
			_timer.start()*/;
		}
		
		private function onseError(e:SecurityErrorEvent):void 
		{
			trace("连接失败，安全错误"+e.text);
			_nectioned = false;
			/*_timer.reset();
			_timer.start();*/
		}
		
		public function connectServer():void {
			if(_socket.connected)
			{
				_socket.close();
			}
			_socket.connect(_ipAddress,6666);
		}
		
		/**
		 * 接收消息
		 */
		private function onSOCKET_DATA(event:ProgressEvent):void 
		{
			trace("接收到消息");
		}
		
		public function closeServer():void
		{
			if(_process)
			{
				_process.exit(true);
				_process=null;
			}
		}
		
		public function sendMessage(str:String):void
		{
			if(!_socket.connected)return;
			switch(str)
			{
				case "upBtn":
				{
					if(_socket.connected)
					{
						_socket.close();
					}
					
					_socket.connect(_ipAddress,6666);
					_socket.writeUTFBytes("UP");
					_socket.flush();
					break;
				}
				case "downBtn":
				{
					if(_socket.connected)
					{
						_socket.close();
					}
					
					_socket.connect(_ipAddress,6666);
					_socket.writeUTFBytes("DOWN");
					_socket.flush();
					break;
				}
				case "shouYeBtn":
				{
					if(_socket.connected)
					{
						_socket.close();
					}
					
					_socket.connect(_ipAddress,6666);
					_socket.writeUTFBytes("HOME");
					_socket.flush();
					break;
				}
				case "weiYeBtn":
				{
					if(_socket.connected)
					{
						_socket.close();
					}
					
					_socket.connect(_ipAddress,6666);
					_socket.writeUTFBytes("END");
					_socket.flush();
					break;
				}
				case "backBtn":
				{
					if(_socket.connected)
					{
						_socket.close();
					}
					
					_socket.connect(_ipAddress,6666);
					_socket.writeUTFBytes("QUIT");
					_socket.flush();
					break;
				}
			}
		}
		
		public function controlPPT(str:String):void
		{
			if(_socket.connected)
			{
				_socket.close();
			}
			_socket.connect(_ipAddress,6666);
			setTimeout(function():void
			{
				switch(str)
				{
					case "up":
					{
						_socket.writeUTFBytes("UP");
						_socket.flush();
						break;
					}
					case "down":
					{
						_socket.writeUTFBytes("DOWN");
						_socket.flush();
						break;
					}
					case "home":
					{
						_socket.writeUTFBytes("HOME");
						_socket.flush();
						break;
					}
					case "end":
					{
						_socket.writeUTFBytes("END");
						_socket.flush();
						break;
					}
				}
			},10);
		}
	}
}