package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.msgs.ClientType;
	import com.models.msgs.ControlType;
	import com.models.msgs.HandleMSG;
	import com.models.msgs.IMSG;
	import com.models.msgs.MSGType;
	import com.models.msgs.MsgHeader;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.DatagramSocketDataEvent;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.MediaType;
	import flash.net.DatagramSocket;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.Socket;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import mx.charts.CategoryAxis;
	import mx.core.Application;
	
	import org.osmf.media.MediaType;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-6-17 下午3:20:31
	 * 
	 */
	public class SocketComponents extends Sprite
	{
		private var _socket:Socket;
		private var _timer:Timer;
		private var _isNetSuccess:Boolean;
		public var updata:Function;
		public var traceFun:Function;
		public static var ipAddress:String;
		public static var port:int;
		private var _isFirst:Boolean;
		private var _timerID:int;
		private var _datagramSocket:DatagramSocket = new DatagramSocket(); ;
		private var _ipAddress:String;
		
		public function SocketComponents()
		{
			_ipAddress =  ToolKit.getIpAddress();
			initSocket();
			setUDPConnect();
			initContent();
		}
		
		private function initContent():void
		{
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);		
			_timer.reset();
			_timer.stop();
		}
		
		private function initSocket():void
		{
//			Tool.log(_timerID+"initSocket");
			_socket = new Socket();
			_socket.addEventListener(Event.CONNECT,onCONNECT);
			_socket.addEventListener(Event.CLOSE,onSocketClose);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onseError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onSOCKET_DATA);
