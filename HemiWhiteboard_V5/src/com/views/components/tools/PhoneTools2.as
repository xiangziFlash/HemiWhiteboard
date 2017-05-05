package com.views.components.tools
{
	import com.models.ApplicationData;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.components.DisplaySprite;
	import com.views.components.panel.GongSiXiangCePanel;
	import com.views.components.panel.GongZhuPanel;
	import com.views.components.panel.SetDiWenBtn;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class PhoneTools2 extends Sprite
	{
		private var _phoneTools2Res:PhoneTools2Res;
		private var _gongSiXiangCe:GongSiXiangCePanel;
		private var _disSprite:DisplaySprite;
		private var _setWenLiPanel:SetDiWenBtn;
		private var _gongZhuPanel:GongZhuPanel;
		
		public function PhoneTools2()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_disSprite = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			_phoneTools2Res = new PhoneTools2Res();
			this.addChild(_phoneTools2Res);
			_phoneTools2Res.cacheAsBitmap = true;
			_phoneTools2Res.menuSuoBtn.gotoAndStop(1);
			_phoneTools2Res.fangDaBtn.gotoAndStop(1);
			_phoneTools2Res.hideShowBtn.gotoAndStop(1);
//			_phoneTools2Res.addEventListener(MouseEvent.CLICK,onToolsClick);
			_phoneTools2Res.addEventListener(MouseEvent.MOUSE_DOWN,onToolsDown);
		}
		
		private function onToolsDown(event:MouseEvent):void
		{
//			trace(event.target.name,"event.target.name");
			if(event.target.name=="fangDaBtn"||event.target.name=="suoXiaoBtn")
			{
				(event.target as MovieClip).alpha = 0.5;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,onToolsUp);
		}
		
		private function onToolsUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onToolsUp);
			switch(e.target.name)
			{
				case "iptidBtn":
				{
					NotificationFactory.sendNotification(NotificationIDs.CHANGE_IPTID_MODEL);
					NotificationFactory.sendNotification(NotificationIDs.TUYA_BEGIN);
					break;
				}
				case "menuSuoBtn":
				{
					if((e.target as MovieClip).currentFrame==1)
					{
						ApplicationData.getInstance().isLock =true;
						(e.target as MovieClip).gotoAndStop(2);
					}else{
						ApplicationData.getInstance().isLock =false;
						(e.target as MovieClip).gotoAndStop(1);
					}
					NotificationFactory.sendNotification(NotificationIDs.TONGBU_BTN,(e.target as MovieClip).currentFrame);
					break;
				}
				case "hideShowBtn":
				{
					if((e.target as MovieClip).currentFrame==1)
					{
						(e.target as MovieClip).gotoAndStop(2);
					}else{
						(e.target as MovieClip).gotoAndStop(1);
					}
					NotificationFactory.sendNotification(NotificationIDs.HIDE_SHOW_MENU,(e.target as MovieClip).currentFrame);
					break;
				}
				case "fangDaBtn":
				{
					(e.target as MovieClip).alpha = 1;
					NotificationFactory.sendNotification(NotificationIDs.FANGDAJING,0);
					break;
				}
				
				case "suoXiaoBtn":
				{
					(e.target as MovieClip).alpha = 1;
					NotificationFactory.sendNotification(NotificationIDs.FANGDAJING,1);
					break;
				}
					
				case "minBtn":
				{
					NotificationFactory.sendNotification(NotificationIDs.MINI_WINDOWN);
					break;
				}
				case "zhengLiBtn":
				{
					gongJuLanPanle();
					break;
				}
					
				case "geZiBtn":
				{
					if(_setWenLiPanel==null)
					{
						_setWenLiPanel = new SetDiWenBtn();
						_setWenLiPanel.scaleX = _setWenLiPanel.scaleY = 3;
						_setWenLiPanel.rotation = 180;
						_setWenLiPanel.x = 750;
						_setWenLiPanel.y = 122-_setWenLiPanel.height;
						_disSprite.addMidSprite(_setWenLiPanel);
						_setWenLiPanel.visible = false;
					}
					Tweener.addTween(_setWenLiPanel,{y:122+_setWenLiPanel.height,visible:true,time:0.5,onComplete:wenLiMoveEnd});
					
					function wenLiMoveEnd():void
					{
						_disSprite.addPanelSprite(_setWenLiPanel);
					}
					break;
				}
				case "gongZhuBtn":
				{
					if(_gongZhuPanel==null)
					{
						_gongZhuPanel = new GongZhuPanel();
						_gongZhuPanel.scaleX = _gongZhuPanel.scaleY = 3;
						_gongZhuPanel.x = 610;
						_gongZhuPanel.y = 119-_gongZhuPanel.height;
						_gongZhuPanel.rotation = 180;
						_disSprite.addMidSprite(_gongZhuPanel);
						_gongZhuPanel.visible = false;
						_gongZhuPanel.gotoStop(2);
					}else{
						_gongZhuPanel.gotoStop(2);
					}
					Tweener.addTween(_gongZhuPanel,{y:119+_gongZhuPanel.height,visible:true,time:0.5,onComplete:gongZhuMoveEnd});
						
					function gongZhuMoveEnd():void
					{
						_disSprite.addPanelSprite(_gongZhuPanel);
					}
					break;
				}
			}
		}
					
		public function gongJuLanPanle():void
		{
			if(_gongSiXiangCe==null)
			{
				_gongSiXiangCe = new GongSiXiangCePanel();
				_gongSiXiangCe.scaleX = _gongSiXiangCe.scaleY = 2;
				_gongSiXiangCe.x = 327;
				_gongSiXiangCe.y = 0;
				_gongSiXiangCe.visible = false;
				_disSprite.addPanelSprite(_gongSiXiangCe);
			}
			_gongSiXiangCe.reset();
			if(_gongSiXiangCe.y ==176)
			{
				_disSprite.addMidSprite(_gongSiXiangCe);
				Tweener.addTween(_gongSiXiangCe,{x:327,y:0,visible:true,time:0.5});
			}else{
				Tweener.addTween(_gongSiXiangCe,{x:327,y:176,visible:true,time:0.5});
				_disSprite.addPanelSprite(_gongSiXiangCe);
				_gongSiXiangCe.showCon();
			}
		}
		
		public function hideGongSiPanel(boo:Boolean):void
		{
			if(_gongSiXiangCe)
			{
				_disSprite.addMidSprite(_gongSiXiangCe);
				Tweener.addTween(_gongSiXiangCe,{x:327,y:0,visible:false,time:0.5});
			}	
		}
		
		/**
		 * 
		 *隐藏所有弹出来的panel 
		 */					
		public function hidePanel():void
		{
			if(_gongZhuPanel)
			{
				_disSprite.addMidSprite(_gongZhuPanel);
				Tweener.addTween(_gongZhuPanel,{y:119-_gongZhuPanel.height,visible:false,time:0.5});
			}
			
			if(_setWenLiPanel)
			{
				_disSprite.addMidSprite(_setWenLiPanel);
				Tweener.addTween(_setWenLiPanel,{y:122-_setWenLiPanel.height,visible:false,time:0.5});
			}
		}
		
		public function gotoStop(id:int):void
		{
			_phoneTools2Res.menuSuoBtn.gotoAndStop(id);
		}
		
		public function gotoHideShowBtnStop(id:int):void
		{
			_phoneTools2Res.hideShowBtn.gotoAndStop(id);
		}
	}
}