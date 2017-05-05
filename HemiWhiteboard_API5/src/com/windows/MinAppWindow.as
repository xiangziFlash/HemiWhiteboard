package com.windows
{
	import com.models.vo.FullShowAppVO;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.html.HTMLLoader;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	public class MinAppWindow extends NativeWindow
	{
		private var _spCon:Sprite;
		private var _closeButtonWin:ButtonWindow;
		private var _process:NativeProcess;//应用程序
		private var _ldr:Loader;//普通Loader加载器
		private var _htmlLdr:HTMLLoader;
		//private var _loading:MinShowAppLoadingRes;
		private var _timer:Timer;
		private var mainApp:NativeWindow;
		private var _alwaysInFrontTimer:Timer;
		
		public function MinAppWindow(winArgs:NativeWindowInitOptions=null)
		{
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.systemChrome="none";
			winArgs.transparent = true;
			winArgs.resizable=false;
			super(winArgs);
			mainApp = NativeApplication.nativeApplication.openedWindows[0] as NativeWindow;
			this.alwaysInFront = true;
			this.stage.align = "TL";
			this.stage.scaleMode = "noScale";
			this.addEventListener(Event.CLOSING, onClosing);
			this.width = 1920;
			this.height = 1080;
			this.x = 0;
			this.y = 0;
			
			_spCon=new Sprite();
//			_spCon.graphics.beginFill(0x000000);
//			_spCon.graphics.drawRect(0,0,960,540);
//			_spCon.graphics.endFill();
			
		//	_loading=new MinShowAppLoadingRes();			
		//	this.stage.addChild(_loading);
			//this.stage.addChild(_spCon);
			
			_timer = new Timer(10000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
			
			_alwaysInFrontTimer = new Timer(1000);
			_alwaysInFrontTimer.addEventListener(TimerEvent.TIMER,onAlwaysInFrontTimer);
			_alwaysInFrontTimer.start();
			
			//_closeButtonWin=new ButtonWindow();
			//_closeButtonWin.x = _closeButtonWin.y = 0;
//			_closeButtonWin.addEventListener(Event.CHANGE,onCHANGE);
		//	_closeButtonWin.addEventListener(Event.CLOSE,onCloseAll);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN,onThisDown);
//			this.stage.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onCHANGE(event:Event):void
		{
			//trace("click++++++++")	
			this.startMove();
		}
		
		private function onThisDown(event:MouseEvent):void
		{
 			//trace("down")
			this.startMove();
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}	
		
		private function onClosing(evt:Event):void
		{
			evt.preventDefault();
			this.visible=false;
		}
		
		private function onAlwaysInFrontTimer(e:TimerEvent):void
		{
			if(!this.closed)
			{
				if(!this.alwaysInFront)
				{
					this.alwaysInFront = true;
				}
			}else{
				//_alwaysInFrontTimer.stop();
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
//			if(!_closeButtonWin.closed){
//				_closeButtonWin.activate();
//			}
//			_timer.stop();
		}
		
		private function onCloseAll(event:Event):void
		{
//			_loading.visible=false;
			if(_process){
				_process.exit(true);
				_process.addEventListener(NativeProcessExitEvent.EXIT,onEXIT);
			}
			if(_ldr){
				_ldr.unloadAndStop(true);
				_ldr=null;
				closeApp();
			}
			if(_htmlLdr){
				_htmlLdr.load(new URLRequest("assets/blank.html"));
				closeApp();
			}
		}
		
		/**
		 * 
		 * 打开一个应用
		 * */
		public function openApp(vo:com.models.vo.FullShowAppVO):void
		{			
			var pattern:RegExp = /\\/g;
			vo.appUrl = vo.appUrl.replace(pattern, "/");
			switch(vo.appType)
			{
				case FullShowAppVO.EXE_APP:
					var file:File = new File(vo.appUrl);
					var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
					nativeProcessStartupInfo.executable = file;		
					nativeProcessStartupInfo.arguments = vo.args;
					if(!_process){
						_process = new NativeProcess();
						_process.addEventListener(NativeProcessExitEvent.EXIT,onEXIT);
						_process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR,onIO_ERROR);
					}else{
						_process.exit(true);
					}
					_process.start(nativeProcessStartupInfo);
					break;
				case FullShowAppVO.LOADER_APP:
					_ldr=new Loader();
					_ldr.load(new URLRequest(vo.appUrl));
					_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrLoaded);
					break;
				case FullShowAppVO.HTML_APP:
					_htmlLdr=new HTMLLoader();
					_htmlLdr.paintsDefaultBackground =false;
					_htmlLdr.width=Capabilities.screenResolutionX;
					_htmlLdr.height=Capabilities.screenResolutionY;
					_spCon.addChild(_htmlLdr);
					_htmlLdr.load(new URLRequest(vo.appUrl));
					_htmlLdr.addEventListener(Event.COMPLETE, htmlCompleteHandler);
					break;
				default:
					break;				
			}
			showWindows();
		}
		
		private function onEXIT(event:NativeProcessExitEvent):void
		{
			_process=null;
			closeApp();
		}
		
		/**
		 * 加载应用程序出错，自动关闭
		 * */
		private function onIO_ERROR(event:IOErrorEvent):void
		{
		//	_process=null;
			closeApp();
		}
		
		private function onHideLoading(event:TimerEvent):void
		{
//			_loading.visible=false;
		}
		
		private function onLdrLoaded(event:Event):void
		{
			//if (_ldr.width > 1920 || _ldr.height > 1080) {
			//	_ldr.scaleX=_ldr.scaleY = Math.min(1920 / _ldr.contentLoaderInfo.width, 1080 /_ldr.contentLoaderInfo.height);
			//}
			
			//_ldr.x = (1920 - _ldr.contentLoaderInfo.width*_ldr.scaleX) * 0.5;
			//_ldr.y = (1080 - _ldr.contentLoaderInfo.height*_ldr.scaleY) * 0.5; 
//			_loading.visible=false;
			//			_ldr.scaleX=1920 / _ldr.contentLoaderInfo.width;
			//			_ldr.scaleY =1080 /_ldr.contentLoaderInfo.height;
			_ldr.x=.5*1920 - _ldr.contentLoaderInfo.width*.5;
			_ldr.y=.5*1080 -_ldr.contentLoaderInfo.height*.5;
			_spCon.addChild(_ldr);
			
		}
		
		private function htmlCompleteHandler(event:Event):void
		{
//			_loading.visible=false;
		}
		
		/**
		 * 显示窗口
		 * */
		public function show():void{			
			if(this.active){
				
			}else{
				//this.activate();				
			}
			mainApp.alwaysInFront = false;
			//this.visible = true;
		//	_spCon=new Sprite();
		//	_spCon.graphics.beginFill(0x000000);
			//_spCon.graphics.drawRect(0,0,960,540);
			//_spCon.graphics.endFill();
		
			//this.alwaysInFront=true;
//			if(_closeButtonWin.closed){
//				_closeButtonWin=new ButtonWindow();
//			}
//			_closeButtonWin.activate();
			//_timer.reset();
			//_timer.start();
		}
		
		/**
		 * 隐藏窗口
		 * */
		public function hide():void{			
			if(this.active){
				
			}else{
				this.activate();				
			}
			this.visible = true;				
		}
		
		public function showWindows():void
		{
			if(this.closed)
			{
				this.activate();
				this.alwaysInFront = true;
			}
			mainApp.alwaysInFront = false;
		}
		
		public function hideWindows():void
		{
			//this.visible=false;
			_process.exit(false);
		}
		
		/**
		 * 关闭应用程序
		 */
		public function closeApp():void 
		{		
			if(_process)
			{
				_process.exit(true);
				_process=null;
			}
			if(!this.closed)
			{
				this.close();
			}
			this.dispatchEvent(new Event(Event.CLOSE));
		}
	}
}