package com.views.components
{
	import com.models.vo.DataVO;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeDragActions;
	import flash.desktop.NativeDragManager;
	import flash.display.Bitmap;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.net.FileFilter;
	
	public class OpenLocalFile extends Sprite
	{
		private var _file:File;
		private var _filePath:String;
		private var mainApp:NativeWindow;
		
		public function OpenLocalFile()
		{
			_file = new File();
			_file.addEventListener(Event.SELECT,onFileSelect);
			_file.addEventListener(Event.CANCEL,onFileCancel);
			_file.addEventListener(Event.OPEN,onFileOpen);
		}
		
		public function browseForOpen():void
		{
			_file.browseForOpen("会议白板素材导入");
			mainApp = NativeApplication.nativeApplication.openedWindows[0] as NativeWindow;
			configListeners();
		}
		
		/**
		 * 选择文件完成后 用系统默认程序打开该文件
		 * */
		private function onFileSelect(event:Event):void
		{
			var openFile:File = File.desktopDirectory.resolvePath(_file.nativePath);
			openFile.openWithDefaultApplication();
			openFile.addEventListener(Event.COMPLETE,onOpenFileEd);
			//this.dispatchEvent(new Event(Event.SELECT));
//			var minWin:MinimizeWindow = new MinimizeWindow();
			NotificationFactory.sendNotification(NotificationIDs.MINI_WINDOWN);
			removeConfigListeners();
		}
		
		private function onFileCancel(e:Event):void
		{
//			trace("onFileCancel")
			removeConfigListeners();
		}
		
		private function onFileOpen(e:Event):void
		{
//			trace("onFileOpen")
			removeConfigListeners();
		}
		
		private function onOpenFileEd(e:Event):void
		{
			trace("文件打开准备截屏");
			//this.dispatchEvent(new ImageDargEvent(ImageDargEvent.SHOT_SCREEN));
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
//			trace("拖拽开始")
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
						case ".gif":
						case ".GIF":
						case ".png":
						case ".PNG":
//							trace("NATIVE_DRAG_ENTER")
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
						case ".jpg":
						case ".JPG":
						case ".jpeg":
						case ".JPEG":
						case ".gif":
						case ".GIF":
						case ".png":
						case ".PNG":
							//删除上一张加载的图片
							//_loader.unload();
							//加载拖入的图片
//							trace("NATIVE_DRAG_DROP")
							//	_loader.load(new URLRequest(file.url));
							//mainApp.stage.addChild(_loader);
							break;
					}
					break;
			}
			_filePath = file.url;
			if(_filePath.split(".")[1]=="jpg"||_filePath.split(".")[1]=="JPG"||_filePath.split(".")[1]=="jpeg"||_filePath.split(".")[1]=="JPEG"||_filePath.split(".")[1]=="PNG"||_filePath.split(".")[1]=="png")
			{
				mainApp.stage.removeEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
				Tweener.addTween(this,{time:0.2,delay:0.3,onComplete:moveEnd});
			}
			function moveEnd():void
			{
				onDragComplete(null);
				mainApp.stage.addEventListener(NativeDragEvent.NATIVE_DRAG_ENTER, eventHandler);
			}
		}
		
		private function onDragComplete(event:NativeDragEvent):void
		{
//			trace("拖入完成")
			var vo:MediaVO = new MediaVO();
			vo.type = _filePath.split(".")[1];
			vo.path = _filePath;
			vo.thumb = _filePath;
			vo.globalP = new Point(1920*0.5,1080*0.5);
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,vo);
		}
	}
}