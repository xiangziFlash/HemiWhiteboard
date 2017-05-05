package com.scxlib
{
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	
	public class ShotScreen extends Sprite
	{
		static public const SHOT_COMPLETE:String = "shot_complete";
		private var _file:File;
		private var _nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var _process:NativeProcess;
		private var _shotComplete:Event;
		private var _bitmapData:BitmapData;
		private var _bitmap:Bitmap;
		
		public function ShotScreen()
		{
			_file = File.applicationDirectory.resolvePath("PrintScreen.exe");
			_nativeProcessStartupInfo = new NativeProcessStartupInfo();
			_nativeProcessStartupInfo.executable = _file;
			_process = new NativeProcess();
			
			_shotComplete = new Event(SHOT_COMPLETE);
			
			
			/**var myfile:File = File.applicationDirectory;                    
			myfile = myfile.resolvePath("D:/Program Files/foobar2000/foobar2000.exe"); //指定你需要打开的.exe文件路径            
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();//AIR2.0中的新类, 创建进程的信息对象
			nativeProcessStartupInfo.executable = myfile;// 将你指定的MyFile对象指定为可执行文件
			var yourprocess:NativeProcess = new NativeProcess();// 创建一个本地进程
			yourprocess.start(nativeProcessStartupInfo);// 运行本地进程**/

		}
		
		public function shotScreen():void
		{
			NotificationFactory.sendNotification(NotificationIDs.START_SHOTSCREEN,2);
			this.dispatchEvent(new Event(Event.CLOSE));
			_process.start(_nativeProcessStartupInfo);
			_process.addEventListener(NativeProcessExitEvent.EXIT,onExit); 
		}
		
		private function onExit(event:NativeProcessExitEvent):void
		{
			//trace(Clipboard.generalClipboard.,"++++") 
			//if (Clipboard.generalClipboard.hasFormat(ClipboardFormats.BITMAP_FORMAT))
			//{trace("执行了这里")
				_bitmapData = Clipboard.generalClipboard.getData(ClipboardFormats.BITMAP_FORMAT) as BitmapData;
				_bitmap = new Bitmap(_bitmapData);
				dispatchEvent(_shotComplete);
//				trace("截图完成事件派发")
			//}
		}
		
		public function get bitmapData():BitmapData
		{
			return _bitmapData as BitmapData;
		}
	}
}