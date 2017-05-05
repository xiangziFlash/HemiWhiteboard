package com.views.components.user
{
	import com.greensock.TweenLite;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.LoaderImage;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-14 下午2:37:50
	 * 
	 */
	public class UserMedia extends Sprite
	{
		private var _mediaSp:Sprite;
		private var _medias:Vector.<MediaVO> = new Vector.<MediaVO>;
		private var _userDownX:Number=0;
		private var _userDownY:Number=0;
		private var _userTempX:Number=0;
		private var _userTempY:Number=0;
		private var _listMask:Shape;
		
		public function UserMedia()
		{
			initViews();
			initListener();
		}
		
		private function initViews():void
		{
			_mediaSp = new Sprite();
			_mediaSp.x = 0;
			_mediaSp.y = 0;
			
			_listMask = new Shape();
			_listMask.graphics.beginFill(0xFFFFFF,0.5);
			_listMask.graphics.drawRect(0, 0, 676 ,543);
			_listMask.graphics.endFill();
			_listMask.x = 0;
			_listMask.y = 0;
			
			this.addChild(_mediaSp);
			this.addChild(_listMask);
			_mediaSp.mask = _listMask;
		}
		
		private function initListener():void
		{
			_mediaSp.addEventListener(MouseEvent.MOUSE_DOWN,onUserListDown);
		}
		
		public function addAllMedia(medias:Vector.<MediaVO>):void
		{
			dispose();
			for (var i:int = 0; i < medias.length; i++) 
			{
				var media:LoaderImage = new LoaderImage();
				media.setWH(187, 105, false ,true);
				media.setPath(medias[i]);
				media.x = Math.ceil(i%3)*244;
				media.y = Math.floor(i/3)*146;
				_mediaSp.addChild(media);
			}
			_mediaSp.graphics.clear();
			_mediaSp.graphics.beginFill(0xFFFFFF,0);
			_mediaSp.graphics.drawRect(0, 0, _mediaSp.width ,_mediaSp.height);
			_mediaSp.graphics.endFill();
		}
		
		public function addOneMedia(mediaVO:MediaVO ,num:int):void
		{
			var media:LoaderImage = new LoaderImage();
			media.setWH(187, 105, false ,true);
			media.setPath(mediaVO);
			media.x = Math.ceil(num%3)*244;
			media.y = Math.floor(num/3)*146;
			_mediaSp.addChild(media);
			
			_mediaSp.graphics.clear();
			_mediaSp.graphics.beginFill(0xFFFFFF,0);
			_mediaSp.graphics.drawRect(0, 0, _mediaSp.width ,_mediaSp.height);
			_mediaSp.graphics.endFill();
		}
		
		private function onUserListDown(e:MouseEvent):void
		{
			_userDownX = mouseX;
			_userDownY = mouseY;
			_userTempX = mouseX;
			_userTempY = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onListMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onListUp);
		}
		
		private function onListMove(event:MouseEvent):void
		{
			_mediaSp.y += mouseY - _userDownY;
			_userDownX = mouseX;
			_userDownY = mouseY;
			
			if(_mediaSp.height < _listMask.height)
			{
				TweenLite.to(_mediaSp, 0.5 ,{y:_listMask.y});
				return;
			}
				
			if(_mediaSp.y > _listMask.y)
			{
				TweenLite.to(_mediaSp, 0.5 ,{y:_listMask.y});
			}
			
			if(_mediaSp.y < -(_mediaSp.height - _listMask.height - 30))
			{
				TweenLite.to(_mediaSp, 0.5 ,{y: -(_mediaSp.height - _listMask.height - 30)});
			}
		}
		
		private function onListUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onListMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onListUp);
			
			if(Math.abs(_userTempX-mouseX)<5||Math.abs(_userTempY-mouseY)<5){
				//					trace("是点击",(event.target as LoaderImage).mediaVO.type)
				if(event.target is LoaderImage)
				{
					NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,	(event.target as LoaderImage).mediaVO);
				}
			}
		}
		
		public function dispose():void
		{
			while(_mediaSp.numChildren > 0) 
			{
				if(_mediaSp.getChildAt(0) is LoaderImage)
				{
					(_mediaSp.getChildAt(0) as LoaderImage).dispose();
				}
				_mediaSp.removeChildAt(0);
			}
		}
		
	}
}