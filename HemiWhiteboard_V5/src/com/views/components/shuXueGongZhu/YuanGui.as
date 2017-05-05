package com.views.components.shuXueGongZhu
{
	import com.models.ConstData;
	import com.tweener.transitions.DynamicRegistrationTweener;
	import com.tweener.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class YuanGui extends Sprite
	{
		private var _res:YuanGuiRes;
		
		private var _downX:Number=0;
		private var _huDu:Number=0;
		private var _jiaoDu:Number=0;
		private var _disX:Number=0;
		
		public function YuanGui()
		{
			_res = new YuanGuiRes();
			
			this.addChild(_res);
			
			initListener();
		}
		
		private function initListener():void
		{
			_res.rightMC.laSheng.addEventListener(MouseEvent.MOUSE_DOWN,onRightMCDown);
			_res.maoZi.addEventListener(MouseEvent.MOUSE_DOWN,onMaoZiDown);
			_res.rightMC.huaTu.addEventListener(MouseEvent.MOUSE_DOWN,onHuaTuDown);
		}
		
		private function onRightMCDown(e:MouseEvent):void
		{
			_downX = stage.mouseX;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onRightMCMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onRightMCUp);
		}
		
		private function onRightMCMove(event:MouseEvent):void
		{
			_disX = stage.mouseX-_downX;
			_huDu = Math.atan2(440,_disX);
//			_huDu = Math.cos((_res.rightMC.x-7)/440);
			_jiaoDu =_huDu / Math.PI * 180-90;
			if(_jiaoDu>0)return;
			_res.rightMC.rotation = _jiaoDu;
			_res.leftMC.rotation = -_res.rightMC.rotation;
//			_downX = mouseX;
			updataMaoZi();
		}
		
		private function onRightMCUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onRightMCMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onRightMCUp);
		}
		
		private function updataMaoZi():void
		{
			var huDu:Number = _res.rightMC.rotation/180*Math.PI;
			var yy:Number = Math.sin(huDu)*440;
		//	_res.maoZi.y = -yy+102.4;
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
		
		private function onHuaTuDown(e:MouseEvent):void
		{
			RegPoint(_res,new Point(_res.leftMC.pointMc.x,_res.leftMC.pointMc.y));
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onHuaTuMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onHuaTuUp);
		}
		
		private function onHuaTuMove(event:MouseEvent):void
		{
			_huDu = Math.atan2(stage.mouseY-this.y, stage.mouseX-this.x);
			_jiaoDu = _huDu / Math.PI * 180;
			this.rotation = _jiaoDu;
		}
		
		private function onHuaTuUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onHuaTuMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onHuaTuUp);
		}
		
		private function RegPoint(obj:MovieClip,point:Point):void 
		{
			var tmp_point:Point=obj.parent.globalToLocal(obj.localToGlobal(point));
			trace(tmp_point.x,tmp_point.y,"xy");
//			var huDu1:Number = _res.leftMC.rotation/180*Math.PI;
//			var dx:Number = Math.sin(huDu1)*440;
//			var dy:Number = Math.cos(huDu1)*440;
//			var tmp_point:Point = new Point(dx,dy);
			var len:int=obj.numChildren;
			while (len--) {
				var tmp_obj:DisplayObject=obj.getChildAt(len);
				tmp_obj.x-=point.x;
				tmp_obj.y-=point.y;
			}
			obj.x=tmp_point.x;
			obj.y=tmp_point.y;
		}
	}
}