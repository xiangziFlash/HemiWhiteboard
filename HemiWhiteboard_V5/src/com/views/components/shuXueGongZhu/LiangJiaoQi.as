package com.views.components.shuXueGongZhu
{
	import com.lylib.touch.objects.RotatableScalable1;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class LiangJiaoQi extends Sprite
	{
		private var _liangjiaoQiRes:LiangJiaoQiRes;
		private var _downX:Number=0;
		private var _downY:Number=0;
		
		private var _down2X:Number=0;
		private var _down2Y:Number=0;
		
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _line:Shape;
		private var _huDu:Number=0;
		private var _jiaoDu:Number=0;
		private var _line2:Shape;
		private var _shapeSp:Sprite;
		private var _line3:Shape;
		private var _line4:Shape;
		
		private var _startRotation:Number=0;
		private var _endRotation:Number=0;
		private var _moveX:Number;
		private var _moveY:Number;
		private var _xieBian:Number=0;
		
		private var _ballJiaoDu1:Number=0;
		private var _ballJiaoDu2:Number=0;
		private var _ballJiaoDu:int=0;
		
		public function LiangJiaoQi()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function onAddStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddStage);
			
			_liangjiaoQiRes = new LiangJiaoQiRes();
			
			_line = new Shape();
			_line2 = new Shape();
			_line3 = new Shape();
			_line4 = new Shape();
			
			this.addChild(_liangjiaoQiRes);
			
			this.addChild(_line);
			this.addChild(_line2);
			this.addChild(_liangjiaoQiRes.ball1);
			this.addChild(_liangjiaoQiRes.ball2);
			this.addChild(_liangjiaoQiRes.queDing);
			this.addChild(_liangjiaoQiRes.jiaoDu);
			
			_line2.graphics.lineStyle(2,ApplicationData.getInstance().styleVO.lcolor);
			_line2.graphics.moveTo(0,0);
			_line2.graphics.lineTo(_liangjiaoQiRes.ball1.x,_liangjiaoQiRes.ball1.y);
			
			_line.graphics.lineStyle(2,ApplicationData.getInstance().styleVO.lcolor);
			_line.graphics.moveTo(0,0);
			_line.graphics.lineTo(_liangjiaoQiRes.ball2.x,_liangjiaoQiRes.ball2.y);
			
			_downX = _liangjiaoQiRes.ball1.x;
			_downY = _liangjiaoQiRes.ball1.y;
			_down2X = _liangjiaoQiRes.ball2.x;
			_down2Y = _liangjiaoQiRes.ball2.y;
			
			(_liangjiaoQiRes.jiaoDu.tt as TextField).embedFonts = true;
			(_liangjiaoQiRes.jiaoDu.tt as TextField).defaultTextFormat = new TextFormat("YaHei_font",24,0xFFFFFF);
			(_liangjiaoQiRes.jiaoDu.tt as TextField).autoSize = TextFieldAutoSize.CENTER;
			(_liangjiaoQiRes.jiaoDu.tt as TextField).text = "";

			_liangjiaoQiRes.mc.addEventListener(MouseEvent.MOUSE_DOWN,onMCDown);
			_liangjiaoQiRes.ball1.addEventListener(MouseEvent.MOUSE_DOWN,onBaShou0Down);
			_liangjiaoQiRes.ball2.addEventListener(MouseEvent.MOUSE_DOWN,onBaShou2Down);
			_liangjiaoQiRes.queDing.addEventListener(MouseEvent.CLICK,onQueDingClick);
			_liangjiaoQiRes.xuanZhuan.addEventListener(MouseEvent.MOUSE_DOWN,onXuanZhuanDown);
			_liangjiaoQiRes.closeBtn.addEventListener(MouseEvent.CLICK,onCloseClick);
		}
		
		private function onBaShou0Down(event:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			
			_tempX = mouseX;
			_tempY = mouseY;
			_liangjiaoQiRes.ball1.x = mouseX;
			_liangjiaoQiRes.ball1.y = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBaShou0Move);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBaShou0Up);
		}
		
		private function onBaShou0Move(event:MouseEvent):void
		{
			if(_downY>0)
			{
				_downY=0;
			}
			//_xieBian = Point.distance(new Point(mouseX,mouseY),new Point(0,0));
			//var jiaoDu:Number = Math.abs(mouseY)/_xieBian*180/Math.PI;
		//	trace(jiaoDu,"jiaoDu");
			_line.graphics.clear();
			_line.graphics.lineStyle(2,ApplicationData.getInstance().styleVO.lcolor);
			_line.graphics.moveTo(0,0);
			_line.graphics.lineTo(_downX,_downY);
			_liangjiaoQiRes.ball1.x = _downX;
			_liangjiaoQiRes.ball1.y = _downY;
			_downX = mouseX;
			_downY = mouseY;
			
		/**	_huDu = Math.atan2(stage.mouseY-this.y, stage.mouseX-this.x);
			_jiaoDu = _huDu / Math.PI * 180;**/
			var huDu:Number = Math.atan2(mouseY, mouseX);
//			_ballJiaoDu1 =180 + (huDu / Math.PI * 180);
			var jiaoDu:Number = huDu / Math.PI * 180;
			if(jiaoDu<-180)
			{
				jiaoDu = -180;
			}
			
			if(jiaoDu>0)
			{
				if(_liangjiaoQiRes.ball1.x>0)
				{
					jiaoDu = 0;
				}else{
					jiaoDu = -180;
				}
			}
			_ballJiaoDu1 = 180 +jiaoDu;
			_ballJiaoDu = Math.abs(_ballJiaoDu2-_ballJiaoDu1);
			(_liangjiaoQiRes.jiaoDu.tt as TextField).text = String(_ballJiaoDu)+"°";
//			(_liangjiaoQiRes.jiaoDu.tt as TextField).text = String(_ballJiaoDu1)+"°";
		}
		
		private function onBaShou0Up(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBaShou0Move);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBaShou0Up);
		}
		
		private function onBaShou2Down(e:MouseEvent):void
		{
			_down2X = mouseX;
			_down2Y = mouseY;
			_liangjiaoQiRes.ball2.x = mouseX;
			_liangjiaoQiRes.ball2.y = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBaShou2Move);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBaShou2Up);
		}
		
		private function onBaShou2Move(event:MouseEvent):void
		{
			if(_down2Y>0)
			{
				_down2Y=0;
			}
				
			_line2.graphics.clear();
			_line2.graphics.lineStyle(2,ApplicationData.getInstance().styleVO.lcolor);
			_line2.graphics.moveTo(0,0);
			_line2.graphics.lineTo(_down2X,_down2Y);
			_liangjiaoQiRes.ball2.x = _down2X;
			_liangjiaoQiRes.ball2.y = _down2Y;
			_down2X = mouseX;
			_down2Y = mouseY;
			
			var huDu:Number = Math.atan2(mouseY, mouseX);
			var jiaoDu:Number = huDu / Math.PI * 180;
			
			if(jiaoDu<-180)
			{
				jiaoDu = -180;
			}
			
			if(jiaoDu>0)
			{
				if(_liangjiaoQiRes.ball2.x>0)
				{
					jiaoDu = 0;
				}else{
					jiaoDu = -180;
				}
			}
			_ballJiaoDu2 = 180 +jiaoDu;
			_ballJiaoDu = Math.abs(_ballJiaoDu2-_ballJiaoDu1);
			(_liangjiaoQiRes.jiaoDu.tt as TextField).text = String(_ballJiaoDu)+"°";
//			(_liangjiaoQiRes.jiaoDu.tt as TextField).text = String(_ballJiaoDu2)+"°";
		}
		
		private function onBaShou2Up(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBaShou2Move);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBaShou2Up);
		}
		
		
		private function onQueDingClick(e:MouseEvent):void
		{
			_shapeSp = new Sprite();
			this.addChild(_shapeSp);
			_shapeSp.addChild(_line3);
			_shapeSp.addChild(_line4);
			
			_line3.graphics.clear();
			_line3.graphics.lineStyle(2,ApplicationData.getInstance().styleVO.lcolor);
			_line3.graphics.moveTo(0,0);
			_line3.graphics.lineTo(_liangjiaoQiRes.ball1.x,_liangjiaoQiRes.ball1.y);
			
			_line4.graphics.clear();
			_line4.graphics.lineStyle(2,ApplicationData.getInstance().styleVO.lcolor);
			_line4.graphics.moveTo(0,0);
			_line4.graphics.lineTo(_liangjiaoQiRes.ball2.x,_liangjiaoQiRes.ball2.y);
			
			NotificationFactory.sendNotification(NotificationIDs.SHUXUE_GONGJU_END,_shapeSp);
		}
	
		private function onMCDown(e:MouseEvent):void
		{
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove1);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp1);
		}
		
		private function onMove1(event:MouseEvent):void
		{
			var rect:Rectangle = this.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			/*if(rect.left<960&&rect.right>980){
				//	trace(rect.top,rect.bottom)
				if(rect.top>1000-rect.height*0.2){
					this.alpha = 0.5;
					return;
				}					
			}*/
			//	trace(rect.left,rect.right,"lf")
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<ConstData.stageWidth*0.5-20&&rect.right>ConstData.stageWidth*0.5+20){
				//	trace(rect.top,rect.bottom)
				if(rect.top>(ConstData.stageHeight-80)-rect.height*0.2){
					this.alpha = 0.5;
					return;
				}					
			}
			this.alpha = 1;
		}
		
		private function onUp1(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove1);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp1);
			stopDrag();
			var rect:Rectangle = this.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(this.alpha<1){
				Tweener.addTween(this,{x:972,y:1056,scaleX:0.1,scaleY:0.1,alpha:0,time:0.5,onComplete:clearGraph});
			}
			function clearGraph():void
			{
//				reset();
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function onXuanZhuanDown(e:MouseEvent):void
		{
			_moveX=mouseX;
			_moveY=mouseY;
			_startRotation = this.rotation;
			_endRotation = _startRotation;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onXuanZhuanMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onXuanZhuanBtnUp);
		}
		
		private function onXuanZhuanMove(event:MouseEvent):void
		{
//			_endRotation+=_startRotation;
//			_res.rotation =_endRotaion;
			/*_huDu = Math.atan2(stage.mouseY-this.y, stage.mouseX-this.x);
			_jiaoDu = _huDu / Math.PI * 180;
			_endRotation+=_jiaoDu;
			this.rotation = _endRotation;*/
			var a:Number=Point.distance(new Point(mouseX,mouseY),new Point(_moveX,_moveY));
			var b:Number=Point.distance(new Point(0,0),new Point(_moveX,_moveY));
			var c:Number=Point.distance(new Point(mouseX,mouseY),new Point(0,0));
			//trace(a,b,c,(b*b+c*c-a*a)/(2*b*c));
			var tempRotaion:Number=Math.acos((b*b+c*c-a*a)/(2*b*c))/ Math.PI * 180;
			
			var moveT:Number=(_moveX)/b;
			var nowT:Number=(mouseX)/c;
			if(mouseY>0){
				if(nowT>moveT){
					tempRotaion=-tempRotaion;
				}
			}else{
				if(nowT<moveT){
					tempRotaion=-tempRotaion;
				}
			}
			_endRotation+=tempRotaion;
			this.rotation =_endRotation;
			
			_moveX=mouseX;
			_moveY=mouseY;
		}
		
		private function onXuanZhuanBtnUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onXuanZhuanMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onXuanZhuanBtnUp);
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function clear():void
		{
			this.visible = false;
			this.scaleX = this.scaleY = 1;
			this.alpha = 1;
//			dispose();
		}
		
		public function reset():void
		{
//			this.removeChild(_liangjiaoQiRes);
//			_liangjiaoQiRes.con.removeEventListener(MouseEvent.MOUSE_DOWN,onConDown);
		}
	}
}
