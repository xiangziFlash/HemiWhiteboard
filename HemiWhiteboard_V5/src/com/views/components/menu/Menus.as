package com.views.components.menu
{
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.tweener.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.net.FileFilter;

	/**
	 * 
	 * @author 祥子
	 * 白板菜单
	 */	
	public class Menus extends Sprite
	{
		private var _menuBtn:MenuButton;
		private var _hideBtn:HideBtnRes;
		private var _btnArr:Array=[];
		private var _isClick:Boolean;
		private var _arrXY:Array = [new Point(-39.85,-158.4),new Point(81.2,-39.85),new Point(-39.85,78.7),new Point(-160.9,-39.85)];
		private var _menuXML:XML;
		private var _menuArr:Array=[];
		
		public function Menus()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_hideBtn = new HideBtnRes();
			_hideBtn.name = "hideBtn_";
			_hideBtn.x = -68.5;
			_hideBtn.y = -68.55;
			
			this.addChild(_hideBtn);
			
//			_hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClick);
			addButton();
			
		}
		
		private function addButton():void
		{
			_menuXML  = ApplicationData.getInstance().menuXML;
			_menuArr=[];
			_btnArr=[];
			for (var i:int = 0; i < _menuXML.item.length(); i++) 
			{
				var mediaVO:MediaVO = new MediaVO();
				mediaVO.title = _menuXML.item[i].@cname;
				mediaVO.path = ApplicationData.getInstance().assetsPath+_menuXML.item[i].@ico;
				mediaVO.thumb =ApplicationData.getInstance().assetsPath+ _menuXML.item[i].@ico;
				_menuArr.push(mediaVO);
			}
			
			for (var j:int = 0; j < _menuArr.length; j++) 
			{
				var menuBtn:MenuButton = new MenuButton();
				menuBtn.name = "menuBtn_"+j;
				menuBtn.setVO(_menuArr[j] as MediaVO);
				menuBtn.x = menuBtn.y=0;
				_btnArr.push(menuBtn);
				this.addChild(menuBtn);
			}
			outIn();
		}

		public function outIn():void
		{
			for (var i:int = 0; i < _btnArr.length; i++) 
			{
				Tweener.removeTweens(_btnArr[i]);
				Tweener.addTween(_btnArr[i]as MenuButton,{x:_arrXY[i].x,y:_arrXY[i].y,scaleX:1,scaleY:1,visible:true,time:0.8,delay:0.05*i})
			}
		}
		
		public function inOut():void
		{
			for (var i:int = 0; i < _btnArr.length; i++) 
			{
				Tweener.removeTweens(_btnArr[i]);
				Tweener.addTween(_btnArr[i]as MenuButton,{x:0,y:0,time:0.8,delay:0.05*i,visible:false,scaleX:0,scaleY:0});
			}
		}
	}
}
