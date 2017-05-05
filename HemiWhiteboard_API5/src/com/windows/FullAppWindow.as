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
	import flash.events.NativeProcessExitEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.html.HTMLLoader;
	import flash.media.SoundMixer;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class FullAppWindow extends NativeWindow
	{
		private var _spCon:Sprite;
		private var _closeButtonWin:CloseButtonWindow;
		private var _process:NativeProcess;//应用程序
		private var _ldr:Loader;//普通Loader加载器
		private var _htmlLdr:HTMLLoader;
		private var _loading:FullShowAppLoadingRes;
		private var _timer:Timer;
		private var _tiShiKuang:ShotScreenTiShiRes;
		
		
		public function FullAppWindow()
		{
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.systemChrome = NativeWindowSystemChrome.NONE;
			winArgs.transparent = false;
			super(winArgs);
			this.alwaysInFront = false;
			this.stage.align = "TL";
			this.stage.scaleMode = "noScale";
			this.addEventListener(Event.CLOSING, onClosing);
			this.width = Capabilities.screenResolutionX;
			this.height = Capabilities.screenResolutionY;
			this.x = 0;
			this.y = 0;
			_spCon=new Sprite();
			_spCon.graphics.beginFill(0x000000,0);
			_spCon.graphics.drawRect(0,0,100,100);
			_spCon.graphics.endFill();
			_loading=new FullShowAppLoadingRes();	
			
			
			this.stage.addChild(_loading);
			this.stage.addChild(_spCon);
			
			
			_timer = new Timer(10000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
			
			_closeButtonWin=new CloseButtonWindow();
			_closeButtonWin.x = 1780;
			_closeButtonWin.y = 1005;
			_closeButtonWin.addEventListener(Event.CLOSE,onCloseAll);
			_closeButtonWin.addEventListener(Event.COMPLETE,onCom);
		}
		
		private function onCom(event:Event):void
		{
		//	trace("onComonComonComonComonCom");
			//_tiShiKuang.visible = true;
			setTimeout(function ():void
			{
				//_tiShiKuang.visible = false;
			},2000);
		}
		/**
		 * 
		 * 打开一个应用
		 * */
		public function openApp(vo:FullShowAppVO):void
		{			
			var pattern:RegExp = /\\/g;
			vo.appUrl = vo.appUrl.replace(pattern, "/");
			switch(vo.appType)
			{
				case FullShowAppVO.EXE_APP:
					var file:File = new File(vo.appUrl);
					//file = new File("c:\windows\system32\ping.exe");
					var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
					nativeProcessStartupInfo.executable = file;		
					nativeProcessStartupInfo.arguments = vo.args;
					if(!_process){
						_process = new NativeProcess();
					}else{
						_process.exit(true);
					}
					_process.addEventListener(NativeProcessExitEvent.EXIT,onEXIT);
					_process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR,onIO_ERROR);
					_process.start(nativeProcessStartupInfo);				
					var time:Timer=new Timer(5*1000,1);
					time.addEventListener(TimerEvent.TIMER,onHideLoading);
					time.start();
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
			show();
		}
		
		public function hideBackBtn():void
		{
			_closeButtonWin.hideBackBtn();
		}
		/**
		 * 加载应用程序出错，自动关闭
		 * */
		private function onIO_ERROR(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			_process=null;
			closeApp();
		}
		
		private function onHideLoading(event:TimerEvent):void
		{
			// TODO Auto-generated method stub
			_loading.visible=false;
		}
		
		private function onLdrLoaded(event:Event):void
		{
			//if (_ldr.width > 1920 || _ldr.height > 1080) {
			//	_ldr.scaleX=_ldr.scaleY = Math.min(1920 / _ldr.contentLoaderInfo.width, 1080 /_ldr.contentLoaderInfo.height);
			//}
			
			//_ldr.x = (1920 - _ldr.contentLoaderInfo.width*_ldr.scaleX) * 0.5;
			//_ldr.y = (1080 - _ldr.contentLoaderInfo.height*_ldr.scaleY) * 0.5; 
			_loading.visible=false;
//			_ldr.scaleX=1920 / _ldr.contentLoaderInfo.width;
//			_ldr.scaleY =1080 /_ldr.contentLoaderInfo.height;
			_ldr.x=.5*1920 - _ldr.contentLoaderInfo.width*.5;
			_ldr.y=.5*1080 -_ldr.contentLoaderInfo.height*.5;
			_spCon.addChild(_ldr);
			
		}
		
		private function htmlCompleteHandler(event:Event):void
		{
			// TODO Auto-generated method stub
			_loading.visible=false;
		}
		
		private function onClosing(evt:Event):void{
			evt.preventDefault();
			this.visible=false;
		}
		
		/**
		 * 显示窗口
		 * */
		public function show():void{			
			if(this.active){
				
			}else{
				this.activate();				
			}
			this.visible = true;		
			//this.alwaysInFront=true;
			if(_closeButtonWin.closed){
				_closeButtonWin=new CloseButtonWindow();
			}
			_closeButtonWin.activate();
			_timer.reset();
			_timer.start();
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
		
		private function onTimer(e:TimerEvent):void
		{
			if(!_closeButtonWin.closed){
				_closeButtonWin.activate();
			}
			_timer.stop();
		}
		
		private function onCloseAll(event:Event):void
		{
			
			_loading.visible=false;
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
		
		private function onEXIT(event:NativeProcessExitEvent):void
		{
			// TODO Auto-generated method stub
			_process=null;
			closeApp();
		}
		/**
		 * 关闭应用程序
		 */
		private function closeApp():void 
		{			
//			var windows:Array = NativeApplication.nativeApplication.openedWindows;
//			var len:int=windows.length;
//			for(var i:int=1;i<len;i++){
//				windows[i].close();
//			}
			if(!_closeButtonWin.closed)
			{
				_closeButtonWin.close();
			}
			
			if(!this.closed)
			{
				this.close();
			}
		}
	}
}