package com.views.components
{
	import com.controls.Pen;
	import com.models.ApplicationData;
	import com.models.vo.TuXingVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.GraffitiBoardMouse;
	import com.scxlib.GraphObject;
	import com.senocular.display.CustomResetControl1;
	import com.senocular.display.CustomRotationControl;
	import com.senocular.display.TransformTool;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class DrawShapeFill extends Sprite 
	{
		private var _isTianChong:Boolean;
		private var _bmpSprite:Sprite;
		private var _shapeSprite:Sprite;
		private var _bmpd:BitmapData;
		private var _bmp:Bitmap;
		private var _graphArr:Array=[];
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempGraph:Sprite;
		private var _graphFun:Array=[];//存放画图形函数
		private var _currTool:TransformTool;
		private var _customTool:TransformTool;
		private var _defaultTool:TransformTool;
		private var _isChange:Boolean;
		private var _bmpBian:BitmapBianRes;
		private var _isTuYa:Boolean = true;
		private var _bmpdArr:Array=[];
		private var _stepID:int;
		private var _graphSp:Sprite;
		private var _eSprite:Sprite = new Sprite();
		private var _circle:Shape =  new Shape();
		private var isCir:Boolean;
		private var isEraser:Boolean;
		private var _ct:ColorTransform = new ColorTransform();
		
		public function DrawShapeFill()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function onAddStage(event:Event):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0xFFFF00,0);
			this.graphics.drawRect(0,0,1920,1050);
			this.graphics.endFill();
			
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_bmpSprite = new Sprite();
			this.addChild(_bmpSprite);
			
			_shapeSprite = new Sprite();
			this.addChild(_shapeSprite);
			
//			this.addChild(_eSprite);
			this.addChild(_circle);
			_graphSp = new Sprite();
			_bmpSprite.addChild(_graphSp);
			
//			_bmpBian = new BitmapBianRes();
			//_bmpSprite.addChild(_bmpBian);
			_graphFun = [drawTriangle,drawRect,drawRegularPolygon5,drawRegularPolygon6,drawCircle,drawStar,drawEllipse,drawLine];
			_bmpd = new BitmapData(this.width,this.height,true,0);
			_bmp = new Bitmap(_bmpd,"auto",true);
			this.addChildAt(_bmp,0);
			
//			_bmpd.draw(_bmpSprite);
//			_bmpSprite.removeChild(_bmpBian);

			// default tool
			_defaultTool = new TransformTool();
			addChild(_defaultTool);
			
			// custom tool with some custom options
			_customTool = new TransformTool();
			addChild(_customTool);
			
			_customTool.raiseNewTargets = false;
			_customTool.moveNewTargets = true;
			_customTool.moveUnderObjects = false;
			
			_customTool.registrationEnabled = false;
			_customTool.rememberRegistration = false;
			
			_customTool.rotationEnabled = false;
			_customTool.constrainRotation = true;
			_customTool.constrainRotationAngle = 90/4;
			
			_customTool.constrainScale = true;
			_customTool.maxScaleX = 2;
			_customTool.maxScaleY = 2;
			
			_customTool.skewEnabled = false;
			
//			_customTool.setSkin(TransformTool.SCALE_TOP_LEFT, new ScaleCircle());
//			_customTool.setSkin(TransformTool.SCALE_TOP_RIGHT, new ScaleCircle());
//			_customTool.setSkin(TransformTool.SCALE_BOTTOM_RIGHT, new ScaleCircle());
//			_customTool.setSkin(TransformTool.SCALE_BOTTOM_LEFT, new ScaleCircle());
//			_customTool.setSkin(TransformTool.SCALE_TOP, new ScaleCircle());
//			_customTool.setSkin(TransformTool.SCALE_RIGHT, new ScaleCircle());
//			_customTool.setSkin(TransformTool.SCALE_BOTTOM, new ScaleCircle());
//			_customTool.setSkin(TransformTool.SCALE_LEFT, new ScaleCircle());
			
			
			
//			_customTool.addControl(new CustomRotationControl());
//			_customTool.addControl(new CustomResetControl1());
			
			// keep track of the current tool being used
			_currTool = _defaultTool;
			_currTool.addEventListener(TransformTool.CONTROL_DOWN,onCustomToolDown);
			_currTool.addEventListener(TransformTool.CONTROL_UP,onCustomToolUp);
			_currTool.addEventListener(TransformTool.CONTROL_CLOSE,onCustomClose);
		}
		
		private function onCustomToolDown(event:Event):void
		{
			_isTianChong = false;
			_isChange = true;
		}
		
		private function onCustomToolUp(event:Event):void
		{
			_isChange = false;
		}
		/**
		 * 双击激发将图形转换成位图
		 * @param e
		 * 
		 */		
		private function onCustomClose(e:Event):void
		{
			_bmpSprite.addChild((e.target as TransformTool).target);
//			var moveTargets:Boolean = (e.target as TransformTool).moveNewTargets;
//			(e.target as TransformTool).moveNewTargets = false;
//			(e.target as TransformTool).target = null;
//			(e.target as TransformTool).moveNewTargets = moveTargets;
			
			_bmpd.draw(_bmpSprite);
			while(_bmpSprite.numChildren>0)
			{
				(_bmpSprite.getChildAt(0) as GraphObject).clear();
				_bmpSprite.removeChildAt(0);
			}
			
			if(_bmpdArr.length>10)
			{
				(_bmpdArr[0] as BitmapData).dispose();
				_bmpdArr.shift();
			}
			var bmd:BitmapData=new BitmapData(1920,1050,true,0);
			bmd=_bmpd.clone();
			_bmpdArr.push(bmd);
			_stepID = _bmpdArr.length-1;
			ApplicationData.getInstance().jiLuArr = _bmpdArr;
			ApplicationData.getInstance().stepID = _stepID;
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
		
		
		public function onTuYa(vo:TuXingVO):void
		{
			_isTuYa = vo.tuYa;
			_isTianChong = vo.tianChong;
			trace(_isTuYa,"_isTuYa",vo.tianChong);
		}
		
		public function addGongJuDraw(shape:Object):void
		{
			var globPoint:Point =shape.target.localToGlobal(new Point())
			
			var bmpd:BitmapData = shape.bmpd as BitmapData;
			var bmp:Bitmap = new Bitmap(bmpd);
//			bmp.x = globPoint.x;
//			bmp.y = globPoint.y;
//			bmp.rotation = shape.rotation;
			_bmpSprite.addChild(bmp);
			
			_bmpd.draw(_bmpSprite);
			while(_bmpSprite.numChildren>0)
			{
				if(_bmpSprite.getChildAt(0) is Bitmap)
				{
					(_bmpSprite.getChildAt(0) as Bitmap).bitmapData.dispose();
				}
				_bmpSprite.removeChildAt(0);
			}
			
			if(_bmpdArr.length>10)
			{
				(_bmpdArr[0] as BitmapData).dispose();
				_bmpdArr.shift();
			}
			var bmd:BitmapData=new BitmapData(1920,1050,true,0);
			bmd=_bmpd.clone();
			_bmpdArr.push(bmd);
			_stepID = _bmpdArr.length-1;
			ApplicationData.getInstance().jiLuArr = _bmpdArr;
			ApplicationData.getInstance().stepID = _stepID;
		}
		
		private function initListener():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,onClick);
		}
		
		private function onBtnClick(event:MouseEvent):void
		{
			
		}
		
		private function onClick(event:MouseEvent):void
		{
			//trace("++++++++++++++++++++++++++++++++++++++++++++++")
			isCir = ApplicationData.getInstance().styleVO.isCir;
			isEraser = ApplicationData.getInstance().styleVO.isEraser;
			if(isCir==true||isEraser==true)
			{
				_isTianChong =false;
				_isTuYa = true;
			}
//			trace(event.target.name,"+++++++++++++++");
			if(_isTianChong==true)
			{
				var color:uint = ApplicationData.getInstance().styleVO.lcolor;
				var r = color >> 16 & 0xFF ;
				var g = color >> 8 & 0xFF ;
				var b = color & 0xFF ;
				
				color = ((0xFF << 24) | (r << 16) | (g << 8) | b);
				//trace(color,"color",ApplicationData.getInstance().styleVO.lcolor);
				//trace("添加bmpd",(_bmpd.getPixels(new Rectangle(mouseX,mouseY,1920,1080)) as ByteArray).length);
//				var bounds:Rectangle = new Rectangle(mouseX,mouseY, _bmpd.width, _bmpd.height);
//				var pixels:ByteArray = _bmpd.getPixels(bounds);
//				trace("测试",pixels.length);
				_bmpd.floodFill(mouseX,mouseY,color);
				if(_bmpdArr.length>10)
				{
					(_bmpdArr[0] as BitmapData).dispose();
					_bmpdArr.shift();
				}
				
				var bmd1:BitmapData=new BitmapData(1920,1050,true,0);
				bmd1=_bmpd.clone();
				_bmpdArr.push(bmd1);
				_stepID = _bmpdArr.length-1;
				ApplicationData.getInstance().jiLuArr = _bmpdArr;
				ApplicationData.getInstance().stepID = _stepID;
				NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE_END);
			}else{
				//trace("_isTuYa:"+_isTuYa,"isCir:",ApplicationData.getInstance().styleVO.isCir);
				if(_isTuYa){//trace("_is000TuYa.",_isTuYa)
					if(isCir)
					{
						_circle.graphics.lineStyle(1,0x000000,0.5);
						_eSprite.graphics.lineStyle(2,0x0000ff,0.5);
						_eSprite.graphics.beginFill(0xff0000);
						_eSprite.graphics.moveTo(mouseX,mouseY);
						_circle.graphics.moveTo(mouseX,mouseY);
						_circle.visible=true;
					}else{
						if(isEraser){
							_graphSp.graphics.lineStyle(5,0x000000,1);
						}else{
							_graphSp.graphics.lineStyle(2,0x000000,1);
						}
						//_bmpd.dispose();
						//_bmpd = new BitmapData(1920,1050,true,0);
						_bmpSprite.addChild(_graphSp);
						_graphSp.graphics.moveTo(this.mouseX, this.mouseY);
					}
					stage.addEventListener(MouseEvent.MOUSE_MOVE,onTouchMove);
					stage.addEventListener(MouseEvent.MOUSE_UP,onTouchUp);
					NotificationFactory.sendNotification(NotificationIDs.TUYA_BEGIN);
				}else{//trace("_is111TuYa.",_isTuYa)
//					if(_isChange==true)return;
					stage.addEventListener(MouseEvent.MOUSE_MOVE,onTouchMove);
					stage.addEventListener(MouseEvent.MOUSE_UP,onTouchUp);
					var graph:GraphObject = new com.scxlib.GraphObject();
					graph.name = "graph"+_graphArr.length;
					_graphArr.push(graph);
					graph.x = mouseX;
					graph.y = mouseY; 
					_downX = 0;
					_downY = 0;
					_shapeSprite.addChild(graph);
					graph.addEventListener(MouseEvent.MOUSE_DOWN,onGraphDown);
					graph.addEventListener(Event.CLOSE,onGraphClose);
				}
			}
		}
		
		private function onTouchMove(e:MouseEvent):void
		{
			if(_isTuYa)
			{
				if(isCir)
				{
					_eSprite.graphics.lineTo(mouseX,mouseY);
					_circle.graphics.lineTo(mouseX,mouseY);
				}else{
					_graphSp.graphics.lineTo(this.mouseX, this.mouseY);
					_bmpd.draw(_bmpSprite, null, null, isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
				}
			}else{
				if(_isChange==true)return;
				_graphArr[_graphArr.length-1].pen.clear();
				_graphArr[_graphArr.length-1].pen.beginFill(0xFFFFFF);
				_graphFun[ApplicationData.getInstance().styleVO.shapeStyle](_graphArr[_graphArr.length-1].pen,_graphArr[_graphArr.length-1]);
			}
			
		}

		private function onTouchUp(e:MouseEvent):void
		{
			if(isCir)
			{
				_bmpd.draw(_eSprite, null, null,BlendMode.ERASE,null,true);
				_eSprite.graphics.clear();
				_graphSp.graphics.clear();
				_circle.graphics.clear()
			}else{
				//trace("upup");
				if(_isTuYa)
				{
					if(_bmpdArr.length>10)
					{
						(_bmpdArr[0] as BitmapData).dispose();
						_bmpdArr.shift();
					}
					//				trace("添加bmpd",_bmpdArr)
					var bmd1:BitmapData=new BitmapData(1920,1050,true,0);
					bmd1=_bmpd.clone();
					_bmpdArr.push(bmd1);
					_stepID = _bmpdArr.length-1;
					_graphSp.graphics.clear();
					ApplicationData.getInstance().jiLuArr = _bmpdArr;
					ApplicationData.getInstance().stepID = _stepID;
					NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE_END);
				}else{
				//	trace("图形绘制结束");
					if((_graphArr[_graphArr.length-1] as GraphObject).width<80&&(_graphArr[_graphArr.length-1] as GraphObject).height<80)
					{
						_shapeSprite.removeChild((_graphArr[_graphArr.length-1] as GraphObject));
						(_graphArr[_graphArr.length-1] as GraphObject).dispose();
						var len:int = _graphArr.length-1;
						_graphArr.splice(len,1);
					}
				}
			}
			if(ApplicationData.getInstance().styleVO.shapeStyle==7)
			{
				changeBmp(_graphArr[_graphArr.length-1] as GraphObject);
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onTouchMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onTouchUp);
		}
		
		private function onGraphDown(e:MouseEvent):void
		{
//			this.removeEventListener(MouseEvent.MOUSE_DOWN,onClick);
			_isChange = true;
			e.stopPropagation();
//			_currTool.target = e.target as Sprite;
			trace("qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",_isTianChong);
//			toolInit();
			if(_isTianChong==true)
			{
				_ct.color = ApplicationData.getInstance().styleVO.lcolor;
				(e.target as GraphObject).transform.colorTransform = _ct
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,onTargetUp);
		}
		
		private function onGraphClose(e:Event):void
		{
//			trace("事件接收成功",e.target);
			_graphArr.splice(int(e.target.name.split("_")[1]),1);
			changeBmp(e.target as GraphObject);
//			e.target.removeEventListener(MouseEvent.MOUSE_DOWN,onGraphDown);
//			e.target.removeEventListener(Event.CLOSE,onGraphClose);
//			_bmpSprite.addChild(e.target as GraphObject);
//			_bmpd.draw(_bmpSprite);
//			for (var i:int = 0; i < _bmpSprite.numChildren; i++) 
//			{
//				if((_bmpSprite.getChildAt(i) is GraphObject))
//				{
//					(_bmpSprite.getChildAt(i) as GraphObject).clear();
//					_bmpSprite.removeChildAt(i);
//				}
//			}
//			
//			if(_bmpdArr.length>10)
//			{
//				(_bmpdArr[0] as BitmapData).dispose();
//				_bmpdArr.shift();
//			}
////			trace("添加bmpd",_bmpdArr)
//			var bmd1:BitmapData=new BitmapData(1920,1050,true,0);
//			bmd1=_bmpd.clone();
//			_bmpdArr.push(bmd1);
//			_stepID = _bmpdArr.length-1;
//			NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE_END);
		}
		
		private function changeBmp(obj:GraphObject):void
		{
			obj.removeEventListener(MouseEvent.MOUSE_DOWN,onGraphDown);
			obj.removeEventListener(Event.CLOSE,onGraphClose);
			_bmpSprite.addChild(obj as GraphObject);
			_bmpd.draw(_bmpSprite);
			for (var i:int = 0; i < _bmpSprite.numChildren; i++) 
			{
				if((_bmpSprite.getChildAt(i) is GraphObject))
				{
					(_bmpSprite.getChildAt(i) as GraphObject).clear();
					_bmpSprite.removeChildAt(i);
				}
			}
			
			if(_bmpdArr.length>10)
			{
				(_bmpdArr[0] as BitmapData).dispose();
				_bmpdArr.shift();
			}
			//			trace("添加bmpd",_bmpdArr)
			var bmd1:BitmapData=new BitmapData(1920,1050,true,0);
			bmd1=_bmpd.clone();
			_bmpdArr.push(bmd1);
			_stepID = _bmpdArr.length-1;
			NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE_END);
		}
		
		private function onTargetUp(event:MouseEvent):void
		{
			_isChange = false;
			stage.removeEventListener(MouseEvent.MOUSE_UP,onTargetUp);
		}		
		
		private function toolInit():void 
		{
			// raise
			_currTool.parent.setChildIndex(_currTool, _currTool.parent.numChildren - 1);
			
			// center registration for customTool
			if (_currTool == _customTool) {
				_currTool.registration = _currTool.boundsCenter;
			}
		}
		
		private function setTool(event:MouseEvent):void 
		{
			// get other tool
			var newTool:TransformTool = (_currTool == _defaultTool) ? _customTool : _defaultTool;
			
			// make sure moveNewTargets is not set when setting tool this way
			var moveTargets:Boolean = newTool.moveNewTargets;
			newTool.moveNewTargets = false;
			newTool.target = _currTool.target;
			newTool.moveNewTargets = moveTargets;
			
			// unset currTool
			_currTool.target = null;
			_currTool = newTool;
			
			toolInit();
		}
		
		public function chongZuo():void
		{
			if(_stepID<_bmpdArr.length-1){
				//BackgroundPorxy.isEraser = false;
				_stepID++;
				_bmpd = _bmpdArr[_stepID].clone();
				_bmp.bitmapData=_bmpd;
				//_tuYa.bmp.mouseEnabled = false;
			}
			ApplicationData.getInstance().stepID = _stepID;
			//trace("重做",_tuYa.stepID)
			NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE_END);
		}
		
		public function cheXiao():void
		{
			if(_stepID>0){
				_stepID--;
				_bmpd = _bmpdArr[_stepID].clone();
				_bmp.bitmapData=_bmpd;
			}else{
				_bmp.bitmapData = null;
				_stepID=-1;
			}
			ApplicationData.getInstance().stepID = _stepID;
			NotificationFactory.sendNotification(NotificationIDs.DRAW_SHAPE_END);
		}
		
		public function clearAll():void
		{
			if(_bmp!=null){
				_bmpd.dispose();
				_bmpd = new BitmapData(1920,1050,true,0);
				_bmp.bitmapData = _bmpd;
			}
			for (var i:int = 0; i < _bmpdArr.length; i++) 
			{
				_bmpdArr[i].dispose();
			}
			_bmpdArr=[];
			_stepID=0;
			ApplicationData.getInstance().jiLuArr = _bmpdArr;
			ApplicationData.getInstance().stepID = _stepID;
			
			//清除还没有转化成位图的图形
			while(_shapeSprite.numChildren>0)
			{
				if(_shapeSprite.getChildAt(0) is GraphObject)
				{
					(_shapeSprite.getChildAt(0) as GraphObject).dispose();
					_shapeSprite.removeChildAt(0);
				}
			}
			_graphArr=[];
		}

		public function get isTianChong():Boolean
		{
			return _isTianChong;
		}

		public function set isTianChong(value:Boolean):void
		{
			_isTianChong = value;
		}

		public function get stepID():int
		{
			return _stepID;
		}

		public function set stepID(value:int):void
		{
			_stepID = value;
		}

		public function get bmpdArr():Array
		{
			return _bmpdArr;
		}


	}
}