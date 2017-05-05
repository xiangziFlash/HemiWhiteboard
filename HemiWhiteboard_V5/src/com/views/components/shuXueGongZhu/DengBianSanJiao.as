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
	
	public class DengBianSanJiao extends Sprite
	{
		private var _dengBianSanJiao:DengBianSanJiaoRes;
		private var _isHuaXian:Boolean;
		private var _line:Shape;
		private var _downX:Number;
		private var _downY:Number;
		private var _bmp:Bitmap;
		private var _bmpd:BitmapData;
		private var _isLock:Boolean;
		private var _drawLine:DrawLine;
		private var _globPoint:Point
		private var _disSprite:DisplaySprite;
		
		private var _huDu:Number=0;
		private var _jiaoDu:Number=0;
		private var _tempX:Number=0;
		private var _moveX:Number=0;
		private var _isX:Boolean;
		
		private var _startRotaion:Number=0;
		private var _endRotaion:Number=0;
		private var _disX:Number;
		private var _disY:Number;
		
		public function DengBianSanJiao()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddAtage);
		}
		
		private function onAddAtage(event:Event):void
		{
			_disSprite = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			_dengBianSanJiao = new DengBianSanJiaoRes();
			this.addChild(_dengBianSanJiao);
			_drawLine = new DrawLine();
			(_dengBianSanJiao.jiaoDu.tt as TextField).embedFonts = true;
			(_dengBianSanJiao.jiaoDu.tt as TextField).defaultTextFormat = new TextFormat("YaHei_font",13,0xFFFFFF);
			(_dengBianSanJiao.jiaoDu.tt as TextField).autoSize = TextFieldAutoSize.CENTER;
			(_dengBianSanJiao.jiaoDu.tt as TextField).text = "";
			
			_dengBianSanJiao.con.addEventListener(MouseEvent.MOUSE_DOWN,onConDown);
			_dengBianSanJiao.addBtn.addEventListener(MouseEvent.MOUSE_DOWN,onAddDown);
			_dengBianSanJiao.xuanZhuan.addEventListener(MouseEvent.MOUSE_DOWN,onXuanZhuanDown);
			_dengBianSanJiao.mc.addEventListener(MouseEvent.MOUSE_DOWN,onMCDown);
			_dengBianSanJiao.closeBtn.addEventListener(MouseEvent.CLICK,onCloseClick);
		}
		
		private function onConDown(event:MouseEvent):void
		{
//			trace(event.target.name,"==");
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
			(_dengBianSanJiao.jiaoDu.tt as TextField).text = String((int(dis/57*10))/10)+"cm";
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
			_tempX = mouseX;
			
			_dengBianSanJiao.bg.width += _moveX;
			_dengBianSanJiao.bg.height += _moveX;
			
			_dengBianSanJiao.keDu1.keDuMask.width += _moveX;
			_dengBianSanJiao.keDu2.keDuMask.width += _moveX;
			
			if(_dengBianSanJiao.bg.width<539)
			{
				_dengBianSanJiao.bg.width=539;
				_dengBianSanJiao.keDu1.keDuMask.width=467;
				_dengBianSanJiao.keDu2.keDuMask.width=421;
			}
			if(_dengBianSanJiao.bg.width>1767){
				_dengBianSanJiao.bg.width=1767;
				_dengBianSanJiao.keDu1.keDuMask.width=1767;
				_dengBianSanJiao.keDu2.keDuMask.width=1767;
			}
			
			if(_dengBianSanJiao.bg.height<539)
			{
				_dengBianSanJiao.bg.height=539;
			}
			if(_dengBianSanJiao.bg.height>1767){
				_dengBianSanJiao.bg.height=1767;
			}
//			_dengBianSanJiao.addBtn.x = _dengBianSanJiao.bg.width-239*_dengBianSanJiao.bg.scaleX;
//			_dengBianSanJiao.xuanZhuan.y = (_dengBianSanJiao.bg.height-230*_dengBianSanJiao.bg.scaleY);
			
			_dengBianSanJiao.addBtn.x = _dengBianSanJiao.bg.width-181*_dengBianSanJiao.bg.scaleX;
			_dengBianSanJiao.addBtn.y = _dengBianSanJiao.bg.height-469*_dengBianSanJiao.bg.scaleY;
			
			_dengBianSanJiao.xuanZhuan.x = _dengBianSanJiao.bg.width-477*_dengBianSanJiao.bg.scaleX;
			_dengBianSanJiao.xuanZhuan.y = _dengBianSanJiao.bg.height-179*_dengBianSanJiao.bg.scaleY;
			
			_dengBianSanJiao.jiaoDu.x = _dengBianSanJiao.bg.width-391*_dengBianSanJiao.bg.scaleX;
			_dengBianSanJiao.jiaoDu.y = _dengBianSanJiao.bg.height-388*_dengBianSanJiao.bg.scaleY;
			
			_dengBianSanJiao.closeBtn.x = _dengBianSanJiao.bg.width-477*_dengBianSanJiao.bg.scaleX;
			_dengBianSanJiao.closeBtn.y = _dengBianSanJiao.bg.height-470*_dengBianSanJiao.bg.scaleY;
		}
		
		private function onAddBtnUp(event:MouseEvent):void
		{
			_dengBianSanJiao.con.width = _dengBianSanJiao.mc.width = _dengBianSanJiao.bg.width;
			_dengBianSanJiao.con.height = _dengBianSanJiao.mc.height = _dengBianSanJiao.bg.height;
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
		/**	_huDu = Math.atan2(stage.mouseY-this.y, stage.mouseX-this.x);
			_jiaoDu = _huDu / Math.PI * 180;
			this.rotation = _jiaoDu;
			(_dengBianSanJiao.jiaoDu.tt as TextField).text = String(int(_jiaoDu))+"°";**/
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
			(_dengBianSanJiao.jiaoDu.tt as TextField).text = String(tempJiaoDu)+"°";
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
				reset();
			}
		}
		
		private function onCloseClick(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
			reset();
		}
		
		public function clear():void
		{
			reset();
		}
		
		public function reset():void
		{
//			this.removeChild(_dengBianSanJiao);
			_dengBianSanJiao.con.removeEventListener(MouseEvent.MOUSE_DOWN,onConDown);
//			dispose();
		}
	}
}