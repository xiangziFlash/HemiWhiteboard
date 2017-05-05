package com.views.components
{
	import com.lylib.email.EmailSocket;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class LoadingPage extends Sprite
	{
		private var _bg:Sprite;
		private var _loading:Loading;
		private var _titleTf:TextFormat=new TextFormat("YaHei_font",22,0xffffff);
		private var _sp:Sprite;

		private var _text:TextField;
		public function LoadingPage()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_bg=new Sprite();
			_bg.graphics.beginFill(0,0.6);
			_bg.graphics.drawRect(0,0,1920,1080);
			_bg.graphics.endFill();
			this.addChild(_bg);
			
			_sp = new Sprite();
			this.addChild(_sp);
			
			_loading=new Loading();
		
			_text=new TextField();
			_text.embedFonts=true;
			_text.defaultTextFormat=_titleTf;
			_text.autoSize="left";
			setTT("正在導出文件请稍等...");
			
			_bg.doubleClickEnabled = true;
			_bg.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		}
		
		private function onDoubleClick(event:MouseEvent):void
		{
			this.visible = false;
		}
		
		public function setTT(str:String):void
		{
			_text.text=str;
			_text.x = (1920-_text.width)*0.5;
			_text.y = (1080-_text.height)*0.5;
			this.addChild(_text);
			_loading.x=(1920-_loading.width)*0.5-60;
			_loading.y=(1080-_loading.height)*0.5-50;
			this.addChild(_loading);
		}
	}
}