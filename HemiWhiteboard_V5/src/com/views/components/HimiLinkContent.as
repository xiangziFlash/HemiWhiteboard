package com.views.components
{
	import com.events.ChangeEvent;
	import com.greensock.TweenLite;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.res.AppleRes;
	import com.scxlib.OppMedia;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	
	public class HimiLinkContent extends Sprite
	{
		private var _medias:Array=[];
		private var _tempX:Number;
		private var _tempOppY:Number;
		private var _tempR:Number;
		private var _tempScaleX:Number;
		private var _tempScaleY:Number;
//		private var _apple:AppleRes;
		private var _index:int;
		private var _arrXY:Array = [new Point(672,18),new Point(1282,378),new Point(672,734),new Point(66,378)];
		private var _link:String = "";

		private var _thumb:Loader;
		
		public function HimiLinkContent()
		{
			//_apple = new AppleRes();
			//this.addChild(_apple);
		}
		
		public function gotoPlay(thumb:String,link:String):void
		{
		//	trace(thumb);
			_link = link;
			/*_thumb = new Loader();
			_thumb.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEnd);
			_thumb.contentLoaderInfo.addEventListener(ErrorEvent.ERROR,onLdrError);
			_thumb.load(new URLRequest(thumb));*/
			var vo:MediaVO = new MediaVO();
			vo.isBmpd = false;
			vo.thumb = thumb;
			vo.path = thumb;
			vo.isHimi = true;
			vo.himiLink = link;
			
			var oppMedia:OppMedia = new OppMedia();
			oppMedia.name ="oppMedia";
			oppMedia.addEventListener(Event.COMPLETE,onComplete1);
			oppMedia.addEventListener(Event.CLOSE,onOppMediaClose);
			oppMedia.addEventListener(Event.FULLSCREEN,onOppMediaFull);
			oppMedia.addEventListener(Event.CHANGE,onOppMediaFullClose);
			oppMedia.addEventListener(ChangeEvent.FIT_WEIZHI,onFitWeiZhi);
			oppMedia.setPath(vo,false);
		}
		
		private function onComplete1(event:Event):void
		{
			var tempOpp:OppMedia = event.target  as OppMedia;
			tempOpp.scaleX = tempOpp.scaleY = 0.3
			var midX:Number = (1920 - 1920*0.3)*0.5;
			var midY:Number = (1080 - 1080*0.3)*0.5;
			tempOpp.x = -100;
			tempOpp.y = midY;
			ConstData.spCon.addMediaSprite(tempOpp);
			
			TweenLite.to(tempOpp,0.5,{x:midX});
			
//			trace(ApplicationData.getInstance().assetsPath+_link);
			loadData(ApplicationData.getInstance().assetsPath+_link);
		}
		
		private function onLdrError(event:Event):void
		{
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"同步素材失败，软件已损坏");
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},1000);
		}
		
		private function onLdrEnd(event:Event):void
		{
			var ldr:Bitmap = event.target.content;
			ldr.smoothing = true;
			var midX:Number = (1920 - ldr.width)*0.5;
			var midY:Number = (1080 - ldr.height)*0.5;
			ldr.x = -100;
			ldr.y = midY;
			this.addChild(ldr);
			
			TweenLite.to(ldr,0.5,{x:midX});
			
//			trace(ApplicationData.getInstance().assetsPath+_link);
			loadData(ApplicationData.getInstance().assetsPath+_link);
		}
		
		private function loadData(str:String):void
		{
			var urlLdr:URLLoader = new URLLoader(new URLRequest(str));
			urlLdr.addEventListener(Event.COMPLETE,onDataEnd);
			urlLdr.addEventListener(ErrorEvent.ERROR,onDataError);
		}
		
		private function onDataError(event:Event):void
		{
			trace("onDataError");
		}
		
		private function onDataEnd(event:Event):void
		{
			_index = 0;
			_medias.length = 0;
			var vos:Vector.<MediaVO> = new Vector.<MediaVO>;
			var xml:XML = new XML(event.target.data);
			for (var i:int = 0; i < xml.item.length(); i++) 
			{
				var mediaVO:MediaVO = new MediaVO();
				mediaVO.type = xml.item[i].@type;
				mediaVO.path = ApplicationData.getInstance().assetsPath + xml.item[i].@path;
				mediaVO.thumb = ApplicationData.getInstance().assetsPath + xml.item[i].@thumb;
				mediaVO.isBmpd = false;
				mediaVO.isServer = false;
				vos.push(mediaVO);
			}
			loadContent(vos);
		}
		
		private function loadContent(vos:Vector.<MediaVO>):void
		{
			for (var i:int = 0; i < vos.length; i++) 
			{
				oppMedia(vos[i]);
			}
			
		}
		
		private function playAnimation():void
		{
			for (var i:int = 0; i < _medias.length; i++) 
			{
				ConstData.spCon.addMediaSprite(_medias[i]);
				TweenLite.to(_medias[i],0.5,{delay:i*0.3,scaleX:0.3,scaleY:0.3,alpha:1,x:_arrXY[i].x,y:_arrXY[i].y});
			}
			
			setTimeout(function ():void
			{
				if(_thumb)
				{
					if(_thumb.content)
					{
						(_thumb.content as Bitmap).bitmapData.dispose();
					}
					_thumb.unloadAndStop();
					_thumb = null;
				}
			},2000);
		}
		
		private function oppMedia(vo:MediaVO):void
		{
			var oppMedia:OppMedia = new OppMedia();
			oppMedia.name ="oppMedia";
			//this.addChild(oppMedia);
			oppMedia.alpha = 0;
//			oppMedia.scaleX = oppMedia.scaleY = 0.1;
			oppMedia.addEventListener(Event.COMPLETE,onComplete);
			oppMedia.addEventListener(Event.CLOSE,onOppMediaClose);
			oppMedia.addEventListener(Event.FULLSCREEN,onOppMediaFull);
			oppMedia.addEventListener(Event.CHANGE,onOppMediaFullClose);
			oppMedia.addEventListener(ChangeEvent.FIT_WEIZHI,onFitWeiZhi);
			oppMedia.setPath(vo,false);
		}
		
		private function onComplete(e:Event):void
		{
			_index ++;
			var tempOppMedia:OppMedia = (e.target as OppMedia);
			tempOppMedia.scaleX = tempOppMedia.scaleY = 0.1;
			tempOppMedia.x = (1920 - tempOppMedia.width) *0.5;
			tempOppMedia.y = (1080 - tempOppMedia.height) *0.5;
			_medias.push(tempOppMedia);
//			trace(_index, _medias.length);
			if(_index == _medias.length)
			{
				setTimeout(function ():void
				{
					playAnimation();
				},10);
			}
		}
		
		/**
		 * 弹出媒体关闭
		 * @param e
		 * 
		 */		
		private function onOppMediaClose(e:Event):void
		{
			var pad:OppMedia = e.target as OppMedia;
			if(e.target.hasMinisize){
				removeOppMedia(pad);
				//				_boardThumb.removeDisplayThumb(pad);
			}else{
				removeOppMedia(pad);
			}
		}
		
		private function removeOppMedia(obj:OppMedia):void
		{
		//	_historyCon.addThumb(obj.mediaVO);
			obj.removeEventListener(Event.COMPLETE,onComplete);
			obj.removeEventListener(Event.CLOSE,onOppMediaClose);
			obj.removeEventListener(Event.FULLSCREEN,onOppMediaFull);
			obj.removeEventListener(Event.CHANGE,onOppMediaFullClose);
			obj.removeDownEvent();
			obj.removeEventListener(ChangeEvent.FIT_WEIZHI,onFitWeiZhi);
			obj.reset();
			if(obj!=null){
				if(obj.parent==null)return;
				obj.parent.removeChild(obj);
			}
		}
		
		/**
		 *弹出媒体全屏 
		 * @param e
		 * 
		 */		
		private function onOppMediaFull(e:Event):void
		{
			Tweener.removeTweens((e.target as OppMedia));
			_tempX = (e.target as OppMedia).x;
			_tempOppY = (e.target as OppMedia).y;
			_tempR = (e.target as OppMedia).rotation;
			_tempScaleX = (e.target as OppMedia).scaleX;
			_tempScaleY = (e.target as OppMedia).scaleY;
			if((e.target as OppMedia).rotationY == 0)
			{
				(e.target as OppMedia).resetXY();
				(e.target as OppMedia).scaleX = (e.target as OppMedia).scaleY = 1;
				(e.target as OppMedia).x = 0;
				(e.target as OppMedia).y = 0;
				(e.target as OppMedia).rotation = 0;
				(e.target as OppMedia).fullScreen();
			} else {
				(e.target as OppMedia).setMediaXYCenter();
				(e.target as OppMedia).scaleX = (e.target as OppMedia).scaleY = 1;
				(e.target as OppMedia).x = 1920*0.5;
				(e.target as OppMedia).y = 1080*0.5;
				(e.target as OppMedia).rotation = 0;
				(e.target as OppMedia).fullScreen();
			}
		}
		
		private function onFitWeiZhi(e:ChangeEvent):void
		{
			(e.target as OppMedia).resetXY();
			(e.target as OppMedia).scaleX = (e.target as OppMedia).scaleY = 0.5;
			(e.target as OppMedia).x = 1920*0.25;
			(e.target as OppMedia).y = 1080*0.25;
			(e.target as OppMedia).rotation = 0;
			(e.target as OppMedia).closeFullScreen();
			if(!(e.target as OppMedia).isLock){
			}
		}
		
		private function onOppMediaFullClose(e:Event):void
		{
			(e.target as OppMedia).closeFullScreen();
			(e.target as OppMedia).x = _tempX;
			(e.target as OppMedia).y = _tempOppY;
			(e.target as OppMedia).scaleX = _tempScaleX;
			(e.target as OppMedia).scaleY = _tempScaleY;
			(e.target as OppMedia).rotation = _tempR;
		}
	}
}