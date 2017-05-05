package com.views.components
{
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.res.IPAddressRes;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-1-8 下午7:02:58
	 *  设置软件通信的环境
	 */
	public class SettingEnvironment extends Sprite
	{
		private var _sp:Sprite;
		private var _res:IPAddressRes;
		private var _ips:Vector.<String>;
		private var _ipAddress:String;
		
		private var _pattern:RegExp;
		
		public function SettingEnvironment()
		{
			initViews();
		}
		
		private function initViews():void
		{
			_sp = new Sprite();
			_res = new IPAddressRes();
			_sp.x = 0;
			_sp.y = 0;
			this.addChild(_res);
			this.addChild(_sp);
			_sp.visible = false;
			//			this.addChild(_res.yesBtn);
			addIps();
			_sp.addEventListener(MouseEvent.CLICK, onSpClick);
			_res.downBtn.addEventListener(MouseEvent.CLICK, onDownBtnClick);
			_res.yesBtn.addEventListener(MouseEvent.CLICK, onYesBtnClick);
			try
			{
				_res.bg.addEventListener(MouseEvent.CLICK, onBgClick);
			} 
			catch(error:Error) 
			{
				
			}
			
		}
		
		private function onBgClick(event:MouseEvent):void
		{
			this.visible = false;
		}
		
		private function onYesBtnClick(event:MouseEvent):void
		{
			_ipAddress = _res.ipTT.text;
			//			trace("_ipAddress",_ipAddress);
			ApplicationData.getInstance().socketServer = _ipAddress;
			ApplicationData.getInstance().pptAddress = _ipAddress;
			xiuGaiBaiBanData();
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在配置软件环境");
		}
		
		private function onDownBtnClick(event:MouseEvent):void
		{
			_sp.visible = true;
		}
		
		private function drawBtn(str:String):Sprite
		{
			var sp:Sprite = new Sprite();
			var text:TextField = new TextField();
			text.mouseEnabled = false;
			text.embedFonts = true;
			text.autoSize = "left";
			text.defaultTextFormat = new TextFormat("YaHei_font", 15, 0xFFFFFF);
			text.text = str;
			sp.addChild(text);
			sp.graphics.clear();
			sp.graphics.beginFill(0xFFFFFF,0);
			sp.graphics.drawRect(0, 0, sp.width, sp.height);
			sp.graphics.endFill();
			return sp;
		}
		
		private function getIpAddress():Vector.<String>
		{
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
			var networkInterface:Vector.<NetworkInterface> = networkInfo.findInterfaces();
			var ips:Vector.<String> = new Vector.<String>;
			for (var i:int = 0; i < networkInterface.length; i++) 
			{
				if(_pattern.test(networkInterface[i].addresses[0].address) == true)
				{
					ips.push(networkInterface[i].addresses[0].address);
				}
			}
			ips.reverse();
			return ips;
		}
		
		private function onSpClick(e:MouseEvent):void
		{
			if(e.target.name.split("_")[0] != "sp")return;
			var id:int = e.target.name.split("_")[1];
			_res.ipTT.text = _ips[id];
			_sp.visible = false;
		}
		
		public function addIps():void
		{
			_pattern=/^(([1-9]|([1-9]\d)|(1\d\d)|(2([0-4]\d|5[0-5])))\.)(([1-9]|([1-9]\d)|(1\d\d)|(2([0-4]\d|5[0-5])))\.){2}([1-9]|([1-9]\d)|(1\d\d)|(2([0-4]\d|5[0-5])))$/;
			_ips = getIpAddress();
			_res.ipTT.embedFonts = true;
			_res.ipTT.defaultTextFormat = new TextFormat("YaHei_font", 15, 0x000000);
			_res.ipTT.text = _ips[0];
			while(_sp.numChildren > 0)
			{
				_sp.removeChildAt(0);
			}
			for (var i:int = 1; i < _ips.length; i++) 
			{
				var sp:Sprite = drawBtn(_ips[i]);
				sp.name = "sp_"+(i);
				sp.y = (i-1)*20;
				_sp.addChild(sp);
			}
		}
		
		private function xiuGaiBaiBanData():void
		{
			var appPath:String = ApplicationData.getInstance().appPath;
			var pptPath:String = appPath + "PPT/EE4WebCam.exe.config";
			var appConfig:String = appPath + "config/config.xml";
			var serverPath:String = appPath + "assets/WhiteBoardServer/config.xml";
			var webConfig:String = appPath + "UPloadfile/web.config";
			readConfigFile(pptPath);
			
			setTimeout(function ():void
			{
				readAppConfigFile(appConfig);
			},1000);
			
			setTimeout(function ():void
			{
				readserverPath(serverPath);
			},2000);
			
			setTimeout(function ():void
			{
				readWebConfig(webConfig);
			},3000);
		}
		
		private function readAppConfigFile(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				//					trace(xml.appSettings.add[1].@value);
				xml.ipAddress = _ipAddress;
				xml.pptAddress = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readserverPath(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				//trace(xml.appSettings.add[1].@value);
				xml.ipAddress = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readWebConfig(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				xml.appSettings.add[1].@value = "http://"+ _ipAddress +":10000/photos/";
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readConfigFile(path:String):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void{
				//trace(evt.target.data);
				//					trace(evt.target.data.appSettings);
				var xml:XML = new XML(evt.target.data);
				//trace(xml.appSettings.add[1].@value);
				xml.appSettings.add[1].@value = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
			ConstData.setEnv.visible = false;
			
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.SETTING_APP);
			},100);
		}
		
		
		/**
		 * xml写入
		 * @param fileName
		 * @return 
		 */	
		private static function saveUTFString(str:String, fileName:String):void
		{//trace("数据处理完成")
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			//				trace(fileName, "fileName");
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.openAsync(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
		}
		
		public function reset():void
		{
			while(_sp.numChildren > 0)
			{
				_sp.removeChildAt(0);
			}
			_sp.visible = false;
		}
	}
}