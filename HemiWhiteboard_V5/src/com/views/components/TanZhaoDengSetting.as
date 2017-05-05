package com.views.components
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TanZhaoDengSetting extends Sprite
	{
		private var _res:TZDSettingRes;
		private var _downX:Number;
		private var _alphaID:Number=0;
		private var _modelID:int;
		
		public function TanZhaoDengSetting()
		{
			_res = new TZDSettingRes();
			
			this.addChild(_res);
			reset();
			_res.addEventListener(MouseEvent.CLICK,onResClick);
			_res.setting.bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarDown);
		}
		
		public function get modelID():int
		{
			return _modelID;
		}

		public function get alphaID():Number
		{
			return _alphaID;
		}

		private function onResClick(event:MouseEvent):void
		{
			switch(event.target.name)
			{
				case "closeBtn":
				{
					this.dispatchEvent(new Event(Event.CLOSE));
					break;
				}
					
				case "shapeBtn":
				{//方框和圆的切换
					if((event.target as MovieClip).currentFrame==1)
					{
						(event.target as MovieClip).gotoAndStop(2);
						_modelID = 2;
					}else{
						(event.target as MovieClip).gotoAndStop(1);
						_modelID = 1;
					}
					this.dispatchEvent(new Event(Event.CANCEL));
					break;
				}
					
				case "setBtn":
				{
					if(_res.setting.visible)
					{
						_res.setting.visible = false
					}else{
						_res.setting.visible = true;
					}
					break;
				}
			}
		}
		
		private function onBarDown(e:MouseEvent):void
		{
			_downX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBarUp);
		}
		
		private function onBarMove(event:MouseEvent):void
		{
			_res.setting.bar.x += mouseX-_downX;
			_downX = mouseX;
			if(_res.setting.bar.x<38.4)
			{
				_res.setting.bar.x=38.4;
			}
			if(_res.setting.bar.x>137.15)
			{
				_res.setting.bar.x = 137.15;
			}
			
			_alphaID = (((_res.setting.bar.x-38.4)/100)*10)/10;
//			trace(_alphaID,"_alphaID");
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onBarUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBarUp);
		}
		
		public function reset():void
		{
			_modelID = 1;
			_res.setting.bar.x = 137.15;
			_res.shapeBtn.gotoAndStop(1);
			_res.setting.visible = false;
			_res.setting.bar.gotoAndStop(1);
			_res.shapeBtn.mouseChildren = false;
			_res.setBtn.mouseChildren = false;
			_res.closeBtn.mouseChildren = false;
		}
	}
}