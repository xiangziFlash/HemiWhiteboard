package com.scxlib
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.DataVO;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class AutoOppMedia extends Sprite
	{
		public function AutoOppMedia()
		{
			
		}
		
		public static function setPath(str:String):void
		{
			ToolKit.log("setPathsetPathsetPath");
			var vo:MediaVO = new MediaVO();
			vo.type = ".jpg";
			vo.isBmpd = false;
			vo.path =ApplicationData.getInstance().assetsPath + str;
			vo.isZiDong = true;
			vo.globalP = new Point(ConstData.stageWidth * 0.5, ConstData.stageHeight * 0.5);
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,vo);
		}
		
		public static function setLocalPath(str:String):void
		{
			var vo:MediaVO = new MediaVO();
			vo.type = ".jpg";
			vo.isBmpd = false;
			vo.path = str;
			vo.isZiDong = true;
			vo.globalP = new Point(1920*0.5, 1080*0.5);
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,vo);
		}
		
		public static function setVO(vo:MediaVO):void
		{
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,vo);
		}
		
		public static function setData(vo:DataVO):void
		{
			//NotificationFactory.getInstance().sendNotification(NotificationIDs.DRAG_OBJECT,vo);
		}
	}
}