package com.views.components
{
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	
	public class ZhuCePath extends Sprite
	{
		private var _file:File;
		private var _savPath:String;
		
		public function ZhuCePath()
		{
			//_file = new File("C:/Windows/System32/hy.reg");
			var fil:File=File.applicationStorageDirectory;			
			_savPath=fil.nativePath+"/";
			var pattern:RegExp = /\\/g;
			_savPath = _savPath.replace(pattern, "/");
			_savPath=_savPath.split("Education")[0];
			_file = new File(_savPath+"registerV1/Local Store/hy.regi");
			//trace(_file.exists,"_file.exists");
			if(_file.exists)
			{
				trace("检测通过")	
			}else{
				closeApp();
			}
			_file.addEventListener(IOErrorEvent.IO_ERROR,onFileError);
		}
		
		private function onFileError(event:IOErrorEvent):void
		{
			trace("加载文件出错")
		}
		
		private function closeApp():void
		{
			var windows:Array=NativeApplication.nativeApplication.openedWindows;
			var len:int=windows.length;
			for(var i:int=0;i<len;i++){
				windows[i].close();
			}
		}
	}
}