package com.views.components.panel
{
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ClearPanel extends Sprite
	{
		private var _clearMC:ClearMCRes;
		
		public function ClearPanel()
		{
			_clearMC = new ClearMCRes();
			this.addChild(_clearMC);
			
			_clearMC.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(e:MouseEvent):void
		{
			if(e.target.name == "yesBtn")
			{
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_ALL);
			}else if(e.target.name == "noBtn")
			{
				
			}
			this.dispatchEvent(new Event(Event.CLOSE));
		}
	}
}