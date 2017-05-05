package com.lylib.email
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	[Event(type="flash.events.Event", name="connect")]
	
	[Event(type="flash.events.Event", name="close")]
	
	[Event(type="flash.events.ProgressEvent", name="socket_data")]
	
	[Event(type="flash.events.IOErrorEvent", name="io_error")]
	
	[Event(type="flash.events.SecurityErrorEvent", name="security_error")]
	
	
	
	public class BaseSocket extends EventDispatcher
	{
		
		protected var _socket:Socket;
		
		private var _host:String;
		private var _port:int;
		private var _isConnected:Boolean = false;
		protected var _sendMsgByteArray:ByteArray;
		
		private var _state:String = SocketState.NONE;
		
		
		public function BaseSocket()
		{
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT, connectHandler);
			_socket.addEventListener(Event.CLOSE, closeHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		
		public function doConnect(host:String, port:int):void
		{
			_host = host;
			_port = port;
			if( !_isConnected )
			{
				_socket.connect(_host, _port);
			}
		}
		
		
		public function sendMessage(msg:String):void
		{
			//if(!_isConnected)return;
			//新建一个ByteArray来存放数据
			_sendMsgByteArray = new ByteArray();
			_sendMsgByteArray.writeUTFBytes(msg);
			//写入socket缓冲区
			_socket.writeBytes(_sendMsgByteArray);
			_socket.flush();
		}
		
		
		protected function connectHandler(e:Event):void
		{
			_isConnected = true;
			this.dispatchEvent( new Event(Event.CONNECT) );
		}
		
		protected function closeHandler(e:Event):void
		{
			_isConnected = false;
			this.dispatchEvent( new Event(Event.CLOSE) );
		}
		
		protected function socketDataHandler(e:ProgressEvent):void
		{
			this.dispatchEvent( new ProgressEvent(ProgressEvent.SOCKET_DATA) );
		}

		protected function ioErrorHandler(e:IOErrorEvent):void
		{
			this.dispatchEvent( new IOErrorEvent(IOErrorEvent.IO_ERROR) );
		}
		
		protected function securityErrorHandler(e:SecurityErrorEvent):void
		{
			this.dispatchEvent( new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR) );
		}
		
		
		public function get host():String
		{
			return _host;
		}

		public function set host(value:String):void
		{
			_host = value;
		}

		public function get port():int
		{
			return _port;
		}

		public function set port(value:int):void
		{
			_port = value;
		}

		public function get isConnected():Boolean
		{
			return _isConnected;
		}

		public function set isConnected(value:Boolean):void
		{
			_isConnected = value;
		}

		public function get state():String
		{
			return _state;
		}

		public function set state(value:String):void
		{
			_state = value;
		}


	}
}