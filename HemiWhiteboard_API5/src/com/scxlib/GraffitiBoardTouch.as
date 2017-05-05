package com.scxlib
{
	import com.controls.Pen;
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.FengBiVO;
	import com.models.vo.MaoBiVO;
	import com.models.vo.StyleVO;
	import com.models.vo.TuXingVO;
	import com.models.vo.XiangCeVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.components.DisplaySprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PNGEncoderOptions;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class GraffitiBoardTouch extends Sprite
	{
		/**
		 * 绘画对象
		 */
		private var _graphicSp:Sprite;
		//private var _lineThickness:int=5;
		//private var _lcolor:uint=0x383838;
		
		private var _bmpd:BitmapData;
		private var _bmp:Bitmap;
		//private var _isEraser:Boolean;
		//private var _lineStyle:int;
		private var _tempPoint0:Point=new Point();
		private var _tempPoint1:Point=new Point();
		private var _tempPen:MovieClip;
		private var _tempColor:MovieClip;
		//private var _tempLineStyle:int;
		private var _touchPointArr:Array=[];
		private var _brushArr:Array=[];
		private var _pointArr:Array=[];
		private var brush:PenBrush;
		private var brush1:PenBrush;
		private var _stageW:Number=500;
		private var _stageH:Number=400;
		private var _eSprite:Sprite = new Sprite();
		private var _circle:Shape =  new Shape();
		private var _touchIDArr:Array=[];
		private var _arr:Array=[];
		private var _eCircleArr:Array=[];
		private var _fCircleArr:Array=[];
		private var _tempPoint0Arr:Array=[];
		private var _tempPoint1Arr:Array=[];
		
		private var _maoBiArr:Array=[];
		private var _maoBiBrush0:MaoBiBrushRes;
		private var _maoBiBrush1:MaoBiBrushRes;
		private var _tempPoint3Arr:Array=[];
		private var _tempPoint4Arr:Array=[];
		private var _tempPoint3:Point;
		private var _tempPoint4:Point;
		
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _graphFun:Array=[];//存放画图形函数
		/**
		 * 是否是圈选删除
		 */
		private var _circleSp:Sprite;
		
		public var styleVO:StyleVO;
		private var _jiLuArr:Vector.<ByteArray> = new Vector.<ByteArray>;
		private var _stepID:int;
		
		/**
		 *毛笔的一系列参数 
		 */		
		private var _oldX:Number=0;
		private var _oldY:Number =0;
		private var _oldScale:Number=0;
		private var cx:Number = 0.03;// 粗细变化参数,建议值(0.02~0.12),值越小，笔画越均匀0.03
		private var brushMin:Number = 0.08;//.08;//最细笔触限制
		private var brushAlpha:Number = 0.55;//笔刷浓度0.65
		private var defaultScale:Number = 0.8;//默认笔触的大小0.8
		private var ct:ColorTransform = new ColorTransform();
		private var _cuXiXiShu:Number = 0;
		private var _isMouse:Boolean=true;
		private var _ct:ColorTransform = new ColorTransform();
		/**
		 * 
		 */
		private var _fengBiTempX:Number=0;
		private var _fengBiTempY:Number=0;
		
		private var _isSuoDing:Boolean;
		private var _isDrawShape:Boolean;
		private var _isShape:Boolean;
		private var _isTianChong:Boolean;
		private var _graphArr:Array=[];
		
//		private var _shapeTiShi:ShapeRes;
//		private var _yanLiaoTongTiShi:YanLiaoTongRes;
		private var _tempGraph:GraphObject;
		private var _ldrByte:Loader;
		private var _sp:DisplaySprite;
		private var _shapeSP:Sprite;
		private var _bmpSP:Sprite;
		private var _isManYou:Boolean;
		
		public var tempBmpd:BitmapData = null;
		public var touchBegin:Function;
		
		public function GraffitiBoardTouch()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAddstage);
			_sp = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			initContent();
			initListener();
		}
		
		private function onAddstage(event:Event):void
		{
//			trace(this.parent,"sdsd");
			_shapeSP = new Sprite();
			_shapeSP.doubleClickEnabled = true;
			this.parent.addChild(_shapeSP);
		}
		
		public function setManYou(boo:Boolean):void
		{
			_isManYou = boo;
			for (var i1:int = 0; i1 < _jiLuArr.length; i1++) 
			{
				(_jiLuArr[i1] as ByteArray).clear();
			}
			_jiLuArr.length = 0;
			NotificationFactory.sendNotification(NotificationIDs.TUYA_END,null);
		}
		
		public function setWH(w:Number,h:Number):void
		{
			_stageW=w;
			_stageH=h;
			this.graphics.clear();
			this.graphics.beginFill(0,0.01);
			this.graphics.drawRect(0,0,_stageW,_stageH);
			this.graphics.endFill();
			
			try
			{
				_graphicSp.addChild(_bmp);
				_bmpd = new  BitmapData(_stageW,_stageH,true,0);
				_bmpd.draw(_graphicSp, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
				_bmp = new Bitmap(_bmpd,"auto",true);
				_bmp.smoothing = true;
				this.addChildAt(_bmp,1);
				while (_graphicSp.numChildren > 0)
				{
					_graphicSp.removeChildAt(0);
				}
			} 
			catch(error:Error) 
			{
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
				return;
			}
			
		
			
			/*_bmpd = new  BitmapData(_stageW,_stageH,true,0);
			_bmpd.draw(_bmpSP, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
			
			if(_bmp == null)
			{
				_bmp = new Bitmap(_bmpd,"auto",true);
				_bmp.smoothing = true;
			} else {
				_bmp.bitmapData = _bmpd;
			}
			
			this.addChild(_circleSp);
			this.addChild(_bmpSP);
			_bmpSP.addChild(_bmp);
			this.addChild(_circle);*/
			
			while(_bmpSP.numChildren > 1)
			{
				if(_bmpSP.getChildAt(0) is Bitmap)
				{
					(_bmpSP.getChildAt(0) as Bitmap).bitmapData.dispose();
					(_bmpSP.getChildAt(0) as Bitmap).bitmapData = null;
					_bmpSP.removeChildAt(0);
				}
			}
			
			/*var bmd:BitmapData=_bmpd.clone();
			var bmp:Bitmap=new Bitmap(bmd);
			_graphicSp.addChild(bmp);
			_bmpd = new BitmapData(_stageW,_stageH,true,0);
			_bmpd.draw(_graphicSp, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
			_bmp.bitmapData = _bmpd;
			_graphicSp.removeChild(bmp);
			bmd.dispose();*/
//			clear();
		}
		
		private function initContent():void
		{
			_graphicSp=new Sprite();
			_bmpSP = new Sprite();
			_bmpSP.doubleClickEnabled = true;
			this.addChild(_bmpSP);
			this.addChild(_graphicSp);
			
			_circleSp = new Sprite();
			this.addChild(_circleSp);
			this.addChild(_circle);
			
			_graphFun = [drawTriangle,drawRect,drawRegularPolygon5,drawRegularPolygon6,drawCircle,drawStar,drawEllipse,drawLine];
			styleVO = new StyleVO();
		}
		
		public function drawBitmap(bmpd:BitmapData):void
		{
			_bmpd = bmpd;
			if(_bmp == null)
			{
				_bmp = new Bitmap(null);
				this.addChildAt(_bmp,1);
			}
			if(_bmp.bitmapData)
			{
				_bmp.bitmapData.dispose();
				_bmp.bitmapData = null;
			}
			_bmp.bitmapData = _bmpd;
			
			try
			{
				NotificationFactory.sendNotification(NotificationIDs.TUYA_END,_bmpd);
			} 
			catch(error:Error) 
			{
				trace("获取数据失败");
			}
			/*this.removeChild(_circle);
			if(_bmp)
			{
				this.removeChild(_bmp);
				_bmp.bitmapData.dispose();
				_bmp = null;
			}
			_bmp = new Bitmap(_bmpd);
			_bmp.smoothing = true;
			
			this.addChild(_bmp);
			this.addChildAt(_circle,0);*/
			
			/*var bmp:Bitmap = new Bitmap(_bmpd);
			ConstData.stage.addChild(bmp);*/
		}
		
		private function initListener():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
		}
		
		private function onADDED_TO_STAGE(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
		}
		
		public function removeListener():void
		{
			this.removeEventListener(TouchEvent.TOUCH_BEGIN,onTOUCH_BEGIN);
		}
		
		public function addListener():void
		{
			this.addEventListener(TouchEvent.TOUCH_BEGIN,onTOUCH_BEGIN);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
		}
		
		//*************************鼠标操控*******************//
		private function onMOUSE_DOWN(event:MouseEvent):void
		{
			if(_isSuoDing)return;
			if(styleVO.isCir==true||styleVO.isEraser==true)
			{
				_isTianChong =false;
				_isDrawShape = false;
			}
//			trace(_isTianChong,"_isTianChong");
			
			if(_isTianChong)
			{
				
//				_shapeTiShi.visible = false;
//				_yanLiaoTongTiShi.visible = true;
				/*_yanLiaoTongTiShi.x = mouseX;
				_yanLiaoTongTiShi.y = mouseY;*/
				_bmpd.floodFill(mouseX,mouseY,ApplicationData.getInstance().styleVO.lcolor);
			}else{
				if(_isDrawShape)
				{
					/*_shapeTiShi.visible = true;
					_yanLiaoTongTiShi.visible = false;
					_shapeTiShi.x = mouseX;
					_shapeTiShi.y = mouseY*/;
					
					var graph:GraphObject = new GraphObject();
					graph.name = "graph"+_graphArr.length;
					_graphArr.push(graph);
					graph.x = this.parent.mouseX;
					graph.y = this.parent.mouseY; 
					_downX = 0;
					_downY = 0;
//					_sp.addMidSprite(graph);
					_shapeSP.addChild(graph);
					graph.addEventListener(MouseEvent.MOUSE_DOWN,onGraphDown);
					graph.addEventListener(Event.CLOSE,onGraphClose);
					NotificationFactory.sendNotification(NotificationIDs.TUYA_BEGIN);
				}else{
					var eve:TouchEvent=new TouchEvent(TouchEvent.TOUCH_BEGIN);
					eve.touchPointID=0;
					eve.localX=mouseX;
					eve.localY=mouseY;
					onTOUCH_BEGIN(eve);
				}
			}
			stage.addEventListener(MouseEvent.MOUSE_UP,onMOUSE_UP);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
		}
		
		private function onMOUSE_MOVE(event:MouseEvent):void
		{
			if(_isTianChong)
			{
				/*_yanLiaoTongTiShi.x = mouseX;
				_yanLiaoTongTiShi.y = mouseY;*/
			}else{
				if(_isDrawShape)
				{
				/*	_shapeTiShi.x = mouseX;
					_shapeTiShi.y = mouseY;*/
//					if(_isChange==true)return;
					_graphArr[_graphArr.length-1].pen.clear();
					_graphArr[_graphArr.length-1].pen.beginFill(ApplicationData.getInstance().styleVO.lcolor);
					_graphFun[ApplicationData.getInstance().styleVO.shapeStyle](_graphArr[_graphArr.length-1].pen,_graphArr[_graphArr.length-1]);
				}else{
					var eve:TouchEvent=new TouchEvent(TouchEvent.TOUCH_MOVE);
					eve.touchPointID=0;
					eve.localX=mouseX;
					eve.localY=mouseY;
					onTOUCH_MOVE(eve);
				}
			}
		}
		
		private function onMOUSE_UP(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMOUSE_UP);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
