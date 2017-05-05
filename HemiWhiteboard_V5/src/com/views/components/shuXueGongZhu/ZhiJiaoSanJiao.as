package com.views.components.shuXueGongZhu
{
	import com.lylib.touch.objects.RotatableScalable1;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.components.DisplaySprite;
	
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
	
	public class ZhiJiaoSanJiao extends Sprite
	{
		private var _ZhiJiaoSanjiaoRes:ZhiJiaoSanJiaoRes;
		private var _isHuaXian:Boolean;
		private var _line:Shape;
		private var _downX:Number;
		private var _downY:Number;
		private var _bmp:Bitmap;
		private var _bmpd:BitmapData;
		private var _isLock:Boolean;
		private var _drawLine:DrawLine;
		private var _globPoint:Point;
		private var _disSprite:DisplaySprite;
		
		private var _huDu:Number=0;
		private var _jiaoDu:Number=0;
		private var _tempX:Number=0;
		private var _moveX:Number=0;
		private var _moveY:Number=0;
		private var _isX:Boolean;
		
		private var _startRotaion:Number=0;
		private var _endRotaion:Number=0;
		private var _disX:Number;
		private var _disY:Number;
		
		public function ZhiJiaoSanJiao()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddAtage);
		}
		
		private function onAddAtage(event:Event):void
		{
			_disSprite = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			
			_ZhiJiaoSanjiaoRes = new ZhiJiaoSanJiaoRes();
			this.addChild(_ZhiJiaoSanjiaoRes);

			(_ZhiJiaoSanjiaoRes.jiaoDu.tt as TextField).embedFonts = true;
			(_ZhiJiaoSanjiaoRes.jiaoDu.tt as TextField).defaultTextFormat = new TextFormat("YaHei_font",13,0xFFFFFF);
			(_ZhiJiaoSanjiaoRes.jiaoDu.tt as TextField).autoSize = TextFieldAutoSize.CENTER;
			(_ZhiJiaoSanjiaoRes.jiaoDu.tt as TextField).text = "";
			
			_ZhiJiaoSanjiaoRes.con.addEventListener(MouseEvent.MOUSE_DOWN,onConDown);
			_ZhiJiaoSanjiaoRes.addBtn.addEventListener(MouseEvent.MOUSE_DOWN,onAddDown);
			_ZhiJiaoSanjiaoRes.xuanZhuan.addEventListener(MouseEvent.MOUSE_DOWN,onXuanZhuanDown);
			_ZhiJiaoSanjiaoRes.mc.addEventListener(MouseEvent.MOUSE_DOWN,onMCDown);
			_ZhiJiaoSanjiaoRes.closeBtn.addEventListener(MouseEvent.CLICK,onCloseClick);
		}
		
		private function onConDown(event:MouseEvent):void
		{
			if(event.target.name=="con1")
			{
				_isX = true;
			}else{
				_isX = false;
			}
			_line = new Shape();
			this.addChild(_line);
			_downX = mouseX;
			_downY = mouseY;
			this.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(event:MouseEvent):void
		{
			_line.graphics.clear();
			_line.graphics.lineStyle(5,ApplicationData.getInstance().styleVO.lcolor);
			var dis:Number =0;
			if(_isX)
			{
				_line.graphics.moveTo(_downX,0);
				_line.graphics.lineTo(mouseX,0);
				dis = Math.sqrt((_downX-mouseX)*(_downX-mouseX));
			}else{
				_line.graphics.moveTo(0,_downY);
				_line.graphics.lineTo(0,mouseY);
				dis = Math.sqrt((_downY-mouseY)*(_downY-mouseY));
			}
//			trace((int(_line.width/65.2*10))/10,"22");
//			(int(_line.width/65.2*10))/10;
			(_ZhiJiaoSanjiaoRes.jiaoDu.tt as TextField).text = String((int(dis/57*10))/10)+"cm";
//			trace("dis",dis);
		}
		
		private function onUp(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			NotificationFactory.sendNotification(NotificationIDs.SHUXUE_GONGJU_END,_line);
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
			_moveY = _moveX*0.58;
			_tempX = mouseX;
			
			_ZhiJiaoSanjiaoRes.bg.width += _moveX;
			_ZhiJiaoSanjiaoRes.bg.height += _moveY;
			
			_ZhiJiaoSanjiaoRes.keDu1.keDuMask.width += _moveX;
//			_ZhiJiaoSanjiaoRes.keDu1.keDuMask.width = _ZhiJiaoSanjiaoRes.bg.width-147.4;
			_ZhiJiaoSanjiaoRes.keDu2.keDuMask.width += _moveY;
//			_ZhiJiaoSanjiaoRes.keDu2.keDuMask.width += _ZhiJiaoSanjiaoRes.bg.height-290;
			
			if(_ZhiJiaoSanjiaoRes.bg.width<622)
			{
				_ZhiJiaoSanjiaoRes.bg.width=622;
				_ZhiJiaoSanjiaoRes.keDu1.keDuMask.width=533;
				_ZhiJiaoSanjiaoRes.keDu2.keDuMask.width=250;
			}
			if(_ZhiJiaoSanjiaoRes.bg.width>1801){
				_ZhiJiaoSanjiaoRes.bg.width=1801;
				_ZhiJiaoSanjiaoRes.keDu1.keDuMask.width=1750;
				_ZhiJiaoSanjiaoRes.keDu2.keDuMask.width=810;
			}
			
			if(_ZhiJiaoSanjiaoRes.bg.height<360)
			{
				_ZhiJiaoSanjiaoRes.bg.height=360;
			}
			if(_ZhiJiaoSanjiaoRes.bg.height>1039){
				_ZhiJiaoSanjiaoRes.bg.height=1039;
			}
//			trace(_ZhiJiaoSanjiaoRes.bg.scaleX,_ZhiJiaoSanjiaoRes.bg.scaleY);
//			_ZhiJiaoSanjiaoRes.addBtn.x = _ZhiJiaoSanjiaoRes.bg.width - 219*_ZhiJiaoSanjiaoRes.bg.scaleX;
//			_ZhiJiaoSanjiaoRes.xuanZhuan.x = _ZhiJiaoSanjiaoRes.bg.width*0.58 - 282;
			
			_ZhiJiaoSanjiaoRes.addBtn.x = _ZhiJiaoSanjiaoRes.bg.width-218*_ZhiJiaoSanjiaoRes.bg.scaleX;
			_ZhiJiaoSanjiaoRes.addBtn.y = _ZhiJiaoSanjiaoRes.bg.height-323*_ZhiJiaoSanjiaoRes.bg.scaleY;
			
			_ZhiJiaoSanjiaoRes.xuanZhuan.x = _ZhiJiaoSanjiaoRes.bg.width-579*_ZhiJiaoSanjiaoRes.bg.scaleX;
			_ZhiJiaoSanjiaoRes.xuanZhuan.y = _ZhiJiaoSanjiaoRes.bg.height-121*_ZhiJiaoSanjiaoRes.bg.scaleY;
			
			_ZhiJiaoSanjiaoRes.jiaoDu.x = _ZhiJiaoSanjiaoRes.bg.width-479*_ZhiJiaoSanjiaoRes.bg.scaleX;
			_ZhiJiaoSanjiaoRes.jiaoDu.y = _ZhiJiaoSanjiaoRes.bg.height-261*_ZhiJiaoSanjiaoRes.bg.scaleY;
			
			_ZhiJiaoSanjiaoRes.closeBtn.x = _ZhiJiaoSanjiaoRes.bg.width-579*_ZhiJiaoSanjiaoRes.bg.scaleX;
			_ZhiJiaoSanjiaoRes.closeBtn.y = _ZhiJiaoSanjiaoRes.bg.height-325*_ZhiJiaoSanjiaoRes.bg.scaleY;
		}
		
		private function onAddBtnUp(event:MouseEvent):void
		{
			_ZhiJiaoSanjiaoRes.con.width = _ZhiJiaoSanjiaoRes.mc.width = _ZhiJiaoSanjiaoRes.bg.width;
			_ZhiJiaoSanjiaoRes.con.height = _ZhiJiaoSanjiaoRes.mc.height = _ZhiJiaoSanjiaoRes.bg.height;
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
			(_ZhiJiaoSanjiaoRes.jiaoDu.tt as TextField).text = String(int(_jiaoDu))+"°";**/
			
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
			(_ZhiJiaoSanjiaoRes.jiaoDu.tt as TextField).text = String(tempJiaoDu)+"°";
		}
		
		private function onXuanZhuanBtnUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onXuanZhuanMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onXuanZhuanBtnUp);
		}
		
		private function onMCDown(e:MouseEvent):void
		{
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMcMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMcUp);
		}
		
		private function onMcMove(event:MouseEvent):void
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
		
		private function onMcUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMcMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMcUp);
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
		
		public function clear():void
		{
			this.visible = false;
			this.scaleX = this.scaleY = 1;
			this.alpha = 1;
		}
		
		public function reset():void
		{
//			this.removeChild(_ZhiJiaoSanjiaoRes);
			_ZhiJiaoSanjiaoRes.con.removeEventListener(MouseEvent.MOUSE_DOWN,onConDown);
		}

		public function get bmpd():BitmapData
		{
			return _bmpd;
		}

	}
}