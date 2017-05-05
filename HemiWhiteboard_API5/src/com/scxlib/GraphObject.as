package  com.scxlib
{
	import com.controls.Pen;
	import com.lylib.touch.objects.RotatableScalable;
	import com.lylib.touch.objects.RotatableScalable1;
	import com.models.ApplicationData;
	import com.models.vo.TuXingVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GraphObject extends RotatableScalable
	{
		private var _pen:Pen;
		private var _tiShiTT:TextField;
		private var _tuXingVO:TuXingVO = new TuXingVO;
		
		public function GraphObject()
		{
			touchEndFun=touchEnd;
			this._maxWidth = 1920;
			this._maxHeight = 1080;
//			this.mouseEnabled = false;
			_pen = new Pen(this.graphics);
			
			this.mouseChildren = false;
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		
		private function onDoubleClick(event:MouseEvent):void
		{
//			this.removeChild(_tiShiTT);
			this.dispatchEvent(new Event(Event.CLOSE));
			
			ApplicationData.getInstance().isTuYaBan = false;
			_tuXingVO.tuYa = true;
			_tuXingVO.tianChong = false;
			_tuXingVO.shape = false;
			_tuXingVO.drawShape = false;
			NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE,_tuXingVO);
		}
		
		private function onDown(e:MouseEvent):void
		{
			e.stopPropagation();
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(event:MouseEvent):void
		{
			event.stopPropagation();
			var rect:Rectangle = this.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<960&&rect.right>980){
				//	trace(rect.top,rect.bottom)
				if(rect.top>1000-rect.height*0.2){
					this.alpha = 0.5;
					return;
				}					
			}
			this.alpha = 1;
		}
		
		private function onUp(event:MouseEvent):void
		{
			event.stopPropagation();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			stopDrag();
			var rect:Rectangle = this.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(this.alpha<1){
				Tweener.addTween(this,{x:972,y:1056,scaleX:0.1,scaleY:0.1,alpha:0,time:0.5,onComplete:clearGraph});
			}
			function clearGraph():void
			{
				clear();
			}
		}
		
		private function touchEnd():void
		{
			
		}
		
		private function touchBegin():void
		{
			
		}
		
		public function addTiShi():void
		{
			_tiShiTT = new TextField();
			_tiShiTT.embedFonts = true;
			_tiShiTT.defaultTextFormat = new TextFormat("YaHei_font",10,0x000000);
			_tiShiTT.autoSize = "left";
			_tiShiTT.text = "双击转化成位图";
//			_tiShiTT.x = -(this.width)*0.5;
//			_tiShiTT.y = (this.height)*0.5;
//			this.addChild(_tiShiTT);
		}
		
		public function clear():void
		{
			_pen.clear();
			this.removeEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
			dispose();
		}
		
//		public function dispose():void
//		{
//			
//		}

		public function get pen():Pen
		{
			return _pen;
		}

		public function set pen(value:Pen):void
		{
			_pen = value;
		}

	}
}