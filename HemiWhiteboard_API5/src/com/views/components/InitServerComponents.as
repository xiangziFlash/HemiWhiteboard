package com.views.components
{
	import com.controls.ToolKit;
	import com.res.InitServerRes;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2017-3-30 下午3:31:47
	 * 
	 */
	public class InitServerComponents extends Sprite
	{
		private var _res:InitServerRes;
		public var setStuteFun:Function;
		public var timer:Timer;
		
		public function InitServerComponents()
		{
			init();
		}
		
		private function init():void
		{
			_res = new InitServerRes();
			this.addChild(_res);
//			_res.wait.visible = false;
			_res.wait.gotoAndStop(1);
			_res.logTT.embedFonts = true;
			_res.logTT.defaultTextFormat = new TextFormat("YaHei_font", 35, 0x012B54);
			_res.logTT.text = "将此白板设置为主脑！";
			
			timer = new Timer(3*1000);
			
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			_res.addEventListener(MouseEvent.CLICK, onResClick);
			
			timer.reset();
			timer.stop();
		}
		
		private function onTimer(event:TimerEvent):void
		{
			ToolKit.log("10秒内没有检测到服务，正在启动服务");
			if(setStuteFun)
			{
				setStuteFun(3);
			}
		}
		
		public function setLog(str:String):void
		{
			_res.logTT.text = str;
		}
		
		public function hideThis():void
		{
			_res.logTT.text = "环境配置成功";
			_res.wait.visible = true;
			_res.wait.gotoAndPlay(1);
			_res.yesBtn.visible = false;
		}
		
		private function onResClick(event:MouseEvent):void
		{
			var targetName:String = event.target.name;
			switch(targetName)
			{
				case "yesBtn":
				{
					if(setStuteFun)
					{
						setStuteFun(0);
					}
					setLog("正在配置环境，请稍候...");
					_res.wait.visible = true;
					_res.wait.gotoAndPlay(1);
					_res.yesBtn.visible  = false;
					timer.reset();
					timer.start();
					break;
				}
					
				case "noBtn":
				{
					if(setStuteFun)
					{
						setStuteFun(1);
					}
					break;
				}
			}
		}
		
		public function reset():void
		{
//			_res.wait.visible = false;
			_res.wait.gotoAndStop(1);
			_res.logTT.text = "将此白板设置为主脑！";
		}
	}
}