package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.vo.FullShowAppVO;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.StatusEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.LocalConnection;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import mx.utils.object_proxy;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-16 下午5:06:33
	 * 
	 */
	public class SaveLocalImage extends Sprite
	{
		private var _conn:Object;
		private var _process:NativeProcess;
		private var _fileName:String;
		private var _timer:Timer;
		private var _saveFile:File;
		public function SaveLocalImage()
		{
			initViews();
		}
		
		public function  initViews():void
		{
			setLocalConnection();
			
			/*var vo:FullShowAppVO = new FullShowAppVO();
			vo.appType = FullShowAppVO.EXE_APP;
			vo.appUrl = ApplicationData.getInstance().appPath+"assets/tool/SaveImage/SaveImage.exe";
			openTool(vo);*/
			
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.reset();
			_timer.stop();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			_saveFile = new File(_fileName);
			if(_saveFile == null)return;
			if(_saveFile.exists)
			{
				trace("saveEND");
				this.dispatchEvent(new Event(Event.COMPLETE));
				_fileName = "";
				_saveFile = null;
				_timer.stop();
			}
		}
		
		private function openTool(vo:FullShowAppVO):void
		{
			var file:File = new File(vo.appUrl);
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = file;		
			nativeProcessStartupInfo.arguments = vo.args;
			if(!_process){
				_process = new NativeProcess();
				_process.addEventListener(NativeProcessExitEvent.EXIT,onEXIT);
				_process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR,onIO_ERROR);
				_process.start(nativeProcessStartupInfo);	
			}
			
			setTimeout(function():void
			{
				var date:Date = new Date();
				_fileName = ApplicationData.getInstance().appPath + "votes/"+String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds)+".png";
				_conn.send("app#SaveImage:whiteBoard", "chuangJianFile", _fileName);
				_saveFile = new File(_fileName);
				_timer.reset();
				_timer.start();
			},1000);
		}
		
		public function saveBmpd(bmpd:BitmapData,path:String,isCom:Boolean = true):void
		{
			Clipboard.generalClipboard.setData(ClipboardFormats.BITMAP_FORMAT, bmpd);
			_fileName = path;
			
			setTimeout(function():void
			{
				_conn.send("app#SaveImage:whiteBoard", "chuangJianFile",_fileName);
				if(!isCom)return;
				_saveFile = new File(_fileName);
				_timer.reset();
				_timer.start();
			},1000);
		}
		
		public function fileSaveComplete(string:String):void
		{
			trace("fileSaveComplete");
		}
		
		
		
		private function onEXIT(event:NativeProcessExitEvent):void
		{
			_process=null;
		}
		
		public function closeProcess():void
		{
			if(_process)
			{
				_process.exit();
				_process=null;
			}
		}
		
		/**
		 * 加载应用程序出错，自动关闭
		 * */
		private function onIO_ERROR(event:IOErrorEvent):void
		{
			_process=null;
		}
		
		private function setLocalConnection():void
		{
			_conn=new LocalConnection();
			_conn.client = this;
			_conn.allowDomain('app#SaveImage');
			try {
				_conn.connect("saveImage");
			} catch (error:ArgumentError) {
				trace("Can't connect...the connection name is already being used by another SWF");
			}
			_conn.addEventListener(StatusEvent.STATUS, onStatus);
			
			/*conn = new LocalConnection();
			conn.client = this;
			conn.allowDomain('app#HemiWhiteboard.V4');
			try {
				conn.connect("whiteBoard");
			} catch (error:ArgumentError) {
				trace("Can't connect...the connection name is already being used by another SWF");
			}*/
		}
		
		private function onStatus(event:StatusEvent):void {
			switch (event.level) {
				case "status":
					trace("LocalConnection.send() succeeded----1");
					break;
				case "error":
					trace("LocalConnection.send() failed----1");
					break;
			}
		}

		public function get fileName():String
		{
			return _fileName;
		}

	}
}