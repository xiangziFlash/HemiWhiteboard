package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.GraffitiBoardMouse;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class MessageBoardComponentMouse extends Sprite
	{
		private var _res:MessageBoardRes;
		private var _tuYa:GraffitiBoardMouse;
		private var _tempColorMC:MovieClip;
		private var _tempSizeMC:MovieClip;
		private var _colorArr:Array=[0xBF2115,0xEEC848,0x71AD34,0x0396DB,0xFFFFFF];
		private var _sizeArr:Array=[5,10,18,28];
		private var _lineThickness:Number=3;
		private var _saveBimData:BitmapData;
		private var _saveBim:Bitmap;
		private var _xml:XML;
		private var _fileArr:Array=[];
		private var _urlLdr:URLLoader;
		public var assetsPath:String="";
		private var _timer:Timer;
		private var _allFile:File;
		private var _nowColor:uint=_colorArr[0];
		private var _nowSize:int=_sizeArr[0];
		private var _nowStyle:int=0;
		private var _colorBitMap:BitmapData;
		private var _stageW:Number=0;
		private var _stageH:Number=0;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _tempThincess:int;
		private var _templineStyle:int;
		
		public function MessageBoardComponentMouse()
		{
			super();
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_res=new MessageBoardRes();
			_res.gotoAndStop(1);
			_tuYa=new GraffitiBoardMouse();
			_res.saveBtn.mouseChildren=false;
			_res.eraserBtn.mouseChildren=false;
			_res.clearBtn.mouseChildren=false;
			this.addChild(_tuYa);
			this.addChild(_res);
			
//			var sp:Sprite = new Sprite();
//			sp.graphics.beginFill(0);
//			sp.graphics.drawRect(0,0,100,100);
//			sp.graphics.endFill();
//			this.addChild(sp);
			
			_res.eraserBtn.gotoAndStop(1);
			_res.clearBtn.gotoAndStop(1);
			_res.clearAllBtn.gotoAndStop(1);
			_res.selectColor.visible=false;
			
			_colorBitMap = new BitmapData(_res.selectColor.width, _res.selectColor.height, true, 0);
			_colorBitMap.draw(_res.selectColor);
			for (var i:int = 0; i < 5; i++) 
			{
				_res.colorBtn["color_"+i].gotoAndStop(1);
				if(_res.sizeMC["size_"+i]){
					_res.sizeMC["size_"+i].gotoAndStop(1);
				}
			}
			_tempColorMC=_res.colorBtn.color_0;
			_tempSizeMC=_res.sizeMC.size_0;
			upDataColor();
			upDataSize();
			_tuYa.lcolor=_nowColor;
			_tuYa.lineThickness=_nowSize;
//			_tuYa.addListener();
			_tuYa.noTuYa = false;
			_tuYa.isGongYong = false;
//			_tuYa.setWH(1920,1080);
			
		}
		
		public function setWH(w:Number,h:Number):void
		{
			_stageW = w;
			_stageH = h;
			_tuYa.setWH(w,h);
			_res.x = w-570; 
			_res.y = h-268; 
		}
		
		public function gongNengXuanZhe(boo:Boolean=false):void
		{
			if(boo==false){
				_res.gotoAndStop(1);
			}else{
				_res.closeBtn.visible = false;
				_res.saveBtn.visible = false;
				_res.gotoAndStop(2);
				_res.x = _stageW-469+72; 
				_res.y = _stageH-268+20; 
			}
		}
		
		public function setToolsVis(boo:Boolean):void
		{
			if(boo==false){
				_res.visible = false;
			}else{
				_res.visible = true;
			}
		}
		
		public function drawBitmap(bmpd:BitmapData):void
		{
			_tuYa.drawBitmap(bmpd);
		}
		
		private function initListener():void
		{
//			_res.addEventListener(MouseEvent.CLICK,onTuYa_CLICK);
			_res.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_res.clearBtn.addFrameScript(0,onStop);
			_res.eraserBtn.addFrameScript(0,onStop);
			_res.clearAllBtn.addFrameScript(0,onStop);
			_res.clearAllBtn.addFrameScript(25,onClearAllStop);
			_res.selectColor.addEventListener(MouseEvent.CLICK,onSelecetColor_CLICK);
			_res.closeBtn.addEventListener(MouseEvent.CLICK,onCloseBtnClick);
			_res.saveBtn.addEventListener(MouseEvent.CLICK,onSaveBtnClick);
		}
		
		private function onCloseBtnClick(event:MouseEvent):void
		{
			NotificationFactory.sendNotification(NotificationIDs.START_SHOTSCREEN,1);			
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onSaveBtnClick(event:MouseEvent):void
		{
			_res.visible = false;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onSelecetColor_CLICK(event:MouseEvent):void
		{
			_nowColor = _colorBitMap.getPixel(_res.selectColor.mouseX, _res.selectColor.mouseY);
			_tuYa.lcolor=_nowColor;
		}				
		
		private function onClearAllStop():void
		{
			_res.clearAllBtn.gotoAndStop(26);
			stage.addEventListener(MouseEvent.CLICK,onStageCLICK);
		}
		
		private function onStageCLICK(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK,onStageCLICK);
			_res.clearAllBtn.gotoAndStop(1);
		}
		
		private function onStop():void
		{
			_res.clearBtn.gotoAndStop(1);
			_res.eraserBtn.gotoAndStop(1);
			_res.clearAllBtn.gotoAndStop(1);
		}
		
		private function onDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseX;
			_tempY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(event:MouseEvent):void
		{
			_res.x +=mouseX-_downX;
			_res.y +=mouseY-_downY;
			_downX = mouseX;
			_downY = mouseY;
		}
		
		private function onUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			if(Math.abs(mouseX-_tempX)<5||Math.abs(mouseY-_tempY)<5)
			{
				trace("是点击",event.target.name,"+++++++")
				onTuYa_CLICK(event)
			}
		}
		
		private function onTuYa_CLICK(event:MouseEvent):void
		{
			switch(event.target.name)
			{
				case "pencilBtn":
					if(ApplicationData.getInstance().styleVO.isEraser)
					{
						_tuYa.lineThickness = _tempThincess;
						_tuYa.lineStyle = _templineStyle;
						_res.eraserBtn.gotoAndStop(1);
						ApplicationData.getInstance().styleVO.isEraser = false;
					}
					_res.clearBtn.gotoAndStop(1);
					_nowStyle=0;
					_tuYa.lineThickness=_nowSize;
					_tuYa.isEraser=false;
					_tuYa.isCir=false;
					ApplicationData.getInstance().styleVO.isEraser = false;
					ApplicationData.getInstance().styleVO.isCir = false;
					upDataPen();
					break;
				case "penBtn":
					if(ApplicationData.getInstance().styleVO.isEraser)
					{
						_tuYa.lineThickness = _tempThincess;
						_tuYa.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
						_res.eraserBtn.gotoAndStop(1);
					}
					_res.clearBtn.gotoAndStop(1);
					_nowStyle=1;
					_tuYa.lineThickness=_nowSize;
					_tuYa.isEraser=false;
					_tuYa.isCir=false;
					ApplicationData.getInstance().styleVO.isEraser = false;
					ApplicationData.getInstance().styleVO.isCir = false;
					upDataPen();
					break;
				case "size_0":
				case "size_1":
				case "size_2":
				case "size_3":
					if(ApplicationData.getInstance().styleVO.isEraser)
					{
						_tuYa.lineThickness = _tempThincess;
						_tuYa.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
						_res.eraserBtn.gotoAndStop(1);
					}
					_res.clearBtn.gotoAndStop(1);
					upDataSize(int(event.target.name.split("_")[1]));
					//trace(_nowSize);
					ApplicationData.getInstance().styleVO.isEraser = false;
					ApplicationData.getInstance().styleVO.isCir = false;
					_tuYa.isEraser=false;
					_tuYa.isCir=false;
					upDataPen();
					break;
				case "colorBoard":
					if(_tempColorMC)
					{
						_tempColorMC.gotoAndStop(1);
					}
					if(ApplicationData.getInstance().styleVO.isEraser)
					{
						_tuYa.lineThickness = _tempThincess;
						_tuYa.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
						_res.eraserBtn.gotoAndStop(1);
					}
					ApplicationData.getInstance().styleVO.isEraser = false;
					ApplicationData.getInstance().styleVO.isCir = false;
					_res.clearBtn.gotoAndStop(1);
					event.stopPropagation();
					if((event.target as MovieClip).currentFrame==1)
					{
						(event.target as MovieClip).gotoAndStop(2);
						_res.selectColor.visible=true;
						_res.visible=true;
						_res.addChild(_res.selectColor);
					}else{
						(event.target as MovieClip).gotoAndStop(1);
						_res.selectColor.visible=false;
					}
					//stage.addEventListener(MouseEvent.CLICK,onColorStageClick);
					break;
				case "color_0":
				case "color_1":
				case "color_2":
				case "color_3":
				case "color_4":
				case "color_5":
					_res.selectColor.visible=false;
					_res.colorBtn.colorBoard.gotoAndStop(1);
					upDataColor(int(event.target.name.split("_")[1]));
					if(ApplicationData.getInstance().styleVO.isEraser)
					{
						_tuYa.lineThickness = _tempThincess;
						_tuYa.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
						_res.eraserBtn.gotoAndStop(1);
					}
					_res.clearBtn.gotoAndStop(1);
					ApplicationData.getInstance().styleVO.isEraser = false;
					ApplicationData.getInstance().styleVO.isCir = false;
					_tuYa.isEraser=false;
					_tuYa.isCir=false;
					upDataPen();
					break;
				case "clearAllBtn":
					//_res.clearAllBtn.play();
					onNew();
					break;	
				case "clearAllYes":
					
					break;
				case "saveBtn":
					onSave();
					break;				
				case "eraserBtn":
					//橡皮擦
//					_res.pencilBtn.gotoAndStop(1);
//					_res.penBtn.gotoAndStop(1);
					
					_res.clearBtn.gotoAndStop(1);
					if((event.target as MovieClip).currentFrame==1){
						(event.target as MovieClip).gotoAndStop(2);
						_tempThincess = _tuYa.lineThickness;
						_templineStyle = _tuYa.lineStyle;
						_tuYa.lineThickness = 20;
						_tuYa.lineStyle = 0;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = true;
					}else{
						(event.target as MovieClip).gotoAndStop(1);
						_tuYa.lineThickness = _tempThincess;
						_tuYa.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}
					
					/*_tuYa.lineStyle=0;	
					_tuYa.lineThickness=_nowSize+10;
					_tuYa.isEraser=true;
					_tuYa.isCir=false;
					ApplicationData.getInstance().styleVO.isEraser = true;
					ApplicationData.getInstance().styleVO.isCir = false;
//					_res.eraserBtn.play();
					upDataPen();*/
					break;		
				case "clearBtn":
					//圈选删除
//					_res.clearBtn.play();
					/*ApplicationData.getInstance().styleVO.isEraser = false;
					ApplicationData.getInstance().styleVO.isCir = true;
					_tuYa.isEraser=false;
					_tuYa.isCir=true;
					upDataPen();*/
					if(ApplicationData.getInstance().styleVO.isEraser)
					{
						_tuYa.lineThickness = _tempThincess;
						_tuYa.lineStyle = _templineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}
					_res.eraserBtn.gotoAndStop(1);
					if((event.target as MovieClip).currentFrame==1){
						(event.target as MovieClip).gotoAndStop(2);
						ApplicationData.getInstance().styleVO.isCir = true;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}else{
						(event.target as MovieClip).gotoAndStop(1);
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = false;
					}
					break;	
				default:
					break;
			}
		}
		
		private function onColorStageClick(event:MouseEvent):void
		{
			//stage.removeEventListener(MouseEvent.CLICK,onColorStageClick);
			//_res.selectColor.visible=false;
		}		
		
		
		private function upDataPen():void
		{
			if(_tuYa.isEraser||_tuYa.isCir){
//				_res.pencilBtn.gotoAndStop(1);
//				_res.penBtn.gotoAndStop(1);
				return;
			}
			_tuYa.lineStyle=_nowStyle;
			if(_nowStyle==0){
//				_res.pencilBtn.gotoAndStop(2);
//				_res.penBtn.gotoAndStop(1);
			}else{
//				_res.pencilBtn.gotoAndStop(1);
//				_res.penBtn.gotoAndStop(2);
			}
		}
		
		private function upDataSize(id:int=0):void
		{
			if(_tempSizeMC){
				_tempSizeMC.gotoAndStop(1);
			}
			_tempSizeMC=_res.sizeMC["size_"+id] as MovieClip;
			_tempSizeMC.gotoAndStop(2);
			_nowSize=_sizeArr[id];
			_tuYa.lcolor=_nowColor;
			_tuYa.lineThickness=_nowSize;
		}
		private function upDataColor(id:int=0):void
		{
			if(_tempColorMC){
				_tempColorMC.gotoAndStop(1);
			}
			_tempColorMC=_res.colorBtn["color_"+id] as MovieClip;
			_tempColorMC.gotoAndStop(2);
			_nowColor=_colorArr[id];
			_tuYa.lcolor=_nowColor;
			_tuYa.lineThickness=_nowSize;
		}
		
		public function onNew():void
		{
			_tuYa.clear();
			upDataPen();
			_tuYa.lineThickness=_nowSize;
			_tuYa.isEraser=false;
			_tuYa.isCir=false;
		}
		
		/**
		 * 恢复到初始
		 * */
		public function reset():void
		{
			_res.visible = true;
			_tuYa.clear();
			_tuYa.lineThickness=_nowSize;
			_tuYa.isEraser=false;
			_tuYa.isCir=false;
			_nowStyle=0;
			upDataSize(0);
			upDataColor(0);
			upDataPen();
			ApplicationData.getInstance().styleVO.isCir = false;
			ApplicationData.getInstance().styleVO.isEraser = false;
			_res.eraserBtn.gotoAndStop(1);
			_res.clearBtn.gotoAndStop(1);
			_res.colorBtn.colorBoard.gotoAndStop(1);
			_res.selectColor.visible = false;
//			ApplicationData.getInstance().styleVO.lineThickness 
		}
		
		/**
		 * 保存绘图
		 * */
		private function onSave():void
		{
			ToolKit.log("保存绘图保存绘图保存绘图");
			_saveBimData = new BitmapData(_tuYa.stageW, _tuYa.stageH);
			_saveBimData.draw(_tuYa);					
		}
		
	
		
	}
}