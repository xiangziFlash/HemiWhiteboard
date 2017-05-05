package com.views.components
{
	import com.controls.ToolKit;
	import com.wyzlib.containers.LoopTurnContainer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class Countdown extends Sprite
	{
		private var _timeSp:Sprite;
		private var _hourList:LoopTurnContainer;
		private var _minuteList:LoopTurnContainer;
		private var _secondList:LoopTurnContainer;
		private var _jishiTimer:Timer;
		private var _mask:Sprite;
		private var _h:int;
		private var _m:int;
		private var _s:int;
		private var _tempS:int;
		
		public function Countdown()
		{
			super();
			initContent();
			initListener();
		}
		private function initContent():void
		{
			_timeSp=new Sprite();
			this.addChild(_timeSp);
			
//			_hourList=new LoopTurnContainer(54.9,48.7);
			_hourList=new LoopTurnContainer(55,65);
			_hourList.moveDis=65;
			var conHour:HourFormat;
			_hourList.setContent("com.views.components.HourFormat","num_");
//			_hourList.x=10.6;
//			_hourList.y=2;
			_hourList.selectNameObj("num_0");
			
			_minuteList=new LoopTurnContainer(55,65);
			_minuteList.moveDis=65;
			var conMinute:MinuteFormat;
			_minuteList.setContent("com.views.components.MinuteFormat","num_");
			_minuteList.x=77.9-10.6;
			_minuteList.selectNameObj("num_0");
			
			_secondList=new LoopTurnContainer(55,65);
			_secondList.moveDis=65;
			var conSecond:MinuteFormat;
			_secondList.setContent("com.views.components.MinuteFormat","num_");
			_secondList.x=146.4-10.6;
			_secondList.selectNameObj("num_0");
			
			
			_timeSp.addChild(_hourList);
			_timeSp.addChild(_minuteList);
			_timeSp.addChild(_secondList);
			
			_jishiTimer=new Timer(1000);
		}
		
		private function initListener():void
		{
			_jishiTimer.addEventListener(TimerEvent.TIMER,onCountdownTimer);
			_hourList.addEventListener(Event.COMPLETE,onHourComplete);
			_minuteList.addEventListener(Event.COMPLETE,onMinuteComplete);
			_secondList.addEventListener(Event.COMPLETE,onSecondComplete);
		}
		
		private function onCountdownTimer(e:TimerEvent):void
		{
			ToolKit.log("小时： " + _h + " 分钟：" + _m + " 秒： " + _s);
			if(_s==0)
			{
				if(_m==0)
				{
					if(_h==0)
					{//trace("结束了3",_s,_m,_h)
						this.dispatchEvent(new Event(Event.CLOSE));
						_jishiTimer.stop();
					}else
					{//trace("结束了0")
						_hourList.selectNameObj("num_"+_h)
						_m=0;
						_s=0;
						_minuteList.selectNameObj("num_"+_m)
						_secondList.selectNameObj("num_"+_s)
					}
				}else
				{//trace("结束了1")
					if(_s==0&&_m==0&&_s==0)
					{
						//trace("000");
						this.dispatchEvent(new Event(Event.CLOSE));
						_jishiTimer.stop();
						return;
					}
					_minuteList.selectNameObj("num_"+_m)
					_s=0;
					_secondList.selectNameObj("num_"+_s)
				}
			}else
			{
				//trace("结束了")
				_secondList.selectNameObj("num_"+_s);
			}
			
		}
		
		protected function onSecondComplete(event:Event):void
		{
			_s=int(_secondList.nowSelectObjID);
			if(_s == 0)
			{
				_tempS = 0;
				return;
			}
			if(_tempS == _s)
			{
				_s--;
			}
			_tempS = _s;
			//trace(_s, "_s");
		}
		private function onHourComplete(event:Event):void
		{
			_h=int(_hourList.nowSelectObjID);
			//trace(_h, "h");
		}
		private function onMinuteComplete(event:Event):void
		{
			_m=int(_minuteList.nowSelectObjID);
			//trace(_m, "m");
		}
		
		/**
		 * 开始计时
		 * */
		public function startTime():void
		{
			if(_h==0&&_m==0&&_s==0)
			{
				
			}else
			{	
				_jishiTimer.reset();
				_jishiTimer.start();
			
			}
		}
		/**
		 * 暂停计时
		 * */
		public function stopTime():void
		{
			_jishiTimer.stop();
			_jishiTimer.reset();
		}
		/**
		 * 重置,回到00
		 * */
		public function againStartTime():void
		{
			_hourList.selectNameObj("num_1");
			_minuteList.selectNameObj("num_1");
			_secondList.selectNameObj("num_1");
			_jishiTimer.stop();
			_jishiTimer.reset();
		}
		
		
		public function reset():void
		{
			_hourList.selectNameObj("num_1");
			_minuteList.selectNameObj("num_1");
			_secondList.selectNameObj("num_1");
			_jishiTimer.stop();
			_jishiTimer.reset();
		}
	}
}