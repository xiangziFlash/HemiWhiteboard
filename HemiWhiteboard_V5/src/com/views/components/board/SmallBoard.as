package com.views.components.board
{
	import com.ToolUIRes;
	import com.lylib.touch.objects.RotatableScalable1;
	import com.models.ApplicationData;
	import com.scxlib.GraffitiBoardMouse;
	import com.scxlib.GraffitiLayer;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class SmallBoard extends Sprite
	{
		private var _graffitiLayer:GraffitiLayer;
		private var _smallBoardRes:SmallBoardRes;
		private var _smallTools:ToolUIRes;
		private var _tempColor:MovieClip;
		private var _tempThicness:MovieClip;
		private var _tempStyle:MovieClip;
		private var _colorArr:Array=[0xFFFFFF,0xFF0000];
		private var _ThicnessArr:Array=[5,3];
		
		private var _downX:Number=0;
		private var _tempX:Number=0;
		private var _downY:Number=0;
		private var _tempY:Number=0;
		
		/**
		 * 惯性一系列参数
		 * 
		 * 
		 */
		private var _startX:Number=0;
		private var _startY:Number=0;
		private var _upX:Number=0;
		private var _upY:Number=0;
		private var _speedX:Number=0;
		private var _speedY:Number=0;
		private var _timer:Timer;
		private var _moCaLi:Number = 1.2;
		private var _m:Matrix;
		private var _localPoint:Point;
		private var _parentPoint:Point;
		private var _spBtn:Sprite;
		private var _i:int=0;
		
		public var isXiFu:Boolean;
		
		public function SmallBoard()
		{
			_smallTools = new ToolUIRes();
			_smallTools.y = 40;
			
			_smallBoardRes = new SmallBoardRes();
			_smallBoardRes.x = 44;
			
			_graffitiLayer = new GraffitiLayer();
			_graffitiLayer.x = 60.45;
			_graffitiLayer.y = 21.3;
			_graffitiLayer.setSize(1480,833);
			
			_spBtn = new Sprite();
			_spBtn.y = 350;
			
			this.addChild(_smallTools);
			this.addChild(_spBtn);
			this.addChild(_smallBoardRes);
			this.addChild(_graffitiLayer);
			
			_smallBoardRes.addChild(_smallBoardRes.bianKuang);
			_timer = new Timer(110);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
			_smallBoardRes.record_btn.gotoAndStop(1);
			
			initListener();
			chuShi();
		}
		
		private function initListener():void
		{
//			_smallTools.palette_btn.addEventListener(MouseEvent.CLICK,onPalette_btnClick);
//			_smallTools.strokeWeight_btn.addEventListener(MouseEvent.CLICK,onStrokeWeight_btnClick);
//			_smallTools.strokeStyles_btn.addEventListener(MouseEvent.CLICK,onStrokeStyles_btnClick);
//			_smallTools.circleSelect.addEventListener(MouseEvent.CLICK,onCircleSelectClick);
//			_smallTools.eraser_btn.addEventListener(MouseEvent.CLICK,onEraser_btnClick);
			_smallTools.claerAll_btn.addEventListener(MouseEvent.CLICK,onClaerAll_btnClick);
			_smallTools.record_btn.addEventListener(MouseEvent.CLICK,onRecord_btnClick);
			_smallTools.stop_btn.addEventListener(MouseEvent.CLICK,onStop_btnClick);
			_smallTools.play_btn.addEventListener(MouseEvent.CLICK,onPlay_btnClick);
			_smallTools.hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClick);
			_spBtn.addEventListener(MouseEvent.CLICK,onSpBtnClick);
			_smallTools.close_btn.addEventListener(MouseEvent.CLICK,onCloseBtnClick);
			_smallTools.addEventListener(MouseEvent.CLICK,onToolsClick);
			_smallBoardRes.bianKuang.addEventListener(MouseEvent.MOUSE_DOWN,onBianKuangDown);
			_smallTools.hideBtn.gotoAndStop(1);
		}
		
		private function chuShi():void
		{
			_graffitiLayer.onStrokeStyles_btnClick(1);
			_graffitiLayer.onPalette_btnClick(_colorArr[1]);
			_graffitiLayer.onStrokeWeight_btnClick(_ThicnessArr[0]);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_startY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
		}
		
		private function onToolsClick(e:MouseEvent):void
		{
//			trace(e.target.name,"name")
		}
		
		private function onPlay_btnClick(event:MouseEvent):void
		{
			_graffitiLayer.play();
		}
		
		private function onStop_btnClick(event:MouseEvent):void
		{
			_smallTools.record_btn.gotoAndStop(1);
			_smallTools.play_btn.visible=true;
			_graffitiLayer.stop();
		}
		
		private function onRecord_btnClick(event:MouseEvent):void
		{
			_smallTools.record_btn.gotoAndStop(2);
			_graffitiLayer.onRecord_btnClick();
		}
		
		private function onClaerAll_btnClick(event:MouseEvent):void
		{
			_graffitiLayer.onClaerAll_btnClick();
			
		}
		
		private function onHideBtnClick(e:MouseEvent):void
		{
			if(_smallBoardRes.getChildByName("bmp")!=null)
			{
				_smallBoardRes.removeChild(_smallBoardRes.getChildByName("bmp"));
			}
		}
		
		protected function onEraser_btnClick(event:MouseEvent):void
		{
			_graffitiLayer.onEraser_btnClick();
		}
		
		private function onCircleSelectClick(event:MouseEvent):void
		{
			_graffitiLayer.onCircleSelectClick();
		}
		
		private function onStrokeStyles_btnClick(event:MouseEvent):void
		{
			if(event.target.name.split("_")[0]!="brush")return;
			var id:int = event.target.name.split("_")[1]
			if(_tempStyle){
				_tempStyle.gotoAndStop(1);
			}
			_tempStyle = event.target as MovieClip;
			_tempStyle.gotoAndStop(2);
			_graffitiLayer.onStrokeStyles_btnClick(id);
		}
		
		private function onStrokeWeight_btnClick(event:MouseEvent):void
		{
			if(event.target.name.split("_")[0]!="btn")return;
			var id:int = event.target.name.split("_")[1]
			if(_tempThicness){
				_tempThicness.gotoAndStop(1);
			}
			_tempThicness = event.target as MovieClip;
			_tempThicness.gotoAndStop(2);
			_graffitiLayer.onStrokeWeight_btnClick(_ThicnessArr[id]);
		}
		
		private function onBianKuangDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseX;
			_tempX = mouseY;
			_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_startY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;	
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
			//this.addEventListener(Event.ENTER_FRAME, onObjFrame);
			if(!isXiFu){
				_timer.reset();
				_timer.start();	
			}
		}
		
		private function onObjFrame(e:Event):void
		{
			_timer.stop();
			this.stage.removeEventListener(Event.ENTER_FRAME,onObjFrame);
			this.x += _speedX;
			this.y += _speedY;
			
			_speedX /=_moCaLi;
			_speedY /=_moCaLi;
			
			if(Math.abs(_speedX)<=0.09)
			{
				_timer.stop();
				this.removeEventListener(Event.ENTER_FRAME,onObjFrame);
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function onMove(e:MouseEvent):void
		{
			this.x +=mouseX-_downX;
			this.y +=mouseY-_downY;
			_downX = mouseX;
			_downY = mouseY;
		}
		
		private function onUp(e:MouseEvent):void
		{
			_upX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_upY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			
			//触控结束的回调函数
			if(Math.abs(_upX-_startX)>10||Math.abs(_upY-_startY)>10)
			{
				if(!isXiFu){
					_speedX = _upX-_startX;
					_speedY = _upY-_startY;
					this.addEventListener(Event.ENTER_FRAME,onObjFrame);
				}else{
					isXiFu =false;
					Tweener.addTween(this,{x:(1920-this.width)*0.5,y:(1080-this.height)*0.5,time:0.5});
				}
			}else{
				if(!isXiFu){
					_speedX = 0;
					_speedY = 0;
				//	this.addEventListener(Event.ENTER_FRAME,onObjFrame);
				}else{
					isXiFu =false;
					Tweener.addTween(this,{x:(1920-this.width)*0.5,y:(1080-this.height)*0.5,time:0.5});
				}
			}
		}
		
		private function onPalette_btnClick(event:MouseEvent):void
		{
//			trace(event.target.name,"66++")
			if(event.target.name.split("_")[0]!="btn")return;
			var id:int = event.target.name.split("_")[1]
			if(_tempColor){
				_tempColor.gotoAndStop(1);
			}
			_tempColor = event.target as MovieClip;
			_tempColor.gotoAndStop(2);
			_graffitiLayer.onPalette_btnClick(_colorArr[id]);
		}
		
		private function onLockBtnClick(e:MouseEvent):void
		{
			if((e.target as MovieClip).currentFrame==1)
			{
				(e.target as MovieClip).gotoAndStop(2);
//				this.noDrag = false;
				_graffitiLayer.addListener();
//				removeEventListeners();
			}else{
				(e.target as MovieClip).gotoAndStop(1);
//				this.noDrag = false;
				_graffitiLayer.removeListener();
//				addEventListeners();
			}
		}
		
		public function onCloseBtnClick(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function changeWenTi():void
		{
			while(_spBtn.numChildren>0)
			{
				trace(_spBtn.getChildAt(0));
				if(_spBtn.getChildAt(0) is WenTiBtn)
				{trace("释放");
					(_spBtn.getChildAt(0) as WenTiBtn).dispose();
				}
				_spBtn.removeChildAt(0);	
			}
			_i=0;
			addBoardThumb(ApplicationData.getInstance().smallBoardArr[_i]);
		}
		
		private function addBoardThumb(path:String):void
		{
			var btn:WenTiBtn = new WenTiBtn(path);
			btn.name = "btn_"+_i;
			btn.addEventListener(Event.COMPLETE,onBtnEnd);
			btn.y =_i*28;
			_spBtn.addChild(btn);
		}
		
		private function onBtnEnd(e:Event):void
		{
			if(_i<ApplicationData.getInstance().smallBoardArr.length-1)
			{
				_i++;
				addBoardThumb(ApplicationData.getInstance().smallBoardArr[_i]);
			}else{
//				trace("问题加载完成")
			}
			
		}
		
		private function onSpBtnClick(e:MouseEvent):void
		{
			if(e.target.name.split("_")[0]!="btn")return;
			if(_smallBoardRes.getChildByName("bmp")!=null)
			{
				_smallBoardRes.removeChild(_smallBoardRes.getChildByName("bmp"));
			}
			var bmp:Bitmap = new Bitmap((e.target as WenTiBtn).bmpd,"auto",true);
			bmp.name ="bmp";
			bmp.x = bmp.y = 20;
			_smallBoardRes.addChild(bmp);
		}
		
		public function reset():void
		{
			_smallTools.play_btn.visible=false;
			_graffitiLayer.clear();
			
//			for(var i:int=0;i<_spBtn.numChildren;i++){
//				(_spBtn.getChildAt(i) as BitmapData).dispose();
//			}
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.Sprite;
import flash.events.Event;
import flash.net.URLRequest;
import flash.text.TextFormat;

class WenTiBtn extends Sprite
{
//	private var _path:String;
	private var _ldr:Loader;
	private var _bmpd:BitmapData;
	
	public function WenTiBtn(path:String)
	{
		this.mouseChildren = false;
		_ldr = new Loader();
		_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEnd);
		_ldr.load(new URLRequest(path));
	}
	
	private function onLdrEnd(event:Event):void
	{
		_bmpd = (_ldr.content as Bitmap).bitmapData;
		_ldr.width = 47;
		_ldr.height = 27;
		this.addChild(_ldr);
		
		this.dispatchEvent(new Event(Event.COMPLETE));
	}
	
	public function dispose():void
	{
		(_ldr.content as Bitmap).bitmapData.dispose();
		_ldr.unloadAndStop();
		_ldr=null;
	}

	public function get bmpd():BitmapData
	{
		return _bmpd;
	}
}