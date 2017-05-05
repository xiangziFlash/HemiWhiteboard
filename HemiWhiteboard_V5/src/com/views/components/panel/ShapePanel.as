package com.views.components.panel
{
	import com.models.ApplicationData;
	import com.models.vo.TuXingVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ShapePanel extends Sprite
	{
		private var _shapePanel:ShapePanelRes;
		private var _shapeID:int;
		private var _tuXingVO:TuXingVO;
		private var _tempBtn:MovieClip;
		
		public function ShapePanel()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_shapePanel = new ShapePanelRes();
			this.addChild(_shapePanel);
			_tuXingVO = new TuXingVO();
			_shapePanel.addEventListener(MouseEvent.CLICK,onClick);
		}
		
		private function onClick(event:MouseEvent):void
		{
			if(event.target.name.split("_")[0]!="shape")return;
			if(_tempBtn)
			{
				_tempBtn.alpha = 1;
			}
			_tempBtn = event.target as MovieClip;
			_tempBtn.alpha = 0.5;
			
			this.dispatchEvent(new Event(Event.CHANGE));
			_shapeID = event.target.name.split("_")[1];
			ApplicationData.getInstance().styleVO.shapeStyle = _shapeID;
			_tuXingVO.tuYa = false;
			_tuXingVO.tianChong = false;
			_tuXingVO.shape = true;
			_tuXingVO.drawShape = true;
			NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
		}
	}
}