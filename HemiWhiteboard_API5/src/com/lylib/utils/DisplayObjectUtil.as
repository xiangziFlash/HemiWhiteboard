package com.lylib.utils
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DisplayObjectUtil
	{
		public function DisplayObjectUtil()
		{
		}
		
		/**
		 * 移除容器内所有对象
		 * @param container
		 */		
		public static function removeAllChildren(container:DisplayObjectContainer):void{
			while(container.numChildren>0){
				container.removeChildAt(0);
			}
		}
		
		
	}
}