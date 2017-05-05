package com.windows
{
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	public class ButtonWindow extends NativeWindow
	{
		private var _spCon:Sprite;
		public function ButtonWindow()
		{
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.systemChrome = NativeWindowSystemChrome.NONE;
			//winArgs.transparent = false;
			winArgs.transparent = true;
			super(winArgs);
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.width = 960,
			this.height = 540,
			this.alwaysInFront = true;
			this.x =0;
			this.y = 0;
			
			_spCon=new Sprite();
			_spCon.graphics.beginFill(0x000000,0.3);
			_spCon.graphics.drawRect(0,0,960,540);
			_spCon.graphics.endFill();		
			this.stage.addChild(_spCon);
		}
	}
}