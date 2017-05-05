package com.lylib.shape
{
	import flash.display.Sprite;
	
	public class Rect extends Sprite
	{
		public function Rect(width:Number, height:Number, color:uint=0xff0000, alpha:Number=1)
		{
			this.graphics.beginFill(color, alpha);
			this.graphics.drawRect(0,0,width,height);
			this.graphics.endFill();
		}
	}
}