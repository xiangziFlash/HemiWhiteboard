package com.views.components
{
	import com.lylib.touch.objects.RotatableScalable;
	import com.lylib.touch.objects.RotatableScalable1;
	import com.tweener.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class ShowTime extends RotatableScalable
	{
		private var _btn:timeBtnRes;
		private var _conBackground:contentBackgroundRes;
		private var _myTimer:Timer;
		private var _countDown:Countdown;
		private var _date:Date;
		private var _closeMovebtn:CloseMoveBtnRes;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _sound:Sound;
		private var _channel:SoundChannel;
		
		public function ShowTime()
		{
			touchEndFun=touchEnd;
			touchMoveFun=touchMove;
			initContente();
			initListener();
		}
		
		private function initContente():void
		{
			_btn=new timeBtnRes();
			_btn.y = 30;
			_conBackground=new contentBackgroundRes();
			_conBackground.x=30+104.8;
			_conBackground.y=70.25;
			
			_closeMovebtn = new CloseMoveBtnRes();
			_closeMovebtn.x = (240-55)*0.5+15;
//			_closeMovebtn.y = (_conBackground.height-_closeMovebtn.height)*0.5;
			
			this.addChild(_btn);
			this.addChild(_conBackground);
			this.addChild(_closeMovebtn);
			noRotat = true;
			_countDown=new Countdown();
			_countDown.x=10.6;
//			_countDown.y=5;
			_countDown.visible=false;
			
			_date = new Date();
			_conBackground.nowTime.text=timeFormat(String(_date.hours))+":"+timeFormat(String(_date.minutes));
			_conBackground.nowMonth.text=timeFormat(String(_date.month+1))+"/"+timeFormat(String(_date.date));
			_conBackground.nowDay.text="星期"+dayFormat(_date.day);
			
			_myTimer=new Timer(1000);
			_myTimer.start();
		}
		
		private function initListener():void
		{
			_myTimer.addEventListener(TimerEvent.TIMER,onNowTimer);
			_btn.addEventListener(MouseEvent.CLICK,onClickBtn);
//			_closeMovebtn.addEventListener(MouseEvent.MOUSE_DOWN,onCloseMoveBtnDown);
			_closeMovebtn.addEventListener(MouseEvent.CLICK,onCloseMoveBtnClick);
			_closeMovebtn.closeBtn.mouseChildren = false;
			_closeMovebtn.moveBtn.mouseChildren = false;
			_countDown.addEventListener(Event.CLOSE,onCountClose);
		}
		/**
		 * 
		 * @param e
		 * 音乐结束后响铃
		 */		
		private function onCountClose(e:Event):void
		{
			_countDown.mouseChildren=true;
			soundTiShi();
		}
		
		/**
		 * 当前时间
		 * */
		private function onNowTimer(e:TimerEvent):void
		{
			gengXingTime();
		}
		
		private function gengXingTime():void
		{
			var date:Date=new Date;
			_conBackground.nowTime.text=timeFormat(String(date.hours))+":"+timeFormat(String(date.minutes));
			_conBackground.nowMonth.text=timeFormat(String(date.month+1))+"/"+timeFormat(String(date.date));
			_conBackground.nowDay.text="星期"+dayFormat(date.day);
		}
		
		private function onClickBtn(e:MouseEvent):void
		{
			Tweener.removeTweens(_conBackground);
			if(e.target.name.split("_")[0]=="btn")
			{
				var id:int=int(e.target.name.split("_")[1]);
				if(id==0)
				{
					if(_sound)
					{
						_channel.stop();
					}
					gengXingTime();
					_btn.gotoAndStop(2);
//					Tweener.addTween(_conBackground,{time:0.5,rotationX:-180,rotationZ:-180,rotationY:-180});
					_conBackground.gotoAndStop(2);
					_conBackground.djsMc.addChild(_countDown);
					_conBackground.nowTime.visible = false;
					_conBackground.nowMonth.visible = false;
					_conBackground.nowDay.visible = false;
					_btn.startBtn.gotoAndStop(1);
					_countDown.reset();
					_countDown.mouseChildren=true;
					_countDown.visible=true;
				}else if(id==1)
				{
					if(_sound)
					{
						_channel.stop();
					}
					_conBackground.nowTime.visible = true;
					_conBackground.nowMonth.visible = true;
					_conBackground.nowDay.visible = true;
					_countDown.visible=false;
					_btn.gotoAndStop(1);
//					Tweener.addTween(_conBackground,{time:0.5,rotationX:180,rotationZ:180,rotationY:180});
					_conBackground.gotoAndStop(1);
				}
				if(id==2)
				{
					if(_sound)
					{
						_channel.stop();
					}
					if(_btn.startBtn.currentFrame==1)
					{
						_countDown.startTime();
						_btn.startBtn.gotoAndStop(2);
						_countDown.mouseChildren=false;
					}else
					{
						_countDown.stopTime();
						_btn.startBtn.gotoAndStop(1);
						_countDown.mouseChildren=true;
					}
				}if(id==3)
				{
					if(_sound)
					{
						_channel.stop();
					}
					_countDown.againStartTime();
					_btn.startBtn.gotoAndStop(1);
					_countDown.mouseChildren=true;
				}
			}
		}
		
		public function soundTiShi():void
		{
			if(_sound==null)
			{
				_sound = new Sound();
				_sound.load(new URLRequest("assets/medias/闹铃.mp3"));
				_sound.addEventListener(Event.COMPLETE,onSoundLoaded);
				_channel = new SoundChannel();
			}
			_channel = _sound.play();
		}
		
		private function onSoundLoaded(event:Event):void
		{
			_sound.close();
		}
		
		private function onCloseMoveBtnDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = this.x;
			_tempY = this.y;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMoveCloseMove);	
			stage.addEventListener(MouseEvent.MOUSE_UP,onMoveCloseUp);	
		}
		
		private function onMoveCloseMove(event:MouseEvent):void
		{
			this.x +=mouseX-_downX;
			this.y +=mouseY-_downY;
			
			_downX = mouseX;
			_downY = mouseY;
		}
		
		private function onMoveCloseUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMoveCloseMove);	
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMoveCloseUp);
			
			if(Math.abs(this.x-_tempX)<5&&Math.abs(this.y-_tempY)<5)
			{
				if(event.target.name=="closeBtn")
				{
					this.visible = false;
					if(_sound)
					{
						_channel.stop();
					}
				}
			}
		}
		private function onCloseMoveBtnClick(e:MouseEvent):void
		{
			if(e.target.name=="closeBtn")
			{
				this.visible = false;
				if(_sound)
				{
					_channel.stop();
				}
				_countDown.stopTime();
				_countDown.reset();
			}else if(e.target.name=="moveBtn")
			{
				if((e.target as MovieClip).currentFrame==1)
				{
					(e.target as MovieClip).gotoAndStop(2);
					noDrag = true;
					noScale = true;
				}else{
					(e.target as MovieClip).gotoAndStop(1);
					noDrag = false;
					noScale = false;
				}
			}
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
		 * 星期显示格式
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
		
		private function touchEnd():void
		{
		
		}
		
		private function touchMove():void
		{
			
		}
		
		public function reset():void
		{
//			_myTimer.stop();
			_btn.gotoAndStop(1);
			_conBackground.gotoAndStop(1);
			_conBackground.nowTime.visible = true;
			_conBackground.nowMonth.visible = true;
			_conBackground.nowDay.visible = true;
//			_btn.startBtn.gotoAndStop(1);
			_countDown.visible = false;
			_countDown.reset();
			if(_sound)
			{
				_channel.stop();
			}
			_closeMovebtn.moveBtn.gotoAndStop(1);
		}
	}
}