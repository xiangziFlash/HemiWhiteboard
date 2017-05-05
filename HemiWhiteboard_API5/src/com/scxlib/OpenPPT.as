package com.scxlib
{
	import com.models.ApplicationData;
	import com.models.ConstData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-12-29 上午10:07:54
	 * 
	 */
	public class OpenPPT extends Sprite
	{
		private static var _targetFile:File;
		public function OpenPPT()
		{
			
		}
		
		public static function setPath(path:String):void
		{
			var file:File = new File(path);
			_targetFile = new File(ApplicationData.getInstance().httpAssets+ConstData.dateFile+"/"+file.name.split(".")[0]+".pps");
			file.copyToAsync(_targetFile, true);
			file.addEventListener(Event.COMPLETE, onCopyComplete);
		}
		
		private static function onCopyComplete(event:Event):void
		{
			_targetFile.openWithDefaultApplication();
			_targetFile.addEventListener(Event.COMPLETE,onTargetFileCom);
		}
		
		private static function onTargetFileCom(event:Event):void
		{
			
		}
	}
}