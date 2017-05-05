package com.scxlib
{
	import com.greensock.TweenLite;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.res.DelRes;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-12-28 上午11:10:51
	 * 接受到手机传入文件列表
	 */
	public class ReceiveFileList extends Sprite
	{
		private var _spCon:Sprite;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _mask:Shape;
		private var _tempFileMedia:FileMedia;
		private var _isHuaMove:Boolean;
		private var _delRes:DelRes;
		
		public function ReceiveFileList()
		{
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0, 0, 1920, 130);
			this.graphics.endFill();
			
			_spCon = new Sprite();
			_spCon.x = 100;
			_spCon.y = 10;
			
			/*_mask = new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, 100, 117);
			_mask.graphics.beginFill(0);
			_mask.x = 300;
			_mask.y = 10;*/
			
			
//			this.addChild(_mask);
			
			_delRes = new DelRes();
			_delRes.scaleX = _delRes.scaleY = 1;
			_delRes.x = 0;
			_delRes.y = 20;
			this.addChild(_delRes);
			this.addChild(_spCon);
//			_spCon.mask = _mask;
			
			_spCon.addEventListener(MouseEvent.MOUSE_DOWN ,onSpConDown);
			_delRes.addEventListener(MouseEvent.CLICK, onDelResClick);
		}
		
		private function onDelResClick(e:MouseEvent):void
		{
			while(_spCon.numChildren > 0)
			{
				if(_spCon.getChildAt(0) is FileMedia)
				{
					(_spCon.getChildAt(0) as FileMedia).dispose();
				}
				_spCon.removeChildAt(0);
			}
			
			NotificationFactory.sendNotification(NotificationIDs.TUYA_BEGIN);
		}
		
		public function addMedia(vo:MediaVO):void
		{
//			trace("addMedia");
			var fileMedia:FileMedia = new FileMedia(vo,107, 60);
			fileMedia.name = "media_" + _spCon.numChildren;
			fileMedia.x = Math.ceil(_spCon.numChildren%15)*115;
			fileMedia.y = Math.floor(_spCon.numChildren/15)*80;
			_spCon.addChild(fileMedia);
			
//			_delRes.x = 1830;
			setTimeout(function ():void
			{
				TweenLite.to(_delRes, 0.2, {x:_spCon.width + 15 + _spCon.x});
			},500);
			
		}
		
		public function getMediaNum():int
		{
			return _spCon.numChildren;
		}
		
		private function onSpConDown(e:MouseEvent):void
		{
			_tempFileMedia = e.target as FileMedia;
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseX;
			_tempY = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSpConMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSpConUp);
		}
		
		private function onSpConMove(event:MouseEvent):void
		{
			/*if (Math.abs(this.mouseX - _tempX )> 20) {
				_isHuaMove = true;
			}
			
			if (Math.abs(this.mouseY - _tempY ) > 20) {
				_isHuaMove = false;
			}
			
			if (_isHuaMove) {
				_spCon.x += mouseX - _downX;
				_downX = mouseX;
				_downY = mouseY;
				if(_spCon.x > _mask.x)
				{
					TweenLite.to(_spCon, 0.1, {x:_mask.x});
				}
				if(_spCon.width < _mask.width)return;
				if(_spCon.x < -(_spCon.width - _mask.width))
				{
					TweenLite.to(_spCon, 0.1, {x:-(_spCon.width - _mask.width)});
				}
			}*/
		}
		
		private function onSpConUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSpConMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSpConUp);
			
			if(Math.abs(mouseX - _tempX) < 5 && Math.abs(mouseY - _tempY) < 5)
			{
				var fileMedia:FileMedia = event.target as FileMedia;
				var date1:Date = new Date();
				var fileParentName:String = "";
				var month:String = "";
				var date:String = "";
				if(date1.month + 1 < 10)
				{
					month = "0"+String(date1.month + 1);
				} else {
					month = String(date1.month + 1);
				}
				
				if(date1.date  < 10)
				{
					date = "0"+String(date1.date);
				} else {
					date = String(date1.date);
				}
				fileParentName = String(date1.fullYear)+"-"+month+"-"+date;
				var filePath:String = fileParentName + "/" +fileMedia.mediaVO.path.split("/")[fileMedia.mediaVO.path.split("/").length-1];
				var file:File = new File(ApplicationData.getInstance().httpAssets + filePath);
				switch(fileMedia.mediaVO.type)
				{
					case MediaVO.IMAGE:
					case MediaVO.SWF:
					{
						NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,fileMedia.mediaVO);
						break;
					}
						
					case MediaVO.PPT:
					{
						ConstData.isPPTCtr = true;
						OpenPPT.setPath(ApplicationData.getInstance().httpAssets + filePath);
						NotificationFactory.sendNotification(NotificationIDs.OPEN_FILE, 0);
						break;
					}
						
					default:
					{
						file.openWithDefaultApplication();
						NotificationFactory.sendNotification(NotificationIDs.OPEN_FILE, 1);
						break;
					}
				}
			} else {
				if(Math.abs(mouseY-_tempY)>20 && Math.abs(mouseX-_tempX) < 15){
					_spCon.removeChild(_tempFileMedia);
					resetSpCon();
				}
			}
		}
		
		private function resetSpCon():void
		{
			for (var i:int = 0; i < _spCon.numChildren; i++) 
			{
				_spCon.getChildAt(i).name = "media_"+i;
				_spCon.getChildAt(i).x = i*115;
			}
		}
		
		public function dispose():void
		{
			while(_spCon.numChildren > 0)
			{
				if(_spCon.getChildAt(0) is FileMedia)
				{
					(_spCon.getChildAt(0) as FileMedia).dispose();
				}
				_spCon.removeChildAt(0);
			}
		}
	}
}