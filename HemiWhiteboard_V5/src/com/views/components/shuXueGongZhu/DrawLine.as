package com.views.components.shuXueGongZhu
{
	import com.models.ApplicationData;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class DrawLine extends Sprite
	{
		private var _line:Shape;
		private var _bmpd:BitmapData;
		
		public function DrawLine()
		{
			_line = new Shape();
			this.addChild(_line);
			
			_bmpd = new BitmapData(1920,1050,true,0);
		}
		
		public function lineTo(x:Number,y:Number):void
		{
//			_line.graphics.clear();
			_line.graphics.lineStyle(5,ApplicationData.getInstance().styleVO.lcolor,1);
			_line.graphics.moveTo(x, y);
		}
		
		public function moveTo(x:Number,y:Number):void
		{
			_line.graphics.lineTo(x, y);
			_bmpd.draw(_line);
		}
		
		public function drawCircle(huduNum:Number):void
		{
			var x1=275+150*Math.cos(huduNum);  //圆最左边的坐标为：（275=425-150，200）,确定圆的位置。
			var y1=200+150*Math.sin(huduNum);  
			_line.graphics.lineTo(x1,y1);  
			_bmpd.draw(_line);
		}
		
		public function clearAll():void
		{
//			_bmpd.dispose();
//			this.removeChild(_line);
			_line.graphics.clear();
		}

		public function get bmpd():BitmapData
		{
			return _bmpd;
		}

			
	}
}