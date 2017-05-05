package com.lylib.shape
{
	import flash.display.Sprite;
	
	/**
	 * 箭头
	 * @author Administrator
	 * 
	 */	
	public class Arrow extends Sprite
	{
		public function Arrow()
		{
			graphics.lineStyle(1,0,1); 
			graphics.beginFill(0xffff00); 
			graphics.moveTo(-50,-25); 
			graphics.lineTo(0,-25); 
			graphics.lineTo(0,-50); 
			graphics.lineTo(50,0); 
			graphics.lineTo(0,50); 
			graphics.lineTo(0,25); 
			graphics.lineTo(-50,25); 
			graphics.lineTo(-50,-25); 
			graphics.endFill();
		}
	}
}