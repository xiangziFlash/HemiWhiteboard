package com.views.components.shuXueGongZhu
{
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class YuanGui2 extends Sprite
	{
		private var _res:YuanGuiRes2;
		private var _downX:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _huDu:Number=0;
		private var _jiaoDu:Number=0;
		private var _disX:Number=0;
		private var _disY:Number=0;
		private var _shape:Shape;
		private var _radius:Number=0;
		private var _endJiaoDu:Number=0;
		
		private  var _tempJiaoDu:Number=0;
		private var _startJiaoDu:Number=0;
		private var _startHuDu:Number=0;
		
		private var _startRotaion:Number=0;
		private var _endRotaion:Number=0;
		
		private var _disJiaoDu:Number=0;
		private var _xx:Number=0;
		private var _yy:Number=0;
		private var _globalP1:Point;
		private var _globalP2:Point;
		private var _globalP3:Point;
		private var _globalP4:Point;
		
		private var _circleJiaoDu:Number=0;
		private var _circleHuDu:Number=0;
		private var _moveX:Number;
		private var _moveY:Number;
		
		public function YuanGui2()
		{
			_res = new YuanGuiRes2();
			
			this.addChild(_res);
			
			(_res.duShu as TextField).embedFonts = true;
			(_res.duShu as TextField).defaultTextFormat = new TextFormat("YaHei_font",10,0xFFFFFF);
			(_res.duShu as TextField).autoSize = "right";
			
			initListener();
		}
		
		private function initListener():void
		{
			_res.rightMC.laSheng.addEventListener(MouseEvent.MOUSE_DOWN,onRightMCDown);
			_res.maoZi.addEventListener(MouseEvent.MOUSE_DOWN,onMaoZiDown);
			_res.rightMC.xuanZhuan.addEventListener(MouseEvent.MOUSE_DOWN,onXuanZhuanDown);
			_res.rightMC.huaTu.addEventListener(MouseEvent.MOUSE_DOWN,onHuaTuDown);
			_res.maoZi.closeBtn.addEventListener(MouseEvent.CLICK,onCloseClick);
			_res.leftMC.addEventListener(MouseEvent.MOUSE_DOWN,onMaoZiDown);
		}
		
		private function onRightMCDown(e:MouseEvent):void
		{
			trace(_res.rotation,"_res.rotation")
			_downX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onRightMCMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onRightMCUp);
		}
		
		private function onRightMCMove(event:MouseEvent):void
		{
			_disX += mouseX-_downX;
			_huDu = Math.atan2(440,_disX);
			_jiaoDu =_huDu / Math.PI * 180-90;
			_downX = mouseX;
			if(_jiaoDu>0)return;
			_res.rightMC.rotation = _jiaoDu;
			_res.leftMC.rotation = -_res.rightMC.rotation;
			var huDu2:Number = (90-_res.leftMC.rotation)/180*Math.PI;
			_radius = Math.cos(huDu2)*440*2+16.7;
			_res.rightMC.x = _radius;
			_res.keDu.keDuMask.width = _radius;
			updataMaoZi();
		}
		
		private function onRightMCUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onRightMCMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onRightMCUp);
			_res.keDu.keDuMask.width = _radius;
		}
		
		private function updataMaoZi():void
		{
			var huDu2:Number = (90-_res.leftMC.rotation)/180*Math.PI;
			var xx:Number = Math.cos(huDu2)*440;
			var yy:Number = Math.sin(huDu2)*440;
			_res.maoZi.x = xx-22.8 + 11.9;
			_res.maoZi.y = -yy-121;
		}
		
		private function onMaoZiDown(e:MouseEvent):void
		{
			startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMaoZiMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMaoZiUp);
		}
		
		private function onMaoZiMove(e:MouseEvent):void
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
		
		private function onMaoZiUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMaoZiMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMaoZiUp);
			
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
		
		private function onHuaTuDown(e:MouseEvent):void
		{
//			stage.frameRate = 60;
			_shape =  new Shape();
			this.addChild(_shape);
			this.addChild(_res);
			_moveX=mouseX;
			_moveY=mouseY;
			_startRotaion=_res.rotation;
			_endRotaion=_startRotaion;
			_startHuDu = _startRotaion*(Math.PI/180);
//			trace("_startJiaoDu",_startJiaoDu);
			_shape.graphics.lineStyle(5,ApplicationData.getInstance().styleVO.lcolor);
			_shape.graphics.moveTo(Math.cos(_startHuDu)*_radius,Math.sin(_startHuDu)*_radius);  
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onHuaTuMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onHuaTuUp);
		}
		
		private function onHuaTuMove(event:MouseEvent):void
		{
			_shape.graphics.clear();
			_shape.graphics.lineStyle(5,ApplicationData.getInstance().styleVO.lcolor);
			_shape.graphics.moveTo(Math.cos(_startHuDu)*_radius,Math.sin(_startHuDu)*_radius);  
			
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
			_endRotaion+=tempRotaion;
			_res.rotation =_endRotaion;

			if(_startRotaion<_endRotaion){
				for (var i:int = _startRotaion; i < _endRotaion; i++) 
				{
					var huDu:Number = i/ 180 * Math.PI;
					_shape.graphics.lineTo(Math.cos(huDu)*_radius,Math.sin(huDu)*_radius);
					_shape.graphics.endFill();
				}
			}else{
				for (var j:int = _startRotaion; j > _endRotaion; j--) 
				{
					var huDu1:Number = j/ 180 * Math.PI;
					_shape.graphics.lineTo(Math.cos(huDu1)*_radius,Math.sin(huDu1)*_radius);
					_shape.graphics.endFill();
				}
			}
			var num:int;
			if(_res.rotation<0)
			{
				num = 360+_res.rotation;
			}else{
				num = _res.rotation;
			}
			(_res.duShu as TextField).text = String(num);
			_moveX=mouseX;
			_moveY=mouseY;
			
		}

		private function onHuaTuUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onHuaTuMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onHuaTuUp);
			
			NotificationFactory.sendNotification(NotificationIDs.SHUXUE_GONGJU_END,_shape);
		}
		
		private function onXuanZhuanDown(e:MouseEvent):void
		{
			_moveX=mouseX;
			_moveY=mouseY;
			_startRotaion=_res.rotation;
			_endRotaion=_startRotaion;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onXuanZhuanMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onXuanZhuanUp);
			(_res.duShu as TextField).text = String(_endRotaion);
		}
		
		private function onXuanZhuanMove(event:MouseEvent):void
		{
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
			_endRotaion+=tempRotaion;
			_res.rotation =_endRotaion;
			var num:int;
			if(_res.rotation<0)
			{
				num = 360+_res.rotation;
			}else{
				num = _res.rotation;
			}
			(_res.duShu as TextField).text = String(num);
//			trace(_res.rotation);
			_moveX=mouseX;
			_moveY=mouseY;
		}
		
		private function onXuanZhuanUp(event:MouseEvent):void
		{
			trace(_res.rotation,"rotation")
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onXuanZhuanMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onXuanZhuanUp);
		}
		
		public function reset():void
		{
			_res.maoZi.x = -11.9;
			_res.maoZi.y = -562.45;
			
			_res.leftMC.x = 0;
			_res.leftMC.y = -0.6;
			
			_res.rightMC.x = 15.7;
			_res.rightMC.y = -0.1;
			_res.leftMC.rotation = _res.rightMC.rotation = 0;
			_res.keDu.keDuMask.width = 15.3;
		}
	}
}