package com.lylib.shape
{
	import flash.display.Sprite;
	
	public class Sector extends Sprite
	{
		private var _x0:Number; //圆心横坐标
		private var _y0:Number; //圆心纵坐标
		private var _r:Number; //圆半径
		private var _a0:Number; //起始角度 0度开始顺时针方向
		private var _lineWidth:Number; //线条宽度
		private var _lineColor:Number; //线条颜色
		private var _fillColor:Number; //填充颜色
		public function Sector(x0:Number,y0:Number,r:Number,a0:Number,a:Number,lineWidth:Number=1,lineColor:Number=0xFF0000,fillColor:Number=0xE9A60B){
			_x0 = x0;
			_y0 = y0;
			_r = r;
			_a0 = a0*Math.PI/180;
			_lineWidth = lineWidth;
			_lineColor = lineColor;
			_fillColor = fillColor;
			if(a>0&&a<=360) drawSector(a);
		}
		
		private function drawSector(a:Number):void{
			//this.graphics.lineStyle(_lineWidth,_lineColor);
			this.graphics.beginFill(_fillColor);
			this.graphics.moveTo(_x0,_y0);
			this.graphics.lineTo(_x0+_r*Math.cos(_a0),_y0+_r*Math.sin(_a0)); //曲线绘制起始点
			var n:uint = Math.floor(a/45); //分段绘制接近Bezier曲线的曲线，分段越细，曲线越接近真实圆弧线
			var a0:Number = _a0; //记录初始角度
			while(n-->0){
				a0+=Math.PI/4;
				this.graphics.curveTo(_x0+_r/Math.cos(Math.PI/8)*Math.cos(a0-Math.PI/8),_y0+_r/Math.cos(Math.PI/8)*Math.sin(a0-Math.PI/8),_x0+_r*Math.cos(a0),_y0+_r*Math.sin(a0));
			}
			if(a%45){
				var am:Number = a%45*Math.PI/180;
				this.graphics.curveTo(_x0+_r/Math.cos(am/2)*Math.cos(a0+am/2),_y0+_r/Math.cos(am/2)*Math.sin(a0+am/2),_x0+_r*Math.cos(a0+am),_y0+_r*Math.sin(a0+am));
			}
			this.graphics.lineTo(_x0,_y0);
			this.graphics.endFill();
		}
		public function reDraw(r:Number,a0:Number,a:Number):void{
			if(a>0&&a<=360){
				_r = r;
				_a0 = a0*Math.PI/180;
				this.graphics.clear();
				drawSector(a);
			}
		}
	}
}