package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.LoaderImage;
	import com.tweener.transitions.Tweener;
	import com.views.components.method.HundredOper;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.net.Socket;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-2-6 上午9:58:51
	 * 
	 */
	public class HemiContent extends Sprite
	{
		private var _xml:XML;
		private var _arr:Array=[];
		private var _mask:Shape;
		private var _arrCon:Array=[];
		private var _spCon:Sprite;
		
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _tempConX:Number=0;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempMC:LoaderImage;
		private var _socket:Socket;
		private var _timer:Timer;
		private var _isConnect:Boolean;
		private var _stageTT:TextField;
		private var _isHuaMove:Boolean;
		private var _isIF:Boolean;
		private var _nc:NetConnection;
		private var _myRemoteSO:SharedObject;
		private var _isMy:Boolean;
		
		public function HemiContent()
		{
			if(stage==null)
			{
				addEventListener(Event.ADDED_TO_STAGE,initStage);
			}else{
				initData(null);
			}
		}
		
		private function initStage(event:Event):void
		{
			_stageTT = new TextField();
//			stage.addChild(_stageTT);
			_stageTT.text = "测试";
			_stageTT.autoSize = "left";
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
			
			socketConnect();
		}
		
//		public function initData(e:Event):void
		public function initData(e:Event):void
		{
			if(hasEventListener(Event.ADDED_TO_STAGE))
			{
				removeEventListener(Event.ADDED_TO_STAGE,initData);
			}
//			_xml = ApplicationData.getInstance().menuXML.item[4];
			_xml = ApplicationData.getInstance().shuangNaoXML;
			_arr=[];
//			trace(_xml.item.length(),"_xml.item.length()")
			for (var i:int = 0; i < _xml.item.length(); i++) 
			{
				var obj:MediaVO =  new MediaVO();
				obj.path = ApplicationData.getInstance().UDiskPath+_xml.item[i];
				obj.thumb = ApplicationData.getInstance().UDiskPath+_xml.item[i].@thumb;
				obj.formatString(ApplicationData.getInstance().UDiskPath+_xml.item[i]);
			//	obj.type = "."+obj.path.split(".")[obj.path.split(".").length-1];
				obj.mediaID = i+1;
				_arr.push(obj);
			}
			
//			ApplicationData.getInstance().msgNum = Math.random()*1000000000000;
			initViews();
			initListeners();
		}
		
		/**
		 * 
		 */
		private function initViews():void
		{
			_mask = new Shape();
			_mask.graphics.beginFill(0,0);
			_mask.graphics.drawRect(0,0,1600,112);
			_mask.graphics.endFill();
			this.addChild(_mask);
			
			_spCon = new Sprite();
			this.addChild(_spCon);
			_spCon.mask = _mask;
			
			_arrCon=[];
//			trace(_arr.length,"_arr.length");
			for (var i:int = 0; i < _arr.length; i++) 
			{
				var ldr:LoaderImage =  new LoaderImage();
				ldr.setPath(_arr[i]);
				ldr.setWH(200,112,false,false);
				ldr.x = 1600;
				_spCon.addChild(ldr);
				_arrCon.push(ldr);
			}
		}
		
		public function onTimer(e:TimerEvent):void
		{
			_socket.connect(ApplicationData.getInstance().ipAddress,ApplicationData.getInstance().port);
			_timer.reset();
			_timer.stop();
		}
		
		private function initListeners():void
		{
			_spCon.addEventListener(MouseEvent.MOUSE_DOWN,onSpConDown);
		}
		
		private function onSpConDown(event:MouseEvent):void
		{
			_tempX = this.mouseX;
			_tempY = this.mouseY;
			_downX = this.mouseX;
			_downY = this.mouseY;
			_tempConX = _spCon.x;
			_isIF = true;
			_isHuaMove = false;
			if(event.target is LoaderImage)
			{
				_tempMC = event.target as LoaderImage;
			}
		
			stage.addEventListener(MouseEvent.MOUSE_UP,onSpConUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onSpConMove);
		}
		
		private function onSpConMove(event:MouseEvent):void
		{
			if (Math.abs(this.mouseX - _tempX )> 50&&_isIF) {
				_isIF = false;
				_isHuaMove = true;
			}
			if (Math.abs(this.mouseY - _tempY ) > 50&&_isIF) {
				_isIF = false;
				_isHuaMove = false;
			}
			
			if (_isHuaMove) {
				_spCon.x += this.mouseX-_downX;
				_downX = this.mouseX;
				
				if(_spCon.x>_mask.x)
				{
					_spCon.x=_mask.x;
				}
				
				if(_spCon.x<-(_spCon.width-_mask.width-_mask.x))
				{
					_spCon.x=-(_spCon.width-_mask.width-_mask.x);
				}
			}
		}
		
		private function onSpConUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onSpConUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSpConMove);
			
			if(Math.abs(_tempY-this.mouseY)>10)
			{
				//if(_tempMC.alpha!=1)return;
				if(_tempConX!=_spCon.x)return;
				if(_isHuaMove)return;
				var stagePoint:Point =localToGlobal(new Point(_tempMC.x,_tempMC.y));
				_tempMC.mediaVO.globalP = stagePoint;
				_tempMC.mediaVO.globaX = stagePoint.x;
				_tempMC.mediaVO.globaY = stagePoint.y;
				_tempMC.mediaVO.isFull = false;
				//_tempMC.alpha = 0.3;
//				_tempMC.isOpp = false;
				NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,_tempMC.mediaVO);
			}
		}
		
		public function sendMsg(vo:MediaVO):void
		{
			if(_isConnect==false)return;
			/*var obj:MediaVO = new MediaVO()
			obj.path = vo.path;
			obj.thumb = vo.thumb;
			obj.globalP = vo.globalP;
			obj.globaX = vo.globaX;
			obj.globaY = vo.globaY;
			obj.mediaID = vo.mediaID;
			obj.ipAddress = vo.ipAddress;
			obj.type = vo.type;
			obj.isFull = true;
			obj.isServer = false;
			obj.btyeArray = vo.btyeArray;*/
//			vo.msgNum = ApplicationData.getInstance().msgNum;
			_socket.writeObject(vo);		
			_socket.flush();//派发消息
		}
		
		private function socketConnect():void
		{
			_socket = new Socket();
			_socket.connect(ApplicationData.getInstance().ipAddress,ApplicationData.getInstance().port);
			_socket.addEventListener(Event.CONNECT,onCONNECT);
			_socket.addEventListener(IOErrorEvent.IO_ERROR,onError);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onseError);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA,onSOCKET_DATA);
		}
		
		private function onCONNECT(e:Event):void 
		{
			trace("连接成功");
			_stageTT.text = "网络连接成功";
			var tempSocket:Socket = e.target as Socket;
			tempSocket.addEventListener(Event.CLOSE,onSocketClose);
			_isConnect = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
			_timer.reset();
			_timer.stop();

		}
		
		private function onSocketClose(e:Event):void
		{
			//trace("网络断开");
			_stageTT.text = "网络链接断开";
			_isConnect = false;
			this.dispatchEvent(new Event(Event.CLOSE));
			_timer.reset();
			_timer.start();
		}
		
		private function onError(e:IOErrorEvent):void 
		{
			//trace("连接失败,服务器没打开!");
			_stageTT.text = "连接失败,检测到服务器没打开!";
			_isConnect = false;
			_timer.reset();
			_timer.start();
		}
		
		private function onseError(e:SecurityErrorEvent):void 
		{
			//trace("连接失败，安全错误"+e.text);
			_stageTT.text = "连接失败，安全错误"+e.text;
			_isConnect = false;
			_timer.reset();
			_timer.start();
		}
		
		/**
		 * 接收消息
		 */
		private function onSOCKET_DATA(event:ProgressEvent):void 
		{
			/*var tempSocket:Socket = event.target as Socket;
			//var msg:String = tempSocket.readUTFBytes(tempSocket.bytesAvailable);
			var msg:Object = tempSocket.readObject();
			Tool.log("接收消息"+msg);*/
//			trace("接收消息" ,msg.path,msg.msgNum ,ApplicationData.getInstance().msgNum , msg.type);
			/*if(msg.msgNum!=ApplicationData.getInstance().msgNum)
			{
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在玩命加载资源,请稍后....");
				if( msg.type==".jpg")
				{
					setTimeout(function ():void
					{
						Tool.log("加载图片");
						var stagePoint:Point = new Point(1920*0.5,1080*0.5);
						var obj:MediaVO = new MediaVO();
						obj.isFull = true;
						obj.type = ".jpg";
						obj.isBmpd = true;
						obj.isServer = false;
						obj.globalP = stagePoint;
						obj.globaX = stagePoint.x;
						obj.globaY = stagePoint.y;
						obj.btyeArray = ApplicationData.getInstance().ba;
					//	NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);
					},1000);
				}else{
					Tool.log("视频地址"+msg.ipAddress+"视频名称"+msg.path);
					var stagePoint:Point = new Point(1920*0.5,1080*0.5);
					var obj:MediaVO = new MediaVO();
					obj.isFull = true;
					obj.type = ".flv";
					obj.isServer = true;
					obj.globalP = stagePoint;
					obj.globaX = stagePoint.x;
					obj.globaY = stagePoint.y;
					obj.ipAddress  = msg.ipAddress;
					obj.path = msg.path;
					obj.thumb = msg.thumb;
					NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);
				}
				
			}*/
		}
		
		private function setNetConnect():void
		{
			_nc = new NetConnection();
			_nc.client = this;
			_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_nc.connect("rtmp://192.168.3.78/whiteBoardFile");
		}
		
		private function netStatusHandler(e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success" :
					ToolKit.log("NetConnection.Connect.Success1");
					/*_myRemoteSO = SharedObject.getRemote("whiteBoardSharedObiectData", _nc.uri, false);
					_myRemoteSO.connect(_nc);
					_myRemoteSO.addEventListener(SyncEvent.SYNC, handleSync);*/
					break;
				case "NetConnection.Connect.Rejected" :
				case "NetConnection.Connect.Failed" :
					ToolKit.log("NetConnection.Connect.Failed");
//					_nc.connect("rtmp://192.168.3.78/whiteBoardFile");
					break;
			}
		}
		
		private function handleSync( event:SyncEvent ):void
		{
			if(_myRemoteSO.data.BA==undefined)return;
			_myRemoteSO.data.BA.position = 0;
			ToolKit.log("改变了_isMy"+_isMy);
			if(_isMy)return;
			var byte:ByteArray = _myRemoteSO.data.BA;
			NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			var stagePoint:Point = new Point(1920*0.5,1080*0.5);
			var obj:MediaVO = new MediaVO();
			obj.isFull = true;
			obj.type = ".jpg";
			obj.isBmpd = true;
			obj.isServer = false;
			obj.globalP = stagePoint;
			obj.globaX = stagePoint.x;
			obj.globaY = stagePoint.y;
			obj.btyeArray = byte;
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);
			_myRemoteSO.removeEventListener(SyncEvent.SYNC, handleSync);
			//			Tool.log(_whiteBoardRemoteSO.data.BA);
			
			/*if(!ApplicationData.getInstance().isOpp)
			{
			Tool.log("接收到ByteArray的长度"+String(_whiteBoardRemoteSO.data.BA.length));
			var byte:ByteArray = _whiteBoardRemoteSO.data.BA;
			NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			var stagePoint:Point = new Point(1920*0.5,1080*0.5);
			var obj:MediaVO = new MediaVO();
			obj.isFull = true;
			obj.type = ".jpg";
			obj.isBmpd = true;
			obj.isServer = false;
			obj.globalP = stagePoint;
			obj.globaX = stagePoint.x;
			obj.globaY = stagePoint.y;
			obj.btyeArray = byte;
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);
			}*/
		}
		
		
		private function getSharedObject():void
		{
			_myRemoteSO = SharedObject.getRemote("whiteBoardSharedObiectData", ApplicationData.getInstance().netConnect.uri, false);
			_myRemoteSO.connect(ApplicationData.getInstance().netConnect);
			
			/*Tool.log("接收到ByteArray的长度"+String(_myRemoteSO.data.BA.length));
			var byte:ByteArray = _myRemoteSO.data.BA;
			
			NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			var stagePoint:Point = new Point(1920*0.5,1080*0.5);
			var obj:MediaVO = new MediaVO();
			obj.isFull = true;
			obj.type = ".jpg";
			obj.isBmpd = true;
			obj.isServer = false;
			obj.globalP = stagePoint;
			obj.globaX = stagePoint.x;
			obj.globaY = stagePoint.y;
			obj.btyeArray = byte;
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);*/
		}
		
		public function closeMC(id:int):void
		{
			for (var i:int = 0; i < _arr.length; i++) 
			{
				if(_arr[i].mediaID == id)
				{
					if(_arrCon[i])
					{
						_arrCon[i].alpha = 1;
						_arrCon[i].isOpp = false;
					}
				}
			}
		}
		
		public function outIn():void
		{
			for (var i:int = 0; i < _arrCon.length; i++) 
			{
				Tweener.addTween(_arrCon[i],{time:1.5,delay:0.2*(i-1),x:(i)*210,alpha:1,y:0});
			}
			
		}
		
		public function inOut():void
		{///trace("inOutinOutinOutinOut");
			for (var i:int = 0; i < _arrCon.length; i++) 
			{
				Tweener.addTween(_arrCon[i],{time:1,delay:0.1*(i-1),alpha:1,y:120});
			}
			
			setTimeout(function ():void
			{
				dispose();
			},2000);
		}
		
		private function dispose():void
		{
			for (var i:int = 0; i < _arrCon.length; i++) 
			{
				(_arrCon[i] as LoaderImage).dispose();
				_arrCon[i].parent.removeChild(_arrCon[i]);
				//Tweener.addTween(_arrCon[i],{time:1,delay:0.1*(i-1),alpha:1,y:120});
			}
		}
		
		public function reset():void
		{
			for (var i:int = 0; i < _arrCon.length; i++) 
			{
				_arrCon[i].x = 1600;
			}
		}
	}
}