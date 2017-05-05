package com.views.components
{
	import com.models.ApplicationData;
	import com.models.ConstData;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-12-30 下午2:38:20
	 * 
	 */
	public class CustomBackground extends Sprite
	{
		private static var _targetFile:File;
		public function CustomBackground()
		{
			
		}
		
		public static function addBackground(file:File):void
		{
			_targetFile = new File(ApplicationData.getInstance().appPath+"assets/backGround/"+(ConstData.bgs.length+1)+".png");
			file.copyToAsync(_targetFile, true);
			file.addEventListener(Event.COMPLETE, onCopyComplete);
		}
		
		private static function onCopyComplete(event:Event):void
		{
			trace("onCopyComplete---")
		}
	}
}