package com.scxlib
{
	import com.controls.Pen;
	import com.models.ApplicationData;
	import com.models.vo.StyleVO;
	import com.models.vo.TuXingVO;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.text.TextField;
	
	public class DrawShape extends Sprite
	{
		private var _spShape:Sprite;
		private var _graphFun:Array=[];//存放画图形函数
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _isTianChong:Boolean;
		private var _graphArr:Array=[];
		private var _ct:ColorTransform = new ColorTransform();
		private var _isDrawShape:Boolean;
		private var _tempObj:GraphObject;
		
		public function DrawShape()
		{
			this.graphics.clear();
			this.graphics.beginFill(0,0.01);
			this.graphics.drawRect(0,0,1920,990);
			this.graphics.endFill();
			
			_spShape = new Sprite();
			this.addChild(_spShape);
			
			
			
			_graphFun = [drawTriangle,drawRect,drawRegularPolygon5,drawRegularPolygon6,drawCircle,drawStar,drawEllipse,drawLine];
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.MOUSE_DOWN,onThisDown);
		}
		
		public function setVO(vo:TuXingVO):void
		{
			_isTianChong = vo.tianChong;
			_isDrawShape = vo.drawShape;
		}
		
		private function drawLine(pen:Pen,graphObj:GraphObject):void
		{
			pen.lineStyle(2,0x000000);
			pen.drawLine(0,0,graphObj.mouseX,graphObj.mouseY);
		}
		
		private function drawTriangle(pen:Pen,graphObj:GraphObject):void
		{
			var angle:Number = Math.atan((graphObj.mouseY - _downY)/(graphObj.mouseX - _downX))*180/Math.PI;
			var dis:Number = Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY));
			
			if(graphObj.mouseX - _downX>=0){
				pen.drawTriangle(0,0,-dis,-dis,60,180-angle);
			}else{
				pen.drawTriangle(0,0,dis,dis,60,180-angle);
			}
		}
		
		private function drawRect(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawRect(0, 0, graphObj.mouseX-_downX,graphObj.mouseY-_downY);
		}
		
		private function drawCircle(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawCircle(0, 0, Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY)));
		}
		
		private function drawEllipse(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawEllipse(0, 0, graphObj.mouseX - _downX, graphObj.mouseY - _downY);
		}
		
		private function drawRoundRect(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawRoundRect(0, 0, graphObj.mouseX - _downX, graphObj.mouseY - _downY, (graphObj.mouseX - _downX) * 0.2, (graphObj.mouseY - _downY) * 0.2);
		}
		
		private function drawStar(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawStar(0, 0, 5, Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY)), Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY)) * 0.3);
		}
		
		private function drawStar1(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawStar(0, 0, 7, Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY)), Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY)) * 0.3);
		}
		
		private function drawRegularPolygon5(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawRegularPolygon(0, 0, 5, Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY)));
		}
		
		private function drawRegularPolygon6(pen:Pen,graphObj:GraphObject):void
		{
			pen.drawRegularPolygon(0, 0, 6, Math.sqrt((graphObj.mouseX - _downX) * (graphObj.mouseX - _downX) + (graphObj.mouseY - _downY) * (graphObj.mouseY - _downY)));
		}
		
		private function onThisDown(e:MouseEvent):void
		{
			if(ApplicationData.getInstance().styleVO.isCir||ApplicationData.getInstance().styleVO.isEraser)
			{
				this.mouseEnabled = false;
				return;
			}
			
			if(_isTianChong==true)
			{
				var color:uint = ApplicationData.getInstance().styleVO.lcolor;
				var r = color >> 16 & 0xFF ;
				var g = color >> 8 & 0xFF ;
				var b = color & 0xFF ;
				color = ((0xFF << 24) | (r << 16) | (g << 8) | b);
				if(e.target is GraphObject)
				{
					_ct.color = color;
					(e.target as GraphObject).transform.colorTransform = _ct
				}
			}else{
				if(_isDrawShape)
				{
					stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
					stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
					var graph:GraphObject = new GraphObject();
					graph.name = "graph"+_graphArr.length;
					_graphArr.push(graph);
					graph.x = mouseX;
					graph.y = mouseY; 
					_downX = 0;
					_downY = 0;
					_spShape.addChild(graph);
					graph.addEventListener(MouseEvent.MOUSE_DOWN,onGraphDown);
					graph.addEventListener(Event.CLOSE,onGraphClose);	
				}
 			}
		}
		
		private function onGraphDown(e:MouseEvent):void
		{
			e.stopPropagation();
			if(_isTianChong==true)
			{
				_ct.color = ApplicationData.getInstance().styleVO.lcolor;
				(e.target as GraphObject).transform.colorTransform = _ct
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,onTargetUp);
		}
		
		private function onTargetUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onTargetUp);
		}	
		
		private function onGraphClose(e:Event):void
		{
			_graphArr.splice(int(e.target.name.split("_")[1]),1);
			_tempObj = e.target as GraphObject;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onMove(event:MouseEvent):void
		{
			if(_isDrawShape)
			{
				_graphArr[_graphArr.length-1].pen.clear();
				_graphArr[_graphArr.length-1].pen.beginFill(0xFFFFFF);
				_graphFun[ApplicationData.getInstance().styleVO.shapeStyle](_graphArr[_graphArr.length-1].pen,_graphArr[_graphArr.length-1]);
			}
		}
		
		private function onUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			
			if((_graphArr[_graphArr.length-1] as GraphObject).width<80&&(_graphArr[_graphArr.length-1] as GraphObject).height<80)
			{
				_spShape.removeChild((_graphArr[_graphArr.length-1] as GraphObject));
				(_graphArr[_graphArr.length-1] as GraphObject).dispose();
				var len:int = _graphArr.length-1;
				_graphArr.splice(len,1);
			}else{
				(_graphArr[_graphArr.length-1] as GraphObject).addTiShi();
			}
		}
		
		public function clearBg():void
		{
			this.graphics.clear();
		}
		
		public function addBg():void
		{
			this.graphics.beginFill(0xff0000,0);
			this.graphics.drawRect(0,0,1920,990);
			this.graphics.endFill();
		}
		
		public function clearAll():void
		{
			while(_spShape.numChildren>0)
			{
				if(_spShape.getChildAt(0) is GraphObject)
				{
					(_spShape.getChildAt(0) as GraphObject).dispose();
				}
				_spShape.removeChildAt(0);
			}
		}

		public function get tempObj():GraphObject
		{
			return _tempObj;
		}

		public function set tempObj(value:GraphObject):void
		{
			_tempObj = value;
		}

	}
}