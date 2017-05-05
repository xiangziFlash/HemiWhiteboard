package com.views.components
{
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.geom.Point;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.net.URLStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class FuWuQi extends Sprite
	{
		private var _serverSocket:ServerSocket;
		private var _clientList:Array=[];
		private var _stageTT:TextField;
		private var _byte:ByteArray = new ByteArray();
		
		public function FuWuQi()
		{
			initContent();
		}
		
		private function initContent(event:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,initContent);
			_stageTT = new TextField();
			_stageTT.embedFonts = true;
			_stageTT.defaultTextFormat = new TextFormat("YaHei_font",20,0x0B0B0B);
			_stageTT.autoSize = "left";
//			stage.addChild(_stageTT);
			_stageTT.mouseEnabled = false;
			_serverSocket = new ServerSocket();
			_serverSocket.addEventListener(Event.CONNECT,onSocketConnectHandler);
			_serverSocket.addEventListener(Event.CLOSE,onSocketColoseHandler);
			_serverSocket.addEventListener(Event.COMPLETE,onSocketCompete);
			if(_serverSocket.bound){
				_serverSocket.close();
				trace("注销server");
			}
			_serverSocket.bind(ApplicationData.getInstance().port,ApplicationData.getInstance().socketServer);
//			_serverSocket.bind(1989,"192.168.3.78");
			_serverSocket.listen();
			_stageTT.text = "服务绑定在："+ApplicationData.getInstance().socketServer;
		}
		
		private function onSocketCompete(event:Event):void
		{
			trace("onSocketCompete");
		}
		
		private function onAddStage(event:Event):void
		{
			
		}
		
		private function onSocketConnectHandler(event:ServerSocketConnectEvent):void
		{
			var tempSocket:Socket = event.socket;
			trace("\n"+ tempSocket.remoteAddress + "链接进来");
			//_stageTT.text +="\n"+ tempSocket.remoteAddress + "链接进来";
			_clientList.push(tempSocket);
			tempSocket.addEventListener(Event.CLOSE,onClose);
			tempSocket.addEventListener(ProgressEvent.SOCKET_DATA,onSocketDataHandler);
		}
		
		/**
		 * 服务器关闭
		 */
		private function onSocketColoseHandler(event:Event):void
		{
			trace("服务器关闭")
		}
		
		/**
		 * 客户端断开了连接
		 */
		private function onClose(event:Event):void
		{
			for (var i:int = 0; i < _clientList.length; i++) 
			{
				if((_clientList[i] as Socket).remoteAddress == event.target.remoteAddress)
				{
					_clientList.splice(i,1);
					NotificationFactory.sendNotification(NotificationIDs.REMOVE_PHONEUSER,event.target.remoteAddress);
				}
			}			
		}
		
		/**
		 * 检测到消息
		 */
		private function onSocketDataHandler(event:ProgressEvent):void
		{
			try
			{
				var tempSocket:Socket = event.target as Socket;
				_stageTT.text += "\n收到"+tempSocket.remoteAddress+"消息:";
//				var msg:String = tempSocket.readMultiByte(tempSocket.bytesAvailable, "gb2312");
				var msg:String = tempSocket.readUTFBytes(tempSocket.bytesAvailable);
				//trace("\n收到"+tempSocket.remoteAddress+"消息:" + msg);
				if(msg.indexOf("<policy-file-request/>")>-1){
					trace("\n不安全的客户端");
				}else{
					for each(var clt:Socket in _clientList){
						clt.writeUTFBytes(msg);
						clt.flush();						
					}
					
				} 	
			}catch(error:Error) 
			{
				_stageTT.text += "\n出错";
			}
		}
		
		/**
		 * 将gb2312转换为UTF8
		 * 
		 * @param arr   ANSI字符值数组
		 * @return 
		 * 
		 */        
		public static function ANSIToUnicode(arr:Array):String
		{
			var byte:ByteArray =new ByteArray();
			for(var i:int = 0; i < arr.length;i++)
			{       
				var data:int = arr[i];
				if ((data & 0xFF) == data)
				{
					byte.writeByte(data);
				}
				else
				{       
					byte.writeByte(data >> 8);
					byte.writeByte(data & 0xFF);
				}
			}
			byte.position = 0;
			return byte.readMultiByte(byte.bytesAvailable,"gb2312");
		}
		

	}
}