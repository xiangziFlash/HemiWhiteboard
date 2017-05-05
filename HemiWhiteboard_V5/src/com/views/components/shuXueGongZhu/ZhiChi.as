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
	
	public class ZhiChi extends Sprite
	{
		private var _zhiChiRes:ZhiChiRes;
		private var _isHuaXian:Boolean;
		private var _line:Shape;
		private var _downX:Number;
		private var _bmp:Bitmap;
		private var _bmpd:BitmapData;
		private var _isLock:Boolean;
		private var _drawLine:DrawLine;
		private var _globPoint:Point;
		private var _moveX:Number=0;
		private var _tempX:Number=0;
		private var _tempPoint:Point;
		private var _downPoint:Point;
		private var _startPoint:Point;
		private var _dx:Number=0;
		private var _dy:Number=0;
		private var _huDu:Number=0;
		private var _jiaoDu:Number=0;
		
		private var _startRotaion:Number=0;
		private var _endRotaion:Number=0;
		private var _disX:Number;
		private var _disY:Number;
		
		public function ZhiChi()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function onAddStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddStage);
			
			_zhiChiRes = new ZhiChiRes();
			this.addChild(_zhiChiRes);
			
			(_zhiChiRes.jiaoDu.tt as TextField).embedFonts = true;
			(_zhiChiRes.jiaoDu.tt as TextField).defaultTextFormat = new TextFormat("YaHei_font",13,0xFFFFFF);
			(_zhiChiRes.jiaoDu.tt as TextField).autoSize = TextFieldAutoSize.CENTER;
			(_zhiChiRes.jiaoDu.tt as TextField).text = "";
			
			_zhiChiRes.con.addEventListener(MouseEvent.MOUSE_DOWN,onConDown);
			_zhiChiRes.addBtn.addEventListener(MouseEvent.MOUSE_DOWN,onAddDown);
			_zhiChiRes.xuanZhuan.addEventListener(MouseEvent.MOUSE_DOWN,onXuanZhuanDown);
			_zhiChiRes.mc.addEventListener(MouseEvent.MOUSE_DOWN,onMCDown);
			_zhiChiRes.closeBtn.addEventListener(MouseEvent.CLICK,onCloseClick);
			_zhiChiRes.closeBtn.addEventListener(MouseEvent.CLICK,onCloseClick);
		}
		
		private function onConDown(event:MouseEvent):void
		{
			_line = new Shape();
			this.addChild(_line);
			_downX = mouseX
			this.addEventListener(MouseEvent.MOUSE_MOVE,onConMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onConUp);
		}
		
		private function onConMove(event:MouseEvent):void
		{
			_line.graphics.clear();
			_line.graphics.lineStyle(5,ApplicationData.getInstance().styleVO.lcolor);
			_line.graphics.moveTo(_downX,0);
			_line.graphics.lineTo(mouseX,0);
			var dis:Number =0;
			dis = Math.sqrt((_downX-mouseX)*(_downX-mouseX));
			(_zhiChiRes.jiaoDu.tt as TextField).text = String((int(dis/57*10))/10)+"cm";
		}
		
		private function onConUp(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onConMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onConUp);
			NotificationFactory.sendNotification(NotificationIDs.SHUXUE_GONGJU_END,_line);
//			this.removeChild(_line);
		}
		
		private function onClick(e:MouseEvent):void
		{
			
		}
		
		private function touchEnd():void
		{
			
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
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onAddDown(e:MouseEvent):void
		{
			_tempX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onAddBtnMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onAddBtnUp);
		}
		
		private function onAddBtnMove(event:MouseEvent):void
		{
			_moveX = mouseX-_tempX;
			_tempX = mouseX;
			_zhiChiRes.bg.width+=_moveX;
//			_zhiChiRes.keDu.keDuMask.width+=_moveX;
			_zhiChiRes.keDu.keDuMask.width = _zhiChiRes.bg.width+(1-0.89)*_zhiChiRes.bg.width-15;
//			trace(_zhiChiRes.bg.width,"_zhiChiRes.bg.width");
			if(_zhiChiRes.bg.width<672)
			{
//				_zhiChiRes.keDu.keDuMask.width = 672;
				_zhiChiRes.bg.width=672;
				_zhiChiRes.keDu.keDuMask.width = 672+(1-0.89)*672-15;
			}
			if(_zhiChiRes.bg.width>1915){
				_zhiChiRes.bg.width=1915;
//				_zhiChiRes.keDu.keDuMask.width=1915;
				_zhiChiRes.keDu.keDuMask.width = 1915+(1-0.89)*1915-15;
			}
			
			_zhiChiRes.addBtn.x = _zhiChiRes.bg.width-56;
			_zhiChiRes.jiaoDu.x = (_zhiChiRes.bg.width-_zhiChiRes.jiaoDu.width)*0.5;
			_zhiChiRes.closeBtn.x = _zhiChiRes.jiaoDu.x +155;
		}
		
		private function onAddBtnUp(event:MouseEvent):void
		{
			_zhiChiRes.con.width = _zhiChiRes.mc.width = _zhiChiRes.bg.width;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onAddBtnMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onAddBtnUp);
		}
		
		private function onXuanZhuanDown(e:MouseEvent):void
		{
			_disX = mouseX;
			_disY = mouseY;
			_startRotaion=this.rotation;
			_endRotaion=_startRotaion;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onXuanZhuanMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onXuanZhuanBtnUp);
		}
		
		private function onXuanZhuanMove(event:MouseEvent):void
		{
			/**_huDu = Math.atan2(stage.mouseY-this.y, stage.mouseX-this.x);
			_jiaoDu = _huDu / Math.PI * 180;
			this.rotation = _jiaoDu;
			(_zhiChiRes.jiaoDu.tt as TextField).text = String(int(_jiaoDu))+"°";**/
			
			var a:Number=Point.distance(new Point(mouseX,mouseY),new Point(_disX,_disY));
			var b:Number=Point.distance(new Point(0,0),new Point(_disX,_disY));
			var c:Number=Point.distance(new Point(mouseX,mouseY),new Point(0,0));
			//trace(a,b,c,(b*b+c*c-a*a)/(2*b*c));
			var tempRotaion:Number=Math.acos((b*b+c*c-a*a)/(2*b*c))/ Math.PI * 180;
			
			var moveT:Number=(_disX)/b;
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
			_endRotaion+=tempRotaion;
			this.rotation =_endRotaion;
			_disX = mouseX;
			_disY = mouseY;
			
			var tempJiaoDu:int =0;
			if(this.rotation<0)
			{
				tempJiaoDu = 360+this.rotation
			}else{
				tempJiaoDu = this.rotation;
			}
			(_zhiChiRes.jiaoDu.tt as TextField).text = String(tempJiaoDu)+"°";
		}
		
		private function onXuanZhuanBtnUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onXuanZhuanMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onXuanZhuanBtnUp);
		}
		
		private function radianToAngle(radian:Number):Number
		{ 
			return radian*(180/Math.PI); 
		}
		
		public function clear():void
		{
			this.visible = false;
			this.scaleX = this.scaleY = 1;
			this.alpha = 1;
		}
		
		public function reset():void
		{
//			this.removeChild(_zhiChiRes);
			_zhiChiRes.con.removeEventListener(MouseEvent.MOUSE_DOWN,onConDown);
		}
	}
}