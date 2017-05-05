package com.views.components.menu
{
	import com.events.MeetsEvent;
	import com.models.vo.MediaVO;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ButtonDoor extends Sprite
	{
		private var _doorRes:DoorRes;
		private var _spBtn:Sprite;
		private var _tempH:int;
		private var _btnArr:Array=[];
		private var _tempH1:Number=0;
		private var _tempBtn:ButtonList;
		private var _listID:int;
		private var _menuX:Number=0;
		
		public function ButtonDoor()
		{
			_doorRes = new DoorRes();
			this.addChild(_doorRes);
			
			_spBtn = new Sprite();
			this.addChild(_spBtn);
		}
		
		public function setArr(arr:Array):void
		{
			while(_spBtn.numChildren>0)
			{
				_spBtn.removeChildAt(0);
			}
			_btnArr=[];
			_tempH=0;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var btnList:ButtonList = new ButtonList();
				btnList.name = "btnList_"+i;
				btnList.setVO(arr[i] as MediaVO);
				btnList.y = _tempH;
				_tempH += btnList.stageHeight+5;
				_spBtn.addChild(btnList);
				_btnArr.push(btnList);
				btnList.addEventListener(Event.CHANGE,onBtnListChange);
				btnList.addEventListener(MeetsEvent.OPEN_MEDIAS,onOpenMedia);
				btnList.addEventListener(MeetsEvent.OPEN_MEDIAS_MENU,onOpenMediaMenu);
			}
			_spBtn.x = (122-101)*0.5;
			_spBtn.y = (1080-_spBtn.height)*0.5;
		}
		
		private function onOpenMediaMenu(e:MeetsEvent):void
		{
			var eve:MeetsEvent = new MeetsEvent(MeetsEvent.OPEN_MEDIAS_MENU);
			eve.arr = e.arr;
			this.dispatchEvent(eve);
		}
		
		public function setMenuX(menux:Number):void
		{
			_menuX = menux;
		}
		
		private function onBtnListChange(e:Event):void
		{
			_listID = e.target.name.split("_")[1];
			_tempH1=0
			_spBtn.graphics.clear();
			for (var i:int = 0; i < _btnArr.length; i++) 
			{
				if(i!=_listID)
				{
					_btnArr[i].closeBtn();
				}
				_btnArr[i].y = _tempH1;
				_tempH1 += _btnArr[i].stageHeight+5;
			}
			_spBtn.x = (122-101)*0.5;
			_spBtn.y = (1080-_spBtn.height)*0.5;
		}
		
		private function onOpenMedia(e:MeetsEvent):void
		{
			var eve:MeetsEvent = new MeetsEvent(MeetsEvent.OPEN_MEDIAS);
			eve.arr = e.arr;
			this.dispatchEvent(eve);
		}

		public function get menuX():Number
		{
			return _menuX;
		}

	}
}