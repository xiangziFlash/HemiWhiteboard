package com.views.components
{
	import com.events.MeetsEvent;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.MediaVO;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.scxlib.MediaMenu;
	import com.scxlib.MediaPeiLie;
	import com.views.components.menu.ButtonDoor;
	import com.views.components.menu.ButtonList;
	import com.views.components.menu.Menus;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	
	public class MenuPlugin extends Sprite
	{
		private var _menus:Menus;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _menuID:int =0;
		private var _menuXML:XML;
		private var _menuArr:Array=[];
		
		private var _btnDoor:ButtonDoor;
		private var _menuX:Number=0;
		private var _mediaPaiLie:MediaPeiLie;
		private var _mediaMenu:MediaMenu;
		private var _isRight:Boolean;
		private var _sp:DisplaySprite;
		private var _dataArr:Array=[];//记录只能和私人素材库数据
		
		public function MenuPlugin()
		{
			_sp = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_menus = new Menus();
			_sp.addMenuSprite(_menus);
			
			_menus.filters = [new DropShadowFilter(4,45,0x333333)];
			_menus.visible = false;
			_menuXML = ApplicationData.getInstance().menuXML;
		}
		
		private function initListener():void
		{
			_menus.addEventListener(MouseEvent.MOUSE_DOWN,onMenuDown);
			
		}
		
		public function setMenuLocation(e:MouseEvent):void
		{
//			trace(stage.mouseX,"stage.mouseX");
			_menus.outIn();
			_menus.x = 1500;
			_menus.y = 500;
			_menus.visible = true;
			_menuX = stage.mouseX * ConstData.stageScaleX;
			ApplicationData.getInstance().menuX = _menuX;
		}
		
		private function onMenuDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseY;
			_tempY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			_menus.x +=mouseX-_downX;
			_menus.y +=mouseY-_downY;
			_downX = mouseX;
			_downY = mouseY;
			if(_btnDoor)
			{
				if(_menuX>960)
				{
					_btnDoor.x = _menus.x - 320;
				}else{
					_btnDoor.x = _menus.x + 180;
				}
				if(_mediaPaiLie)
				{
					_mediaPaiLie.setMask(_btnDoor.x-146,_isRight);
				}
			}
		}
		/**
		 * 点击菜单  自动切换到课件
		 */		
		public function zidongQieHuan():void
		{
			addMeetingContent();
		}
		
		private function onUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			if(Math.abs(_tempX-mouseX)<5||Math.abs(_tempY-mouseY)<5)
			{
//				trace(e.target.name,"click",ApplicationData.getInstance().userName)
				if(e.target.name.split("_")[0]=="menuBtn")
				{
					_menuID = e.target.name.split("_")[1];
					if(_menuID==0){
						if(ApplicationData.getInstance().userName=="")
						{
							fengXiData(_menuID);
						}else{
							addMeetingContent();	
						}
					}
					else{
						fengXiData(_menuID);	
					}
					/*else if(_menuID==1){
						fengXiData(_menuID);	
					}else if(_menuID==2){
//						if(!ApplicationData.getInstance().UDiskModel)return;
						fengXiUPanData(2);
					}else if(_menuID==3){
//						if(!ApplicationData.getInstance().UDiskModel)return;
						fengXiUPanData(3);
					}*/
				}else{
					if(e.target.name.split("_")[0]=="hideBtn")
					{
						if(_btnDoor)
						{
							_btnDoor.visible =false;
						}
						
						_menus.inOut();
						if(_mediaPaiLie)
						{
							_mediaPaiLie.visible =false;
							_mediaPaiLie.clearContainer();
						}
						_menus.visible =false;
					}
				}
			}else{
			}
		}
		
		private function onBtnDoorDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseY;
			_tempY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onDoorMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onDoorUp);
		}
		
		private function onDoorMove(e:MouseEvent):void
		{
			_btnDoor.x +=mouseX-_downX;
			//_btnDoor.y +=mouseY-_downY;
			_downX = mouseX;
			_downY = mouseY;
			if(_btnDoor)
			{
				if(_menuX>960)
				{
					_menus.x = _btnDoor.x + 320;
				}else{
					_menus.x = _btnDoor.x - 180;
				}
				if(_mediaPaiLie)
				{
					_mediaPaiLie.setMask(_btnDoor.x-146,_isRight);
				}
			}
		}
		
		private function onDoorUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDoorMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onDoorUp);
		}
		
		private function addMeetingContent():void
		{
//			trace(ApplicationData.getInstance().nowLessonXML,"++++");
			_menuArr=[];
			for (var i:int = 0; i < ApplicationData.getInstance().nowLessonXML.list.length(); i++) 
			{
				var vo:MediaVO = new MediaVO();
				vo.title = ApplicationData.getInstance().nowLessonXML.list[i].@title;
				vo.type = ApplicationData.getInstance().nowLessonXML.list[i].@type;
				vo.path = ApplicationData.getInstance().nowLessonXML.list[i].@path;
				_menuArr.push(vo);
			}	
			
			for (var j:int = 0; j < _menuXML.item[0].item.length(); j++) 
			{
				var vo1:MediaVO = new MediaVO();
				vo1.title = _menuXML.item[0].item[j].@cname;
				vo1.type = _menuXML.item[0].item[j].@type;
				vo1.path = _menuXML.item[0].item[j].@path;
				_menuArr.push(vo1);
			}	
			addMenuDoor();
		}
		
		private function fengXiUPanData(id:int):void
		{
			_menuArr=[];
			var vo:MediaVO = new MediaVO();
			if(id==2)
			{
				/*vo.title = ApplicationData.getInstance().userXML.type[1].item[0].@title;
				vo.type = ApplicationData.getInstance().userXML.type[1].item[0].@type;
				vo.path = ApplicationData.getInstance().userXML.type[1].item[0].@path;*/
				if(ApplicationData.getInstance().currLessonXML==null)return;
				if(ApplicationData.getInstance().currLessonXML.geRenSuCai.item.@type==undefined)return;
				vo.title = "个人素材库";
				vo.type = ApplicationData.getInstance().currLessonXML.geRenSuCai.item.@type;
				vo.path = ApplicationData.getInstance().currLessonXML.geRenSuCai.item.@path;
			}else if(id==3){
				if(ApplicationData.getInstance().userXML==null)return;
				if(ApplicationData.getInstance().userXML.type[2].item[0].@title==undefined)return;
				vo.title = ApplicationData.getInstance().userXML.type[2].item[0].@title;
				vo.type = ApplicationData.getInstance().userXML.type[2].item[0].@type;
				vo.path = ApplicationData.getInstance().userXML.type[2].item[0].@path;
			}
			_menuArr.push(vo);
			addMenuDoor();
		}
		
		private function fengXiData(id:int):void
		{
			_menuArr=[];
			for (var i:int = 0; i < _menuXML.item[id].item.length(); i++) 
			{
				var vo:MediaVO = new MediaVO();
				vo.title = _menuXML.item[id].item[i].@cname;
				vo.type = _menuXML.item[id].item[i].@type;
				vo.path = _menuXML.item[id].item[i].@path;
				_menuArr.push(vo);
			}	
			addMenuDoor();
		}
		
		private function addMenuDoor():void
		{
			if(_btnDoor==null)
			{
				_btnDoor = new ButtonDoor();
				_btnDoor.visible = false;
//				_sp.addMenuSprite(_btnDoor);
				this.addChild(_btnDoor);
				_btnDoor.addEventListener(MeetsEvent.OPEN_MEDIAS,onBtnDoorOpenMedia);
				_btnDoor.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDoorDown);
			}
			if(_menuX>960)
			{
				_isRight = true;
				_btnDoor.x = _menus.x - 320;
			}else{
				_isRight =false;
				_btnDoor.x = _menus.x + 180;
			}
			_btnDoor.visible = true;
			_btnDoor.setArr(_menuArr);
		}
		
		private function onBtnDoorOpenMedia(e:MeetsEvent):void
		{
			if(_mediaPaiLie==null)
			{
				_mediaPaiLie = new MediaPeiLie();
				_mediaPaiLie.x = 146;
				_mediaPaiLie.y = 136;
				this.addChildAt(_mediaPaiLie,0);
				_mediaPaiLie.visible = false;
			}
			_mediaPaiLie.setMask(_btnDoor.x-146,_isRight);
			_mediaPaiLie.setArr(e.arr);
			_mediaPaiLie.visible = true;
		}
		
		private function onBtnDoorOpenMediaMenu(e:MeetsEvent):void
		{
//			trace("事件已接收")
			if(_mediaMenu==null)
			{
				_mediaMenu = new MediaMenu();
				_mediaMenu.x = 146;
				_mediaMenu.y = 136;
				this.addChildAt(_mediaMenu,0);
				_mediaMenu.visible = false;
			}
			_mediaMenu.setMask(_btnDoor.x-146,_isRight);
			_mediaMenu.setArr(e.arr);
			_mediaMenu.visible = true;
		}
	}
}