//			_yanLiaoTongTiShi.visible = false;
//			_shapeTiShi.visible = false;
			if(_isTianChong)
			{
				var color:uint = ApplicationData.getInstance().styleVO.lcolor;
				var r = color >> 16 & 0xFF ;
				var g = color >> 8 & 0xFF ;
				var b = color & 0xFF ;
				color = ((0xFF << 24) | (r << 16) | (g << 8) | b);
				_bmpd.floodFill(mouseX,mouseY,color);
				
				addHuanCun();
//				this.dispatchEvent(new Event(Event.CHANGE));
				while(_graphicSp.numChildren>0){
					_graphicSp.removeChildAt(0);
				}
			}else{
				if(_isDrawShape)
				{
//					trace(_isDrawShape,"_isDrawShape",_isTianChong,"_isTianChong");
					if((_graphArr[_graphArr.length-1] as GraphObject).width<80&&(_graphArr[_graphArr.length-1] as GraphObject).height<80)
					{
						(_graphArr[_graphArr.length-1] as GraphObject).parent.removeChild((_graphArr[_graphArr.length-1] as GraphObject));
						(_graphArr[_graphArr.length-1] as GraphObject).dispose();
						var len:int = _graphArr.length-1;
						_graphArr.splice(len,1);
					}
				}else{
					var eve:TouchEvent=new TouchEvent(TouchEvent.TOUCH_END);
					eve.touchPointID=0;
					eve.localX=mouseX;
					eve.localY=mouseY;
					onTOUCH_END(eve);
				}
			}
		}
		
		private function onTOUCH_BEGIN(event:TouchEvent):void
		{
			if(_isTianChong||_isDrawShape)return;
//			trace("onTOUCH_BEGIN");
			event.stopPropagation();
			if(_isSuoDing)return;
			onMOUSE_UP(null);
			if(_touchIDArr.indexOf(event.touchPointID)==-1){
				_touchIDArr.push(event.touchPointID);
			}
			
			if(touchBegin)
			{
				touchBegin();
			}
			NotificationFactory.sendNotification(NotificationIDs.TUYA_BEGIN);
			styleVO = ApplicationData.getInstance().styleVO;
//			trace("begin",styleVO.isCir,styleVO.lcolor,styleVO.lineStyle,styleVO.lineThickness);
			var pointID:int = event.touchPointID;
			if(_bmp== null)
			{
				try
				{
					if(_bmpd)
					{
						_bmpd.dispose();
						_bmpd = null;
					}
					
					_bmpd = new  BitmapData(_stageW,_stageH,true,0);
					_bmpd.draw(_graphicSp, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
					_bmp = new Bitmap(_bmpd,"auto",true);
					_bmp.smoothing = true;
					this.addChildAt(_bmp,1);
				} 
				catch(error:Error) 
				{
					_bmp = null;
					return;
				}
				
			} else 
			{
				if(_bmp.bitmapData==null)
				{
					_bmpd = new BitmapData(_stageW,_stageH,true,0);
				}
				_bmp.bitmapData = _bmpd;
			}
			
			if(_arr[pointID]==null)
			{
				var line:Shape = new Shape();
				_arr[pointID] = line;
			}else{
				line = _arr[pointID];
			}
			stage.addEventListener(TouchEvent.TOUCH_END,onTOUCH_END);
			this.addEventListener(TouchEvent.TOUCH_END,onTOUCH_END);
			this.addEventListener(TouchEvent.TOUCH_MOVE,onTOUCH_MOVE);
			if(styleVO.isCir)
			{
				_circle.graphics.lineStyle(1,0x000000,0.5);
				_eSprite.graphics.lineStyle(2,0x0000ff,0.5);
				_eSprite.graphics.beginFill(0xff0000);
				_eSprite.graphics.moveTo(event.localX,event.localY);
				_circle.graphics.moveTo(event.localX,event.localY);
			}
			else
			{
				switch(styleVO.lineStyle)
				{
					case 0:
						line.graphics.lineStyle(styleVO.lineThickness*1,styleVO.lcolor,1);
						line.graphics.moveTo(event.localX,event.localY);
						line.graphics.endFill();
						break;
					case 1:
						line.graphics.clear();
						if(_brushArr[pointID]==null){
							brush= new PenBrush();//钢笔笔刷
							_brushArr[pointID] = brush;
						}
						brush=_brushArr[pointID];
						brush.visible = false;
						brush.x=event.localX;
						brush.y=event.localY;
						_tempPoint0=new Point();
						_tempPoint1=new Point();
						_tempPoint0Arr[pointID]=_tempPoint0;
						_tempPoint1Arr[pointID]=_tempPoint1;
						_tempPoint0.x=brush.x;
						_tempPoint0.y=brush.y;
//						_tempPoint1.x=brush.x+_lineThickness;
//						_tempPoint1.y=brush.y+_lineThickness;
						
						_tempPoint1.x=brush.x+styleVO.lineThickness;
						_tempPoint1.y=brush.y+styleVO.lineThickness;
						break;
					case 2:
						line.graphics.clear();
//						if(styleVO.lineThickness<=5){
//							_cuXiXiShu = 0.38;
//						}else if(styleVO.lineThickness>5&&styleVO.lineThickness<=10){
//							_cuXiXiShu = 0.4;
//						}else if(styleVO.lineThickness>10&&styleVO.lineThickness<=15){
//							_cuXiXiShu = 0.5;
//						}else{
//							_cuXiXiShu = 0.6;
//						}
//						if(styleVO.lineThickness<11)
//						{
//							_cuXiXiShu = 0.07*styleVO.lineThickness;
//						}else if(styleVO.lineThickness>15)
//						{
//							_cuXiXiShu = 0.035*styleVO.lineThickness;
//						}else{
//							_cuXiXiShu = 0.04*styleVO.lineThickness;
//						}
						_cuXiXiShu = styleVO.lineThickness;
						var maoBiVO:MaoBiVO = new MaoBiVO();
						_arr[pointID] = maoBiVO;
						var maoBiBrush:MaoBiBrushRes = new MaoBiBrushRes();
//						maoBiBrush.visible =false;
						maoBiVO.maobi = maoBiBrush;
						maoBiBrush.x = event.localX;
						maoBiBrush.y = event.localY;
						maoBiVO.downX = event.localX;
						maoBiVO.downY = event.localY;
						_oldScale = 1;
						break;
					case 3:
						ct.color = styleVO.lcolor;
						var fengBi:FengBiBrushRes = new FengBiBrushRes();
						fengBi.transform.colorTransform = ct;
						fengBi.x = event.localX;
						fengBi.y = event.localY;
						var fengBiVO:FengBiVO = new FengBiVO();
						fengBiVO.fengbi = fengBi;
						fengBiVO.tempX = event.localX;
						fengBiVO.tempY = event.localY;
						_arr[pointID] = fengBiVO;
						break;
				}
			}
			
		}
		
		private function onTOUCH_MOVE(event:TouchEvent):void
		{
//			trace("touchMove",styleVO.isCir,styleVO.lcolor,styleVO.lineStyle,styleVO.lineThickness)
			if(_touchIDArr.indexOf(event.touchPointID)==-1){
				return;
			}
			var pointID:int = event.touchPointID;
			if(styleVO.lineStyle!=2&&styleVO.lineStyle!=3){
				var line:Shape = _arr[pointID];
			}
			var eCircle:Shape = _eCircleArr[pointID] as Shape;
			var fCircle:Shape = _fCircleArr[pointID] as Shape;
			
			
//			if(isCir)
			if(styleVO.isCir)
			{
				_eSprite.graphics.lineTo(event.localX,event.localY);
				_circle.graphics.lineTo(event.localX,event.localY);
			}else{
				switch(styleVO.lineStyle)
				{
					case 0:
					{	
						line.graphics.lineTo(event.localX,event.localY);
						_bmpd.draw(line, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
						break;
					}				
					case 1:
					{
//						line.graphics.beginFill(_lcolor,1);
						line.graphics.beginFill(styleVO.lcolor,1);
						_brushArr[pointID].x=event.localX;
						_brushArr[pointID].y=event.localY;
						_brushArr[pointID].sclaeX = _brushArr[pointID].scaleY = styleVO.lineThickness*0.5;
						//trace(_brushArr[pointID].width,_brushArr[pointID].height,"_brushArr[pointID].height");
						line.graphics.moveTo(_brushArr[pointID].x,_brushArr[pointID].y);
						line.graphics.lineTo(_brushArr[pointID].x,_brushArr[pointID].y);    
						line.graphics.lineTo(_brushArr[pointID].x+_brushArr[pointID].width,_brushArr[pointID].y+_brushArr[pointID].height);
						line.graphics.lineTo(_tempPoint1Arr[pointID].x,_tempPoint1Arr[pointID].y);
						line.graphics.lineTo(_tempPoint0Arr[pointID].x,_tempPoint0Arr[pointID].y);
						line.graphics.endFill();
						_tempPoint0Arr[pointID].x=_brushArr[pointID].x;
						_tempPoint0Arr[pointID].y=_brushArr[pointID].y;
						_tempPoint1Arr[pointID].x=_brushArr[pointID].x+_brushArr[pointID].width;
						_tempPoint1Arr[pointID].y=_brushArr[pointID].y+_brushArr[pointID].height;//trace("_bmpd",_bmpd)
//						var colorT:ColorTransform = new ColorTransform(1,1,1,0.3);
						_bmpd.draw(line, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
						break;
					}	
					case 2:
					{
						var maoBiVO:MaoBiVO = _arr[pointID]
						const disX:Number=event.localX-maoBiVO.downX;
						const disY:Number=event.localY-maoBiVO.downY;
						const dis:Number = Math.sqrt(disX * disX + disY * disY);
						//改变笔触的大小,越快越小
						var scale:Number = defaultScale - dis * cx;
						//if(dis>0.12){
						if (scale > 1) scale = 1;
						else if (scale < brushMin) scale = brushMin;
						scale = (_oldScale + scale) * _cuXiXiShu;//这个参数可调节笔触的粗细,建议值(0.3~0.82),值越大，笔画越粗0.52
						//}
						const count:int = dis * brushAlpha;
						const scaleBili:Number = (_oldScale-scale) / (count+5);
						var brush:MovieClip;
						ct.color = styleVO.lcolor;
						for (var i:int=0; i<count; i++) {
							var brush1:MaoBiBrushRes = new MaoBiBrushRes();
							brush1.scaleX = brush1.scaleY =styleVO.lineThickness;
							brush1.transform.colorTransform = ct;
							brush1.gotoAndStop(2);
							_graphicSp.addChild(brush1);
//							brush1.scaleX = brush1.scaleY = _oldScale-i * scaleBili; 
							brush1.x=(disX/count)*(i+1)+maoBiVO.downX;
							brush1.y=(disY/count)*(i+1)+maoBiVO.downY;
						}
						maoBiVO.downX = event.localX;//mouseX;
						maoBiVO.downY = event.localY;//mouseY;
						_oldScale = scale;
//						bmd.draw(_graphicSp);
						_bmpd.draw(_graphicSp, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
						while (_graphicSp.numChildren > 0)
						{
							_graphicSp.removeChildAt(0);
						}
						break;
					}
					case 3:
					{
						var fenBiVO:FengBiVO = _arr[pointID]
						const disX1:Number=event.localX-fenBiVO.tempX;
						const disY1:Number=event.localY-fenBiVO.tempY;
						const dis1:Number = Math.sqrt(disX1 * disX1 + disY1 * disY1);
						const count1:int = dis1 * 0.75;
						ct.color = styleVO.lcolor;
						for (var i1:int=0; i1<count1; i1++) 
						{
							var fengBi:FengBiBrushRes = new FengBiBrushRes();
							fengBi.transform.colorTransform = ct;
							fengBi.scaleX = fengBi.scaleY =styleVO.lineThickness;
							fengBi.x =(disX1/count1)*(i1+1)+fenBiVO.tempX;
							fengBi.y = (disY1/count1)*(i1+1)+fenBiVO.tempY;
							_graphicSp.addChild(fengBi);
						}
						
						fenBiVO.tempX = event.localX;
						fenBiVO.tempY = event.localY;
						_bmpd.draw(_graphicSp, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
						while (_graphicSp.numChildren > 0)
						{
							_graphicSp.removeChildAt(0);
						}
						break;
					}
				}
			}
		}
		
		private function onTOUCH_END(event:TouchEvent):void
		{//trace("touchEnd")
			if(_touchIDArr.indexOf(event.touchPointID)!=-1){
				_touchIDArr.splice(_touchIDArr.indexOf(event.touchPointID),1);
				_arr[event.touchPointID]=null;
				if(_brushArr[event.touchPointID]!=null){
					_brushArr[event.touchPointID]=null;
				}
			}else{
				return;
			}
			if(styleVO.isCir)
			{
				_bmpd.draw(_eSprite, null, null,BlendMode.ERASE,null,true);
				_eSprite.graphics.clear();
				_graphicSp.graphics.clear();
				_circle.graphics.clear();
			}
			
			if(_touchIDArr.length==0)
			{//所有点弹起  移除事件
				this.removeEventListener(TouchEvent.TOUCH_END,onTOUCH_END);
				stage.removeEventListener(TouchEvent.TOUCH_END,onTOUCH_END);
				this.removeEventListener(TouchEvent.TOUCH_MOVE,onTOUCH_MOVE);
				
				if(_isManYou)
				{
					NotificationFactory.sendNotification(NotificationIDs.TUYA_END,_bmpd);
					return;
				}
				addHuanCun();
			}
		}
		
		private function addHuanCun():void
		{
			if(_stepID != _jiLuArr.length-1)
			{
				if(_stepID==-1)
				{
					for (var i:int = 0; i < _jiLuArr.length; i++) 
					{
						(_jiLuArr[i] as ByteArray).clear();
						_jiLuArr[i] = null;
					}
					_jiLuArr.length = 0;
				}else if(_stepID==0){
					if(_jiLuArr.length!=0)
					{
						var tempBmpd:ByteArray = _jiLuArr.shift();
						for (var j:int = 0; j < _jiLuArr.length; j++) 
						{
							(_jiLuArr[j] as ByteArray).clear();
							_jiLuArr[j] = null;
						}
						_jiLuArr.length = 0;
						_jiLuArr.push(tempBmpd);
					}
				}else{
					for (var i1:int = _stepID+1; i1 < _jiLuArr.length; i1++) 
					{
						(_jiLuArr[i1] as ByteArray).clear();
						_jiLuArr[i1] = null;
						_jiLuArr.splice(i1,1);
					}
				}
			}
			//				trace("清除后的长度",_jiLuArr.length);
			if(_jiLuArr.length>10)
			{
				//					trace("超过了十步");
//				(_jiLuArr[0] as ByteArray).clear();
				_jiLuArr.shift().clear();
			}
			try
			{
				var ba:ByteArray = new ByteArray(); 
				_bmpd.copyPixelsToByteArray(_bmpd.rect, ba);
				_jiLuArr.push(ba);
				_stepID = _jiLuArr.length-1;
				
//				NotificationFactory.sendNotification(NotificationIDs.TUYA_END,_bmpd.clone());
				NotificationFactory.sendNotification(NotificationIDs.TUYA_END,_bmpd);
			} 
			catch(error:Error) 
			{
				trace("内存不足");
				ToolKit.log("The system is out of memory.");
				for (var i2:int = 0; i2 < _jiLuArr.length; i2++) 
				{
					(_jiLuArr[i2] as ByteArray).clear();
					_jiLuArr[i2] = null;
				}
				_jiLuArr.length=0;
				_stepID=0;
				
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
			}		
		}
		
		private function onLdrByteEnd(e:Event):void
		{
			_bmpd = (e.target.content as Bitmap).bitmapData;
			_bmp.bitmapData= _bmpd;
			//每次涂鸦结束  发送Event.COMPLETE 提醒预览框更新内容
			var eve:Event = new Event(Event.COMPLETE);
			this.dispatchEvent(eve);
		}
		
		public function onDrawShape(vo:TuXingVO):void
		{
			_isDrawShape = vo.drawShape;
			_isTianChong = vo.tianChong;
			_isShape = vo.shape;
//			trace("vo更新了",_isDrawShape,"_isDrawShape",_isTianChong,"_isTianChong");
//			stage.addEventListener(MouseEvent.MOUSE_MOVE,onStageMove);
		}
		
		private function onStageMove(event:MouseEvent):void
		{
			/*if(_isTianChong)
			{
				_yanLiaoTongTiShi.visible = true;
				_shapeTiShi.visible = false;
				_yanLiaoTongTiShi.x = mouseX;
				_yanLiaoTongTiShi.y = mouseY;
			}else{
				_yanLiaoTongTiShi.visible = false;
			}
			
			if(_isDrawShape)
			{
				_shapeTiShi.visible = true;
				_yanLiaoTongTiShi.visible = false;
				_shapeTiShi.x = mouseX;
				_shapeTiShi.y = mouseY;
			}else{
				_shapeTiShi.visible = false;
			}*/
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
		
		/**
		 * 绘制扇形
		 * @param angle	扇形角度
		 * @param radius扇形半径
		 * @return 
		 */		
		private function drawSector(angle:int,radius:Number):Sprite
		{
			var color:Number = 0xffffff * Math.random();//颜色随机
			var a:Sprite=new Sprite();//放置扇形的容器
			a.graphics.lineStyle(0.1,color,1);//设置线段的宽度，颜色透明度
			a.graphics.moveTo(0,0);//起点
			a.graphics.beginFill(color,1)
			for (var t:int=0; t< angle; t++)
			{
				a.graphics.lineTo(radius * Math.cos(t * Math.PI / 180),radius * Math.sin(t * Math.PI / 180));//画圆的公式，角度递增
				//线段回到起点
			}
			a.graphics.endFill();
			return a;
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
		
		private function onGraphDown(e:MouseEvent):void
		{
			e.stopPropagation();
			_tempGraph = e.target as GraphObject;
			if(_isTianChong==true)
			{
				_ct.color = ApplicationData.getInstance().styleVO.lcolor;
				_tempGraph.transform.colorTransform = _ct
			}else{
				_tempGraph.startDrag();	
			}
			_tempGraph.addEventListener(MouseEvent.MOUSE_MOVE,onTargetMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onTargetUp);
		}
		
		private function onTargetMove(e:MouseEvent):void
		{
			if(_isTianChong==true)return;
//			trace(e.target,"66")
			var rect:Rectangle = _tempGraph.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<960&&rect.right>980){
				//	trace(rect.top,rect.bottom)
				if(rect.top>1000-rect.height*0.25){
					_tempGraph.alpha = 0.5;
					return;
				}					
			}
			this.alpha = 1;
		}
		
		private function onTargetUp(e:MouseEvent):void
		{
			_tempGraph.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP,onTargetUp);
			_tempGraph.removeEventListener(MouseEvent.MOUSE_MOVE,onTargetMove);
			var rect:Rectangle = _tempGraph.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(_tempGraph.alpha<1){
				Tweener.addTween(_tempGraph,{x:972,y:1056,scaleX:0.1,scaleY:0.1,alpha:0,time:0.5,onComplete:clearGraph});
			}
			function clearGraph():void
			{
				_tempGraph.clear();
			}
		}	
		
		private function onGraphClose(e:Event):void
		{
			_graphArr.splice(int(e.target.name.split("_")[1]),1);
			changeBmp(e.target as GraphObject);
		}
		
		private function changeBmp(obj:GraphObject):void
		{
		//	obj.x = obj.x - this.parent.x;
		//	obj.y = obj.y - this.parent.y;
			var point:Point = this.parent.globalToLocal(_graphicSp.globalToLocal(new Point(obj.x,obj.y)));
			obj.x = point.x;
			obj.y = point.y;
			_graphicSp.addChild(obj);
			_bmpd.draw(_graphicSp, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
			addHuanCun();
//			NotificationFactory.sendNotification(NotificationIDs.TUYA_END,_bmpd.clone());
			while (_graphicSp.numChildren > 0)
			{
				_graphicSp.removeChildAt(0);
			}
		}
		
		private function onTouchUp(e:MouseEvent):void
		{
			if(_isDrawShape)
			{
					//	trace("图形绘制结束");
					if((_graphArr[_graphArr.length-1] as GraphObject).width<80&&(_graphArr[_graphArr.length-1] as GraphObject).height<80)
					{
						(_graphArr[_graphArr.length-1] as GraphObject).parent.removeChild((_graphArr[_graphArr.length-1] as GraphObject));
						(_graphArr[_graphArr.length-1] as GraphObject).dispose();
						var len:int = _graphArr.length-1;
						_graphArr.splice(len,1);
					}
			}
			if(ApplicationData.getInstance().styleVO.shapeStyle==7)
			{
				//changeBmp(_graphArr[_graphArr.length-1] as GraphObject);
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_UP,onTouchUp);
		}
		
		private function hideShowMouseEnable(boo:Boolean):void
		{
			for (var i:int = 0; i < _graphArr.length; i++) 
			{
				(_graphArr[i] as GraphObject).mouseEnabled = boo;
			}
			
		}
		
		public function addShuXueShape(obj:DisplayObject):void
		{
			var globPoint:Point = obj.parent.localToGlobal(new Point(obj.x,obj.y));
			obj.x = globPoint.x / ConstData.stageScaleX - this.x;
			obj.y = globPoint.y / ConstData.stageScaleY - this.y;
			obj.rotation = obj.parent.rotation;
			_graphicSp.addChild(obj);
			if(_bmpd == null)
			{
				_bmpd = new BitmapData(_stageW, _stageH, true, 0);
			}
			_bmpd.draw(_graphicSp, null, null, styleVO.isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
			while (_graphicSp.numChildren > 0)
			{
				_graphicSp.removeChildAt(0);
			}
			addHuanCun();
		}
		
		public function clearSystemMemory():void
		{
			for (var i:int = 0; i < _jiLuArr.length; i++) 
			{
				(_jiLuArr[i] as ByteArray).clear();
				_jiLuArr[i] = null;
			}
			_jiLuArr.length=0;
			_stepID=-1;
			
			try
			{
				setTimeout(function ():void
				{
					if(!_isManYou)
					{
						if(_bmpd == null)return;
						tempBmpd = _bmpd.clone();
					}
				},5);
			} 
			catch(error:Error) 
			{
				
			}
			NotificationFactory.sendNotification(NotificationIDs.TUYA_END,null);
//			trace("clearSystemMemory");
		}
		
		/**
		 * 清除面板
		 */
		public function clear():void
		{
			if(_bmp){
				if(_bmp.bitmapData)
				{
					_bmp.bitmapData.dispose();
					_bmp.bitmapData = null;
				}
				if(_bmpd)
				{
					_bmpd.dispose();
					_bmpd = null;
				}
				_bmpd = new BitmapData(_stageW,_stageH,true,0);
				_bmp.bitmapData = _bmpd;
			}
			_graphicSp.graphics.clear();
			for (var i:int = 0; i < _jiLuArr.length; i++) 
			{
				(_jiLuArr[i] as ByteArray).clear();
			}
			if(tempBmpd)
			{
				tempBmpd.dispose();
				tempBmpd = null;
			}

			while(_shapeSP.numChildren>0)
			{
				if(_shapeSP.getChildAt(0) is GraphObject)
				{
					(_shapeSP.getChildAt(0) as GraphObject).clear();
				}
				_shapeSP.removeChildAt(0);
			}
			_graphArr=[];
			_jiLuArr.length = 0;
			_stepID=0;
		}
		
		public function dispose():void
		{
			_graphicSp = null;
			if(_bmpd)
			{
				_bmpd.dispose();
				_bmpd = null;
			}
			if(_bmp)
			{
				if(_bmp.bitmapData)
				{
					_bmp.bitmapData.dispose();
					_bmp.bitmapData = null;
				}
				_bmp = null;
			}
			_tempPen = null;
			_tempColor = null;
			_touchPointArr=[];
			_brushArr=[];
			_pointArr=[];
			brush = null;
			brush1 = null;
			_eSprite = null;
			_circle = null;
			_touchIDArr=[];
			_arr=[];
			_eCircleArr=[];
			_fCircleArr=[];
			_tempPoint0Arr=[];
			_tempPoint1Arr=[];
			_maoBiArr=[];
			_maoBiBrush0 = null;
			_maoBiBrush1 = null;
			_tempPoint3Arr=[];
			_tempPoint4Arr=[];
			_graphFun=[];//存放画图形函数
			_circleSp= null;
			styleVO = null;
			_jiLuArr.length = 0;
			ct = null;
			_ct = null;
			_graphArr=[];
			_tempGraph = null;
			if(_ldrByte)
			{
				_ldrByte.unloadAndStop();
				_ldrByte = null;
			}
			_sp= null;
			_shapeSP= null;
			_bmpSP= null;
			if(tempBmpd)
			{
				tempBmpd.dispose();
				tempBmpd = null;
			}
			
		}
		
//		/**
//		 * 绘制线条粗细值
//		 */
//		public function get lineThickness():int
//		{
//			return styleVO.lineThickness;
//		}
//		
//		/**
//		 * @private
//		 */
//		public function set lineThickness(value:int):void
//		{
//			_lineThickness = value;
//		}
		
		/**
		 * 线条颜色
		 */
		public function get lcolor():uint
		{
			return styleVO.lcolor;
		}
		
//		/**
//		 * @private
//		 */
//		public function set lcolor(value:uint):void
//		{
//			_lcolor = value;
//		}
		
		/**
		 * 是否处于橡皮擦功能
		 */
		public function get isEraser():Boolean
		{
			return styleVO.isEraser;
		}
		
//		/**
//		 * @private
//		 * @param	value  false 笔触  true  橡皮擦
//		 */
//		public function set isEraser(value:Boolean):void
//		{
//			_isEraser = value;
//		}
		
		/**
		 * 线条样式
		 */
		public function get lineStyle():int
		{
			return styleVO.lineStyle;
		}
		
//		/**
//		 * @private
//		 * @param	value  0：铅笔 1:钢笔
//		 */
//		public function set lineStyle(value:int):void
//		{
//			_lineStyle = value;
//		}
		
		public function get stageW():Number
		{
			return _stageW;
		}
		
		public function get stageH():Number
		{
			return _stageH;
		}

		public function get bmpd():BitmapData
		{
			return _bmpd;
		}

		public function set bmpd(value:BitmapData):void
		{
			_bmpd = value;
		}

		public function get stepID():int
		{
			return _stepID;
		}

		public function set stepID(value:int):void
		{
			_stepID = value;
		}

//		public function get jiLuArr():Array
//		public function get jiLuArr():Vector.<BitmapData>
		public function get jiLuArr():Vector.<ByteArray>
		{
			return _jiLuArr;
		}

		public function get bmp():Bitmap
		{
			return _bmp;
		}

		public function set bmp(value:Bitmap):void
		{
			_bmp = value;
		}

		public function get isSuoDing():Boolean
		{
			return _isSuoDing;
		}

		public function set isSuoDing(value:Boolean):void
		{
			_isSuoDing = value;
		}
		
		
	}
}