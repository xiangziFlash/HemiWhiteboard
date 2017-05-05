package com.views.components.panel
{
	import com.models.ApplicationData;
	import com.models.vo.XiangCeVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.Timer;
	
	public class GongSiXiangCePanel extends Sprite
	{
		private var _toolsPanelRes:ZhuoMianPanelRes;
		private var _downX:Number=0;
		private var _time:Number=20;//设置轮播的时间
		private var _isPlay:Boolean;
		private var _isXunHuan:Boolean=true;
//		private var _vo:XiangCeVO;
		
		private var _hideBtn:PanelHideRes;
		private var _mask:Shape;
		private var _spBtn:Sprite;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		
		private var _hideDownX:Number=0;
		private var _hideDownY:Number=0;
		
		/**
		 * 惯性一系列参数
		 */
		private var _startX:Number=0;
		private var _startY:Number=0;
		private var _upX:Number=0;
		private var _upY:Number=0;
		private var _speedX:Number=0;
		private var _speedY:Number=0;
		private var _timer:Timer;
		private var _moCaLi:Number = 1.2;
		private var _m:Matrix;
		private var isXiFu:Boolean;
		private var _timerTiShi:Timer;
		
		public function GongSiXiangCePanel()
		{
			_hideBtn = new PanelHideRes();
			_toolsPanelRes = new ZhuoMianPanelRes();
			_toolsPanelRes.x = 50;
			
			_mask = new Shape();
			
			this.addChild(_mask);
			this.addChild(_toolsPanelRes);
			this.addChild(_hideBtn);
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xffffff);
			_mask.graphics.drawRect(0,0,this.width,this.height+10);
			_mask.graphics.endFill();
			_mask.y = -71.15;
			this.mask = _mask;
			
			_timer = new Timer(110);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
		
//			_vo = new XiangCeVO();
			_toolsPanelRes.btn_3.mouseChildren=false;
			_toolsPanelRes.clearAllMC.visible=false;
			_toolsPanelRes.clearAllMC.alpha=0;
			_toolsPanelRes.clearAllMC.y=40;
			_toolsPanelRes.addEventListener(MouseEvent.CLICK,onPanelClick);
			_toolsPanelRes.timeBar.barBtn.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			//_hideBtn.addEventListener(MouseEvent.CLICK,onhideToolClick);
			_hideBtn.addEventListener(MouseEvent.MOUSE_DOWN,onHideBtnDown);
			
			chuShi();
		}
		
		/**
		 * 
		 * panel 的初始状态
		 */		
		private function chuShi():void
		{
			_toolsPanelRes.clearAllMC.visible=false;
			_toolsPanelRes.clearAllMC.alpha=0;
			_toolsPanelRes.clearAllMC.y=40;
			_toolsPanelRes.lock_btn.gotoAndStop(1);
			_toolsPanelRes.btn_3.gotoAndStop(1);
			_toolsPanelRes.btn_4.gotoAndStop(1);
			_toolsPanelRes.lock_btn.gotoAndStop(1);
			ApplicationData.getInstance().xiangCeVO.isTimer = false;
			ApplicationData.getInstance().xiangCeVO.isXunHuan = true;
		}
		
		public function setResZhuangTai():void
		{
			if(ApplicationData.getInstance().xiangCeVO.isVisible)
			{
				_toolsPanelRes.minBtn.gotoAndStop(1);
			} else {
				_toolsPanelRes.minBtn.gotoAndStop(2);
			}
		}
		
		private function onhideToolClick(e:MouseEvent):void
		{
//			trace(this.x,"看看在左边还是右边")
			if(this.x >960)
			{
				_mask.graphics.clear();
				_mask.graphics.beginFill(0xffffff);
				_mask.graphics.drawRect(0,0,-this.width,this.height+10);
				_mask.graphics.endFill();
				_mask.y = -71.15;
				_mask.x = 42;
			}else{
				_mask.graphics.clear();
				_mask.graphics.beginFill(0xffffff);
				_mask.graphics.drawRect(0,0,this.width,this.height+10);
				_mask.graphics.endFill();
				_mask.y = -71.15;
				_mask.x = 0;
			}
			if(_hideBtn.currentFrame==1)
			{
				zuoBianCon();
			}else{
				youBianCon();
			}
		}
		
		public function hidePanel():void
		{
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xffffff);
			_mask.graphics.drawRect(0,0,-this.width,this.height);
			_mask.graphics.endFill();
			zuoBianCon();
		}
		
		private function zuoBianCon():void
		{
			_hideBtn.gotoAndStop(2);
			Tweener.addTween(_toolsPanelRes,{x:-_toolsPanelRes.width-10,time:0.5});
		}
		
		private function youBianCon():void
		{
			_hideBtn.gotoAndStop(1);
			Tweener.addTween(_toolsPanelRes,{x:50,time:0.5});
		}
		
		public function hidtCon():void
		{
			_hideBtn.gotoAndStop(2);
			_toolsPanelRes.x = -_toolsPanelRes.width-10;
		}
		
		public function  closeLuck():void
		{
//			trace("closeLuck");
			_toolsPanelRes.lock_btn.gotoAndStop(1);
			_toolsPanelRes.btn_3.gotoAndStop(1);
			ApplicationData.getInstance().xiangCeVO.isTimer = false;
			ApplicationData.getInstance().xiangCeVO.isLock = false;
		}
		
		public function showCon():void
		{
			_hideBtn.gotoAndStop(1);
			_toolsPanelRes.x = 50;
		}
		
		private function onPanelClick(e:MouseEvent):void
		{
			ApplicationData.getInstance().xiangCeVO.isClearAllMedia=false;
			switch(e.target.name)
			{
				case "btn_0":
				{//排列
					_toolsPanelRes.lock_btn.gotoAndStop(1);
					ApplicationData.getInstance().xiangCeVO.isLock = false;
					_toolsPanelRes.btn_3.gotoAndStop(1);
					_isPlay = false;
					ApplicationData.getInstance().xiangCeVO.isTimer = false;
					ApplicationData.getInstance().xiangCeVO.modelID = 0;
					ApplicationData.getInstance().xiangCeVO.isModel = true;
					if(ApplicationData.getInstance().xiangCeVO.isVisible == false){
						ApplicationData.getInstance().xiangCeVO.isVisible = true;
						_toolsPanelRes.minBtn.gotoAndStop(1);
					}
					NotificationFactory.sendNotification(NotificationIDs.HIDE_SHOW_MENU,1);//当点击桌面整理时  影藏浮在上面的内容  派发id==3
					break;
				}
					
				case "btn_1":
				{//大图模式
					_toolsPanelRes.lock_btn.gotoAndStop(1);
					ApplicationData.getInstance().xiangCeVO.isLock = false;
					ApplicationData.getInstance().xiangCeVO.modelID = 1;
					ApplicationData.getInstance().xiangCeVO.isModel = true;
					if(ApplicationData.getInstance().xiangCeVO.isVisible == false){
						ApplicationData.getInstance().xiangCeVO.isVisible = true;
						_toolsPanelRes.minBtn.gotoAndStop(1);
					}
					NotificationFactory.sendNotification(NotificationIDs.HIDE_SHOW_MENU,1);//当点击桌面整理时  影藏浮在上面的内容  派发id==3
					break;
				}
					
				case "btn_2":
				{//全屏幻灯模式
					_toolsPanelRes.lock_btn.gotoAndStop(1);
					ApplicationData.getInstance().xiangCeVO.isLock = false;
					ApplicationData.getInstance().xiangCeVO.modelID = 2;
					ApplicationData.getInstance().xiangCeVO.isModel = true;
					if(ApplicationData.getInstance().xiangCeVO.isVisible == false){//如果点击相册的排列模式了 内容的visible=false 让他变为true
						ApplicationData.getInstance().xiangCeVO.isVisible = true;
						_toolsPanelRes.minBtn.gotoAndStop(1);
					}
					NotificationFactory.sendNotification(NotificationIDs.HIDE_SHOW_MENU,3);//当点击桌面整理时  影藏浮在上面的内容  派发id==3
					break;
				}
					
				case "btn_3":
				{//开始和暂停轮播
					if(ApplicationData.getInstance().xiangCeVO.modelID==1||ApplicationData.getInstance().xiangCeVO.modelID==2)
					{
						if(e.target.currentFrame==1)
						{
							_toolsPanelRes.lock_btn.gotoAndStop(1);
							ApplicationData.getInstance().xiangCeVO.isLock = false;
							
							(e.target as MovieClip).gotoAndStop(2);
							_isPlay = true;
							ApplicationData.getInstance().xiangCeVO.isTimer = true;
						}else{
							(e.target as MovieClip).gotoAndStop(1);
							_isPlay = false;
							ApplicationData.getInstance().xiangCeVO.isTimer = false;
						}
						ApplicationData.getInstance().xiangCeVO.isModel = false;
					}
					break;
				}
					
				case "btn_4":
				{//是否循环播放
					if(e.target.currentFrame==1)
					{
						(e.target as MovieClip).gotoAndStop(2);
						_isXunHuan = false;
						ApplicationData.getInstance().xiangCeVO.isXunHuan = false;
					}else{
						(e.target as MovieClip).gotoAndStop(1);
						_isXunHuan = true;
						ApplicationData.getInstance().xiangCeVO.isXunHuan = true;
					}
					ApplicationData.getInstance().xiangCeVO.isModel = false;
					break;
				}
				case "btn_5":
				{//混排模式
					_toolsPanelRes.lock_btn.gotoAndStop(1);
					ApplicationData.getInstance().xiangCeVO.isLock = false;
					ApplicationData.getInstance().xiangCeVO.modelID = 3;
					ApplicationData.getInstance().xiangCeVO.isModel = true;
					ApplicationData.getInstance().xiangCeVO.isTimer = false;
					_toolsPanelRes.btn_3.gotoAndStop(1);
					if(ApplicationData.getInstance().xiangCeVO.isVisible == false){//如果点击相册的排列模式了 内容的visible=false 让他变为true
						ApplicationData.getInstance().xiangCeVO.isVisible = true;
						_toolsPanelRes.minBtn.gotoAndStop(1);
					}
					NotificationFactory.sendNotification(NotificationIDs.HIDE_SHOW_MENU,1);//当点击桌面整理时  影藏浮在上面的内容  派发id==3
					break;
				}
				case "lock_btn":
				{
					if(e.target.currentFrame==1)
					{
						(e.target as MovieClip).gotoAndStop(2);
						ApplicationData.getInstance().xiangCeVO.isLock = true;
					}else{
						(e.target as MovieClip).gotoAndStop(1);
						ApplicationData.getInstance().xiangCeVO.isLock = false;
					}
					_toolsPanelRes.btn_3.gotoAndStop(1);
					_isPlay = false;
					ApplicationData.getInstance().xiangCeVO.isTimer = false;
					ApplicationData.getInstance().xiangCeVO.isModel = true;
					break;
				}
				case "clearBtn":
				{
					ApplicationData.getInstance().xiangCeVO.isClear = true;
					ApplicationData.getInstance().xiangCeVO.isModel = false;
					break;
				}
				case "clearAllBtn":
				{
					if(_toolsPanelRes.clearAllMC.visible){
						hideClearAllMC();
					}else{
						showClearAllMC();
					}
					ApplicationData.getInstance().xiangCeVO.isModel = false;
					break;
				}	
				case "clearOKBtn":
				{
					NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在删除卡片,请稍后...");
					if(_timerTiShi==null)
					{
						_timerTiShi = new Timer(5*1000);
						_timerTiShi.reset();
						_timerTiShi.stop();
						_timerTiShi.addEventListener(TimerEvent.TIMER,onHideLoadingEnd);
					}
					chuShi();
					ApplicationData.getInstance().xiangCeVO.isClearAllMedia=true;
					ApplicationData.getInstance().xiangCeVO.isModel = false;
					ApplicationData.getInstance().xiangCeVO.modelID =5;
					
					_timerTiShi.reset();
					_timerTiShi.start();
					break;
				}	
				case "clearCancelBtn":
				{
					ApplicationData.getInstance().xiangCeVO.isModel = false;
					break;
				}	
				case "minBtn":
				{
					if(e.target.currentFrame==1)
					{
						(e.target as MovieClip).gotoAndStop(2);
						ApplicationData.getInstance().xiangCeVO.isVisible = false;
					//	_vo.isLock = true;
					}else{
						(e.target as MovieClip).gotoAndStop(1);
						//_vo.isLock = false;
						ApplicationData.getInstance().xiangCeVO.isVisible = true;
					}
					_toolsPanelRes.btn_3.gotoAndStop(1);
					_isPlay = false;
					ApplicationData.getInstance().xiangCeVO.isTimer = false;
					ApplicationData.getInstance().xiangCeVO.isModel = false;
					break;
				}
			}
			ApplicationData.getInstance().xiangCeVO.isHemi = false;
			NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
			ApplicationData.getInstance().xiangCeVO.isClear = false;
		}
		
		private function onHideLoadingEnd(event:TimerEvent):void
		{
			_timerTiShi.stop();
			//NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"卡片已删除");
		}
		/**
		 *显示清除所有媒体元件 
		 * @param e
		 * 
		 */		
		private function showClearAllMC(e:MouseEvent=null):void{
			Tweener.addTween(_toolsPanelRes.clearAllMC,{alpha:1,y:-71.15,visible:true,time:0.5,onComplete:onShowClearAllMCEnd});
		}
		
		private function onShowClearAllMCEnd():void
		{
			// TODO Auto Generated method stub
			stage.addEventListener(MouseEvent.CLICK,hideClearAllMC);
		}
		/**
		 *隐藏清除所有媒体元件 
		 * @param e
		 * 
		 */		
		private function hideClearAllMC(e:MouseEvent=null):void{
			stage.removeEventListener(MouseEvent.CLICK,hideClearAllMC);
			Tweener.addTween(_toolsPanelRes.clearAllMC,{alpha:0,y:53.2,visible:false,time:0.5});
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			_downX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(event:MouseEvent):void
		{
			_toolsPanelRes.timeBar.barBtn.x +=mouseX-_downX;
			_downX = mouseX;
			if(_toolsPanelRes.timeBar.barBtn.x<0){
				_toolsPanelRes.timeBar.barBtn.x =0;
			}
			
			if(_toolsPanelRes.timeBar.barBtn.x>100){
				_toolsPanelRes.timeBar.barBtn.x =100;
			}
		}
		
		private function onUp(event:MouseEvent):void
		{
			_time = int(5+_toolsPanelRes.timeBar.barBtn.x/100*15);
			_toolsPanelRes.timeBar.barBtn.TT.text = String(_time);
			ApplicationData.getInstance().xiangCeVO.LunBoTime = _time;
			NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
			ApplicationData.getInstance().xiangCeLunBoTime = _time;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onHideBtnDown(e:MouseEvent):void
		{
			_tempX = mouseX;
			_tempY = mouseY;
			_hideDownX = this.x;
			_hideDownY = this.y;
			_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_startY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;	
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onHideBtnMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onHideBtnUp);	
			if(!isXiFu){
				_timer.reset();
				_timer.start();	
			}
		}
		
		private function onHideBtnMove(event:MouseEvent):void
		{
			this.x += mouseX-_tempX;
			this.y += mouseY-_tempY;
			_tempX = mouseX;
			_tempY = mouseY;
		}
		
		private function onHideBtnUp(event:MouseEvent):void
		{
			_upX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_upY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onHideBtnMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onHideBtnUp);	
			//trace("this",this.x)
			if(this.x>1920-42)
			{
				Tweener.addTween(this,{x:1920-42,time:0.5});
			}
			
			if(this.x<0)
			{
				Tweener.addTween(this,{x:0,time:0.5});
			}
			
			if(this.y<0)
			{
				Tweener.addTween(this,{y:0,time:0.5});
			}
			
			if(this.y>970)
			{
				Tweener.addTween(this,{y:970,time:0.5});
			}
			
			if(Math.abs(this.x-_hideDownX)<5&&Math.abs(this.y-_hideDownY)<5)
			{
				onhideToolClick(event);
			}else{
				//触控结束的回调函数
				if(Math.abs(_upX-_startX)>10||Math.abs(_upY-_startY)>10)
				{
					if(!isXiFu){
						_speedX = _upX-_startX;
						_speedY = _upY-_startY;
						this.addEventListener(Event.ENTER_FRAME,onObjFrame);
					}else{
						isXiFu =false;
						Tweener.addTween(this,{x:(1920-this.width)*0.5,y:(1080-this.height)*0.5,time:0.5});
					}
				}else{
					if(!isXiFu){
						_speedX = 0;
						_speedY = 0;
						//	this.addEventListener(Event.ENTER_FRAME,onObjFrame);
					}else{
						isXiFu =false;
						Tweener.addTween(this,{x:(1920-this.width)*0.5,y:(1080-this.height)*0.5,time:0.5});
					}
				}
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_startY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
		}
		
		private function onObjFrame(e:Event):void
		{
			_timer.stop();
			this.stage.removeEventListener(Event.ENTER_FRAME,onObjFrame);
			this.x += _speedX;
			this.y += _speedY;
			
			_speedX /=_moCaLi;
			_speedY /=_moCaLi;
			
			if(Math.abs(_speedX)<=0.09){
				_timer.stop();
				if(this.x>1920-42)
				{
					Tweener.addTween(this,{x:1920-42,time:0.5});
				}
				
				if(this.x<0)
				{
					Tweener.addTween(this,{x:0,time:0.5});
				}
				
				if(this.y<0)
				{
					Tweener.addTween(this,{y:0,time:0.5});
				}
				
				if(this.y>970)
				{
					Tweener.addTween(this,{y:970,time:0.5});
				}
				this.removeEventListener(Event.ENTER_FRAME,onObjFrame);
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		public function reset():void
		{
			//_vo.modelID =5;
		}

		public function get time():Number
		{
			return _time;
		}
		
	}
}