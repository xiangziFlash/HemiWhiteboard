package com.views.components.panel
{
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class ShuXuePanel extends Sprite
	{
		private var _shuXuePanelRes:ShuXuePanelRes;
		
		public function ShuXuePanel()
		{
			_shuXuePanelRes = new ShuXuePanelRes();
			this.addChild(_shuXuePanelRes);
			
			_shuXuePanelRes.addEventListener(MouseEvent.CLICK,onPanelClick);
		}
		
		private function onPanelClick(event:MouseEvent):void
		{
			if(event.target.name.split("_")[0]!="btn")return;
			var id:int = event.target.name.split("_")[1];
			NotificationFactory.sendNotification(NotificationIDs.SHUXUE_GONGJU,id);
		}
	}
}