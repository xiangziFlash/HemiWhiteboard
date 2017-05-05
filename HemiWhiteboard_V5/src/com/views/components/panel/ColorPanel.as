package com.views.components.panel
{
	import com.models.ApplicationData;
	
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class ColorPanel extends Sprite
	{
		private var _colorPlaneRes:ColorPlaneRes;
		private var _currColor:uint;//彩色调色板选中的当前颜色值
		private var _multiColorBmpd:BitmapData = new BitmapData(204,135,true,0);
		private var _gradientBmpd:BitmapData = new BitmapData(135,23,true,0);
		private var _ct:ColorTransform = new ColorTransform();
		private var _gradientBar:MovieClip;
		private var _prevColor:uint;//彩色调色板选中前颜色值
		private var _prevCt:ColorTransform = new ColorTransform();
		
		public function ColorPanel()
		{
			initContet();
		}
		
		private function initContet():void
		{
			_colorPlaneRes = new ColorPlaneRes();
			this.addChild(_colorPlaneRes);
			_multiColorBmpd.draw(_colorPlaneRes.multiColorPanel);
			
			_gradientBar = new MovieClip();
			_gradientBar.rotation= 90;
			_gradientBar.x = 242;
			_gradientBar.y = 8.5;
			_gradientBar.name = "gradientBar";
			_colorPlaneRes.addChild(_gradientBar);
			grandientFill([0xffffff,0xffffff,0x000000]);
			_colorPlaneRes.addEventListener(MouseEvent.CLICK,onColorPlaneClick);
		}
		
		private function onColorPlaneClick(e:MouseEvent):void
		{
			var mc:MovieClip = e.target as MovieClip;
			if(mc.name == "multiColorPanel"){
				_prevColor  = _currColor;
				_currColor = _multiColorBmpd.getPixel(mc.mouseX,mc.mouseY);
				_ct.color = _currColor;
				_prevCt.color = _prevColor;
				_colorPlaneRes.colorShow.currColor.transform.colorTransform = _ct;
				_colorPlaneRes.colorShow.panelColor.transform.colorTransform = _prevCt;
				var cols:Array = [0xffffff,_currColor,0x000000];
				grandientFill(cols);
				ApplicationData.getInstance().styleVO.lcolor = _currColor;
				//sendNotification(ToolNotificationIDs.SELECT_COLOR,_currColor);
			}else if(mc.name == "ok"){
				ApplicationData.getInstance().styleVO.lcolor = _currColor;
				this.dispatchEvent(new Event(Event.CLOSE));
			}else if(mc.name == "cancel"){
				this.dispatchEvent(new Event(Event.CLOSE));
			}else if(mc.name == "gradientBar"){
				_gradientBmpd.draw(mc);
				_prevColor  = _currColor;
				_currColor = _gradientBmpd.getPixel(mc.mouseX,mc.mouseY);
				_ct.color = _currColor;
				_prevCt.color = _prevColor;
				_colorPlaneRes.colorShow.currColor.transform.colorTransform = _ct;
				_colorPlaneRes.colorShow.panelColor.transform.colorTransform = _prevCt;
				ApplicationData.getInstance().styleVO.lcolor = _currColor;
			}else if(mc.name == "currColor")
			{
				ApplicationData.getInstance().styleVO.lcolor = _currColor;
			}else if(mc.name == "panelColor")
			{
				ApplicationData.getInstance().styleVO.lcolor = _prevColor;
			}
		}
		
		private function grandientFill(cols:Array):void
		{
			var alphas:Array = [1,1,1];
			var rats:Array = [0,125, 255];
			var matr:Matrix = new Matrix();
			matr.createGradientBox(134, 23, 0, 0, 0);
			_gradientBar.graphics.clear();
			_gradientBar.graphics.beginGradientFill(GradientType.LINEAR,cols,alphas,rats,matr); //渐变填充颜色
			_gradientBar.graphics.drawRoundRect(0,0,135,23,10,10); //绘制矩形
			_gradientBar.graphics.endFill();
		}
	}
}