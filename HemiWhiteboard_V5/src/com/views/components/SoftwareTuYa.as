package com.views.components
{
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	
	public class SoftwareTuYa extends NativeWindow
	{
		private var _sp:Sprite;
		private var _bg:Sprite;
		private var _graffitiBoard:MessageBoardComponentMouse;
		private var _ldr:Loader;
//		private var _graffitiBoard:MessageBoardComponent;
		
		public function SoftwareTuYa()
		{
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.systemChrome = NativeWindowSystemChrome.NONE;
			winArgs.transparent = true;
			super(winArgs);
			this.alwaysInFront = false;
			this.stage.align = "TL";
			this.stage.scaleMode = "noScale";
			this.addEventListener(Event.CLOSING, onClosing);
			this.width = Capabilities.screenResolutionX;
			this.height = Capabilities.screenResolutionY;
			this.x = 0;
			this.y = 0;
			
			if(this.stage.getChildByName("graffitiBoard")!=null)
			{
				this.stage.removeChild(_graffitiBoard);
			}
			_graffitiBoard = new MessageBoardComponentMouse();
			_graffitiBoard.setWH(ConstData.stageWidth,ConstData.stageHeight);
//			_graffitiBoard.gongNengXuanZhe(false);
			_graffitiBoard.name = "graffitiBoard";
			this.stage.addChild(_graffitiBoard);
				
			_graffitiBoard.addEventListener(Event.CLOSE,onClose);
			_graffitiBoard.addEventListener(Event.CHANGE,onChange);
		}
		
		public function setToolsVis(boo:Boolean):void
		{
			_graffitiBoard.setToolsVis(boo);
		}
		
		public function setBG():void
		{
			if(_ldr==null)
			{
				_ldr = new Loader();
				_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEd);
			}else{
				this.stage.removeChild(_ldr);
				(_ldr.content as Bitmap).bitmapData.dispose();
			}
//			_ldr.load(new URLRequest("D:/jiepin/jiepin.png"));
			_ldr.load(new URLRequest(ApplicationData.getInstance().appPath+"jiepin.png"));
		}
		
		private function onLdrEd(e:Event):void
		{
			trace("加载完成了")
			this.stage.addChildAt(_ldr,0);
		}
		
		private function onClose(event:Event):void
		{
		//	trace("+++++++++++++++++++")
			_graffitiBoard.reset();
			_graffitiBoard.visible = false;
			//hide();
			dispose();
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function clearAll():void
		{
			_graffitiBoard.reset();
			_graffitiBoard.visible = false;
			//this.stage.removeChild(_graffitiBoard);
			hide();
		}
		
		private function onChange(event:Event):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onClosing(evt:Event):void
		{
		//	trace("++++++++++++++++++++++++++++++++")
			evt.preventDefault();
			this.visible=false;
		}
		
		private function onClearBtnClick(e:MouseEvent):void
		{
			hide();
			onClosing(null);
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
		}
		
		/**
		 * 隐藏窗口
		 * */
		public function hide():void{
			if(this.closed)return;
			if(this.active){
				//this.close();
			}else{
				this.activate();				
			}
			this.visible = false;	
		}
		
		public function dispose():void
		{
			if(_ldr)
			{
				_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrEd);
				this.stage.removeChild(_ldr);
				(_ldr.content as Bitmap).bitmapData.dispose();
				_ldr=null;
			}
		}
		
		public function reset():void
		{
			_graffitiBoard.visible = true;
			this.visible = true;	
		}
	}
}