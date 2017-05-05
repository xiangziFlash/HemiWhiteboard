package com.views.components
{
	import com.models.ConstData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TanZhaoDeng extends Sprite
	{
		private var _bmpd:BitmapData;
		private var _bmp:Bitmap;
		private var _dengKuang:TanZhaoDengKuang;
		private var _bg:Sprite;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _res:DengBianRes;
		private var _res1:DengBianRes;
		
		private var _setting:TanZhaoDengSetting;
		private var _isCircle:Boolean = true;
		private var _frameID:int;
		
		public function TanZhaoDeng()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function onAddStage(event:Event):void
		{
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_dengKuang = new TanZhaoDengKuang();
			_dengKuang.x = 1920*0.5;
			_dengKuang.y = 1080*0.5;
			
			_bmpd = new BitmapData(1920,1080,true,0);
			_bmp = new Bitmap(_bmpd);
			
			_bg = new Sprite();
			_bg.graphics.beginFill(0,1);
			_bg.graphics.drawRect(0,0,1920,1080);
			
			_bg.graphics.drawCircle(_dengKuang.x,_dengKuang.y,_dengKuang.stageW/2);
			_bg.graphics.endFill();
			
			_setting = new TanZhaoDengSetting();
			_setting.x = _dengKuang.x + _dengKuang.width*0.5+10;
			_setting.y = _dengKuang.y;
			this.addChild(_bg);
			this.addChild(_bmp);
			this.addChild(_dengKuang);
			this.addChild(_setting);
			_bmp.mask = _dengKuang.inCircle;
		}
		
		private function initListener():void
		{
			_dengKuang.addEventListener(TanZhaoDengKuang.TouchBeginEvent,touchBegin);
			_dengKuang.addEventListener(TanZhaoDengKuang.TouchEndEvent,touchEnd);
			_dengKuang.addEventListener(TanZhaoDengKuang.TouchMoveEvent,touchMove);
//			_res.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_setting.addEventListener(Event.CHANGE,onSettingChange);
			_setting.addEventListener(Event.CLOSE,onSettingClose);
			//方块和圆形 探照灯的切换
			_setting.addEventListener(Event.CANCEL,onSettingCancel);
		}
		
		private function onFrame(event:Event):void
		{
			_frameID++
			gengXingSettingXY();
			if(_frameID>10)
			{
				_frameID = 0;
				this.removeEventListener(Event.ENTER_FRAME,onFrame);
			}
		}
		
		private function onSettingClose(event:Event):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onDown(event:MouseEvent):void
		{
			this.visible = false;
			_bmpd.draw(stage);
			this.visible = true;
			_res.startDrag();
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
			
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,1);
			_bg.graphics.drawRect(0,0,1920,1080);
			_bmp.visible=true;
		}
		
		private function onMove(event:MouseEvent):void
		{

		}
		
		private function onUp(event:MouseEvent):void
		{
			_res.stopDrag();
			_bg.graphics.drawCircle(_res.x,_res.y,_res.width/2);
			_bg.graphics.endFill();
			_bmp.visible=false;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		public function openTanZhaoDeng():void
		{
			_setting.visible = false;
			this.visible = false;
			_bmpd.draw(stage);
			_setting.visible = true;
			this.visible = true;
			_setting.reset();
			_dengKuang.changeModel(1);
			reset();
			
			_bg.alpha = 1;
		}
		
		private function touchBegin(e:Event):void
		{
			_setting.visible = false;
			this.visible = false;
			_bmpd.draw(stage);
			this.visible = true;
			_bmp.visible=true;
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,1);
			_bg.graphics.drawRect(0,0,1920,1080);
//			_setting.visible = false;
		}
		
		private function touchEnd(e:Event):void
		{
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME,onFrame);
			}
		}
		
		private function touchMove(e:Event):void
		{
			//gengXingSettingXY();
			_setting.visible = false;
		}
		
		private function onSettingChange(e:Event):void
		{
			_bg.alpha = _setting.alphaID;
		}
		
		/**
		 *更新设置按钮的XY值 
		 */		
		private function gengXingSettingXY():void
		{
//			_setting.x = _dengKuang.x + _dengKuang.stageW*0.5+10;
			_setting.visible = true;
			_setting.x = _dengKuang.transform.pixelBounds.right/ConstData.stageScaleX+10;
			_setting.y = _dengKuang.y;
		}
		/**
		 * 
		 * @param e
		 * 探照灯 圆形和方形的切换
		 */		
		private function onSettingCancel(e:Event):void
		{
			_dengKuang.changeModel(_setting.modelID);
//			trace(_setting.modelID,"_setting.modelID")
			if(_setting.modelID==1)
			{//trace("画圆");
				_isCircle = true;
				_bg.graphics.beginFill(0,1);
				_bg.graphics.drawRect(0,0,1920,1080);
				
				_bg.graphics.drawCircle(_dengKuang.x,_dengKuang.y,_dengKuang.stageW/2);
				_bg.graphics.endFill();
			}else{//trace("画矩形");
				_isCircle = false;
				_bg.graphics.beginFill(0,1);
				_bg.graphics.drawRect(0,0,1920,1080);
				
//				_bg.graphics.drawRect(_dengKuang.x,_dengKuang.y,_dengKuang.stageW,_dengKuang.stageW);
				_bg.graphics.drawRoundRect(_dengKuang.x,_dengKuang.y,_dengKuang.stageW,_dengKuang.stageW,10);
				_bg.graphics.endFill();
			}
			_bmp.mask = _dengKuang.inCircle;
		}
		
		private function reset():void
		{
			_dengKuang.scaleX = _dengKuang.scaleY = 1;
			_dengKuang.x = 1920*0.5;
			_dengKuang.y = 1080*0.5;
			_isCircle = true;
			_bg.graphics.beginFill(0,1);
			_bg.graphics.drawRect(0,0,1920,1080);
			
			_bg.graphics.drawCircle(_dengKuang.x,_dengKuang.y,_dengKuang.stageW/2);
			_bg.graphics.endFill();
			_bmp.mask = _dengKuang.inCircle;
			_setting.x = _dengKuang.x + _dengKuang.width*0.5+10;
			_setting.y = _dengKuang.y;
		}
	}
}