package com.views.components.tools
{
	import com.events.ChangeEvent;
	import com.greensock.TweenLite;
	import com.lylib.air.CmdCommand;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.msgs.ClientType;
	import com.models.vo.FullShowAppVO;
	import com.models.vo.StyleVO;
	import com.models.vo.TuXingVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.res.ErWeiMaKuangRes;
	import com.tweener.transitions.Tweener;
	import com.views.components.DisplaySprite;
	import com.views.components.panel.BrushPanel;
	import com.views.components.panel.ClearPanel;
	import com.views.components.panel.ColorPanel;
	import com.views.components.panel.GongSiXiangCePanel;
	import com.views.components.panel.GongZhuPanel;
	import com.views.components.panel.SetDiWenBtn;
	import com.views.components.panel.ShapePanel;
	import com.views.components.panel.ShuXuePanel;
	import com.windows.FullAppWindow;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.sampler.Sample;
	import flash.system.fscommand;
	import flash.utils.setTimeout;
	
	import org.qrcode.QRCode;
	
	public class Tools extends Sprite
	{
		private var _toolsRes:ToolsRes;
		private var _disSprite:DisplaySprite;
		private var _brushPanel:BrushPanel;
		private var _colorPanel:ColorPanel;
		private var _gongZhuPanel:GongZhuPanel;
		private var _setWenLiPanel:SetDiWenBtn;
		private var _shuXuePanel:ShuXuePanel;
		
		private var _pageBtnSprite:Sprite;
		private var _pageBtn:PageBtnRes;
		private var _pageBtnArr:Array=[];
		private var _tempBtn:MovieClip;
		private var _downX:Number=0;
		private var _tempX:Number=0;
		private var _pageID:int;
		private var _clearPanel:ClearPanel;
		private var _gongSiXiangCe:GongSiXiangCePanel;
		
		private var _colorArr:Array=[0xBF2115,0xEEC848,0x71AD34,0x0396DB,0xFFFFFF,0x000000];
		private var _tempColorBtn:MovieClip;
		private var _tempThincess:int;
		private var _templineStyle:int;
		private var _styleVO:StyleVO;
		private var _shapePanle:ShapePanel;
		private var _tuXingVO:TuXingVO;
		private var fullWin:FullAppWindow;
		private var _process:NativeProcess;
		
		private var _erWeiMaKuang:ErWeiMaKuangRes;
		
		public function Tools()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_disSprite = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			
			_toolsRes = new ToolsRes();
//			_toolsRes.fangDaBtn.visible = false;
//			_toolsRes.suoXiaoBtn.visible = false;
			this.addChild(_toolsRes);
			_toolsRes.cacheAsBitmap = true;
			_pageBtnSprite = new Sprite();
			_pageBtnSprite.y = 4;
			this.addChild(_pageBtnSprite);
//			setErWeiMaPanel();
			_colorPanel = new ColorPanel();
			_colorPanel.x = 62;
			_colorPanel.y = 1100;
			_colorPanel.addEventListener(Event.CLOSE,onColorPanelClose);
			
			_brushPanel = new BrushPanel();
			_brushPanel.x = 347;
			_brushPanel.y = 828.4+187;
			_brushPanel.addEventListener(ChangeEvent.CHANGE_END,onBrushPanelChange);
			
			_gongSiXiangCe = new GongSiXiangCePanel();
			_gongSiXiangCe.x = 1125;
			_gongSiXiangCe.y = 1100;
			_gongSiXiangCe.visible = false;
			
			_disSprite.addPanelSprite(_gongSiXiangCe);
			_brushPanel.visible = false;
			
			_toolsRes.cacheAsBitmap = true;
			_styleVO = new StyleVO();
			
			_tuXingVO = new TuXingVO();
			_toolsRes.localMode.mouseChildren =false;
			//_toolsRes.xingZhuangBtn.mouseChildren =false;
			//_toolsRes.tianChongBtn.mouseChildren =false;
			chuShi();
			addPageBtn();//默认添加一块黑板
			initListener();
		}
		
		private function initListener():void
		{
			(_toolsRes.clearBtn.btn_0 as MovieClip).mouseChildren = false;
			(_toolsRes.clearBtn.btn_1 as MovieClip).mouseChildren = false;
//			_toolsRes.addEventListener(MouseEvent.CLICK,onToolsClick);
			_toolsRes.addEventListener(MouseEvent.MOUSE_DOWN,onToolsClick);
			_toolsRes.colorBtn.addEventListener(MouseEvent.CLICK,onColorBtnClick);
			_toolsRes.clearBtn.addEventListener(MouseEvent.CLICK,onClearBtnClick);
			_pageBtnSprite.addEventListener(MouseEvent.CLICK,onPageBtnClick);
			_toolsRes.moveDis.addEventListener(MouseEvent.MOUSE_DOWN,onMoveDisDown);
		}
		
		private function chuShi():void
		{
			if(ApplicationData.getInstance().clientType == ClientType.STUDENT)
			{
				_toolsRes.erWeiMa.visible = false;
				_toolsRes.localMode.visible = false;
				_toolsRes.uDiskMode.visible = false;
				_toolsRes.logoBtn.visible = true;
			} else {
				_toolsRes.logoBtn.visible = false;
			}
			
			if(_tempColorBtn)
			{
				_tempColorBtn.gotoAndStop(1);
			}
			_tempColorBtn = _toolsRes.colorBtn.btn_4 as MovieClip;
			_tempColorBtn.gotoAndStop(2);
			ApplicationData.getInstance().styleVO.lcolor = 0xFFFFFF;
			ApplicationData.getInstance().styleVO.isCir = false;
			ApplicationData.getInstance().styleVO.isEraser = false;
			ApplicationData.getInstance().styleVO.lineStyle = 1;
			ApplicationData.getInstance().styleVO.lineThickness = 5;
			if(_brushPanel)
			{
				_brushPanel.reset();
			}
			hideChaChuBtn();
			_toolsRes.cheXiaoBtn.gotoAndStop(2);
			_toolsRes.chongZuoBtn.gotoAndStop(2);
			_toolsRes.penBtn.gotoAndStop(2);
		}
		
		public function pianHaoSet(obj:StyleVO):void
		{
			if(obj.lcolor!=5)
			{
				if(_tempColorBtn)
				{
					_tempColorBtn.gotoAndStop(1);
				}
				_tempColorBtn = _toolsRes.colorBtn["btn_"+obj.lcolor];
				_tempColorBtn.gotoAndStop(2);
			}
			if(_brushPanel)
			{
				_brushPanel.setBrush(obj.lineStyle,obj.lineThickness);
			}
			_toolsRes.penBtn.gotoAndStop(obj.lineStyle+1);
			hideChaChuBtn();
			ApplicationData.getInstance().styleVO.lcolor = _colorArr[obj.lcolor];
			ApplicationData.getInstance().styleVO.isCir = false;
			ApplicationData.getInstance().styleVO.isEraser = false;
			ApplicationData.getInstance().styleVO.lineStyle = obj.lineStyle;
			ApplicationData.getInstance().styleVO.lineThickness = obj.lineThickness;
		}
		
//		private function onToolsClick(e:MouseEvent):void
		private function onToolsClick(e:MouseEvent):void
		{
			if(e.target.name=="fangDaBtn"||e.target.name=="paiZhaoBtn"||e.target.name=="suoXiaoBtn")
			{
				(e.target as MovieClip).alpha = 0.5;
			}
			
			stage.addEventListener(MouseEvent.MOUSE_UP,onToolsUp);
		}
					
		private function onToolsUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onToolsUp);	
			
			switch(e.target.name)
			{
				case "zhengLiBtn":
				{
					_gongSiXiangCe.reset();
					
					if(_gongSiXiangCe.visible)
					{
						Tweener.addTween(_gongSiXiangCe,{x:1125,y:1100,visible:false,time:0.5});
						_disSprite.addPanelSprite(_gongSiXiangCe);
						_gongSiXiangCe.showCon();
					}else{
						_disSprite.addPanelSprite(_gongSiXiangCe);
						Tweener.addTween(_gongSiXiangCe,{x:1125,y:964,visible:true,time:0.5});
					}		
					break;
				}
						
				case "menuSuoBtn":
				{
					/*if((e.target as MovieClip).currentFrame==1)
					{
						ApplicationData.getInstance().isLock =true;
						(e.target as MovieClip).gotoAndStop(2);
					}else{
						ApplicationData.getInstance().isLock =false;
						(e.target as MovieClip).gotoAndStop(1);
					}
					
					NotificationFactory.sendNotification(NotificationIDs.TONGBU_BTN,(e.target as MovieClip).currentFrame);*/
					
					
					NotificationFactory.sendNotification(NotificationIDs.STAGE_DOUBLE_CLICK,new MouseEvent(MouseEvent.DOUBLE_CLICK));
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
					hidePanel();
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
							
				case "paiZhaoBtn":
				{
					(e.target as MovieClip).alpha = 1;
					NotificationFactory.sendNotification(NotificationIDs.PHOTO_GRAPH);
					
					Tweener.addTween((e.target as MovieClip),{time:4,onComplete:onGraphEnd});
					
					function onGraphEnd():void
					{
						NotificationFactory.sendNotification(NotificationIDs.COMPLETE_MEDIA);
					}
					break;		
				}
							
				case "minBtn":
				{
					//var minWin:MinimizeWindow = new MinimizeWindow();
					NotificationFactory.sendNotification(NotificationIDs.MINI_WINDOWN);
					break;		
				}	
							
				case "cheXiaoBtn":
				{
					if((e.target as MovieClip).currentFrame==2)return;
					NotificationFactory.sendNotification(NotificationIDs.CHEXIAO);
					break;		
				}
							
				case "chongZuoBtn":
				{
					if((e.target as MovieClip).currentFrame==2)return;
					NotificationFactory.sendNotification(NotificationIDs.CHONEZUO);
					break;		
				}
							
				case "tianChongBtn":
				{
					if((e.target as MovieClip).currentFrame==1)
					{
						(e.target as MovieClip).gotoAndStop(2);
					}
					ApplicationData.getInstance().isTuYaBan = true;
					hideChaChuBtn();
					_tuXingVO.tuYa = false;
					_tuXingVO.tianChong = true;
					_tuXingVO.shape = false;
					_tuXingVO.drawShape = false;
					NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
					break;		
				}
				case "shapeBtn":
				{
					/*if(_toolsRes.tianChongBtn.currentFrame==2)
					{
						_toolsRes.tianChongBtn.gotoAndStop(1);
					}*/
					ApplicationData.getInstance().isTuYaBan = true;
					hideChaChuBtn();
					if(_shapePanle==null)
					{
						_shapePanle = new ShapePanel();
						_shapePanle.x = 335;
						_shapePanle.y = 911+_shapePanle.height+20;
						_disSprite.addMidSprite(_shapePanle);
						_shapePanle.addEventListener(Event.CHANGE,onShapePanleChange);
						_shapePanle.visible = false;
					}
					
					if(_shapePanle.visible == false)
					{
						Tweener.addTween(_shapePanle,{y:911,visible:true,time:0.5,onComplete:shapePanleMoveEnd});
					}else{
						Tweener.addTween(_shapePanle,{y:911+_shapePanle.height+80,visible:false,time:0.5});
					}
					
					//							Tweener.addTween(_shapePanle,{y:911,visible:true,time:0.5,onComplete:shapePanleMoveEnd});
					
					function shapePanleMoveEnd():void
					{
						_disSprite.addPanelSprite(_shapePanle);
					}
					_tuXingVO.tuYa = false;
					_tuXingVO.tianChong = false;
					_tuXingVO.shape = true;
					_tuXingVO.drawShape = true;
					NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
					break;		
				}
				case "chiZiBtn":
				{
					/*if(_toolsRes.tianChongBtn.currentFrame==2)
					{
						_toolsRes.tianChongBtn.gotoAndStop(1);
					}	*/				
					hideChaChuBtn();
					if(_shuXuePanel==null)
					{
						_shuXuePanel = new ShuXuePanel();
						_shuXuePanel.x = 423;
						_shuXuePanel.y = 795+_shuXuePanel.height+20;
						_disSprite.addMidSprite(_shuXuePanel);
						_shuXuePanel.visible = false;
					}
					
					if(_shuXuePanel.visible == false)
					{
						Tweener.addTween(_shuXuePanel,{y:795,visible:true,time:0.5,onComplete:shapePanleMoveEnd});
					}else{
						Tweener.addTween(_shuXuePanel,{y:795+_shuXuePanel.height+80,visible:false,time:0.5});
					}
					
					//Tweener.addTween(_shuXuePanel,{y:795,visible:true,time:0.5,onComplete:shapePanleMoveEnd1});
					
					function shapePanleMoveEnd1():void
					{
						_disSprite.addPanelSprite(_shuXuePanel);
					}
					ApplicationData.getInstance().isTuYaBan = false;
					_tuXingVO.tuYa = true;
					_tuXingVO.tianChong = false;
					_tuXingVO.shape = false;
					_tuXingVO.drawShape = false;
					NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
					break;		
				}
				case "shouJiModelBtn":
				{
					NotificationFactory.sendNotification(NotificationIDs.CHANGE_PHONE_MODEL);
					NotificationFactory.sendNotification(NotificationIDs.TUYA_BEGIN);
					break;		
				}
									
				case "tanZhaoDeng":
				{
					NotificationFactory.sendNotification(NotificationIDs.OPEN_TANZHAODENG);
					break;		
				}
							
				case "erWeiMa":
				{
					/*if(!ConstData.socket.isNetSuccess)
					{
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"服务器连接失败,请检查服务器是否已开启，尝试重新连接");
						setTimeout(function ():void{
							NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
						},2000);
					} else {
						setErWeiMaPanel();
					}*/
					
					setErWeiMaPanel();
					break;										
				}
					
				case "localMode":
				{
					if(ApplicationData.getInstance().clientType == ClientType.STUDENT)return;
					//					trace("课件本地登录");
					NotificationFactory.sendNotification(NotificationIDs.LOCAL_FILE);
					break;
				}
					
				case "uDiskMode":
				{
					if(ApplicationData.getInstance().clientType == ClientType.STUDENT)return;
					//					trace("课件U盘登录");
					if(ApplicationData.getInstance().UDiskJieRu==false)
					{
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"没有检测到U盘，请检查是否已接入。");
						Tweener.addTween(_toolsRes,{time:1,onComplete:waitEnd});
						function waitEnd():void
						{
							NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"没有检测到U盘");
						}
						return;
					}
					if(ApplicationData.getInstance().UDiskJieRu==true)
					{
						if(ApplicationData.getInstance().UDiskModel)
						{
							ApplicationData.getInstance().userXML = ApplicationData.getInstance().UDiskXML;
							NotificationFactory.sendNotification(NotificationIDs.UDISK_FILE);
						}else{
							//							trace("再次接入")
							NotificationFactory.sendNotification(NotificationIDs.RE_LOGIN);
						}
					}
					hidePanel();
					break;
				}
					
				case "clearAll":
				{
					if(_clearPanel==null)
					{
						_clearPanel = new ClearPanel();
						_clearPanel.x = 782.6;
						_clearPanel.y = 828.9+_clearPanel.height+20;
						_clearPanel.addEventListener(Event.CLOSE,onClearPanelClose);
						_disSprite.addMidSprite(_clearPanel);
						_clearPanel.visible = false;		
					}
					Tweener.addTween(_clearPanel,{y:828.9,visible:true,time:0.5,onComplete:clearAllMoveEnd});
					
					function clearAllMoveEnd():void
					{
						_disSprite.addPanelSprite(_clearPanel);
					}	
					break;		
				}
						
				case "penBtn":
				{
					/*if(_toolsRes.tianChongBtn.currentFrame==2)
					{
						_toolsRes.tianChongBtn.gotoAndStop(1);
					}	*/				
					hideChaChuBtn();
					_disSprite.addPanelSprite(_brushPanel);
					if(_brushPanel.visible == false)
					{
						Tweener.addTween(_brushPanel,{y:828.4,visible:true,time:0.5});
					}else{
						Tweener.addTween(_brushPanel,{y:828.4+_brushPanel.height+80,visible:false,time:0.5});
					}
					
					ApplicationData.getInstance().isTuYaBan = false;
					_tuXingVO.tuYa = true;
					_tuXingVO.tianChong = false;
					_tuXingVO.shape = false;
					_tuXingVO.drawShape = false;
					NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
					break;		
				}
						
				case "gongZhuBtn":
				{
					if(_gongZhuPanel==null)
					{
						_gongZhuPanel = new GongZhuPanel();
						_gongZhuPanel.x = 1510;
						_gongZhuPanel.y = 863.5+_gongZhuPanel.height;
						_disSprite.addMidSprite(_gongZhuPanel);
						_gongZhuPanel.visible = false;
					}else{
						_gongZhuPanel.gotoStop(1);
					}
					
					if(_gongZhuPanel.visible == false)
					{
						Tweener.addTween(_gongZhuPanel,{y:863.5,visible:true,time:0.5,onComplete:gongZhuMoveEnd});
					}else{
						Tweener.addTween(_gongZhuPanel,{y:863.5+_gongZhuPanel.height+80,visible:false,time:0.5});
					}
					
					function gongZhuMoveEnd():void
					{
						_disSprite.addPanelSprite(_gongZhuPanel);
					}
					break;			
				}
							
				case "geZiBtn":
				{
					if(_setWenLiPanel==null)
					{
						_setWenLiPanel = new SetDiWenBtn();
						_setWenLiPanel.x = 1562;
						_setWenLiPanel.y = 788.2+_setWenLiPanel.height;
						_disSprite.addMidSprite(_setWenLiPanel);
						_setWenLiPanel.visible = false;
					}
					
					if(_setWenLiPanel.visible == false)
					{
						Tweener.addTween(_setWenLiPanel,{y:788.2,visible:true,time:0.5,onComplete:wenLiMoveEnd});
					}else{
						Tweener.addTween(_setWenLiPanel,{y:788.2+_setWenLiPanel.height+80,visible:false,time:0.5});
					}
					function wenLiMoveEnd():void
					{
						_disSprite.addPanelSprite(_setWenLiPanel);
					}	
					break;			
				}
								
				case "chongZhi":
				{
					if(_brushPanel)
					{
						_brushPanel.reset();
					}
					hideChaChuBtn();
					_toolsRes.cheXiaoBtn.gotoAndStop(2);
					_toolsRes.chongZuoBtn.gotoAndStop(2);
					
					if(ApplicationData.getInstance().userXML)
					{
						var vo:StyleVO = new StyleVO();
						vo.lcolor = ApplicationData.getInstance().userXML.pianHao.color;
						vo.blackID = ApplicationData.getInstance().userXML.pianHao.backGround;
						vo.lineThickness = ApplicationData.getInstance().userXML.pianHao.thickness;
						vo.lineStyle = ApplicationData.getInstance().userXML.pianHao.lineStyle;
						pianHaoSet(vo);
					}else{
						pianHaoSet(ApplicationData.getInstance().pianHaoObj);	
					}
					break;					
				}
			}				
		}
				
		public function setHuanDengModel():void
		{
			if(_gongSiXiangCe)
			{
				_gongSiXiangCe.setResZhuangTai();
			}
		}
						
		public function setErWeiMaPanel():void
		{
			if(_erWeiMaKuang == null)
			{
				_erWeiMaKuang = new  ErWeiMaKuangRes();
//				var bmp:Bitmap = producedQRcode("http://condrage-&ipAddress="+ApplicationData.getInstance().ipAddress+"-&port="+ApplicationData.getInstance().port+"-&serverAddress="+ApplicationData.getInstance().serverAddress+"-&classroom="+ApplicationData.getInstance().classroom);
//				var bmp:Bitmap = producedQRcode("serverAddress="+ApplicationData.getInstance().socketServer+"&port="+ApplicationData.getInstance().port+"&classroom="+ApplicationData.getInstance().classroom);
//				var bmp:Bitmap = producedQRcode("serverAddress="+ApplicationData.getInstance().socketServer+"&port="+ApplicationData.getInstance().port+"&classroom="+ApplicationData.getInstance().classroom);
//				var bmp:Bitmap = producedQRcode("http://"+ApplicationData.getInstance().httpAddress+"/index.html");
//				var bmp:Bitmap = producedQRcode("http://"+ApplicationData.getInstance().httpAddress+"/frame.aspx");
//				var bmp:Bitmap = producedQRcode("http://"+ApplicationData.getInstance().httpAddress+"/Default.aspx");
				var bmp:Bitmap = producedQRcode("http://"+ApplicationData.getInstance().httpAddress);
//				var bmp:Bitmap = producedQRcode("https://open.weixin.qq.com/connect/oauth2/authorize?appid=wxe415ca4cab63133b&redirect_uri=http://wchat.iptid.com.cn/zhoudafu/weixin/getWinxinUser&response_type=code&scope=snsapi_userinfo&state=1#wechat_redirect ");
//				var bmp:Bitmap = producedQRcode("https://www.jingqu.cn/wechat/html/createOrder/chooseGoods.html?m=yPlfO01Y1bNsOwpK8-9dB1JeHPAvf1mXgJEXSQ2i39aRBu6JTWsNFGt7n4ihuClL5tgtPLyDxVzLN78HvjuBArSsUjLGsYaU5SCHEIgg3WTl5bS6vv-zRU9t0pW9BWatzM9LuBRh0Ahy9ShsQzO-Ew&k=59cd8e5bd7324687132f28673111726f");
				bmp.x = bmp.y = 17;
				bmp.width = bmp.height = 150;
				_erWeiMaKuang.addChild(bmp);
				_erWeiMaKuang.alpha = 0;
				_erWeiMaKuang.visible = false;
				_erWeiMaKuang.width = _erWeiMaKuang.height = 500;
				_erWeiMaKuang.x = (1920- _erWeiMaKuang.width)*0.5;
				_erWeiMaKuang.y = (1080- _erWeiMaKuang.height)*0.5;
			}
			
			if(_erWeiMaKuang.parent == null)
			{
				_disSprite.addPanelSprite(_erWeiMaKuang);
//				TweenLite.to(_erWeiMaKuang,0.3,{visible:true,alpha:1});
				Tweener.addTween(_erWeiMaKuang, {time:0.3,visible:true,alpha:1});
			}else{
//				TweenLite.to(_erWeiMaKuang,0.3,{visible:false,alpha:0,onComplete:erWeiMaKuangEnd});
				Tweener.addTween(_erWeiMaKuang, {visible:false, time:0.3, alpha:0, onComplete:erWeiMaKuangEnd});
			}		
		}
				
		private function erWeiMaKuangEnd():void
		{
			if(_erWeiMaKuang.parent == null)return;
			_erWeiMaKuang.parent.removeChild(_erWeiMaKuang);
		}
		
		/**
		 * 生成二维码
		 */		
		public function producedQRcode(str:String):Bitmap
		{
			var qrObj:QRCode  = new QRCode();
			qrObj.encode(str);
			var qrImg:Bitmap = new Bitmap(qrObj.bitmapData);
			qrImg.width = qrImg.height = 300;
			return qrImg;
		}
						
		private function onShapePanleChange(event:Event):void
		{
			/*if(_toolsRes.tianChongBtn.currentFrame==2)
			{
				_toolsRes.tianChongBtn.gotoAndStop(1);
			}	*/		
		}				
		/**
		 * 
		 * 在幻灯全屏模式下  幻灯模式菜单消失了  拖动下面的边让其显示
		 */						
		public function gongJuLanPanle():void
		{
			_gongSiXiangCe.reset();
			/*if(_gongSiXiangCe.visible ==true)
			{
				Tweener.addTween(_gongSiXiangCe,{x:1125,y:1100,visible:false,time:0.5});
//				_disSprite.addPanelSprite(_gongSiXiangCe);
				_gongSiXiangCe.showCon();
			}else{
				_disSprite.addPanelSprite(_gongSiXiangCe);
				Tweener.addTween(_gongSiXiangCe,{x:1125,y:964,visible:true,time:0.5});
			}*/
			
//			if(_gongSiXiangCe.y==964)
			if(_gongSiXiangCe.visible)
			{
				Tweener.addTween(_gongSiXiangCe,{x:1125,y:1100,visible:false,time:0.5});
				_disSprite.addPanelSprite(_gongSiXiangCe);
				_gongSiXiangCe.showCon();
			}else{
				_disSprite.addPanelSprite(_gongSiXiangCe);
				Tweener.addTween(_gongSiXiangCe,{x:1125,y:964,visible:true,time:0.5});
			}
		}
					
		public function hideUDiskButton():void
		{
			_toolsRes.uDiskMode.gotoAndStop(1);
		}
		
		public function showUDiskButton():void
		{
			_toolsRes.uDiskMode.gotoAndStop(2);
		}
		/**
		 * 
		 *锁定按钮同步 
		 */		
		public function gotoSuoDingBtn(id:int):void
		{
			_toolsRes.menuSuoBtn.gotoAndStop(id);
		}
		
		public function setHideShowBtn(id:int):void
		{
			_toolsRes.hideShowBtn.gotoAndStop(id);
		}
		
		private function onBrushPanelChange(e:ChangeEvent):void
		{
			_toolsRes.penBtn.gotoAndStop(e.id+1);
		}
		
		private function fangDaBtnGotoStop(id:int):void
		{
			_toolsRes.fangDaBtn.gotoAndStop(id);
		}
		
		
		/**
		 * @isAll 是全部还是一个
		 * @param mcID 那个按钮
		 * @param id   按钮跑到第几帧
		 * 
		 */		
		public function gotoStop(isAll:Boolean,mcID:int,id:int):void
		{
			if(isAll){
				_toolsRes.cheXiaoBtn.gotoAndStop(id);
				_toolsRes.chongZuoBtn.gotoAndStop(id);
			}else{
				if(mcID==0)
				{
					_toolsRes.cheXiaoBtn.gotoAndStop(id);
				}else{
					_toolsRes.chongZuoBtn.gotoAndStop(id);
				}
			}
		}
					
		private function onColorBtnClick(e:MouseEvent):void
		{
			if(e.target.name.split("_")[0]!="btn")return;
			var id:int = e.target.name.split("_")[1];
			if(_tempColorBtn)
			{
				_tempColorBtn.gotoAndStop(1);
			}
			_tempColorBtn = e.target as MovieClip;
			_tempColorBtn.gotoAndStop(2);
			if(id!=5){
				ApplicationData.getInstance().styleVO.lcolor = _colorArr[id];
			}else{
				//弹出颜色选择框
				//trace("弹出颜色选择框")
				_disSprite.addPanelSprite(_colorPanel);
				Tweener.addTween(_colorPanel,{visible:true,y:852.4,time:0.5});
			}
			_toolsRes.clearBtn.btn_0.gotoAndStop(1);
			_toolsRes.clearBtn.btn_1.gotoAndStop(1);
			ApplicationData.getInstance().styleVO.isCir = false;
			ApplicationData.getInstance().styleVO.isEraser = false;
			if(ApplicationData.getInstance().styleVO.isEraser||_styleVO.isEraser)
			{
				ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
				ApplicationData.getInstance().styleVO.lineStyle  = _templineStyle;
			}
		}
		
		private function onClearBtnClick(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "btn_0":
				{//擦除
					_toolsRes.clearBtn.btn_1.gotoAndStop(1);
					if((e.target as MovieClip).currentFrame==1){
						(e.target as MovieClip).gotoAndStop(2);
						_tempThincess = ApplicationData.getInstance().styleVO.lineThickness;
						_templineStyle = ApplicationData.getInstance().styleVO.lineStyle;
						ApplicationData.getInstance().styleVO.lineThickness = 20;
						ApplicationData.getInstance().styleVO.lineStyle  = 0;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = true;
						_styleVO.isCir = false;
						_styleVO.isEraser = true;
					}else{
						(e.target as MovieClip).gotoAndStop(1);
						ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
						ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
						_styleVO.isCir = false;
						_styleVO.isEraser = false;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}
					break;
				}
				case "btn_1":
				{//圈选擦除
					if((_toolsRes.clearBtn.btn_0 as MovieClip).currentFrame==2)
					{
						_toolsRes.clearBtn.btn_0.gotoAndStop(1);
						ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
						ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
						_styleVO.isCir = false;
						_styleVO.isEraser = false;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}
					if((e.target as MovieClip).currentFrame==1){
						(e.target as MovieClip).gotoAndStop(2);
						_tempThincess = ApplicationData.getInstance().styleVO.lineThickness;
						_templineStyle = ApplicationData.getInstance().styleVO.lineStyle;
						_styleVO.isCir = true;
						_styleVO.isEraser = false;
						ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
						ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = true;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}else{
						(e.target as MovieClip).gotoAndStop(1);
						_styleVO.isCir = false;
						_styleVO.isEraser = false;
						ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
						ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}
					break;
				}
			}
		}
		
		private function onColorPanelClose(e:Event):void
		{
			if(_colorPanel)
			{
				_disSprite.addMidSprite(_colorPanel);
				Tweener.addTween(_colorPanel,{visible:false,y:1100,time:0.5});
			}
		}
		
		private function hideChaChuBtn():void
		{
			_toolsRes.clearBtn.btn_0.gotoAndStop(1);
			_toolsRes.clearBtn.btn_1.gotoAndStop(1);
			_styleVO.isCir = false;
			_styleVO.isEraser = false;
			if(ApplicationData.getInstance().styleVO.isEraser)
			{
				ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
				ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
			}
			if(ApplicationData.getInstance().styleVO.isCir)
			{
				ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
				ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
			}
			ApplicationData.getInstance().styleVO.isCir = false;
			ApplicationData.getInstance().styleVO.isEraser = false;
		}
					
		private function onPageBtnClick(e:MouseEvent):void
		{
//			trace(e.target.name.split("_")[0],"+++++");
			if(e.target.name.split("_")[0]!="pageBtn")return;
			var index:int = e.target.name.split("_")[1];
			if(_tempBtn)
			{
				_tempBtn.gotoAndStop(1);
			}
			_tempBtn = e.target as MovieClip;
			_tempBtn.gotoAndStop(2);
			NotificationFactory.sendNotification(NotificationIDs.CHANGE_BOARD,index);
		}
		
		private function onClearPanelClose(e:Event):void
		{
			_disSprite.addMidSprite(_clearPanel);
			Tweener.addTween(_clearPanel,{y:828.9+_clearPanel.height+20,visible:false,time:0.5});
		}
					
		/**
		 * 
		 *添加一块黑板后  在添加一个工具条上的按钮 
		 */					
		public function addPageBtn():void
		{
			if(_pageBtnArr.length>ApplicationData.getInstance().maxBoard)return;
			_pageBtn = new PageBtnRes();
			_pageBtn.mouseChildren = false;
			_pageBtn.name = "pageBtn_"+_pageBtnArr.length;
			_pageBtn.x = _pageBtnArr.length*20;
			_pageBtnArr.push(_pageBtn);
			_pageBtnSprite.addChild(_pageBtn);
			
			_pageBtnSprite.x = (1920-_pageBtnSprite.width)*0.5;
			
			if(_tempBtn)
			{
				_tempBtn.gotoAndStop(1);
			}
			
			_tempBtn = _pageBtnSprite.getChildByName("pageBtn_"+(_pageBtnArr.length-1))as MovieClip;
			_tempBtn.gotoAndStop(2);
			fangDaBtnGotoStop(1);
			
		//	_toolsRes.xingZhuangBtn.gotoAndStop(1);
		}
		
		public function closeLuck():void
		{
			if(_gongSiXiangCe)
			{
				_gongSiXiangCe.closeLuck();
			}
		}
		
		/**
		 * 移除pageBtn
		 * @param index
		 * 
		 */		
		public function removePageBtn(index:int):void
		{
			_pageBtnSprite.removeChild(_pageBtnArr[index]);
			_pageBtnArr.splice(index,1);
			for (var i:int = 0; i < _pageBtnArr.length; i++) 
			{
				_pageBtnArr[i].x = i*20;
				_pageBtnArr[i].name = "pageBtn_"+i;
			}
			_pageBtnSprite.x = (1920-_pageBtnSprite.width)*0.5;
		}
		/**
		 * 设置pageBtn
		 * @param index
		 * 
		 */		
		public function setPageBtn(index:int):void
		{
			if(_tempBtn)
			{
				_tempBtn.gotoAndStop(1);
			}
			
			_tempBtn = _pageBtnSprite.getChildByName("pageBtn_"+index)as MovieClip;
			_tempBtn.gotoAndStop(2);
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
				Tweener.addTween(_gongZhuPanel,{y:863.5+_gongZhuPanel.height,visible:false,time:0.5});
			}
			
			if(_setWenLiPanel)
			{
				_disSprite.addMidSprite(_setWenLiPanel);
				Tweener.addTween(_setWenLiPanel,{y:788.2+_setWenLiPanel.height,visible:false,time:0.5});
			}
			
			if(_brushPanel)
			{
				_disSprite.addMidSprite(_brushPanel);
				Tweener.addTween(_brushPanel,{y:828.4+_brushPanel.height,visible:false,time:0.5});
			}
			
			if(_colorPanel)
			{
				_disSprite.addMidSprite(_colorPanel);
				Tweener.addTween(_colorPanel,{visible:false,y:1100,time:0.5});
			}
			if(_shapePanle)
			{
				_disSprite.addMidSprite(_shapePanle);
				Tweener.addTween(_shapePanle,{y:911+_shapePanle.height+20,visible:false,time:0.5});
			}
			if(_shuXuePanel)
			{
				_disSprite.addMidSprite(_shuXuePanel);
				Tweener.addTween(_shuXuePanel,{y:795+_shuXuePanel.height+20,visible:false,time:0.5});
			}
			
			if(_erWeiMaKuang)
			{
//				TweenLite.to(_erWeiMaKuang,0.3,{_erWeiMaKuang:false,alpha:0,onComplete:erWeiMaKuangEnd});
				Tweener.addTween(_erWeiMaKuang,{visible:false, time:0.3, alpha:0, onComplete:erWeiMaKuangEnd});
			}
		}
		
		public function hideGongSiPanel(boo:Boolean):void
		{
			if(_gongSiXiangCe)
			{
//				_disSprite.addMidSprite(_gongSiXiangCe);
				Tweener.addTween(_gongSiXiangCe,{x:1125,y:1100,visible:false,time:0.5});
				_gongSiXiangCe.showCon();
			}	
		}
		
		private function onMoveDisDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_tempX = mouseX;
			_pageID=ApplicationData.getInstance().nowBoardID;
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onUp(e:MouseEvent):void
		{
			var len:int = ApplicationData.getInstance().boardArr.length;
			//	trace(len,"len");
			if(Math.abs(mouseX-_tempX)>10)
			{
				if(len<2)return;
				if((mouseX-_tempX)<0)
				{
					_pageID++;
					if(_pageID>len-1){
						_pageID = len-1;
						return;
					}
					//trace("向右",_pageID)
					NotificationFactory.sendNotification(NotificationIDs.CHANGE_BOARD,_pageID);
				}else if((mouseX-_tempX)>0)
				{
					_pageID--; 
					if(_pageID<0){
						_pageID = 0;
						return;
					}
					//trace("向左",_pageID)
					NotificationFactory.sendNotification(NotificationIDs.CHANGE_BOARD,_pageID);
				}
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		public function gotoLocalBtnGotoStop(id:int):void
		{
			_toolsRes.localMode.gotoAndStop(id);
		}
		
		/**
		 * 加载应用程序出错，自动关闭
		 * */
		private function onIO_ERROR(event:IOErrorEvent):void
		{//trace("报错")
			_process=null;
			closeApp();
		}
		
		private function onEXIT(event:NativeProcessExitEvent):void
		{//trace("关闭")
			_process=null;
			closeApp();
		}
		/**
		 * 关闭应用程序
		 */
		private function closeApp():void 
		{			
			var windows:Array = NativeApplication.nativeApplication.openedWindows;
			var len:int=windows.length;
			for(var i:int=1;i<len;i++){
				windows[i].close();
			}
		}
		
		public function reset():void
		{
			
		}
	}
}