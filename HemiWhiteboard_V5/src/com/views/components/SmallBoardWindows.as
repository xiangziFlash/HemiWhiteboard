package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.res.PPTYuLanRes;
	import com.scxlib.AutoOppMedia;
	import com.tweener.transitions.Tweener;
	import com.views.shoyScreenBtnRes;
	import com.views.windows.BasicWindow;
	import com.windows.PromptBoxWindow;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class SmallBoardWindows extends NativeWindow
	{
		private var _shotScreenBtn:shoyScreenBtnRes;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
//		private var _textF:TextField;
//		private var _timer:Timer;
		private var _alwaysInFrontTimer:Timer;
		private var _saveMedia:SaveMedia;
		private var mainApp:NativeWindow;
		private var _pptTools:PPTYuLanRes;
//		private var _pptYuLan:PPTYuLan;
		private var _promptBoxWindow:PromptBoxWindow;

		private var _targetFile:File;
		private var _isWait:Boolean;

		public function SmallBoardWindows(initOption:NativeWindowInitOptions=null)
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.systemChrome="none";
			initOptions.resizable=false;
			initOptions.transparent = true;
			super(initOptions);
			
//			this.width = Capabilities.screenResolutionX/1920;
//			this.height = Capabilities.screenResolutionY/1080;
//			this.x = this.y = 0;
			this.width = Capabilities.screenResolutionX;
			this.height = Capabilities.screenResolutionY;
			//mainApp.scaleX = Capabilities.screenResolutionX/1920;
			//mainApp.scaleY = Capabilities.screenResolutionY/1080;
			this.alwaysInFront = true;
			mainApp = NativeApplication.nativeApplication.openedWindows[0] as NativeWindow;
			this.addEventListener(Event.CLOSE, closeAppHandler);
//			mainApp.width = Capabilities.screenResolutionX;
//			mainApp.height = Capabilities.screenResolutionY;
//			mainApp.x = mainApp.y = 0;
//			_textF = new TextField();
//			_textF.defaultTextFormat = new TextFormat("YaHei_font",14,0xFF0000);
//			_textF.autoSize = "left";
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			_shotScreenBtn = new shoyScreenBtnRes();
			_shotScreenBtn.x = Capabilities.screenResolutionX-_shotScreenBtn.width-50;
			_shotScreenBtn.y = Capabilities.screenResolutionY-_shotScreenBtn.height-50;
			
			_pptTools = new PPTYuLanRes();
			
			this.stage.addChild(_shotScreenBtn);
//			this.stage.addChild(_pptTools);
			_shotScreenBtn.visible = false;
			_pptTools.visible = false;
			
			/*_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);*/
			
			_alwaysInFrontTimer = new Timer(1000);
			_alwaysInFrontTimer.addEventListener(TimerEvent.TIMER,onAlwaysInFrontTimer);
			_alwaysInFrontTimer.start();
			_shotScreenBtn.addEventListener(MouseEvent.MOUSE_DOWN,onShotScreenBtnDown);
			_pptTools.addEventListener(MouseEvent.CLICK,onPPTToolsClick);
		}
		
		private function onPPTToolsClick(event:Event):void
		{
			ConstData.pptYuLan.sendMessage(event.target.name);
		}
		
		private function onAlwaysInFrontTimer(e:TimerEvent):void
		{
			if(!this.closed)
			{
				if(!this.alwaysInFront)
				{
					trace("小窗口 浮在最上层")
					this.alwaysInFront = true;
				}
			}else{
//				_alwaysInFrontTimer.stop();
			}
		}
		
		private function onTimer():void
		{
			this.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
			if(_promptBoxWindow)
			{
				_promptBoxWindow.hideWin();
			}
			_isWait = false;
		}
		
		private function closeWindow():void
		{
			if(this.closed) return;
			_shotScreenBtn.visible = false;
		}
		
		private function onShotScreenBtnDown(e:MouseEvent):void
		{
			_downX = this.stage.mouseX;
			_downY = this.stage.mouseY;
			_tempX = _shotScreenBtn.x;
			_tempY = _shotScreenBtn.y;
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE,onShotScreenMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onShotScreenUP);
		}
		
		private function onShotScreenMove(event:MouseEvent):void
		{
			_shotScreenBtn.x +=stage.mouseX-_downX;
			_shotScreenBtn.y +=stage.mouseY-_downY;
			_downX = this.stage.mouseX;
			_downY = this.stage.mouseY;
		}
		
		private function onShotScreenUP(event:MouseEvent):void
		{
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onShotScreenMove);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onShotScreenUP);
//			trace("_shotScreenBtn")
			if(Math.abs(_shotScreenBtn.x-_tempX)<5&&Math.abs(_shotScreenBtn.y-_tempY)<5)
			{
//				trace("执行了",event.target.name)
				if(event.target.name=="btn_0")
				{
					_shotScreenBtn.visible = false;
					_pptTools.visible = false;
					NotificationFactory.sendNotification(NotificationIDs.START_SHOTSCREEN,0);
					if(_saveMedia==null)
					{
						_saveMedia = new SaveMedia();
						_saveMedia.addEventListener(Event.CHANGE,onSaveChange);
						_saveMedia.addEventListener(Event.CLOSE,onSaveClose);
						_saveMedia.addEventListener(Event.COMPLETE,onSaveComplete);
					}else{
						_saveMedia.dispose();
					}
					setTimeout(function ():void
					{
						_saveMedia.startJiePing();
					},20);
				}else if(event.target.name=="btn_1"){
					//trace("窗口全屏")
					if(_isWait)
					{
						if(_promptBoxWindow==null)
						{
							_promptBoxWindow = new PromptBoxWindow();
						}
						_promptBoxWindow.showWin("正在导入文件,请稍候...");
						return;
					}
					_shotScreenBtn.visible = false;
					_pptTools.visible = false;
					NotificationFactory.sendNotification(NotificationIDs.MAX_WINDOW);
					if(_saveMedia)
					{
						_saveMedia.dispose();
					}
					return;
				}
			}
		}
		
		private function onSaveChange(e:Event):void
		{
			removeConfigListeners();
			NotificationFactory.sendNotification(NotificationIDs.MAX_WINDOW);
		}
		
		private function onSaveComplete(e:Event):void
		{
			hideSmallBoard();
		}
		
		private function onSaveClose(e:Event):void
		{
			NotificationFactory.sendNotification(NotificationIDs.MINI_WINDOWN);
		}
		
		public function configListeners():void 
		{
			NativeDragManager.acceptDragDrop(_shotScreenBtn);
			NativeDragManager.dropAction = NativeDragActions.MOVE;
			this.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, eventHandler); 
			this.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
		}
		
		public function removeConfigListeners():void
		{
			this.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, eventHandler); 
			this.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
		}
		
		private function eventHandler(event:NativeDragEvent):void 
		{
			//将拖入的文件以数组形式获得，指定拖入的数据是文件数组形式
			var files:Array = event.clipboard.getData(ClipboardFormats.FILE_LIST_FORMAT) as Array;
			//获得拖入的第一个文件
			var file:File = File(files[0]);
			//trace(event.type,"event.type")
			switch(event.type) 
			{
				case NativeDragEvent.NATIVE_DRAG_ENTER:
					switch(file.type) {
						case ".jpg":
						case ".JPG":
						case ".jpeg":
						case ".JPEG":
						case ".png":
						case ".PNG":
						case ".flv":
						case ".FLV":
						case ".swf":
						case ".SWF":
						case ".mp4":
						case ".MP4":
							//trace("加载拖入的图片000")
							NativeDragManager.acceptDragDrop(_shotScreenBtn);
							//删除上一张加载的图片
							//_loader.unload();
							//加载拖入的图片
							//trace("加载拖入的图片")
							//_loader.load(new URLRequest(file.url));
							//mainApp.stage.addChild(_loader);
							break;
					}
					break;
				case NativeDragEvent.NATIVE_DRAG_DROP:
					switch(file.type) {
						//						case ".jpg":
						//						case ".JPG":
						//						case ".jpeg":
						//						case ".JPEG":
						//						case ".gif":
						//						case ".GIF":
						//						case ".png":
						//						case ".PNG":
						//删除上一张加载的图片
						//_loader.unload();
						//加载拖入的图片
						//trace("加载拖入的图片")
						//	_loader.load(new URLRequest(file.url));
						//mainApp.stage.addChild(_loader);
						//							break;
					}
					break;
			}
			//	_filePath = file.url;
			//trace(_filePath.split(".")[1]);
			
			for (var i:int = 0; i < files.length; i++) 
			{
				openFile(files[i]);
				//				trace(files[i].url,"files[i].url")
			}
		}
		
		private function openFile(file:File):void
		{
			_isWait = true;
			if(file.type==".jpg"||file.type==".JPG"||file.type==".jpeg"||file.type==".JPEG"||file.type==".PNG"||file.type==".png"||file.type==".swf"||file.type==".SWF")
			{
				removeConfigListeners();
				setTimeout(moveEnd,300);
//				Tweener.addTween(this,{time:0.2,delay:0.3,onComplete:moveEnd});
			}else if(file.type==".flv"||file.type==".FLV"||file.type==".mp4"||file.type==".MP4"){
				removeConfigListeners();
				setTimeout(moveEnd,300);
//				Tweener.addTween(this,{time:0.2,delay:0.3,onComplete:moveEnd});
			}else if(file.type==".bmp"||file.type==".BMP"){
				removeConfigListeners();
				//_fileBmp = new File(str);
				//_fileBmp.load();
				//_fileBmp.addEventListener(Event.COMPLETE,onFileBmpEnd);
//				Tweener.addTween(this,{time:0.2,delay:0.1,onComplete:moveEnd});
				setTimeout(moveEnd,300);
			}else{
				//采用系统默认的程序打开此文件
				removeConfigListeners();
				if(file.type==".pptx"||file.type==".ppt"||file.type==".pps")
				{
					_pptTools.visible = true;
					if(file.extension=="pps")
					{
						file.openWithDefaultApplication();
						openPPT();
					}else
					{
//						_targetFile = new File(file.nativePath.replace(file.extension,"pps"));
						//				trace((event.currentTarget as File).nativePath,targetFile.nativePath);
						_targetFile = new File(ApplicationData.getInstance().appPath + "/temporaryFile/"+file.name.split(".")[file.name.split(".").length-1]+".pps");
						file.copyToAsync(_targetFile, true);
						file.addEventListener(Event.COMPLETE, onCopyComplete);
					}
				}else{
					var openFile:File = File.desktopDirectory.resolvePath(file.nativePath);
					openFile.openWithDefaultApplication();
					_pptTools.visible = false;
				}
				if(_promptBoxWindow==null)
				{
					_promptBoxWindow = new PromptBoxWindow();
				}
				_promptBoxWindow.showWin("正在打开文件");
				setTimeout(onTimer,1500);
//				Tweener.addTween(this,{time:0.1,delay:0.1,onComplete:moveEnd1});
			}
			function moveEnd():void
			{
				onDragComplete(file);
			}
		}
		
		public function showLog(str:String):void
		{
			if(_promptBoxWindow==null)
			{
				_promptBoxWindow = new PromptBoxWindow();
			}
			_promptBoxWindow.showWin(str);
		}
		
		public function hideLog():void
		{
			this.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
			if(_promptBoxWindow)
			{
				_promptBoxWindow.hideWin();
			}
			_isWait = false;
		}
		
		public function openPPT():void
		{
			//打开PPT文件
			/*_pptTools.visible = true;
			if(_pptYuLan==null)
			{
				_pptYuLan = new PPTYuLan();
				_pptYuLan.closeServer();
				_pptYuLan.openServer();
				ConstData.pptYuLan = _pptYuLan;
			}*/
		}
		
		private function onCopyComplete(event:Event):void
		{
			_targetFile.openWithDefaultApplication();
			openPPT();
		}
		
		/*private function openFile(str:String):void
		{
			if(str.split(".")[1]=="jpg"||str.split(".")[1]=="JPG"||str.split(".")[1]=="jpeg"||str.split(".")[1]=="JPEG"||str.split(".")[1]=="PNG"||str.split(".")[1]=="png"||str.split(".")[1]=="swf"||str.split(".")[1]=="SWF")
			{
				removeConfigListeners();
				Tweener.addTween(this,{time:0.2,delay:0.3,onComplete:moveEnd});
			}else if(str.split(".")[1]=="flv"||str.split(".")[1]=="FLV"||str.split(".")[1]=="mp4"||str.split(".")[1]=="MP4"){
				removeConfigListeners();
				Tweener.addTween(this,{time:0.2,delay:0.3,onComplete:moveEnd});
			}else if(str.split(".")[1]=="bmp"||str.split(".")[1]=="BMP"){
				removeConfigListeners();
				//_fileBmp = new File(str);
				//_fileBmp.load();
				//_fileBmp.addEventListener(Event.COMPLETE,onFileBmpEnd);
				Tweener.addTween(this,{time:0.2,delay:0.1,onComplete:moveEnd});
			}else{
				//采用系统默认的程序打开此文件
				removeConfigListeners();
				var openFile:File = File.desktopDirectory.resolvePath(str);
				openFile.openWithDefaultApplication();
				
				if(str.split(".")[str.split(".").length-1]=="pptx"||str.split(".")[str.split(".").length-1]=="ppt")
				{
					if((event.currentTarget as File).extension=="pps")
					{
						(event.currentTarget as File).openWithDefaultApplication();
						sendFile((event.currentTarget as File).nativePath);
					}else
					{
						_targetFile=new File((event.currentTarget as File).nativePath.replace((event.currentTarget as File).extension,"pps"));
						//				trace((event.currentTarget as File).nativePath,targetFile.nativePath);
						(event.currentTarget as File).copyToAsync(_targetFile, true);
						(event.currentTarget as File).addEventListener(Event.COMPLETE, onCopyComplete);
						
					}

					
					
					//打开PPT文件
					_pptTools.visible = true;
					if(_pptYuLan==null)
					{
						_pptYuLan = new PPTYuLan();
						_pptYuLan.closeServer();
						ConstData.pptYuLan = _pptYuLan;
					}
					_pptYuLan.openServer();
				}else{
					_pptTools.visible = false;
				}
				Tweener.addTween(this,{time:0.1,delay:0.1,onComplete:moveEnd1});
			}
			function moveEnd():void
			{
				onDragComplete(str);
			}
			
			function moveEnd1():void
			{
				this.stage.addChild(_textF);
				_textF.text = "文件正在打开";
				_textF.x = (195-_textF.textWidth)*0.5;
				_textF.y = (80-_textF.textHeight)*0.5;
				_timer.reset();
				_timer.start();	
			}
		}*/
		
		private function onDragComplete(file:File):void
		{
//			trace("拖入完成",str)
			var vo:MediaVO = new MediaVO();
			vo.type = "."+file.nativePath.split(".")[1];
			vo.path =file.nativePath;
			vo.thumb = file.nativePath;
			vo.globalP = new Point(0,0);
			vo.formatString(file.nativePath);
			vo.title = file.name.split(".")[0];
		/*	trace(vo.title,"vo.title")
			this.stage.addChild(_textF);
			_textF.text = "文件已载入";
			_textF.x = _shotScreenBtn.x;
			_textF.y = _shotScreenBtn.y;*/
			if(_promptBoxWindow==null)
			{
				_promptBoxWindow = new PromptBoxWindow();
			}
			_promptBoxWindow.showWin("正在导入文件");
			AutoOppMedia.setVO(vo);
			/*_timer.reset();
			_timer.start();*/
			setTimeout(onTimer,2500);
		}
		
		public function hideSmallBoard():void
		{
			this.stage.getChildByName("smallBoard").x =-(this.stage.getChildByName("smallBoard").width - 20);
		}
		
		public function showShotScreenBtn():void
		{
//			trace("showShotScreenBtn")
			_shotScreenBtn.visible = true;
			_pptTools.visible = true;
		}
		
		public function hideShotScreenBtn():void
		{
//			_alwaysInFrontTimer.stop();
			_shotScreenBtn.visible = false;
//			_pptTools.visible = false;
		}
		
		public function showWindows():void
		{
			this.activate();
			mainApp.alwaysInFront = false;
			this.alwaysInFront = true;
		}
		
		public function hideWindows():void
		{
			this.visible=false;
		}
		
		public function closeWindows():void
		{
			this.close();
		}
		
		public function closePPTYuLan():void
		{
		
		}
		private function killAllProcess():void
		{
			ToolKit.killProcess("EE4WebCam");
			ToolKit.killProcess("WebSocketsTestServer");
			ToolKit.killProcess("nsmanage");
			ToolKit.killProcess("WhiteBoardServer");
			//ToolKit.openProcess(ApplicationData.getInstance().appPath+"assets/kill/ProcessKill.exe");
			if(ConstData.socket){
				ConstData.socket.closeSocket();
			}
		}
		
		private function closeAppHandler(e:Event):void
		{
			var windows:Array=NativeApplication.nativeApplication.openedWindows;
			var len:int=windows.length;
			for(var i:int=0;i<len;i++){
				windows[i].close();
			}
			NativeApplication.nativeApplication.clear();
			killAllProcess();
			NativeApplication.nativeApplication.exit();
		}
	}
}