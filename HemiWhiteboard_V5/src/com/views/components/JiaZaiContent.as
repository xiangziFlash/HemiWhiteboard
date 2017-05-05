package com.views.components
{
	import com.notification.ILogic;
	import com.notification.NotificationIDs;
	import com.notification.SimpleNotification;
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class JiaZaiContent extends Sprite implements ILogic
	{
		private var _res:WelcomeWin;
		private var _tf:TextFormat=new TextFormat("YaHei_font",18,0x000000,true);
		static public const NAME:String="JiaZaiContent";
		private var _textInfor:TextField;
		public function JiaZaiContent()
		{
			_res=new WelcomeWin();
			addChild(_res);
//			_res.infoText.embedFonts=true;
//			_res.infoText.autoSize=TextFieldAutoSize.LEFT;
//			_res.infoText.setTextFormat(_tf);
//			_res.infoText.defaultTextFormat=_tf;
//			_res.infoText.selectable=false;
			
			_textInfor=new TextField();
			_textInfor.x=848;
			_textInfor.y=620;
			_res.addChild(_textInfor);
			_textInfor.embedFonts=true;
			_textInfor.autoSize=TextFieldAutoSize.LEFT;
			_textInfor.defaultTextFormat=_tf;
			_textInfor.selectable=false;
		}
		
		public function getLogicName():String
		{
			return NAME;
		}
		
		public function onRegister():void
		{
		}
		
		public function onRemove():void
		{
		}
		
		public function listNotificationInterests():Array
		{
			return [NotificationIDs.APP_DATA_LOADING];
		}
		
		public function handleNotification(notification:SimpleNotification):void
		{
			if(notification.getId()==NotificationIDs.APP_DATA_LOADING){
				_textInfor.text=String(notification.getBody());
			}
		}
	}
}