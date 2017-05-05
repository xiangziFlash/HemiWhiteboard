package com.lylib.shape
{
	import flash.display.Sprite;
	
	public class Ball extends Sprite
	{
		public function Ball(r:Number, color:uint = 0xff0000)
		{
			this.graphics.beginFill(color);
			this.graphics.drawCircle( 0 , 0 , r );
			this.graphics.endFill();
		}
	}
}