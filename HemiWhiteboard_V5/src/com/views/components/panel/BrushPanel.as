package com.views.components.panel
{
	import com.events.ChangeEvent;
	import com.models.ApplicationData;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osmf.events.TimeEvent;
	
	public class BrushPanel extends Sprite
	{
		private var _brush:BrushPanelRes;
		private var _tempBtn:MovieClip;
		private var _brushID:int=1;
		private var _downY:Number;
		private var _thiness:int=5;
		
		public function BrushPanel()
		{
			_brush = new BrushPanelRes();
			this.addChild(_brush);
			reset();
			initListener();
		}
		
		private function initListener():void
		{
			_brush.addEventListener(MouseEvent.CLICK,onBrushClick);
			_brush.bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarDown);
		}
		
		private function onBrushClick(e:MouseEvent):void
		{
			if(e.target.name.split("_")[0]!="btn")return;
			_brushID = e.target.name.split("_")[1];
			if(_tempBtn)
			{
				_tempBtn.gotoAndStop(1);
			}
			
			_tempBtn = e.target as MovieClip;
			_tempBtn.gotoAndStop(2);
			ApplicationData.getInstance().styleVO.isCir = false;
			ApplicationData.getInstance().styleVO.isEraser = false;
			ApplicationData.getInstance().styleVO.lineStyle = _brushID;
			var eve:ChangeEvent = new ChangeEvent(ChangeEvent.CHANGE_END);
			eve.id = _brushID;
			this.dispatchEvent(eve);
		}
		
		public function setBrush(id:int,thiness:int):void
		{
			if(_tempBtn)
			{
				_tempBtn.gotoAndStop(1);
			}
			
			_tempBtn = _brush["btn_"+(id)] as MovieClip;
			_tempBtn.gotoAndStop(2);
			_thiness = thiness;
//			_thiness = int(_brush.bar.y/130*18);
			_brush.bar.y = _thiness/18*130;
			_brush.bar.TT.text = _thiness;
		}
		
		private function onBarDown(e:MouseEvent):void
		{
			_downY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBarUp);
		}
		
		private function onBarMove(event:MouseEvent):void
		{
			_brush.bar.y += mouseY-_downY;
			_downY = mouseY;
			if(_brush.bar.y<12)
			{
				_brush.bar.y = 12;
			}
			
			if(_brush.bar.y>146)
			{
				_brush.bar.y = 146;
			}
		}
		
		private function onBarUp(event:MouseEvent):void
		{
			_thiness = int(_brush.bar.y/130*18);
			_brush.bar.TT.text = _thiness;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBarUp);
			
			ApplicationData.getInstance().styleVO.isCir = false;
			ApplicationData.getInstance().styleVO.isEraser = false;
			ApplicationData.getInstance().styleVO.lineThickness = _thiness;
		}
		
		public function reset():void
		{
			if(_tempBtn)
			{
				_tempBtn.gotoAndStop(1);
			}
			_tempBtn = _brush.btn_1;
			_tempBtn.gotoAndStop(2);
			_brush.bar.y = 5/18*130;
			_brush.bar.TT.text = 5;
			ApplicationData.getInstance().styleVO.lineStyle = 1;
			ApplicationData.getInstance().styleVO.lineThickness = 5;
		}

		public function get brushID():int
		{
			return _brushID;
		}

		public function get thiness():int
		{
			return _thiness;
		}


	}
}