package com.views.components.menu
{
	import com.models.vo.MediaVO;
	import com.tweener.transitions.Tweener;
	import com.views.components.Album;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MeunMC extends Sprite
	{
		private var _menuMC:MenuMCRes;
		private var _downPoint:Point;
		private var _tempPoint:Point;
		private var _radians:Number=0;
		private var _angle:Number=0;
		private var _albumBian:AlbumBianRes;
		private var _urlLdr:URLLoader;
		private var _xml:XML;
		private var _arr:Array=[];
		private var _album:Album;
		
		public function MeunMC()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_menuMC = new MenuMCRes();
			this.addChild(_menuMC);
			
//			_albumBian = new AlbumBianRes();
			//this.addChild(_albumBian);
			_urlLdr = new URLLoader();
			_urlLdr.load(new URLRequest("assets/xmls/album.xml"));
			_urlLdr.addEventListener(Event.COMPLETE,onXmlEnd);
			
			
			_album = new Album();
//			_album.x = 1000;
			this.addChild(_album);
			_album.rotation = 180;
			_album.visible = false;
			chuShi();
			_menuMC.mc.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		
		private function onXmlEnd(e:Event):void
		{
			_xml = new XML(e.target.data);
			_arr=[];
			for (var i:int = 0; i < _xml.item.length(); i++) 
			{
				var mediaVO:MediaVO = new MediaVO();
				mediaVO.path = _xml.item[i].@path;
				mediaVO.thumb = _xml.item[i].@thumb;
				_arr.push(mediaVO);
			}
			
		}
		
		private function chuShi():void
		{
			_menuMC.huan.visible = false;
			_menuMC.bian.visible = false;
			_menuMC.huan.alpha = 0;
			_menuMC.bian.alpha = 0;
			_menuMC.bian.rotation = 0;
			_menuMC.huan.scaleX = _menuMC.huan.scaleY = 0;
			_album.scaleX = _album.scaleY = 0;
		}
		
		private function onDown(e:MouseEvent):void
		{
			Tweener.addTween(_menuMC.huan,{x:0,y:0,scaleX:1,scaleY:1,time:0.5,visible:true,alpha:1,transition:"easeInOutCubic"});
			//Tweener.addTween(_menuMC.bian,{scaleX:1,scaleY:1,time:1,delay:0.5,rotation:180,visible:true,alpha:1,transition:"easeInOutCubic"});
			Tweener.addTween(_album,{scaleX:1,scaleY:1,time:1,delay:0.5,rotation:0,visible:true,alpha:1,transition:"easeInOutCubic"});
			_menuMC.huan.gotoAndPlay(1);
//			_albumBian.visible = true;
			_album.setArr(_arr);
			_downPoint = new Point(mouseX,mouseY);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			_tempPoint = new Point(mouseX,mouseY);
			_radians = Math.atan2((_downPoint.y-_tempPoint.y),(_downPoint.x-_tempPoint.x));
			_angle = _radians * 180/Math.PI;
			//trace(1-Math.sin(_radians),"tan")
		}
		
		private function onUp(event:MouseEvent):void
		{
			//Tweener.addTween(_menuMC.huan,{x:0,y:0,scaleX:0,scaleY:0,time:0.5,visible:false,alpha:0,transition:"easeInOutCubic"});
			//Tweener.addTween(_menuMC.bian,{scaleX:0,scaleY:0,time:0.5,rotation:0,visible:false,alpha:0,transition:"easeInOutCubic"});
		//	_menuMC.huan.gotoAndStop(1);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			
		}
	}
}