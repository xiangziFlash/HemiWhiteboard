package com.views.components.tools
{
	import com.events.ChangeEvent;
	import com.models.ApplicationData;
	import com.models.vo.StyleVO;
	import com.models.vo.TuXingVO;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.components.DisplaySprite;
	import com.views.components.panel.BrushPanel;
	import com.views.components.panel.ClearPanel;
	import com.views.components.panel.ColorPanel;
	import com.views.components.panel.ShapePanel;
	import com.views.components.panel.ShuXuePanel;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class PhoneTools1 extends Sprite
	{
		private var _phoneTools1Res:PhoneTools1Res;
		private var _pageBtn:PageBtnRes;
		private var _pageBtnArr:Array=[];
		private var _pageBtnSprite:Sprite;
		private var _tempBtn:MovieClip;
		private var _brushPanel:BrushPanel;
		private var _disSprite:DisplaySprite;
		private var _styleVO:StyleVO;
		private var _tuXingVO:TuXingVO;
		private var _clearPanel:ClearPanel;
		private var _shapePanle:ShapePanel;
		private var _shuXuePanel:ShuXuePanel;
		private var _tempColorBtn:MovieClip;
		private var _colorArr:Array=[0xBF2115,0xEEC848,0x71AD34,0x0396DB,0xFFFFFF,0x000000];
		private var _colorPanel:ColorPanel;
		private var _tempThincess:int;
		private var _templineStyle:int;
		
		public function PhoneTools1()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_disSprite = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			_phoneTools1Res = new PhoneTools1Res();
			this.addChild(_phoneTools1Res);
			_phoneTools1Res.caChuBtn.gotoAndStop(1);
			_pageBtnSprite = new Sprite();
			_pageBtnSprite.y = 140;
			this.addChild(_pageBtnSprite);
			
			_brushPanel = new BrushPanel();
			_brushPanel.scaleX = _brushPanel.scaleY = 3;
			_brushPanel.x = 1182.4;
			_brushPanel.y = 367.05+_brushPanel.height;
//			_brushPanel.addEventListener(ChangeEvent.CHANGE_END,onBrushPanelChange);
			_disSprite.addMidSprite(_brushPanel);
			_brushPanel.visible = false;
			
			_colorPanel = new ColorPanel();
			_colorPanel.scaleX = _colorPanel.scaleY = 3;
			_colorPanel.x = 30;
			_colorPanel.y = 1080;
			_colorPanel.addEventListener(Event.CLOSE,onColorPanelClose);
			_disSprite.addMidSprite(_colorPanel);
			
			_styleVO = new StyleVO();
			
			_tuXingVO = new TuXingVO();
			
			_phoneTools1Res.cheXiaoBtn.gotoAndStop(2);
			_phoneTools1Res.chongZuoBtn.gotoAndStop(2);
			_phoneTools1Res.clearBtn.gotoAndStop(1);
			_phoneTools1Res.clearBtn.mouseChildren = false;
			for (var i:int = 0; i < 5; i++) 
			{
				(_phoneTools1Res.colorBtn["btn_"+i] as MovieClip).gotoAndStop(1);
			}
			
			_phoneTools1Res.cacheAsBitmap = true;
			addPageBtn();//默认添加一块黑板
			_phoneTools1Res.addEventListener(MouseEvent.MOUSE_DOWN,onToolsClick);
//			_phoneTools1Res.addEventListener(MouseEvent.CLICK,onToolsClick);
		}
		
		private function onToolsClick(event:MouseEvent):void
		{
			if(event.target.name=="paiZhaoBtn")
			{
				(event.target as MovieClip).alpha= 0.5;
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,onToolsUp);
			
		}
					
		private function onToolsUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onToolsUp);	
			
			switch(event.target.name)
			{
				case "penBtn":
				{
					Tweener.addTween(_brushPanel,{y:367.05,visible:true,time:0.5,onComplete:brushMoveEnd});
					
					function brushMoveEnd():void
					{
						_disSprite.addPanelSprite(_brushPanel);
					}
					hideChaChuBtn();
					ApplicationData.getInstance().isTuYaBan = false;
					_tuXingVO.tuYa = true;
					_tuXingVO.tianChong = false;
					_tuXingVO.shape = false;
					_tuXingVO.drawShape = false;
					NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
					break;
					}
					
					case "clearAll":
					{
						if(_clearPanel==null)
						{
							_clearPanel = new ClearPanel();
							_clearPanel.scaleX = _clearPanel.scaleY = 3;
							_clearPanel.x = 491.95;
							_clearPanel.y = 390+_clearPanel.height+20;
							_clearPanel.addEventListener(Event.CLOSE,onClearPanelClose);
							_disSprite.addMidSprite(_clearPanel);
							_clearPanel.visible = false;
						}
						Tweener.addTween(_clearPanel,{y:390,visible:true,time:0.5,onComplete:clearAllMoveEnd});
						
						function clearAllMoveEnd():void
						{
							_disSprite.addPanelSprite(_clearPanel);
						}
						break;
					}	
						
					case "shapeBtn":
					{
						ApplicationData.getInstance().isTuYaBan = true;
						hideChaChuBtn();
						if(_shapePanle==null)
						{
							_shapePanle = new ShapePanel();
							_shapePanle.scaleX = _shapePanle.scaleY = 3;
							_shapePanle.x = 1160;
							_shapePanle.y = 586.45+_shapePanle.height+20;
							_disSprite.addMidSprite(_shapePanle);
							_shapePanle.visible = false;
						}
						Tweener.addTween(_shapePanle,{y:586.45,visible:true,time:0.5,onComplete:shapePanleMoveEnd});
							
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
						if(_shuXuePanel==null)
						{
							_shuXuePanel = new ShuXuePanel();
							_shuXuePanel.scaleX = _shuXuePanel.scaleY = 3;
							_shuXuePanel.x = 1737.15;
							_shuXuePanel.y = 265.8+_shuXuePanel.height+20;
							_disSprite.addMidSprite(_shuXuePanel);
							_shuXuePanel.visible = false;
						}
						Tweener.addTween(_shuXuePanel,{y:265.8,visible:true,time:0.5,onComplete:shapePanleMoveEnd1});
						
						function shapePanleMoveEnd1():void
						{
							_disSprite.addPanelSprite(_shuXuePanel);
						}
						break;	
					}
						case "btn_0":
						case "btn_1":
						case "btn_2":
						case "btn_3":
						case "btn_4":
						case "btn_5":
						{
							if(event.target.name.split("_")[0]!="btn")return;
							var id:int = event.target.name.split("_")[1];
							if(_tempColorBtn)
							{
								_tempColorBtn.gotoAndStop(1);
							}
							_tempColorBtn = event.target as MovieClip;
							_tempColorBtn.gotoAndStop(2);
							if(id!=5){
								ApplicationData.getInstance().styleVO.lcolor = _colorArr[id];
							}else{
								//弹出颜色选择框
								Tweener.addTween(_colorPanel,{visible:true,y:410,time:0.5});
							}
							//_toolsRes.clearBtn.btn_0.gotoAndStop(1);
							//_toolsRes.clearBtn.btn_1.gotoAndStop(1);
							ApplicationData.getInstance().styleVO.isCir = false;
							ApplicationData.getInstance().styleVO.isEraser = false;
							break;
						}
									
						case "xingZhuangBtn":
						{
							hideChaChuBtn();
							if((event.target as MovieClip).currentFrame==1)
							{
								(event.target as MovieClip).gotoAndStop(2);
							}
							ApplicationData.getInstance().isTuYaBan = true;
							_tuXingVO.tuYa = true;
							_tuXingVO.tianChong = false;
							_tuXingVO.shape = false;
							_tuXingVO.drawShape = true;
							NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
							break;
						}			
									
						case "tianChongBtn":
						{
							ApplicationData.getInstance().isTuYaBan = true;
							hideChaChuBtn();
							_tuXingVO.tuYa = false;
							_tuXingVO.tianChong = true;
							_tuXingVO.shape = false;
							_tuXingVO.drawShape = true;
							NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
							break;
						}		
						case "cheXiaoBtn":
						{
							if((event.target as MovieClip).currentFrame==2)return;
							NotificationFactory.sendNotification(NotificationIDs.CHEXIAO);
							break;
						}
							
						case "chongZuoBtn":
						{
							if((event.target as MovieClip).currentFrame==2)return;
							NotificationFactory.sendNotification(NotificationIDs.CHONEZUO);
							break;
						}
							
						case "paiZhaoBtn":
						{
							(event.target as MovieClip).alpha= 1;
							NotificationFactory.sendNotification(NotificationIDs.PHOTO_GRAPH);
							break;
						}
							
						case "caChuBtn":
						{
							/**if((event.target as MovieClip).currentFrame==1){
								(event.target as MovieClip).gotoAndStop(2);
								_tempThincess = ApplicationData.getInstance().styleVO.lineThickness;
								_templineStyle = ApplicationData.getInstance().styleVO.lineStyle;
								ApplicationData.getInstance().styleVO.lineThickness = 20;
								ApplicationData.getInstance().styleVO.lineStyle  = 0;
								ApplicationData.getInstance().styleVO.isCir = false;
								ApplicationData.getInstance().styleVO.isEraser = true;
								_styleVO.isCir = false;
								_styleVO.isEraser = true;
							}else{
								(event.target as MovieClip).gotoAndStop(1);
								ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
								ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
								_styleVO.isCir = false;
								_styleVO.isEraser = false;
								ApplicationData.getInstance().styleVO.isCir = false;
								ApplicationData.getInstance().styleVO.isEraser = false;
							}**/
							_phoneTools1Res.clearBtn.gotoAndStop(1);
							if((event.target as MovieClip).currentFrame==1){
								(event.target as MovieClip).gotoAndStop(2);
								_tempThincess = ApplicationData.getInstance().styleVO.lineThickness;
								_templineStyle = ApplicationData.getInstance().styleVO.lineStyle;
								ApplicationData.getInstance().styleVO.lineThickness = 20;
								ApplicationData.getInstance().styleVO.lineStyle  = 0;
								ApplicationData.getInstance().styleVO.isCir = false;
								ApplicationData.getInstance().styleVO.isEraser = true;
								_styleVO.isCir = false;
								_styleVO.isEraser = true;
							}else{
								(event.target as MovieClip).gotoAndStop(1);
								ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
								ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
								_styleVO.isCir = false;
								_styleVO.isEraser = false;
								ApplicationData.getInstance().styleVO.isCir = false;
								ApplicationData.getInstance().styleVO.isEraser = false;
							}
							break;
						}
							
						case "clearBtn":
						{
							/**if((event.target as MovieClip).currentFrame==1){
								(event.target as MovieClip).gotoAndStop(2);
								_tempThincess = ApplicationData.getInstance().styleVO.lineThickness;
								_templineStyle = ApplicationData.getInstance().styleVO.lineStyle;
								_styleVO.isCir = true;
								_styleVO.isEraser = false;
								ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
								ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
								ApplicationData.getInstance().styleVO.isCir = true;
								ApplicationData.getInstance().styleVO.isEraser = false;
							}else{
								(event.target as MovieClip).gotoAndStop(1);
								_styleVO.isCir = false;
								_styleVO.isEraser = false;
								ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
								ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
								ApplicationData.getInstance().styleVO.isCir = false;
								ApplicationData.getInstance().styleVO.isEraser = false;
							}**/
							if((_phoneTools1Res.caChuBtn as MovieClip).currentFrame==2)
							{
								_phoneTools1Res.caChuBtn.gotoAndStop(1);
								ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
								ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
								_styleVO.isCir = false;
								_styleVO.isEraser = false;
								ApplicationData.getInstance().styleVO.isCir = false;
								ApplicationData.getInstance().styleVO.isEraser = false;
							}
							if((event.target as MovieClip).currentFrame==1){
								(event.target as MovieClip).gotoAndStop(2);
								_tempThincess = ApplicationData.getInstance().styleVO.lineThickness;
								_templineStyle = ApplicationData.getInstance().styleVO.lineStyle;
								_styleVO.isCir = true;
								_styleVO.isEraser = false;
								ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
								ApplicationData.getInstance().styleVO.lineStyle = _templineStyle;
								ApplicationData.getInstance().styleVO.isCir = true;
								ApplicationData.getInstance().styleVO.isEraser = false;
							}else{
								(event.target as MovieClip).gotoAndStop(1);
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
					
		/**
		 * @isAll 是全部还是一个
		 * @param mcID 那个按钮
		 * @param id   按钮跑到第几帧
		*/								
		public function gotoStop(isAll:Boolean,mcID:int,id:int):void
		{
			if(isAll){
				_phoneTools1Res.cheXiaoBtn.gotoAndStop(id);
				_phoneTools1Res.chongZuoBtn.gotoAndStop(id);
			}else{
				if(mcID==0)
				{
					_phoneTools1Res.cheXiaoBtn.gotoAndStop(id);
				}else{
					_phoneTools1Res.chongZuoBtn.gotoAndStop(id);
				}
			}
		}					
					
		private function onClearPanelClose(event:Event):void
		{
			_disSprite.addMidSprite(_clearPanel);
			Tweener.addTween(_clearPanel,{y:828.9+_clearPanel.height+20,visible:false,time:0.5});		
		}
		
		private function onColorPanelClose(e:Event):void
		{
			if(_colorPanel)
			{
				_disSprite.addMidSprite(_colorPanel);
				Tweener.addTween(_colorPanel,{visible:false,y:1080,time:0.5});
			}
		}
		
		private function hideChaChuBtn():void
		{
			_phoneTools1Res.caChuBtn.gotoAndStop(1);
			_phoneTools1Res.clearBtn.gotoAndStop(1);
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
			if(_brushPanel)
			{
				_disSprite.addMidSprite(_brushPanel);
				Tweener.addTween(_brushPanel,{y:367.05+_brushPanel.height,visible:false,time:0.5});
			}
			if(_colorPanel)
			{
				_disSprite.addMidSprite(_colorPanel);
				Tweener.addTween(_colorPanel,{visible:false,y:1080,time:0.5});
			}
			if(_shapePanle)
			{
				_disSprite.addMidSprite(_shapePanle);
				Tweener.addTween(_shapePanle,{y:586.45+_shapePanle.height+20,visible:false,time:0.5});
			}
			if(_shuXuePanel)
			{
				_disSprite.addMidSprite(_shuXuePanel);
				Tweener.addTween(_shuXuePanel,{y:265.8+_shuXuePanel.height+20,visible:false,time:0.5});
			}
		}
	}
}