package com.sketchpad
{
	import com.cndragon.baby.plugs.Sketchpad.VoleumBoxRes;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	
	internal class VoleumBox extends Sprite
	{
		private var _voleumBox:VoleumBoxRes;
		private var _voleum_p:MovieClip;
		private var _voleum_bar:MovieClip;
		private var _mute_btn:MovieClip;
		private var _startY:Number;
		private var _disY:Number;
		private var _stopY:Number;
		public var value:Number;
		public var isMute:Boolean;
		public function VoleumBox()
		{
			initContent();
			super();
		}
		
		private function initContent():void
		{
			// TODO Auto Generated method stub
			_voleumBox=new VoleumBoxRes();
			this.addChild(_voleumBox);
			_voleum_p=_voleumBox.getChildByName("voleum_p") as MovieClip;
			_voleum_bar=_voleumBox.getChildByName("v_bar") as MovieClip;
			_mute_btn=_voleumBox.getChildByName("mute_btn") as MovieClip;
			
			initListeners();
		}
		
		private function initListeners():void
		{
			// TODO Auto Generated method stub
			_voleum_bar.addEventListener(MouseEvent.MOUSE_DOWN, onVoleum_barDown);
			_voleum_bar.addEventListener(TouchEvent.TOUCH_BEGIN, onVoleum_barTOUCH_BEGIN);
			_mute_btn.addEventListener(MouseEvent.MOUSE_DOWN,onMuteDown);

		}
		
		private function onVoleum_barTOUCH_BEGIN(event:TouchEvent):void
		{
			event.stopPropagation();
			
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onScoll_pTOUCH_MOVE);
			stage.addEventListener(TouchEvent.TOUCH_END, onScoll_pTOUCH_END);
		}
		
		private function onScoll_pTOUCH_END(event:TouchEvent):void
		{
			event.stopPropagation();
		}
		
		private function onScoll_pTOUCH_MOVE(event:TouchEvent):void
		{
			event.stopPropagation();
		}
		
		private function onMuteDown(event:MouseEvent):void
		{
			event.stopPropagation();
			_mute_btn.addEventListener(MouseEvent.MOUSE_UP,onMuteUp);
			
		}
		
		protected function onMuteUp(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			if(_mute_btn.currentFrame == 1){
				_mute_btn.gotoAndStop(2);
				isMute = true;
			}else if(_mute_btn.currentFrame == 2){
				_mute_btn.gotoAndStop(1);
				isMute =false;
			}
			this.dispatchEvent(new Event(Event.CANCEL)); 
		}
		
		private function onVoleum_barDown(event:MouseEvent):void
		{
			event.stopPropagation();
			_startY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onVoleum_barMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onVoleum_barUp);
		}
		
		protected function onVoleum_barUp(event:MouseEvent):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onVoleum_barMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onVoleum_barUp);
			this.dispatchEvent(new Event(Event.CLOSE)); 
		}
		
		private function onVoleum_barMove(event:MouseEvent):void
		{
			
			_stopY = mouseY;
			_disY= _voleum_p.y +_stopY- _startY;
			_startY = _stopY;
			_voleum_p.y = _disY;
			
			if (_voleum_p.y<= 10.4)
			{
				_voleum_p.y =10.4 ;
			}
			if (_voleum_p.y >= 10.4+83.75-6.45)
			{
				_voleum_p.y = 10.4+83.75-6.45;
			}
			
			value =1-(_disY- 10.4 ) / (83.75-6.45);
	
			this.dispatchEvent(new Event(Event.CHANGE)); 

		}
		
		
	}
}