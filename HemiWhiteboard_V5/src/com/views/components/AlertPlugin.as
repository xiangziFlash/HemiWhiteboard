package com.views.components
{
	import com.cndragon.baby.plugs.Alert.AlertRes;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class AlertPlugin extends Sprite
	{
		private var _alertPanel:AlertRes;
		private var _alertContent:String;
		private var _okHandel:Function;
		private var _cancelHandel:Function;
		public function AlertPlugin()
		{
			initialize();
		}
		
		private function initialize():void
		{
			_alertPanel = new AlertRes();
			this.addChild(_alertPanel);
			(_alertPanel.panel.txt as TextField).autoSize = "center";
			(_alertPanel.panel.txt as TextField).embedFonts = true;
			(_alertPanel.panel.txt as TextField).defaultTextFormat = new TextFormat("YaHei_font",15,0xCCCCCC);
			initEventListener();
		}
	
		private function initEventListener():void
		{
			_alertPanel.panel.ok.addEventListener(MouseEvent.CLICK,onAlertOK);
			_alertPanel.panel.cancel.addEventListener(MouseEvent.CLICK,onAlertCancel);
		}
		
		private function onAlertOK(e:MouseEvent):void
		{
			if(_okHandel!=null){
				_okHandel();
			}
			
			//this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function onAlertCancel(e:MouseEvent):void
		{
			if(_cancelHandel!=null){
				_cancelHandel();
			}
			
			//this.dispatchEvent(new Event(Event.CANCEL));
		}
		
		public function setAlert(content:String,OKHandel:Function=null,CancelHandel:Function=null):void
		{
			_alertPanel.panel.txt.text = content;
			//_alertPanel.panel.txt.text = "检测到U盘已接入,是否选择U盘模式？";
			_alertContent = content;
			if(OKHandel!=null){
				_okHandel = OKHandel;
			}
			if(CancelHandel!=null){
				_cancelHandel = CancelHandel;
			}
		}
		
	}
}