package com.windows
{
	import com.tweener.transitions.Tweener;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.TimerEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.setTimeout;

	/**
	 * @author Ye
	 * @E-mail: [email=694070863@qq.com][/email]
	 * 创建时间：2015-2-5 下午2:50:18
	 * 
	 */
	public class PromptBoxWindow extends NativeWindow
	{
		private var _tiShiKuang:ShotScreenTiShiRes;
		private var _timer:Timer;
		public function PromptBoxWindow()
		{
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.systemChrome = NativeWindowSystemChrome.NONE;
			winArgs.transparent = true;
			super(winArgs);
			
			_tiShiKuang =  new ShotScreenTiShiRes();
			_tiShiKuang.x = (Capabilities.screenResolutionX - _tiShiKuang.width)*0.5;
			_tiShiKuang.y = (Capabilities.screenResolutionY - _tiShiKuang.height)*0.5;
			//_tiShiKuang.visible = false;
			this.stage.addChild(_tiShiKuang);
			
			(_tiShiKuang.tt as TextField).embedFonts = true;
			(_tiShiKuang.tt as TextField).defaultTextFormat = new TextFormat("YaHei_font", 32, 0xFFFFFF);
			_tiShiKuang.mouseChildren = false;
			_tiShiKuang.mouseEnabled = false;
			
			this.alwaysInFront=true;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.alwaysInFront = true;
			
			this.x = this.y = 0;
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.start();
			
		}
		
		private function onTimer(event:TimerEvent):void
		{
			if(!this.closed){
				this.activate();
			}
//			_timer.stop();
		}
		
		public function hideWin():void
		{
			_timer.stop();
			this.visible = false;
		}
		
		public function showWin(str:String):void
		{
			(_tiShiKuang.tt as TextField).text = str;
			_timer.start();
			this.visible = true;
		}
	}
}