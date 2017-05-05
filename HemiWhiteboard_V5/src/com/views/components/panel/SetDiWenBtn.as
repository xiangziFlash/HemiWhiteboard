package com.views.components.panel
{
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class SetDiWenBtn extends Sprite
	{
		private var _setDiWen:SetDiWenRes;
		private var _downY:Number=0;
		private var _dwID:int=3;
		private var _obj:Object;
		
		public function SetDiWenBtn()
		{
			_setDiWen = new SetDiWenRes();
			this.addChild(_setDiWen);
			_obj = new Object();
			_setDiWen.mc.y = 17;
			
			_setDiWen.addEventListener(MouseEvent.CLICK,onBtnClick);
			_setDiWen.mc.addEventListener(MouseEvent.MOUSE_DOWN,onMcDown);
			_setDiWen.bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarDown);
		}
		
		private function onBtnClick(event:MouseEvent):void
		{
			if(event.target.name.split("_")[0]!="btn")return;
			_setDiWen.mc.y = 17;
			_dwID = event.target.name.split("_")[1];
			_obj.id = _dwID;
			_obj.change = false;
			_obj.scale = 1;
			NotificationFactory.sendNotification(NotificationIDs.SHOW_WENLI,_obj);
		}
		
		private function onMcDown(e:MouseEvent):void
		{
			_downY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			_setDiWen.mc.y += mouseY-_downY;
			_downY = mouseY;
			if(_setDiWen.mc.y<17){
				_setDiWen.mc.y = 17;
			}
			
			if(_setDiWen.mc.y>80)
			{
				_setDiWen.mc.y = 80;
			}
			_obj = new Object();
			_obj.id = _dwID;
			_obj.change = true;
			_obj.scale = 1+((_setDiWen.mc.y-17)/80);
			_obj.alpha = 1-(_setDiWen.bar.y-120)/80;
			NotificationFactory.sendNotification(NotificationIDs.SHOW_WENLI,_obj);
		}
		
		private function onUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onBarDown(e:MouseEvent):void
		{
			_downY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBarUp);
		}
		
		private function onBarMove(e:MouseEvent):void
		{
			_setDiWen.bar.y += mouseY-_downY;
			_downY = mouseY;
			if(_setDiWen.bar.y<120){
				_setDiWen.bar.y = 120;
			}
			
			if(_setDiWen.bar.y>185)
			{
				_setDiWen.bar.y = 185;
			}
			_obj = new Object();
			_obj.id = _dwID;
			_obj.change = true;
			_obj.scale = 1+((_setDiWen.mc.y-17)/80);
			_obj.alpha = 1-(_setDiWen.bar.y-120)/80;
			NotificationFactory.sendNotification(NotificationIDs.SHOW_WENLI,_obj);
		}
		
		private function onBarUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBarUp);
		}
		
		public function reset():void
		{
			_setDiWen.mc.y = 17;
			_dwID = 3;
			_setDiWen.mc.y
		}
	}
}