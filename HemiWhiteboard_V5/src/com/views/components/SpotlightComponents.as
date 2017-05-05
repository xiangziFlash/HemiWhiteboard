package com.views.components
{
	import com.UI.systemTools.LightToolBtnRes;
	import com.UI.systemTools.moveRes;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * 探照灯 
	 * @author zyy
	 * 
	 */	
	public class SpotlightComponents extends Sprite
	{
		private var _blackBg:Sprite;
		private var _bmpd:BitmapData=new BitmapData(1920,1080,true,0);
		private var _bmp:Bitmap;
		private var _drawSp:Sprite;
		
		private var _circleSp:Sprite;
		private var _inCircle:Sprite;
		private var _outCircle:Sprite;
		
		private var _rectSp:Sprite;
		private var _inRect:Sprite;
		private var _outRect:Sprite;
		private var _outDownX:Number;
		private var _outDownY:Number;
		private var _disNum:Number=170;
		
		private var _controlBtnRes:LightToolBtnRes;
		private var _moveRes:moveRes;
		private var _isShow:Boolean;
		private var _lineDownX:Number;
		private var _alpha:Number=1;
		private var _isRect:Boolean;

		private var _disObj:Stage;
		public function SpotlightComponents()
		{
			initContainer();
			initListener();
		}
		
		private function initContainer():void
		{
			_circleSp = new Sprite();
			_circleSp.x=1920*0.5;
			_circleSp.y=1080*0.5;
			
			_inCircle = new Sprite();
			_outCircle = new Sprite();

			_blackBg = new Sprite();
			_blackBg.graphics.beginFill(0,1);
			_blackBg.graphics.drawRect(0,0,1920,1080);
			
			_blackBg.graphics.drawCircle(_circleSp.x,_circleSp.y,170);
			_blackBg.graphics.endFill();
			
			_controlBtnRes = new LightToolBtnRes();
			_controlBtnRes.btn_1.gotoAndStop(1);
			
			_moveRes = new moveRes();
			_moveRes.alpha=0;
			_moveRes.visible=false;
			_moveRes.moveLine.x=160;
			
			drawCircle(0,0,170,false);
			
			_bmp=new Bitmap(_bmpd,"auto");
			_bmp.smoothing=true;
			
			_bmp.mask=_inCircle;
			_bmp.visible=false;
		}
		
		private function initListener():void
		{
			_blackBg.addEventListener(MouseEvent.MOUSE_DOWN,onBgDown);
//			_outCircle.addEventListener(MouseEvent.MOUSE_DOWN,onOutDown);
//			
//			_controlBtnRes.btn_0.addEventListener(MouseEvent.CLICK,onCloseClick);
//			_controlBtnRes.btn_1.addEventListener(MouseEvent.CLICK,onChangeClick);
//			_controlBtnRes.btn_2.addEventListener(MouseEvent.CLICK,onShowClick);
//			_moveRes.moveLine.addEventListener(MouseEvent.MOUSE_DOWN,onLineDown);
		}
		
		/**
		 * 根据DisplayObject对象绘制Bitmap
		 * */
		public function setDisObj(disObj:Stage):void
		{
			_disObj=disObj;
//			this.addChild(_disObj);
			this.addChild(_blackBg);
			this.addChild(_bmp);
			_circleSp.addChild(_inCircle);
			_circleSp.addChild(_outCircle);
			this.addChild(_circleSp);
			this.addChild(_controlBtnRes);
			this.addChild(_moveRes);
		}	
		
		/**
		 * 控制圆移动
		 * */
		private function onBgDown(event:MouseEvent):void
		{
			trace("onBgDown");
			this.visible = false;
			_bmpd.draw(_disObj);
			this.visible = true;
			/*if(_isShow)
			{
				Tweener.addTween(_moveRes,{alpha:0,time:0.3,visible:false})
				_isShow=false;
			}*/
			
			_circleSp.startDrag();
		//	stage.addEventListener(MouseEvent.MOUSE_MOVE,onBgMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBgUp);
			
			
			_blackBg.graphics.clear();
			_blackBg.graphics.beginFill(0,1);
			_blackBg.graphics.drawRect(0,0,1920,1080);
			_bmp.visible=true;
		}
		
		private function onBgMove(event:MouseEvent):void
		{
			trace("onBgMove");
			/*if(_circleSp.x<=0)
			{
				_circleSp.x=0;
			}
			if(_circleSp.x>=1920)
			{
				_circleSp.x=1920;
			}
			if(_circleSp.y<=0)
			{
				_circleSp.y=0;
			}
			if(_circleSp.y>=1080)
			{
				_circleSp.y=1080;
			}*/
			
//			setXY(_circleSp.x,_circleSp.y,_circleSp.width,_circleSp.height);
		}
		
		private function onBgUp(event:MouseEvent):void
		{
			_circleSp.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBgMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBgUp);
			
			if(_isRect)
			{
				_blackBg.graphics.drawRoundRect(_circleSp.x-_circleSp.width*0.5,_circleSp.y-_circleSp.height*0.5,_disNum*2,_disNum*2,20);
				_blackBg.graphics.endFill();
			}
			else
			{
				_blackBg.graphics.drawCircle(_circleSp.x,_circleSp.y,_disNum);
				_blackBg.graphics.endFill();
			}
			_bmp.visible=false;
		}
		//*******************************************************************************************************
		
		/**
		 * 控制外圈移动，绘制圆
		 * */
		private function onOutDown(event:MouseEvent):void
		{
			this.visible = false;
			_bmpd.draw(_disObj);
			this.visible = true;
			if(_isShow)
			{
				Tweener.addTween(_moveRes,{alpha:0,time:0.3,visible:false})
				_isShow=false;
			}
			
			_outDownX = mouseX;
			_outDownY = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onOutMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onOutUp);
			
			_blackBg.graphics.clear();
			_blackBg.graphics.beginFill(0,1);
			_blackBg.graphics.drawRect(0,0,1920,1080);
			_bmp.visible=true;
		}
		
		private function onOutMove(event:MouseEvent):void
		{
			_disNum = Math.sqrt((mouseX-_circleSp.x)*(mouseX-_circleSp.x)+(mouseY-_circleSp.y)*((mouseY-_circleSp.y)));
			if(_disNum<=170)
			{
				_disNum=170;
			}else if(_disNum>=540)
			{
				_disNum=540;
			}
			
			drawCircle(0,0,_disNum,_isRect);
		}
		
		private function onOutUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onOutMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onOutUp);
			
			if(_isRect)
			{
				_blackBg.graphics.drawRoundRect(_circleSp.x-_disNum,_circleSp.y-_disNum,_disNum*2,_disNum*2,20);
				_blackBg.graphics.endFill();
			}
			else
			{
				_blackBg.graphics.drawCircle(_circleSp.x,_circleSp.y,_disNum);
				_blackBg.graphics.endFill();
			}
			_bmp.visible=false;
		}
		//*******************************************************************************************************************
		
		/**
		 * 控制缩放按钮
		 * */
		private function onLineDown(event:MouseEvent):void
		{
			_lineDownX=mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onLineMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onLineUp);
		}
		
		private function onLineMove(event:MouseEvent):void
		{
			_moveRes.moveLine.x+=mouseX-_lineDownX;
			if(_moveRes.moveLine.x<=0)
			{
				_moveRes.moveLine.x=0
			}else if(_moveRes.moveLine.x>=160)
			{
				_moveRes.moveLine.x=160;
			}
			
			_alpha=Math.round(_moveRes.moveLine.x*1/160*10)/10;
			
//			_blackBg.alpha=_alpha;
			Tweener.addTween(_blackBg,{alpha:_alpha,time:0.3})
			_lineDownX=mouseX;
		}
		
		private function onLineUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onLineMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onLineUp);
		}
		//*****************************************************************************************************************
		
	
		/**
		 * 绘制圆形OR矩形
		 * */
		public function drawCircle(nX:Number, nY:Number, nRadius:Number,boo:Boolean):void {trace("fasdfasd")
			_inCircle.graphics.clear();
			_outCircle.graphics.clear();
			
			if(boo)
			{
				
				_inCircle.graphics.beginFill(0x0000ff,0)
				_inCircle.graphics.lineStyle(1,0x00ff00,0);
				_inCircle.graphics.drawRect(nX-nRadius, nY-nRadius, nRadius*2, nRadius*2);
				
				_outCircle.graphics.lineStyle(20,0x999999);
				_outCircle.graphics.drawRect(nX-nRadius, nY-nRadius, nRadius*2, nRadius*2);
			}
			else
			{
				_inCircle.graphics.beginFill(0x0000ff,0)
				_inCircle.graphics.lineStyle(1,0x00ff00,0);
				_inCircle.graphics.drawCircle(nX, nY, nRadius);
				
				_outCircle.graphics.lineStyle(20,0x999999);
				_outCircle.graphics.drawCircle(nX, nY, nRadius);
			}
			
			_circleSp.addChild(_inCircle);
			_circleSp.addChild(_outCircle);
			
			setXY(_circleSp.x,_circleSp.y,_circleSp.width,_circleSp.height);
		}
		
		
		private function setXY(nX:Number,nY:Number,nW:Number,nH:Number):void
		{
			_controlBtnRes.x=nX+nW*0.5+20;
			_controlBtnRes.y=nY-150*0.5;
			_moveRes.x=_controlBtnRes.x+55;
			_moveRes.y=_controlBtnRes.y+110;
		}
		
		/**
		 *  关闭聚光灯 派发close事件
		 * */
		private function onCloseClick(event:MouseEvent):void
		{
			reset();
			this.dispatchEvent(new Event(Event.CLOSE));	
		}
		
		/**
		 * 圆和矩形的切换
		 * */
		private function onChangeClick(event:MouseEvent):void
		{
			_disNum=170;
			_circleSp.x=1920*0.5;
			_circleSp.y=1080*0.5;
			
			if(!_isRect)
			{
				_controlBtnRes.btn_1.gotoAndStop(2);
				_isRect=true;
				drawCircle(0,0,170,true);
				
				_blackBg.graphics.clear();
				_blackBg.graphics.beginFill(0,1);
				_blackBg.graphics.drawRect(0,0,1920,1080);
				
				_blackBg.graphics.drawRoundRect(_circleSp.x-_circleSp.width*0.5,_circleSp.y-_circleSp.height*0.5,170*2,170*2,20);
				_blackBg.graphics.endFill();
			}
			else
			{
				_controlBtnRes.btn_1.gotoAndStop(1);
				_isRect=false;
				drawCircle(0,0,170,false);
				
				_blackBg.graphics.clear();
				_blackBg.graphics.beginFill(0,1);
				_blackBg.graphics.drawRect(0,0,1920,1080);
				
				_blackBg.graphics.drawCircle(_circleSp.x,_circleSp.y,170);
				_blackBg.graphics.endFill();
			}
		}
		
		/**
		 * 控制拖动条的显示
		 * */
		private function onShowClick(event:MouseEvent):void
		{
			if(!_isShow)
			{
				Tweener.addTween(_moveRes,{alpha:1,time:0.3,visible:true})
				_isShow=true;
			}
		}
		
		public function reset():void
		{
			_moveRes.moveLine.x=160
			_moveRes.alpha=0;
			_moveRes.visible=false;
			_isShow=false;
			
			_isRect=false
			drawCircle(0,0,170,false);
			
			_circleSp.x = 1920*0.5;
			_circleSp.y = 1080*0.5;
		
			setXY(_circleSp.x,_circleSp.y,_circleSp.width,_circleSp.height);
			
			_blackBg.graphics.clear();
			_blackBg.graphics.beginFill(0,1);
			_blackBg.graphics.drawRect(0,0,1920,1080);
			
			_blackBg.graphics.drawCircle(_circleSp.x,_circleSp.y,170);
			_blackBg.graphics.endFill();
			_alpha=1;
			_blackBg.alpha=_alpha;
			_bmp.visible=false;
			
			_controlBtnRes.btn_1.gotoAndStop(1);
		}
	}
}