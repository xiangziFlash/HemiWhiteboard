package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-1-9 下午3:00:15
	 * 白板初始化
	 */
	public class InitializeTheEnvironment extends Sprite
	{
		private var _ipAddress:String = "";
		private var _ldr:URLLoader;
		private var _ldr1:URLLoader;
		private var _appPath:String;
		
		public var closeWinFun:Function;
		//校验
		private var _timer:Timer;
		public function InitializeTheEnvironment()
		{
			var file1:File=File.applicationDirectory;   
			var appPath:String = file1.nativePath+"/";
			var pattern:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
			_appPath = appPath.replace(pattern, "/");
			initViews();
//			login();
		}
		
		public function login():void
		{
			ConstData.macAddress = ToolKit.getMacAddress();
			//测试专用
			ConstData.macAddress = "50:E5:49:54:D6:1F";
			var file:File = new File("C:/Windows/TestTxt.dll");
			if(!file.exists){
				ConstData.promptBox.showPromptBox(4);
				ConstData.promptBox.visible = true;
				return;
			}
			ToolKit.readTxt("C:/Windows/TestTxt.dll",readTxtBack);
			ToolKit.log("macAddress:"+ConstData.macAddress);
		}
		
		private function interfaceBack(obj:Object):void
		{
			var code:int = obj.code;
//			trace("code "+ obj.code);
//			code = 202;
			//["是否将历史记录清空？","登录失败，重新登录？","正在登录，请稍候","被踢下线","认证失败","参数错误","用户没有加入到大屏管理后台,是否重新登录？","检测异常，需重新登录"]
			ToolKit.log("登录接口返回值code:"+code);
			switch(code)
			{
				case 201:
				{
//					trace("失败");
//					ConstData.promptBox.showPromptBox(1);
//					ConstData.promptBox.visible = true;
					ConstData.promptBox.setPromptBox(obj.message);
					ConstData.promptBox.visible = true;
					
					setTimeout(function ():void
					{
						if(closeWinFun){
							closeWinFun();
						}
					},2000);
					break;
				}
					
				case 200:
				{
//					trace("成功");
					if(obj == null)return;
					ConstData.promptBox.visible = false;
					ConstData.session = obj.data.response.session;
//					trace("ConstData.session",ConstData.session);
					ToolKit.log("白板session:"+ConstData.session);
					if(!_timer){
//						trace("检测心跳 30分钟");
						//检测心跳 30分钟
						_timer = new Timer(15000);
//						_timer = new Timer(1000*60*30);
						_timer.addEventListener(TimerEvent.TIMER,onTimer);
					}
					_timer.reset();
					_timer.start();
					initViews();
					break;
				}
			}
		}
		
		private function onTimer(event:TimerEvent):void
		{
			checkLogin();
		}
		/*校验*/
		private function checkLogin():void
		{
			var path:String = ConstData.ssologinServerURL + "?session="+ConstData.session;
			ToolKit.log("校验接口:"+path);
			ToolKit.getInterfaceData(path,checkLoginBack);
		}
		
		private function checkLoginBack(obj:Object):void
		{
			var code:int = obj.code;
//			trace("code "+ obj.code);
			ToolKit.log("校验接口返回值code:"+code);
			code = 203;
			switch(code)
			{
				case 203:
				{
					login();
//					trace("需要重新登录");
//					ConstData.promptBox.showPromptBox(7);
//					ConstData.promptBox.visible = true;
					_timer.reset();
					_timer.stop();
					break;
				}
					
				case 201:
				{
//					trace("失败");
					ConstData.promptBox.setPromptBox(obj.message);
//					ConstData.promptBox.showPromptBox(4);
					ConstData.promptBox.visible = true;
					
					setTimeout(function ():void
					{
						if(closeWinFun){
							closeWinFun();
						}
					},2000);
					break;
				}
					
				case 200:
				{
//					trace("成功");
					if(obj == null)return;
					ConstData.promptBox.visible = false;
					break;
				}
					
				case 204:
				{
//					trace("被踢下线");
					ConstData.promptBox.showPromptBox(3);
					ConstData.promptBox.visible = true;
					break;
				}
					
				case 1001:
				{
//					trace("用户没有加入到大屏管理后台");
					ConstData.promptBox.showPromptBox(6);
					ConstData.promptBox.visible = true;
					break;
				}
					
				case 202:
				{
//					trace("参数错误");
//					ConstData.promptBox.showPromptBox(5);
//					ConstData.promptBox.visible = true;
					if(closeWinFun){
						closeWinFun();
					}
					break;
				}
			}
		}
		
		private function readTxtBack(data:String):void
		{
			ToolKit.log("key:"+data);
			var tempKey:String = ToolKit.Trim(data);
			ConstData.key = encodeURIComponent(tempKey);
			var interfacePath:String = ConstData.loginServerURL + "?key=" + ConstData.key + "&app_id=" + "whitebord_head" + "&mac=" + ConstData.macAddress;
			ToolKit.getInterfaceData(interfacePath,interfaceBack);
			ToolKit.log("验证接口链接:"+interfacePath);
		}		
		
		private function initViews():void
		{
			_ipAddress = ToolKit.getIpAddress();
			var file:File = new File(_appPath+"assets/0.txt");
			xiuGaiBaiBanData();
		}
		
		private function xiuGaiBaiBanData():void
		{
			var file1:File=File.applicationDirectory;   
			var appPath:String = file1.nativePath+"/";
			var pattern:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
			appPath = appPath.replace(pattern, "/");
			
			var pptPath:String = appPath + "PPT/EE4WebCam.exe.config";
			var appConfig:String = appPath + "config/config.xml";
			var serverPath:String = appPath + "assets/WhiteBoardServer/config.xml";
			var webConfig:String = appPath + "UPloadfile/web.config";
			var webServer:String = appPath + "assets/webserver/WebSocketsTestServer.exe.config";
			readConfigFile(pptPath);
			
			setTimeout(function ():void
			{
				readAppConfigFile(appConfig);
			},1000);
			
			setTimeout(function ():void
			{
//				readserverPath(serverPath);
			},2000);
			
			setTimeout(function ():void
			{
				readWebConfig(webConfig);
			},3000);
			
			setTimeout(function ():void
			{
				readWebServerConfig(webServer);
			},3000);
			faQiVote("-1");
			var file:File = new File(_appPath+"assets/0.txt");
			if(file.exists)return;
//			shiXianJieKou();
		}
		
		private function faQiVote(type:String):void
		{
			//http://t.iptid.com/ws/eduVote.asmx 
			//http://127.0.0.1:1986/SetVoteStatus?status=4
			var request:URLRequest=new URLRequest("http://127.0.0.1:1986/SetVoteStatus");
			var params:URLVariables = new URLVariables();
			params.status = type;
			request.method = URLRequestMethod.POST;
			request.data=params;
			
			_ldr = new URLLoader();
			_ldr.addEventListener(Event.COMPLETE,onUrlLdrEnd);
			_ldr.addEventListener(IOErrorEvent.IO_ERROR,onIO_ERROR);
			_ldr.load(request);
//			var str:String = "VoteStatus:" + type;
//			saveUTFString(str,ApplicationData.getInstance().appPath+"UPloadfile/VoteStatus.txt")
		}
		
		private function onIO_ERROR(event:IOErrorEvent):void
		{
			trace("onIO_ERROR")
		}
		
		private function onUrlLdrEnd(event:Event):void
		{
			var msg:String = event.target.data;
			trace("<<<<faQiVote", msg);
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
				xml.httpAddress = _ipAddress+":1986";
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
				xml.webAddress = _ipAddress;
				txtLoad.close();
				saveUTFString(xml.toString(), path);
			}
		}
		
		private function readWebServerConfig(path:String):void
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
				xml.appSettings.add[0].@value = _ipAddress;
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
				xml.appSettings.add[1].@value = _ipAddress;
				xml.appSettings.add[3].@value = _ipAddress;
				xml.appSettings.add[4].@value = "http://" + _ipAddress + ":1986/UPloadfile/";
				/*xml.appSettings.add[1].@value = "http://"+ _ipAddress +":10000/photos/";
				xml.appSettings.add[0].@value = ApplicationData.getInstance().appPath +"FileSytem/photos/";*/
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
			setTimeout(function ():void
			{
				disEvent();
			},3000);
		}
		
		private function shiXianJieKou():void
		{
			/*接口地址：http://t.iptid.com/ws/eduShow.asmx
			方法：SetCallbackpage
			参数类型：string（例如“http://192.168.3.89/frame.aspx”）
			结果：string
			“0”：设置失败；
			“1”：设置成功*/
			
			var request:URLRequest = new URLRequest("http://t.iptid.com/ws/eduShow.asmx"+"/SetCallbackpage");
			var params:URLVariables = new URLVariables();
//			params.url = "http://" + "192.168.3.89" + ":1236/frame.aspx";
//			trace("http://"+_ipAddress+":1986/Default.aspx","---");
			params.url = "http://"+_ipAddress+":1986/Default.aspx";
			request.method = URLRequestMethod.POST;
			request.data=params;
			_ldr1 = new URLLoader();
			_ldr1.load(request);
			_ldr1.addEventListener(Event.COMPLETE,onUrlLdrEnd1);
		}
		
		private function onUrlLdrEnd1(event:Event):void
		{
			_ldr1.removeEventListener(Event.COMPLETE,onUrlLdrEnd1);
			var msg:String = event.target.data;
//			trace("<<<<shiXianJieKou", msg);
		}
		
		private function disEvent():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
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
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.openAsync(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
		}
		
	}
}