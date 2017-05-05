package com.views.components
{
	import com.adobe.images.BMPDecoder;
	import com.models.ApplicationData;
	import com.models.vo.DataVO;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.shoyScreenBtnRes;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeDragEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	public class MinimizeWindow extends Sprite
	{
		private var mainApp:NativeWindow;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _loader:Loader;
		private var _filePath:String="";
		private var _shotScreenBtn:shoyScreenBtnRes;
		private var _saveMedia:SaveMedia;
		private var _shotScreen:ShotScreen;
		private var _softwareTuYa:SoftwareTuYa;
		private var _spBG:Sprite;
		private var _textF:TextField;
		private var _timer:Timer;
		private var _fileBmp:File;
//		private var _alwaysInFrontTimer:Timer;
		
		public function MinimizeWindow()
		{
			mainApp = NativeApplication.nativeApplication.openedWindows[0] as NativeWindow;
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
			
			_textF = new TextField();
			_textF.defaultTextFormat = new TextFormat("YaHei_font",14,0xFF0000);
			_textF.autoSize = "left";
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			
//			_alwaysInFrontTimer = new Timer(1000);
//			_alwaysInFrontTimer.stop();
//			_alwaysInFrontTimer.addEventListener(TimerEvent.TIMER,onAlwaysInFrontTimer);
			onAddStage(null);
		}
		
		private function onAddStage(event:Event):void
		{
			_shotScreenBtn = new shoyScreenBtnRes();
			mainApp.stage.addChild(_shotScreenBtn);
			_shotScreenBtn.addEventListener(MouseEvent.MOUSE_DOWN,onShotScreenBtnDown);
			_saveMedia = new SaveMedia();
			minWindow();
		}
		
		public function maxWindow():void
		{
			ApplicationData.getInstance().closeBtn.visible = true;
			if(mainApp.closed) return;
			NotificationFactory.sendNotification(NotificationIDs.MAX_WINDOW);
//			_alwaysInFrontTimer.stop();
			removeConfigListeners();
			mainApp.alwaysInFront = false;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			_shotScreenBtn.visible = false;
		}
		
		private function onEnterFrame(event:Event):void
		{
			if(mainApp.width<1920)
			{
				mainApp.width+=5;
				mainApp.height+=2.8;
			}else{
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				mainApp.width = 1920;
				mainApp.height = 1080;
			}
		}
		
		public function minWindow():void
		{
			if(mainApp.closed) return;
			mainApp.alwaysInFront = true;
			ApplicationData.getInstance().closeBtn.visible = false;
			_shotScreenBtn.visible = true;
			_shotScreenBtn.x = 1920-_shotScreenBtn.width-50;
			_shotScreenBtn.y = 1080-_shotScreenBtn.height-50;
			configListeners();
		}
		
		private function closeWindow():void
		{
			if(mainApp.closed) return;
			_shotScreenBtn.visible = false;
		}
		
		private function onShotScreenBtnDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = _shotScreenBtn.x;
			_tempY = _shotScreenBtn.y;
			mainApp.stage.addEventListener(MouseEvent.MOUSE_MOVE,onShotScreenMove);
			mainApp.stage.addEventListener(MouseEvent.MOUSE_UP,onShotScreenUP);
		}
		
		private function onShotScreenMove(event:MouseEvent):void
		{
			//_shotScreenBtn.x +=mouseX-_downX;
			//_shotScreenBtn.y +=mouseY-_downY;
			_downX = mouseX;
			_downY = mouseY;
		}
		
		private function onShotScreenUP(event:MouseEvent):void
		{
			mainApp.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onShotScreenMove);
			mainApp.stage.removeEventListener(MouseEvent.MOUSE_UP,onShotScreenUP);
			
			if(Math.abs(_shotScreenBtn.x-_tempX)<5||Math.abs(_shotScreenBtn.y-_tempY)<5)
			{
				trace("是窗口点击",event.target.name);
				if(event.target.name=="btn_0")
				{
					trace("是窗口点击截屏");
					NotificationFactory.sendNotification(NotificationIDs.START_SHOTSCREEN);
					closeWindow();
					Tweener.addTween(_saveMedia,{time:0.2,onComplete:onStartJieTu});
					function onStartJieTu():void
					{
						_saveMedia.startJiePing();
						_saveMedia.addEventListener(Event.CHANGE,onSaveChange);
						_saveMedia.addEventListener(Event.CLOSE,onSaveClose);
						return;
					}
					
				}else if(event.target.name=="btn_1"){
					//trace("窗口全屏")
					if(this.stage.getChildByName("smallBoard"))
					{
						this.stage.getChildByName("smallBoard").visible = true;
					}
					_shotScreenBtn.visible = false;
					maxWindow();
					_saveMedia.dispose();
					return;
				}
			}
		}
		
		private function onSaveChange(e:Event):void
		{
			maxWindow();
		}
		
		private function onSaveClose(e:Event):void
		{
			minWindow();
		}
		
		private function configListeners():void 
		{
			NativeDragManager.acceptDragDrop(this);
			NativeDragManager.dropAction = NativeDragActions.MOVE;
			mainApp.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_DROP, eventHandler); 
			mainApp.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
			mainApp.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_START,onDragStart);
			//this.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
			//trace(this,mainApp.stage,"mainApp.stage");
		}
		
		private function removeConfigListeners():void
		{
			mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_DROP, eventHandler); 
			mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
			mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_START,onDragStart);
		}
		
		private function onDragStart(event:NativeDragEvent):void
		{
			//txt.text = "拖拽开始"
			//trace("拖拽开始")
		}
		
		private function eventHandlerIn(e:NativeDragEvent):void
		{
			NativeDragManager.acceptDragDrop(this);
		}
		
		private function onDragComplete(str:String):void
		{
			//trace("拖入完成",_filePath)
			var vo:MediaVO = new MediaVO();
			vo.type = "."+str.split(".")[1];
			vo.path =str;
			vo.thumb = str;
			vo.globalP = new Point(0,0);
			mainApp.stage.addChild(_textF);
			_textF.text = "文件已载入";
			_textF.x = _shotScreenBtn.x;
			_textF.y = _shotScreenBtn.y;
			AutoOppMedia.setVO(vo);
			_timer.reset();
			_timer.start();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			mainApp.stage.removeChild(_textF);
			mainApp.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
			_timer.stop();
//			minWindow();
		}
		
		private function onAlwaysInFrontTimer(e:TimerEvent):void
		{
			if(!mainApp.closed)
			{
				if(!mainApp.alwaysInFront)
				{
					mainApp.alwaysInFront = true;
				}
			}else{
//				_alwaysInFrontTimer.stop();
			}
		}
		
		private function onSaveMediaEd(e:Event):void
		{
			Tweener.addTween(mainApp,{width:1920,height:1080,x:0,y:0,time:0.5});
			mainApp.x =0;
			mainApp.y =0;
			mainApp.width = 1920;
			mainApp.height = 1080;
			//_softwareTuYa.hide();
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
							//trace("加载拖入的图片000")
						NativeDragManager.acceptDragDrop(this);
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
				openFile(files[i].url)
//				trace(files[i].url,"files[i].url")
			}
		}
		
		private function openFile(str:String):void
		{
			if(str.split(".")[1]=="jpg"||str.split(".")[1]=="JPG"||str.split(".")[1]=="jpeg"||str.split(".")[1]=="JPEG"||str.split(".")[1]=="PNG"||str.split(".")[1]=="png"||str.split(".")[1]=="swf"||str.split(".")[1]=="SWF")
			{
				mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
				Tweener.addTween(this,{time:0.2,delay:0.3,onComplete:moveEnd});
			}else if(str.split(".")[1]=="flv"||str.split(".")[1]=="FLV"){
				mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
				Tweener.addTween(this,{time:0.2,delay:0.3,onComplete:moveEnd});
			}else if(str.split(".")[1]=="bmp"||str.split(".")[1]=="BMP"){
				mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
				//_fileBmp = new File(str);
			//	_fileBmp.load();
			//	_fileBmp.addEventListener(Event.COMPLETE,onFileBmpEnd);
				Tweener.addTween(this,{time:0.2,delay:0.1,onComplete:moveEnd});
			}else{
				mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
				var openFile:File = File.desktopDirectory.resolvePath(str);
				openFile.openWithDefaultApplication();
				Tweener.addTween(this,{time:0.1,delay:0.1,onComplete:moveEnd1});
			}
			function moveEnd():void
			{
				onDragComplete(str);
			}
			
			function moveEnd1():void
			{
				mainApp.stage.addChild(_textF);
				_textF.text = "文件正在打开";
				_textF.x = (195-_textF.textWidth)*0.5;
				_textF.y = (80-_textF.textHeight)*0.5;
				_timer.reset();
				_timer.start();	
			}
		}
		
		private function onFileBmpEnd(e:Event):void
		{
			var bmpDec:BMPDecoder=new BMPDecoder();
			var bit:BitmapData=bmpDec.decode(e.target.data);
			var bmp:Bitmap = new Bitmap(bit)
			//ader.loadBytes(e.target.data);
			bmp.scaleX=bmp.scaleY=Math.min(800/bit.width,600/bit.height);
			bmp.x=(800-bmp.width)*0.5;
			bmp.y=(600-bmp.height)*0.5;
			mainApp.stage.addChild(bmp);
		}
	}
}