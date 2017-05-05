package com.scxlib
{
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class GraffitiBoardMouse extends Sprite
	{
		/**
		 * 绘画对象
		 */
		private var _graphicSp:Sprite;
		private var _lineThickness:int=5;
		private var _lColor:uint=0x383838;
		
		private var _bmpd:BitmapData;
		private var _bmp:Bitmap;
		private var _isEraser:Boolean;
		private var _lineStyle:int;
		private var _tempPoint0:Point=new Point();
		private var _tempPoint1:Point=new Point();
		private var _tempPen:MovieClip;
		private var _tempColor:MovieClip;
		private var _tempLineStyle:int;
		private var _touchPointArr:Array=[];
		private var _brushArr:Array=[];
		private var _pointArr:Array=[];
		private var brush:PenBrush;
//		private var brush:Sprite;
//		private var brush1:PenBrush;
		private var _stageW:Number=600;
		private var _stageH:Number=316;
		private var _eSprite:Sprite = new Sprite();
		private var _circle:Shape =  new Shape();
		/**
		 * 是否是圈选删除
		 */
		public var isCir:Boolean;
		private var _isRecord:Boolean;
		
		private var _xmlRecord:XmlRecord=new XmlRecord();
		private var _drawNum:int;
		private var _now_array:Array;
		private var _timer:Timer;
		private var tempPoint0:Point;
		private var tempPoint1:Point;
		public var isGongYong:Boolean;//是否共用工具条
		private var _noTuYa:Boolean;//是否能涂鸦
		
		
		/**
		 *毛笔的一系列参数 
		 */		
		private var _oldX:Number=0;
		private var oldX:Number=0;
		private var _oldY:Number =0;
		private var oldY:Number =0;
		private var _oldScale:Number=0;
		private var cx:Number = 0.03;// 粗细变化参数,建议值(0.02~0.12),值越小，笔画越均匀0.03
		private var brushMin:Number = 0.12;//.08;//最细笔触限制
		private var brushAlpha:Number = 0.65;//笔刷浓度0.65
		private var defaultScale:Number = 0.8;//默认笔触的大小0.8
		private var ct:ColorTransform = new ColorTransform();
		private var _cuXiXiShu:Number = 1;
		
		/**
		 * 
		 */
		private var _fengBiTempX:Number=0;
		private var _fengBiTempY:Number=0;
		private var fengBiTempX:Number;
		private var fengBiTempY:Number;
		
		private var _stepID:int;
//		private var _jiLuArr:Array=[];
		public var touchEnd:Function;
		
		public function GraffitiBoardMouse()
		{
			super();
			initContent();
			initListener();
		}
		
		public function setWH(w:Number,h:Number):void
		{
			_stageW=w;
			_stageH=h;
			this.graphics.clear();
			this.graphics.beginFill(0,0.01);
			this.graphics.drawRect(0,0,_stageW,_stageH);
			this.graphics.endFill();
			clear();
		}
		
		private function initContent():void
		{
//						var sp:Sprite = new Sprite();
//						sp.graphics.beginFill(0xFFFF00);
//						sp.graphics.drawRect(0,0,1920,1080);
//						sp.graphics.endFill();
//						this.addChild(sp);
			_graphicSp=new Sprite();
//			this.addChild(_graphicSp);
			
			_bmpd = new  BitmapData(_stageW,_stageH,true,0);
			_bmp = new Bitmap(_bmpd);
			_bmp.smoothing = true;
			
			this.addChild(_bmp);
			this.addChild(_circle);
			

		}
		
		private function initListener():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
			_xmlRecord.addEventListener(XmlRecord.PEN_EVENT,onPEN_EVENT);
		}
		
		private function onADDED_TO_STAGE(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
		}
		
		public function settingStyle(color:uint,lineStyle:int=1,thickness:int=10):void
		{
			_lineStyle = lineStyle;
			_lColor = color;
			_lineThickness= thickness;
		}
		
		public function drawBitmap(bmpd:BitmapData):void
		{
			_bmpd = bmpd;
			this.removeChild(_bmp);
			this.removeChild(_circle);
			_bmp = new Bitmap(_bmpd);
			_bmp.smoothing = true;
			
			this.addChild(_bmp);
			this.addChildAt(_circle,0);
		}
		
		private function onMOUSE_DOWN(event:MouseEvent):void
		{
			if(noTuYa==true)return;
			isCir = ApplicationData.getInstance().styleVO.isCir;
			isEraser = ApplicationData.getInstance().styleVO.isEraser;
			if(_bmp.bitmapData==null)
			{
				_bmpd = new BitmapData(_stageW,_stageH,true,0);
				_bmp.bitmapData = _bmpd;
			}
			if(isGongYong){
				_lColor = ApplicationData.getInstance().styleVO.lcolor;
				_lineThickness = ApplicationData.getInstance().styleVO.lineThickness;
				_lineStyle = ApplicationData.getInstance().styleVO.lineStyle;
			}
			NotificationFactory.sendNotification(NotificationIDs.TUYA_BEGIN);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMOUSE_UP);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
			if(isCir)
			{
				_circle.graphics.lineStyle(1,0x000000,0.5);
				_eSprite.graphics.lineStyle(2,0x0000ff,0.5);
				_eSprite.graphics.beginFill(0xff0000);
				_eSprite.graphics.moveTo(mouseX,mouseY);
				_circle.graphics.moveTo(mouseX,mouseY);
				_circle.visible=true;
			}else
			{
				switch(_lineStyle)
				{
					case 0:
						_graphicSp.graphics.clear();
						_graphicSp.graphics.lineStyle(_lineThickness,_lColor,1);
						_graphicSp.graphics.moveTo(this.mouseX, this.mouseY);
						
						if (_isRecord)
						{
						//	_xmlRecord.draw_array.push(_graphicSp);
							_xmlRecord._mem_xml.addNode({lineSize:_lineThickness,lineColor:_lColor,coordinate:[mouseX, mouseY],typeID:0,isEraser:_isEraser});
						}
						break;
					case 1:
						_graphicSp.graphics.clear();
						brush= new PenBrush();//钢笔笔刷
//						brush= new Sprite()
						brush.visible = false;
						brush.x=this.mouseX;
						brush.y=this.mouseY;
						_tempPoint0.x=brush.x;
						_tempPoint0.y=brush.y;
						_tempPoint1.x=brush.x;
						_tempPoint1.y=brush.y;					
						
						if (_isRecord)
						{
							_xmlRecord.draw_array.push(_graphicSp);
							_xmlRecord._mem_xml.addNode({lineSize:_lineThickness,lineColor:_lColor,coordinate:[mouseX, mouseY],typeID:1,isEraser:_isEraser});
						}
						break;
					case 2:
//						_cuXiXiShu = 0.04*_lineThickness;
//						_cuXiXiShu = 1;
					
						_oldX = mouseX;
						_oldY = mouseY;
						_oldScale = 1;
						if (_isRecord)
						{
							_xmlRecord.draw_array.push(_graphicSp);
							_xmlRecord._mem_xml.addNode({lineSize:_lineThickness,lineColor:_lColor,coordinate:[mouseX, mouseY],typeID:2,isEraser:_isEraser});
							_xmlRecord._suLvArr.push(0.8);
						}
						break;
					case 3:
						var fengBi:FengBiBrushRes = new FengBiBrushRes();
						ct.color=_lColor;
						fengBi.transform.colorTransform = ct;
						fengBi.x = mouseX;
						fengBi.y = mouseY;
						_fengBiTempX = mouseX;
						_fengBiTempY = mouseY;
						
						if (_isRecord)
						{
							_xmlRecord.draw_array.push(_graphicSp);
							_xmlRecord._mem_xml.addNode({lineSize:_lineThickness,lineColor:_lColor,coordinate:[mouseX, mouseY],typeID:3,isEraser:_isEraser});
						}
						break;
				}
			}
			
		}
		private function onPEN_EVENT(e:Event):void 
		{
			switch (_xmlRecord._typeID ) 
			{
				case 0:
					_drawNum = 0;
					_now_array = [];
					_now_array = _xmlRecord.nowArr;
					_graphicSp = new Sprite();
					_lineThickness=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineSize;
					_lColor=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineColor;
					if(_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].isEraser=="true")
					{
						_isEraser=true;
					}else{
						_isEraser=false;
					}
					
					_graphicSp.graphics.lineStyle(_lineThickness,_lColor);
					_graphicSp.graphics.moveTo(_now_array[0],_now_array[1]);
					_xmlRecord.draw_array.push(_graphicSp); 
					if (_timer == null) {
						_timer = new Timer(5, 0);
						_timer.addEventListener(TimerEvent.TIMER, onDrawTimer);
					}
					_timer.start();
					break;
				case 1:
					_drawNum = 0;
					_now_array = [];
					_now_array = _xmlRecord.nowArr;
					_lineThickness=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineSize;
					_lColor=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineColor;
					if(_lineThickness==1){
						_cuXiXiShu = 0.3;
					}else if(_lineThickness==5){
						_cuXiXiShu = 0.4;
					}else if(_lineThickness==10){
						_cuXiXiShu = 0.5;
					}else{
						_cuXiXiShu = 0.6;
					}
					if(_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].isEraser=="true"){
						_isEraser=true;
					}else{
						_isEraser=false;
					}
					_graphicSp = new Sprite();
					_graphicSp.graphics.clear();
					
					tempPoint0=new Point();
					tempPoint1=new Point();
					tempPoint0.x=_now_array[0];
					tempPoint0.y=_now_array[1];
					tempPoint1.x=tempPoint0.x+_lineThickness;
					tempPoint1.y=tempPoint0.y+_lineThickness;
					_xmlRecord.draw_array.push(_graphicSp); 
					if (_timer == null) {
						_timer = new Timer(5, 0);
						_timer.addEventListener(TimerEvent.TIMER, onDrawTimer);
					}
					_timer.start();
					
					break;
				case 2:
					_drawNum = 0;
					_now_array = [];
					_now_array = _xmlRecord.nowArr;
					_lineThickness=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineSize;
					_lColor=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineColor;
					if(_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].isEraser=="true")
					{
						_isEraser=true;
					}else{
						_isEraser=false;
					}
					_graphicSp = new Sprite();
					_graphicSp.graphics.clear();
					oldX = _now_array[0];
					oldY = _now_array[1];
					_oldScale = 1;
					
					_xmlRecord.draw_array.push(_graphicSp); 
					if (_timer == null) {
						_timer = new Timer(5, 0);
						_timer.addEventListener(TimerEvent.TIMER, onDrawTimer);
					}
					_timer.start();
					break;
				case 3:
				
					_drawNum = 0;
					_now_array = [];
					_now_array = _xmlRecord.nowArr;
					_lineThickness=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineSize;
					_lColor=_xmlRecord._arr[_xmlRecord.id].site[_xmlRecord.movie_position].lineColor;
					var fengBi:FengBiBrushRes = new FengBiBrushRes();
					fengBi.transform.colorTransform = ct;
					fengBi.x = _now_array[0];
					fengBi.y = _now_array[1];
					fengBiTempX = _now_array[0];
					fengBiTempY = _now_array[1];
					_drawNum+=2;
					
					_xmlRecord.draw_array.push(_graphicSp); 
					if (_timer == null) {
						_timer = new Timer(5, 0);
						_timer.addEventListener(TimerEvent.TIMER, onDrawTimer);
					}
					_timer.start();
					break;
			}
			
		}
		private function onDrawTimer(e:TimerEvent):void 
		{
			switch (_xmlRecord._typeID ) 
			{
				case 0:
					var _p0:uint = _drawNum;
					_graphicSp.graphics.lineTo(_now_array[_p0], _now_array[_p0 + 1]);
					_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
					_drawNum+=2;
					if (_drawNum >= _now_array.length) {
						_graphicSp.graphics.endFill();
						_timer.stop();
						_xmlRecord.movie_position++;
						_xmlRecord.odd_movie();
					}else {
						_timer.start();
					}
					break;
				case 1:
					var _p1:uint = _drawNum;
					_graphicSp.graphics.beginFill(_lColor,1);
					_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
					_graphicSp.graphics.moveTo(tempPoint0.x,tempPoint0.y);
					_graphicSp.graphics.lineTo(tempPoint0.x,tempPoint0.y);	
					_graphicSp.graphics.lineTo(tempPoint1.x,tempPoint1.y);
					
					tempPoint0.x=_now_array[_p1];
					tempPoint0.y=_now_array[_p1+1];
					tempPoint1.x=tempPoint0.x+_lineThickness;
					tempPoint1.y=tempPoint0.y+_lineThickness;
					_graphicSp.graphics.lineTo(tempPoint1.x,tempPoint1.y);
					_graphicSp.graphics.lineTo(tempPoint0.x,tempPoint0.y);
					_graphicSp.graphics.endFill();
					
					_graphicSp.graphics.endFill();
					_drawNum+=2;
					if (_drawNum >= _now_array.length) {
						_timer.stop();
						_xmlRecord.movie_position++;
						_xmlRecord.odd_movie();
					}else {
						_timer.start();
					}
					break;
				case 2:
					var _p1:uint = _drawNum;
					var disX:Number=_now_array[_p1]-oldX;
					var disY:Number=_now_array[_p1+1]-oldY;
					var dis:Number = Math.sqrt(disX * disX + disY * disY);
					//改变笔触的大小,越快越小
					var scale:Number = defaultScale - dis * cx;
					//if(dis>0.12){
					if (scale > 1) scale = 1;
					else if (scale < brushMin) scale = brushMin;
					scale = (_oldScale + scale) * _cuXiXiShu;//这个参数可调节笔触的粗细,建议值(0.3~0.82),值越大，笔画越粗0.52
					//}
					var count:int = dis * brushAlpha;
					var scaleBili:Number = (_oldScale-scale) / (count);
					var brush:MovieClip;
					ct.color = _lColor
					for (var i:int=0; i<count; i++) {
						var brush1:MaoBiBrushRes = new MaoBiBrushRes();
						
						brush1.transform.colorTransform = ct;
						//							brush1.gotoAndStop(3);
						_graphicSp.addChild(brush1);
						//brush1.scaleX = brush1.scaleY = _oldScale-i * scaleBili; 
//						trace("brush1.scaleX",_xmlRecord._suLvArr[Math.floor(_p1/2)])
						brush1.scaleX = brush1.scaleY =_xmlRecord._suLvArr[Math.floor(_p1/2)];
						brush1.x=(disX/count)*(i+1)+oldX;
						brush1.y=(disY/count)*(i+1)+oldY;
					}
					oldX = _now_array[_p1];//mouseX;
					oldY = _now_array[_p1+1];//mouseY;
					_oldScale = scale;
					_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
					_drawNum+=2;
					if (_drawNum >= _now_array.length) {
						_timer.stop();
						_xmlRecord.movie_position++;
						_xmlRecord.odd_movie();
					}else {
						_timer.start();
					}
					while (_graphicSp.numChildren > 0)
					{
						_graphicSp.removeChildAt(0);
					}
					break;
				case 3:
					var _p1:uint = _drawNum;
					var disX1:Number=_now_array[_p1]-fengBiTempX;
					var disY1:Number=_now_array[_p1+1]-fengBiTempY;
					var dis1:Number = Math.sqrt(disX1 * disX1 + disY1 * disY1);
					var count1:int = dis1 * 0.75;
					for (var i1:int=0; i1<count1; i1++) 
					{
						var fengBi:FengBiBrushRes = new FengBiBrushRes();
						fengBi.transform.colorTransform = ct;
						fengBi.scaleX = fengBi.scaleY =_lineThickness;
						fengBi.x =(disX1/count1)*(i1+1)+fengBiTempX;
						fengBi.y = (disY1/count1)*(i1+1)+fengBiTempY;
						_graphicSp.addChild(fengBi);
					}
					
					fengBiTempX = _now_array[_p1];
					fengBiTempY = _now_array[_p1+1];
					_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
					_drawNum+=2;
					if (_drawNum >= _now_array.length) {
						_timer.stop();
						_xmlRecord.movie_position++;
						_xmlRecord.odd_movie();
					}else {
						_timer.start();
					}
					while (_graphicSp.numChildren > 0)
					{
						_graphicSp.removeChildAt(0);
					}
					break;
			}
		}
		private function onMOUSE_MOVE(event:MouseEvent):void
		{
			if(isCir)
			{
				_eSprite.graphics.lineTo(mouseX,mouseY);
				_circle.graphics.lineTo(mouseX,mouseY);
			}else
			{
				switch(_lineStyle)
				{
					case 0:
					{	
						_graphicSp.graphics.lineTo(this.mouseX, this.mouseY);
						_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
						if (_isRecord)
						{
							_xmlRecord._mem_xml.updateNode(mouseX,mouseY);
						}
						break;
					}				
					case 1:
					{
						_graphicSp.graphics.beginFill(_lColor,1);
						brush.scaleX = brush.scaleY = _lineThickness*0.5;
						brush.x=this.mouseX;
						brush.y=this.mouseY;
						_graphicSp.graphics.moveTo(brush.x,brush.y);
						_graphicSp.graphics.lineTo(brush.x,brush.y);
						_graphicSp.graphics.lineTo(brush.x+brush.width,brush.y+brush.height);
						_graphicSp.graphics.lineTo(_tempPoint1.x,_tempPoint1.y);
						_graphicSp.graphics.lineTo(_tempPoint0.x,_tempPoint0.y);
						_graphicSp.graphics.endFill();
						_tempPoint0.x=brush.x;
						_tempPoint0.y=brush.y;
						_tempPoint1.x=brush.x+brush.width;
						_tempPoint1.y=brush.y+brush.height;
						_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
						
						if (_isRecord)
						{
							_xmlRecord._mem_xml.updateNode(mouseX,mouseY);
						}
						break;
					}	
					case 2:
					{
						var disX:Number=mouseX-_oldX;
						var disY:Number=mouseY-_oldY;
						var dis:Number = Math.sqrt(disX * disX + disY * disY);
						//改变笔触的大小,越快越小
						var scale:Number = defaultScale - dis * cx;
						//if(dis>0.12){
						if (scale > 1) scale = 1;
						else if (scale < brushMin) scale = brushMin;
						scale = (_oldScale + scale) * _cuXiXiShu;//这个参数可调节笔触的粗细,建议值(0.3~0.82),值越大，笔画越粗0.52
						//}
						var count:int = dis * brushAlpha;
						var scaleBili:Number = (_oldScale-scale) / (count);
						var brush:MovieClip;
						ct.color = _lColor
						for (var i:int=0; i<count; i++) {
							var brush1:MaoBiBrushRes = new MaoBiBrushRes();
							
							brush1.transform.colorTransform = ct;
							//							brush1.gotoAndStop(3);
							_graphicSp.addChild(brush1);
//							brush1.scaleX = brush1.scaleY = _oldScale-i * scaleBili; 
							brush1.scaleX = brush1.scaleY = _lineThickness; 
							brush1.x=(disX/count)*(i+1)+_oldX;
							brush1.y=(disY/count)*(i+1)+_oldY;
						}
						_oldX = mouseX;//mouseX;
						_oldY = mouseY;//mouseY;
						_oldScale = scale;
						_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
			
						if (_isRecord)
						{
							_xmlRecord._mem_xml.updateNode(mouseX,mouseY);
							_xmlRecord._suLvArr.push(_lineThickness);
						}
						while (_graphicSp.numChildren > 0)
						{
							_graphicSp.removeChildAt(0);
						}
						break;
					}
					case 3:
					{
						var disX1:Number=mouseX-_fengBiTempX;
						var disY1:Number=mouseY-_fengBiTempY;
						var dis1:Number = Math.sqrt(disX1 * disX1 + disY1 * disY1);
						var count1:int = dis1 * 0.75;
						for (var i1:int=0; i1<count1; i1++) 
						{
							var fengBi:FengBiBrushRes = new FengBiBrushRes();
							fengBi.transform.colorTransform = ct;
							fengBi.scaleX = fengBi.scaleY =_lineThickness;
							fengBi.x =(disX1/count1)*(i1+1)+_fengBiTempX;
							fengBi.y = (disY1/count1)*(i1+1)+_fengBiTempY;
							_graphicSp.addChild(fengBi);
						}
						
						_fengBiTempX = mouseX;
						_fengBiTempY = mouseY;
						_bmpd.draw(_graphicSp, null, null, _isEraser ? BlendMode.ERASE : BlendMode.NORMAL, null, true);
						while (_graphicSp.numChildren > 0)
						{
							_graphicSp.removeChildAt(0);
						}
						if (_isRecord)
						{
							_xmlRecord._mem_xml.updateNode(mouseX,mouseY);
						}
						while (_graphicSp.numChildren > 0)
						{
							_graphicSp.removeChildAt(0);
						}
						break;
					}
				}
			}
			
		}
		public function play():void
		{
			_graphicSp.graphics.clear();
			_bmp.bitmapData.dispose();
			_bmpd = new BitmapData(_stageW,_stageH,true,0);
			_bmp.bitmapData = _bmpd;
			
		//	_xmlRecord._id= _huifang_btn._boxID-1;
			_xmlRecord.movie_position = 0;
			_xmlRecord.odd_movie();
		}
		
		public function stop():void
		{
			_xmlRecord.saveXML();
		}
		private function onMOUSE_UP(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMOUSE_UP);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
			if(isCir)
			{
				
				_bmpd.draw(_eSprite, null, null,BlendMode.ERASE,null,true);
				_eSprite.graphics.clear();
				_graphicSp.graphics.clear();
				_circle.graphics.clear()
			}
			
			if(touchEnd)
			{
				touchEnd();
			}
			
			/*if(_stepID != _jiLuArr.length-1)
			{
				if(_stepID==-1)
				{
					for (var i:int = 0; i < _jiLuArr.length; i++) 
					{
						(_jiLuArr[i] as BitmapData).dispose();
					}
					_jiLuArr.length = 0;
				}else if(_stepID==0){
					if(_jiLuArr.length!=0)
					{
						var tempBmpd:BitmapData = (_jiLuArr.shift() as BitmapData).clone();
						for (var j:int = 0; j < _jiLuArr.length; j++) 
						{
							(_jiLuArr[j] as BitmapData).dispose();
						}
						_jiLuArr.length = 0;
						_jiLuArr.push(tempBmpd);
					}
				}else{
					for (var i1:int = _stepID+1; i1 < _jiLuArr.length; i1++) 
					{
						(_jiLuArr[i1] as BitmapData).dispose();
						_jiLuArr.splice(i1,1);
					}
				}
			}
			if(_jiLuArr.length>10)
			{
				(_jiLuArr[0] as BitmapData).dispose();
				_jiLuArr.shift();
			}
			var bmd:BitmapData=new BitmapData(_stageW,_stageH,true,0);
			bmd=_bmpd.clone();
			_jiLuArr.push(bmd);
			_stepID = _jiLuArr.length-1;*/
		}
		/**
		 * 清除面板
		 */
		public function clear():void
		{
			if(_bmp.bitmapData)
			{
				_bmp.bitmapData.dispose();
			}
			_bmpd = new BitmapData(_stageW,_stageH,true,0);
			_bmp.bitmapData = _bmpd;
			_graphicSp.graphics.clear();
			/*for (var i:int = 0; i < _jiLuArr.length; i++) 
			{
				(_jiLuArr[i] as BitmapData).dispose();
			}
			_jiLuArr=[];*/
//			_bmp.bitmapData.dispose();
//			_bmp.bitmapData = null
//			_bmp = null;
//			_graphicSp.graphics.clear();
//			this.removeEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
//			_xmlRecord.removeEventListener(XmlRecord.PEN_EVENT,onPEN_EVENT);
		}
		
		public function dispose():void
		{
			_bmp.bitmapData.dispose();
			_bmp.bitmapData = null
			_bmp = null;
			_graphicSp.graphics.clear();
			this.removeEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
			_xmlRecord.removeEventListener(XmlRecord.PEN_EVENT,onPEN_EVENT);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
			
			_graphicSp= null;
			
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
			_touchPointArr=[];
			_brushArr=[];
			_pointArr=[];
			_touchPointArr = null;
			_brushArr = null;
			_pointArr = null;
			brush=null;
			_eSprite=null
			_circle=null;
			_xmlRecord = null;
			_now_array=[];
			_timer = null;
			ct = null;
			_now_array = null;
		}

		/**
		 * 绘制线条粗细值
		 */
		public function get lineThickness():int
		{
			return _lineThickness;
		}

		/**
		 * @private
		 */
		public function set lineThickness(value:int):void
		{
			_lineThickness = value;
		}

		/**
		 * 线条颜色
		 */
		public function get lcolor():uint
		{
			return _lColor;
		}

		/**
		 * @private
		 */
		public function set lcolor(value:uint):void
		{
			_lColor = value;
		}

		/**
		 * 是否处于橡皮擦功能
		 */
		public function get isEraser():Boolean
		{
			return _isEraser;
		}

		/**
		 * @private
		 * @param	value  false 笔触  true  橡皮擦
		 */
		public function set isEraser(value:Boolean):void
		{
			_isEraser = value;
		}

		/**
		 * 线条样式
		 */
		public function get lineStyle():int
		{
			return _lineStyle;
		}

		/**
		 * @private
		 * @param	value  0：铅笔 1:钢笔
		 */
		public function set lineStyle(value:int):void
		{
			_lineStyle = value;
		}

		public function get stageW():Number
		{
			return _stageW;
		}

		public function get stageH():Number
		{
			return _stageH;
		}

		public function get isRecord():Boolean
		{
			return _isRecord;
		}

		public function set isRecord(value:Boolean):void
		{
			_isRecord = value;
		}

		public function get xmlRecord():XmlRecord
		{
			return _xmlRecord;
		}

		public function get bmpd():BitmapData
		{
			return _bmpd;
		}

		public function get noTuYa():Boolean
		{
			return _noTuYa;
		}

		public function set noTuYa(value:Boolean):void
		{
			_noTuYa = value;
		}

		/*public function get jiLuArr():Array
		{
			return _jiLuArr;
		}
		
		public function set jiLuArr(value:Array):void
		{
			_jiLuArr = value;
		}*/
		
		public function get stepID():int
		{
			return _stepID;
		}
		
		public function set stepID(value:int):void
		{
			_stepID = value;
		}
		
		public function set bmpd(value:BitmapData):void
		{
			_bmpd = value;
		}
		
		public function get bmp():Bitmap
		{
			return _bmp;
		}
		
		public function set bmp(value:Bitmap):void
		{
			_bmp = value;
		}
	}
}