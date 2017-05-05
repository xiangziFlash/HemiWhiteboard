package com.views.components
{
	import com.controls.ToolKit;
	import com.events.ChangeEvent;
	import com.events.DragEvent;
	import com.lylib.utils.MathUtil;
	import com.models.ApplicationData;
	import com.models.vo.FullShowAppVO;
	import com.models.vo.MediaVO;
	import com.models.vo.TuXingVO;
	import com.models.vo.XiangCeVO;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.notification.SimpleNotification;
	import com.scxlib.MediaPeiLie;
	import com.scxlib.OppMedia;
	import com.tweener.transitions.Tweener;
	import com.views.components.camera.CameraLuZhi;
	import com.views.components.camera.CameraWindow;
	import com.views.components.yuLan.YuLanPlugin;
	import com.windows.MinAppWindow;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;

	/**
	 * 
	 * @author 祥子
	 * 接受到发送消息的命令后  处理消息
	 */	
	public class ReceiveNotification extends Sprite implements ILogic
	{
		static public const NAME:String="ReceiveNotification";
		
		private var _sp:DisplaySprite;
		private var _menuPlugin:MenuPlugin;
		private var _oppMediaArr:Array=[];
		private var _tempX:Number;
		private var _tempOppY:Number;
		private var _tempR:Number;
		private var _tempScaleX:Number;
		private var _tempScaleY:Number;
		
		private var _mediaYuLan:YuLanPlugin;
		private var _huanDengModel:HuanDengModel;
		private var _nowModelID:int=4;
		private var _historyCon:HistoryContent;
		
		private var _videoLuZhi:CameraLuZhi;
		private var _cator:CatorContainer;
		private var _clockMC:ShowTime;
		
		private var _readJiaoAn:ReadJiaoAn;
		private var _cameraWin:CameraWindow;
		private var fullWin:MinAppWindow;
		
		public function ReceiveNotification()
		{
			_sp = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			
			_historyCon = new HistoryContent();
			_historyCon.scaleX = _historyCon.scaleY = 1.5;
			_historyCon.x = 1790-45;
			_historyCon.y = 965-38;
			_sp.addPanelSprite(_historyCon);
		}
		
		public function getLogicName():String
		{
			return NAME;
		}
		
		public function handleNotification(notification:SimpleNotification):void
		{
			switch(notification.getId())
			{
				case NotificationIDs.CLEAR_ALL:
				{
					while(_sp.mediaSprite.numChildren > 0){
						if(_sp.mediaSprite.getChildAt(0) is OppMedia){
							removeOppMedia(_sp.mediaSprite.getChildAt(0) as OppMedia);
						}
					}
					break;
				}
				
				case NotificationIDs.HUANDENG_PAGEMOVE:
				{
					var key:String = String(notification.getBody());
					if(_huanDengModel)
					{
						_huanDengModel.gotoPage(key);
					}
					break;
				}
				
				case NotificationIDs.CHANGE_PHONE_MODEL:
				{
					_historyCon.x = 1800-_historyCon.width-10;
					_historyCon.y = 850-42;
					break;
				}
					
				case NotificationIDs.READ_JIAOAN:
				{
					if(_mediaYuLan)
					{
						_mediaYuLan.visible = false;
					}
					if(_readJiaoAn==null)
					{
						_readJiaoAn = new ReadJiaoAn();
						_readJiaoAn.x = (1920-_readJiaoAn.width)*0.5;
						_readJiaoAn.y = (1080-_readJiaoAn.height)*0.5;
						_sp.addTopSprite(_readJiaoAn);
						_readJiaoAn.visible = false;
					}
					_readJiaoAn.visible= true;
					_readJiaoAn.setJiaoAn(String(notification.getBody()));
					break;
				}
					
				case NotificationIDs.TUYA_BEGIN:
				{
					_huanDengModel.showTiShi();
					break;
				}
				
				case NotificationIDs.STAGE_DOUBLE_CLICK:
				{
					if(_menuPlugin==null)
					{
						_menuPlugin = new MenuPlugin();
						_menuPlugin.visible = false;
						_sp.addMidSprite(_menuPlugin);
					}
					_menuPlugin.visible = true;
					_menuPlugin.setMenuLocation(notification.getBody()as MouseEvent);
					break;
				}
					
				case NotificationIDs.ZIDONG_CHANGELESSON:
				{
					_menuPlugin.zidongQieHuan();
					break;
				}
				
				case NotificationIDs.OPP_MEDIA:
				{
					oppMedia(notification.getBody() as MediaVO);
					break;
				}
					
				case NotificationIDs.MEDIA_PREVIEW:
				{
					if(_readJiaoAn)
					{
						_readJiaoAn.visible= false;
					}
					if(_mediaYuLan==null)
					{
						_mediaYuLan = new YuLanPlugin();
//						_mediaYuLan.x = (1920-_mediaYuLan.width)*0.5;
//						_mediaYuLan.y = (1080-_mediaYuLan.height)*0.5;
						_mediaYuLan.addEventListener(Event.CLOSE,onMediaYuLan);
						_sp.addTopSprite(_mediaYuLan);
					}
					_mediaYuLan.visible = true;
					_mediaYuLan.setArr(notification.getBody().arr,notification.getBody().id);
					break;
				}
					
				case NotificationIDs.CAMERA_VIDEO_LUZHI:
				{
					/*
					if(!fullWin){
						fullWin=new MinAppWindow();
						fullWin.addEventListener(Event.CLOSE,onWinClose);
						fullWin.openApp(notification.getBody() as FullShowAppVO);
						ApplicationData.getInstance().videoWin = fullWin;
					}
					if(fullWin.closed){
						fullWin = new MinAppWindow();
						fullWin.addEventListener(Event.CLOSE,onWinClose);
						fullWin.openApp(notification.getBody() as FullShowAppVO);
						ApplicationData.getInstance().videoWin = fullWin;
					}		*/		
					if(_videoLuZhi==null)
					{
						_videoLuZhi = new CameraLuZhi();
						_videoLuZhi.x = 10;
						_videoLuZhi.y = 10;
						_sp.addPanelSprite(_videoLuZhi);
						_videoLuZhi.visible = false;
						_videoLuZhi.scaleX = _videoLuZhi.scaleY = Math.min(1094/1920,820/1080);
						_videoLuZhi.x = (1920-_videoLuZhi.width)*0.5;
						_videoLuZhi.y = (1080-_videoLuZhi.height)*0.5;
						_videoLuZhi.addEventListener(Event.CLOSE,onCameraPhotographClose);
					}
					_videoLuZhi.scaleX = _videoLuZhi.scaleY = Math.min(1094/1920,820/1080);
					_videoLuZhi.x = (1920-_videoLuZhi.width)*0.5;
					_videoLuZhi.y = (1080-_videoLuZhi.height)*0.5;
					_videoLuZhi.startCamera();
					_videoLuZhi.alpha = 1;
					_videoLuZhi.visible =true;
					break;
				}
					
				case NotificationIDs.CHANGE_IPTID_MODEL:
				{
					_historyCon.x = 1790-50;
					_historyCon.y = 965-42;
					break;
				}
					
				case NotificationIDs.HUANDENGMODEL:
				{
//					trace((notification.getBody() as XiangCeVO).isLock,(notification.getBody() as XiangCeVO).modelID,"(notification.getBody() as XiangCeVO)");
					if(_huanDengModel==null)
					{
						_huanDengModel = new HuanDengModel();
						_huanDengModel.addEventListener(Event.CLOSE,onXiangCeClose);
						_sp.addPanelSprite(_huanDengModel);
					}
					
					if(!(notification.getBody() as XiangCeVO).isVisible)
					{
						Tweener.addTween(_huanDengModel,{x:1540,y:943,scaleX:0.05,scaleY:0.05,time:0.5,visible:false});
						return;
					}else{
						Tweener.addTween(_huanDengModel,{x:0,y:0,scaleX:1,scaleY:1,time:0.5,visible:true});
					}
					
					if((notification.getBody() as XiangCeVO).isModel)
					{
						if((notification.getBody() as XiangCeVO).modelID==5)return;
						_huanDengModel.fengXiMedia();
//						(notification.getBody() as XiangCeVO).modelID = _huanDengModel.modelID;
						if((notification.getBody() as XiangCeVO).modelID==0)
						{
							_huanDengModel.x = _huanDengModel.y = 0;
							_huanDengModel.setMediaPaiLie();
						}else if((notification.getBody() as XiangCeVO).modelID==1) 
						{
							_huanDengModel.setMediaHuaDeng();
							_huanDengModel.settingModel((notification.getBody() as XiangCeVO));
						}else if((notification.getBody() as XiangCeVO).modelID==2){
							_huanDengModel.x = _huanDengModel.y = 0;
							_huanDengModel.setMediaFull();
							_huanDengModel.settingModel((notification.getBody() as XiangCeVO));
						}else if((notification.getBody() as XiangCeVO).modelID==3){
							_huanDengModel.x = _huanDengModel.y = 0;
							_huanDengModel.setMediaHunPai();
							_huanDengModel.settingModel((notification.getBody() as XiangCeVO));
						}	
					}else{
						_huanDengModel.settingModel((notification.getBody() as XiangCeVO));
					}
					
					if((notification.getBody() as XiangCeVO).isClear)
					{//清除涂鸦
						if((notification.getBody() as XiangCeVO).modelID==1||(notification.getBody() as XiangCeVO).modelID==2)
						{
							_huanDengModel.clearTuYa();
						}
					}
					if((notification.getBody() as XiangCeVO).isClearAllMedia)
					{
						Tweener.addTween(_huanDengModel,{time:1,onComplete:waitEnd});
						
						function waitEnd():void
						{
							_huanDengModel.clearAll();
						}
						_huanDengModel.reset();
					}
					break;
				}
				case NotificationIDs.OPP_CAMERA:
				{
					if(_sp.mediaSprite.numChildren > 56)return;
					if(ApplicationData.getInstance().oppArr.length > 56)return;
					if((_sp.mediaSprite.numChildren + ApplicationData.getInstance().oppArr.length) > 56)return;
					
					if(_sp.mediaSprite.numChildren > 25)
					{
						NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
					}
					var oppMedia1:OppMedia = new OppMedia();
					oppMedia1.name ="oppMedia";
					_sp.addMediaSprite(oppMedia1);
					oppMedia1.alpha = 0;
					oppMedia1.scaleX = oppMedia1.scaleY = Math.min(600/1920,358/1080);
					Tweener.addTween(oppMedia1,{x:MathUtil.random(200,1600),y:MathUtil.random(200,800),rotation:MathUtil.random(-180,180),alpha:1,time:0.5,transition:"linear",onComplete:moveEnd1});
					function moveEnd1():void
					{
						Tweener.removeTweens(oppMedia1);
					}
					oppMedia1.setBitmap((notification.getBody() as BitmapData));
					oppMedia1.addEventListener(Event.CLOSE,onOppMediaClose);
					oppMedia1.addEventListener(Event.FULLSCREEN,onOppMediaFull);
					oppMedia1.addEventListener(Event.CHANGE,onOppMediaFullClose);
					oppMedia1.addEventListener(ChangeEvent.FIT_WEIZHI,onFitWeiZhi);
					break;
				}
				case NotificationIDs.HIDE_SHOW_MENU:
				{
					if(notification.getBody()==2){
						_historyCon.visible = false;
					}else if(notification.getBody()==1){
						_historyCon.visible = true;
					}else{//当点击桌面整理时  影藏浮在上面的内容
						_historyCon.visible = false;
					}
					break;
				}
				case NotificationIDs.OPEN_CLOCK:
				{
					if(_clockMC==null)
					{
						_clockMC = new ShowTime();
						_clockMC.x = (1920-_clockMC.width)-50;
						_clockMC.y = 20;
						_sp.addPanelSprite(_clockMC);
						_clockMC.visible = false;
					}

					_clockMC.reset();
					if(_clockMC.visible)
					{
						_clockMC.visible = false;
					}else{
						_clockMC.visible = true;
					}
					break;
				}
			}
		}
			
		private function onWinClose(event:Event):void
		{
		}
		
		private function oppMedia(vo:MediaVO):void
		{
			if(_sp.mediaSprite.numChildren > 56)return;
			if(ApplicationData.getInstance().oppArr.length > 56)return;
			if((_sp.mediaSprite.numChildren + ApplicationData.getInstance().oppArr.length) > 56)return;
		
			if(_sp.mediaSprite.numChildren > 25)
			{
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
			}
			
			var oppMedia:OppMedia = new OppMedia();
			oppMedia.name ="oppMedia";
			_sp.addMediaSprite(oppMedia);
			oppMedia.alpha = 0;
			oppMedia.scaleX = oppMedia.scaleY = 0.1;
			oppMedia.addEventListener(Event.COMPLETE,onComplete);
			oppMedia.addEventListener(Event.CLOSE,onOppMediaClose);
			oppMedia.addEventListener(Event.FULLSCREEN,onOppMediaFull);
			oppMedia.addEventListener(Event.CHANGE,onOppMediaFullClose);
			oppMedia.addEventListener(ChangeEvent.FIT_WEIZHI,onFitWeiZhi);
			oppMedia.setPath(vo,false);
		}
		
		private function onComplete(e:Event):void
		{
			if((e.target as OppMedia).mediaVO.isZiDong ==true)
			{
				if((e.target as OppMedia).mediaVO.isFull==false)
				{
					Tweener.addTween(e.target,{x:MathUtil.random(200,1600),y:MathUtil.random(200,800),alpha:1,scaleX:Math.min(600/1920,358/1080),scaleY:Math.min(600/1920,358/1080),time:0.5,transition:"linear"});
				}else{
					Tweener.addTween(e.target,{x:800,alpha:1,scaleX:Math.min(600/1920,358/1080),scaleY:Math.min(600/1920,358/1080),time:0.5,transition:"linear"});
				}
				
			}else{
				if((e.target as OppMedia).mediaVO.isFull==false)
				{
					Tweener.addTween(e.target,{x:MathUtil.random(200,1600),y:MathUtil.random(200,800),rotation:MathUtil.random(-180,180),alpha:1,scaleX:Math.min(600/1920,358/1080),scaleY:Math.min(600/1920,358/1080),time:0.5,transition:"linear"});
				}else{
					Tweener.addTween(e.target,{x:800,alpha:1,scaleX:Math.min(600/1920,358/1080),scaleY:Math.min(600/1920,358/1080),time:0.5,transition:"linear"});
				}
				
			}
			setTimeout(function ():void
			{
				if((e.target as OppMedia).mediaVO.isFull==true)
				{
					Tweener.removeTweens((e.target as OppMedia));
					_tempX = (e.target as OppMedia).x;
					_tempOppY = (e.target as OppMedia).y;
					_tempR = (e.target as OppMedia).rotation;
					_tempScaleX = (e.target as OppMedia).scaleX;
					_tempScaleY = (e.target as OppMedia).scaleY;
	
					ApplicationData.getInstance().xiangCeVO.isClearAllMedia=false;
					ApplicationData.getInstance().xiangCeVO.isLock = false;
					ApplicationData.getInstance().xiangCeVO.modelID = 2;
					ApplicationData.getInstance().xiangCeVO.isModel = true;
					ApplicationData.getInstance().xiangCeVO.isHemi = true;
					if(ApplicationData.getInstance().xiangCeVO.isVisible == false){//如果点击相册的排列模式了 内容的visible=false 让他变为true
						ApplicationData.getInstance().xiangCeVO.isVisible = true;
						//						_toolsPanelRes.minBtn.gotoAndStop(1);
					}
					NotificationFactory.sendNotification(NotificationIDs.HIDE_SHOW_MENU,3);
					NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
				}
			},510);
		}
		
		/**
		 * 弹出媒体关闭
		 * @param e
		 * 
		 */		
		private function onOppMediaClose(e:Event):void
		{
			ToolKit.log("+onOppMediaClose+++");
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
			_historyCon.addThumb(obj.mediaVO);
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
		
		private function onMediaYuLan(e:Event):void
		{
			_mediaYuLan.visible = false;
		}
		
		private function onXiangCeClose(e:Event):void
		{
			_nowModelID = 4;
			_huanDengModel.reset();
		}
		
		private function onCameraPhotographClose(e:Event):void
		{
			_videoLuZhi.visible = false;
		}
		
		public function listNotificationInterests():Array
		{
			return [NotificationIDs.STAGE_DOUBLE_CLICK,NotificationIDs.OPP_MEDIA,NotificationIDs.MEDIA_PREVIEW,NotificationIDs.HUANDENGMODEL,NotificationIDs.CAMERA_VIDEO_LUZHI,
				NotificationIDs.OPP_CAMERA,NotificationIDs.HIDE_SHOW_MENU,NotificationIDs.OPEN_CLOCK,NotificationIDs.CLEAR_ALL,NotificationIDs.DRAW_SHAPE_END,NotificationIDs.CHANGE_IPTID_MODEL,
				NotificationIDs.CHANGE_PHONE_MODEL,NotificationIDs.READ_JIAOAN,NotificationIDs.MINI_WINDOWN,NotificationIDs.MAX_WINDOW,NotificationIDs.ZIDONG_CHANGELESSON,
				NotificationIDs.HUANDENG_PAGEMOVE
			];
		}
		
		public function onRegister():void
		{
			
		}
		
		public function onRemove():void
		{
			
		}
		
	}
}