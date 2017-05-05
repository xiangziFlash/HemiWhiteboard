package com.views.components
{
	import com.lylib.touch.objects.RotatableScalable1;
	import com.tweener.transitions.Tweener;
	import com.views.components.menu.OneButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	[Event(name=TouchMoveEvent, type="flash.events.Event")]
	[Event(name=TouchEndEvent, type="flash.events.Event")]
	[Event(name=TouchBeginEvent, type="flash.events.Event")]
	public class TanZhaoDengKuang extends RotatableScalable1
	{
		public static const TouchMoveEvent:String="TouchMoveEvent";
		public static const TouchEndEvent:String="TouchEndEvent";
		public static const TouchBeginEvent:String="TouchBeginEvent";
		
		public var res:DengBianRes;
		private var _circleSp:Sprite;
		public var inCircle:Sprite;
		private var _outCircle:Sprite;
		public var circleSp:Sprite;
		private var _stageW:Number=0;
		private var _timer:Timer;
		
		public function TanZhaoDengKuang()
		{
			touchEndFun=touchEnd;
			touchMoveFun=touchMove;
			touchBeginFun = touchBegin;
			this.maxScale = 4;
			this.minScale = 1;
			res = new DengBianRes();
			this.addChild(res);
			noRotat = true;
			inCircle = res.inCircle;
			_outCircle = res.outCircle;
			circleSp = res.circleSP;
			
		/*	_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.reset();
			_timer.stop();*/
			resetXY();
		}
		
		public function get stageW():Number
		{
			return _stageW;
		}

		private function touchEnd():void
		{
			_stageW = res.width*this.scaleX;
//			Tweener.addTween(res,{time:0.5,onComplete:changeEnd});
//			
//			function changeEnd():void
//			{trace("changeEnd");
				this.dispatchEvent(new Event(TouchEndEvent));
//			}
		}
		
		private function touchMove():void
		{
			_stageW = res.width*this.scaleX;
			this.dispatchEvent(new Event(TouchMoveEvent));
		}
		
		private function touchBegin():void
		{
			this.dispatchEvent(new Event(TouchBeginEvent));
		}
		
		public function changeModel(id:int):void
		{
			res.gotoAndStop(id);
			inCircle = res.inCircle;
			_outCircle = res.outCircle;
			circleSp = res.circleSP;
		}
		
		private function onTimer(e:TimerEvent):void
		{
			this.dispatchEvent(new Event(TouchEndEvent));
			_timer.stop();
		}
		
		public function resetXY():void
		{
			
		}
	}
}