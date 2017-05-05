package com.views.components
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class NowTime extends Sprite
	{
//		private var _timeText:timeTextRes;
		private var _myTimer:Timer
		
		public function NowTime()
		{
			super();
			initContent();
		}
		private function initContent():void
		{
//			_timeText=new timeTextRes();
//			this.addChild(_timeText);
//			
//			var date:Date=new Date();
//			_timeText.nowTime.text=timeFormat(String(date.hours))+":"+timeFormat(String(date.minutes));
//			_timeText.nowMonth.text=timeFormat(String(date.month+1))+"/"+timeFormat(String(date.date));
//			_timeText.nowDay.text="星期"+dayFormat(date.day);
			
			
			_myTimer=new Timer(1000);
			_myTimer.start();
		}
		private function initListener():void
		{
			_myTimer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			var date:Date=new Date();
//			_timeText.nowTime.text=timeFormat(String(date.hours))+":"+timeFormat(String(date.minutes));
//			_timeText.nowMonth.text=timeFormat(String(date.month+1))+"/"+timeFormat(String(date.date));
//			_timeText.nowDay.text="星期"+dayFormat(date.day);
		}
		
		/**
		 * 时间显示格式，不够十的加0
		 * */
		private function timeFormat(str:String):String
		{
			if(int(str)<10)
			{
				return "0"+str;
			}
			return str;
		}
		/**
		 * 星期显示格式，不够十的加0
		 * */
		private function dayFormat(id:Number):String
		{
			var week:String;
			switch(id)
			{
				case 0:
				{
					week="日"
					break;
				}
				case 1:
				{
					week="一"
					break;
				}
				case 2:
				{
					week="二"
					break;
				}
				case 3:
				{
					week="三"
					break;
				}
				case 4:
				{
					week="四"
					break;
				}
				case 5:
				{
					week="五"
					break;
				}
				case 6:
				{
					week="六"
					break;
				}
					
				default:
				{
					break;
				}
			}
			return week;
		}
		
	}
}