//			setConnect();
		}
		
		private function setUDPConnect():void
		{
//			trace("setUDPConnect",getIpAddress());
			if(_datagramSocket.bound)
			{
				_datagramSocket.close();
				_datagramSocket = new DatagramSocket(); 
			}	
			_datagramSocket.addEventListener(DatagramSocketDataEvent.DATA, dataReceived);
			try
			{
				_datagramSocket.bind(8847,_ipAddress);
				_datagramSocket.receive();
				ToolKit.log("UDP Bound to:"+_datagramSocket.localAddress+":"+_datagramSocket.localPort);
			} 
			catch(error:RangeError) 
			{
				ToolKit.log("端口小于0，或者大于65535");
			}catch(error:ArgumentError) 
			{
				ToolKit.log("ipAddress格式不正确");
			}catch(error:IOError) 
			{
				ToolKit.log("无法绑定套接字，端口被占用或者没有系统权限来绑定指定的端口或DatagramSocket对象已绑定或者DatagramSocket已关闭");
				setConnect();
			}
		}
		
		private function dataReceived(event:DatagramSocketDataEvent):void
		{
			if(_isNetSuccess)return;
			var msg:String = event.data.readUTFBytes(event.data.bytesAvailable);
			ToolKit.log("UDP-MSG:" + msg);
			var type:String = msg.split("-&=")[0];
			if(type =="serverAddress")
			{
				_isFirst = true;
				ApplicationData.getInstance().socketServer = msg.split("-&=")[1];
				ApplicationData.getInstance().configXML.socketServer = ApplicationData.getInstance().socketServer;
				setConnect();
			}
		}
		
		private function onSocketClose(event:Event):void
		{
			_isNetSuccess = false;
			_timer.reset();
			_timer.start();
			ConstData.isNetworkSuccess = false;
			ConstData.wangLuoTiShi.visible = true;
			ConstData.wangLuoTiShi.tt.text = "网络连接失败，请重新配置网络...";
		}
		
		private function setConnect():void
		{
//			_socket.connect(_ipAddress,ApplicationData.getInstance().port);
			ToolKit.log("address:"+ApplicationData.getInstance().socketServer+"port:"+ApplicationData.getInstance().port);
			_socket.connect(ApplicationData.getInstance().socketServer,ApplicationData.getInstance().port);
		}
		
		private function onCONNECT(e:Event):void 
		{
//			trace("socket 服务器网络连接成功");
			ToolKit.log("服务绑定在："+_ipAddress+":"+ApplicationData.getInstance().port);
			/*if(_datagramSocket.bound){
				_datagramSocket.removeEventListener(DatagramSocketDataEvent.DATA, dataReceived);
				_datagramSocket.close();
				_datagramSocket = null;
				ToolKit.log("socket 服务器网络连接成功，并关闭UDP");
			}*/
			_isNetSuccess = true;
			if(ConstData.initServer){
				ConstData.initServer.timer.reset();
				ConstData.initServer.timer.stop();
				ConstData.initServer.hideThis();
				setTimeout(function ():void
				{
					ConstData.initServer.visible = false;
					ConstData.initServer.reset();
					if(ConstData.initServer.parent){
						ConstData.initServer.parent.removeChild(ConstData.initServer);
					}
					
				},1000);
			}
			ToolKit.saveUTFString(ApplicationData.getInstance().configXML.toString(),ApplicationData.getInstance().appPath+"config/config.xml");
			ToolKit.log("socketAddress>>"+ApplicationData.getInstance().socketServer);
			
			_timer.reset();
			_timer.stop();
		}
		
		private function onError(e:IOErrorEvent):void 
		{
//			trace("网络连接失败，正在重新连接");
			ToolKit.log(_timerID+"网络连接失败，正在重新连接");
			_isNetSuccess = false;
			ConstData.isNetworkSuccess = false;
			ConstData.wangLuoTiShi.tt.text = "网络连接失败，服务器关闭";
			ConstData.wangLuoTiShi.visible = true;
			_timer.reset();
			_timer.start();
//			sengShiBaiMsg();
		}
		
		private function onseError(e:SecurityErrorEvent):void 
		{
//			trace("网络连接失败，服务器关闭");
			ToolKit.log(_timerID+"网络连接失败，服务器关闭");
			ConstData.isNetworkSuccess = false;
			ConstData.wangLuoTiShi.tt.text = "网络连接失败，服务器关闭";
			ConstData.wangLuoTiShi.visible = true;
			ConstData.stage.addChild(ConstData.wangLuoTiShi);
			_isNetSuccess = false;
			_timer.reset();
			_timer.start();
			
			sengShiBaiMsg();
		}
		
		private function sengShiBaiMsg():void
		{
//			NotificationFactory.sendNotification(NotificationIDs.SOCKET_SHIBAI);
		}
		
		private function onSOCKET_DATA(event:ProgressEvent):void 
		{
			try
			{
				//数据更新  
				var tmpSocket:Socket=event.target as Socket;	
				var msg:String=tmpSocket.readUTFBytes(tmpSocket.bytesAvailable);
				if(updata)
				{
					updata(msg);
				}
			} catch(error:Error) 
			{
				
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_timer.reset();
			_timer.stop();
			setConnect();
		}
		
		public function sendMsg(str:String):void
		{
			if(_isNetSuccess)
			{
				try
				{
					_socket.writeUTFBytes(str);
					_socket.flush();
				} 
				catch(error:Error) 
				{
//					_timer.start();
				}
				
			}else{
//				trace("网络连接失败，无法发送消息，请检查网络")
//				trace("网络连接失败，无法发送消息，请检查网络");
			//	ApplicationData.getInstance().stageTT.text = "网络连接失败，无法发送消息，请检查网络";
			}
		}
		
		public function closeSocket():void
		{
			ToolKit.log("closeSocket");
			if(_socket){
				if(_socket.connected){
					_socket.removeEventListener(Event.CONNECT,onCONNECT);
					_socket.removeEventListener(Event.CLOSE,onSocketClose);
					_socket.removeEventListener(IOErrorEvent.IO_ERROR,onError);
					_socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onseError);
					_socket.removeEventListener(ProgressEvent.SOCKET_DATA,onSOCKET_DATA);
					_socket.close();
				}
			}
			if(_datagramSocket){
				if(_datagramSocket.bound){
					_datagramSocket.removeEventListener(DatagramSocketDataEvent.DATA, dataReceived);
					_datagramSocket.close();
					_datagramSocket = null;
					ToolKit.log("socket 服务器网络连接成功，并关闭UDP");
				}
			}
		}

		public function get isNetSuccess():Boolean
		{
			return _isNetSuccess;
		}

	}
}