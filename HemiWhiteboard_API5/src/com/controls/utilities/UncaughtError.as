package com.controls.utilities 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.UncaughtErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * 检测全局程序异常，错误信息会存入到该程序的专属文件夹内
	 * 
	 * ↓↓↓↓↓↓↓↓↓↓↓↓↓使用说明↓↓↓↓↓↓↓↓↓↓↓↓↓
	 * this.addChild(new UncaughtError());  //必须在主类中声明并添加到舞台   air2.0以上版本才能使用
	 * ↑↑↑↑↑↑↑↑↑↑↑↑↑使用说明↑↑↑↑↑↑↑↑↑↑↑↑↑
	 * 
	 * 1.01  新增加错误代码所在位置，stackTrace节点内存储   仅可在adl环境下使用
	 * 
	 * version 1.01  2012/11/30
	 * @author wang
	 */
	public class UncaughtError extends Sprite
	{
		private var _xml:XML=<data></data>;
		public function UncaughtError() 
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE, onADDED_TO_STAGE);
		}
		
		private function onADDED_TO_STAGE(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onADDED_TO_STAGE);
			this.parent.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,onTTDError);
		}
		private function  onTTDError(e:UncaughtErrorEvent):void{
            //trace("检测全局程序异常",e.errorID,e.error,e.text,e.type,e.error.getStackTrace(),e.error.message);
              
            //var  f:File = new File(File.documentsDirectory.resolvePath("tita/error.txt").nativePath);
			var date:Date = new Date();
			var error:XML =<error></error>;
			error.@errorID = e.error.errorID;
			error.@type = e.error.type;
			error.@time = date.fullYear+"/"+(date.month+1)+"/"+date.date+"  "+date.hours+":"+date.minutes+":"+date.seconds;
			error.text = e.error.text;
			error.error = e.error;			
			error.stackTrace = e.error.getStackTrace();			
			_xml.appendChild(error);
			
			var file:File=File.applicationDirectory;			
			var path:String=file.nativePath+"/";
			var pattern:RegExp = /\\/g;
			path = path.replace(pattern, "/");//软件根目录
			saveUTFString(_xml.toXMLString(), path + "程序错误.xml");
        }
		
		private function saveUTFString(str:String, fileName:String):void
		{
			var pattern:RegExp = /\n/g;
			str=str.replace(pattern, "\r\n");
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
		}
	}

}