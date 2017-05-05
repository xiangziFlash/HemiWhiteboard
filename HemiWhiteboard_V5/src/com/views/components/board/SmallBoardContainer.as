package com.views.components.board
{
	import com.ToolUIRes;
	import com.board.BoardBGRes;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class SmallBoardContainer extends Sprite
	{
		private var _spBoard:Sprite;
		private var _bianKuang:BoardBianKuangRes;
		private var _tools:ToolUIRes;
		private var _spBtn:Sprite;
		
		private var _downX:Number=0;
		private var _tempX:Number=0;
		private var _downY:Number=0;
		private var _tempY:Number=0;
		private var _pageID:int;
		
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
		private var _i:int=0;
		public var isXiFu:Boolean;
		private var _boardMask:BoardBGRes;
		private var _stageMask:Shape;
		private var _defaultBoard:QuestionBoard;//默认的黑板
		
		public function SmallBoardContainer()
		{
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_bianKuang = new BoardBianKuangRes();
			_bianKuang.x = 46.7;
			
			_spBoard = new Sprite();
			_spBoard.x = 46.7+19;
			_spBoard.y = 19;
			
			_tools = new ToolUIRes();
			_tools.y = 40;
			
			_spBtn = new Sprite();
			_spBtn.y = 350;
			
			_boardMask = new BoardBGRes();
			_boardMask.x = 46.7+19;
			_boardMask.y = 19;

			_stageMask = new Shape();
			_stageMask.graphics.beginFill(0);
			_stageMask.graphics.drawRect(0,0,1575,893);
			_stageMask.graphics.endFill();
			
			_defaultBoard = new QuestionBoard();
			_defaultBoard.name = "defaultBoard";
			_defaultBoard.x = 46.7+19;
			_defaultBoard.y = 19;
			
			this.addChild(_tools);
			this.addChild(_spBtn);
			this.addChild(_defaultBoard);
			this.addChild(_spBoard);
			this.addChild(_bianKuang);
			this.addChild(_boardMask);
			this.addChild(_stageMask);
			_spBoard.mask = _boardMask;
			this.mask = _stageMask;
			_spBoard.visible = false;
			_tools.record_btn.gotoAndStop(1);
			_timer = new Timer(110);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
			
			_bianKuang.cacheAsBitmap = true;
			_tools.cacheAsBitmap = true;
//			addBoard();
		}
		
		private function initListener():void
		{
			_tools.claerAll_btn.addEventListener(MouseEvent.CLICK,onClaerAll_btnClick);
			_tools.record_btn.addEventListener(MouseEvent.CLICK,onRecord_btnClick);
			_tools.stop_btn.addEventListener(MouseEvent.CLICK,onStop_btnClick);
			_tools.play_btn.addEventListener(MouseEvent.CLICK,onPlay_btnClick);
//			_tools.hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClick);
			_spBtn.addEventListener(MouseEvent.CLICK,onSpBtnClick);
			_tools.close_btn.addEventListener(MouseEvent.CLICK,onCloseBtnClick);
			_bianKuang.addEventListener(MouseEvent.MOUSE_DOWN,onBianKuangDown);
//			_tools.hideBtn.gotoAndStop(1);
		}
		
		private function addBoard(path:String):void
		{
			var questionBoard:QuestionBoard = new QuestionBoard();
			questionBoard.addQuestion(path);
			questionBoard.name = "questionBoard_"+_spBoard.numChildren;
			questionBoard.x = _spBoard.numChildren*1489;
			_spBoard.addChild(questionBoard);
		}
		
		public function changeBoard(pageID:int):void
		{
			_spBoard.x = -(pageID*1489)+46.7+19;
		}
		
		private function onClaerAll_btnClick(event:MouseEvent):void
		{
			if(_spBoard.visible)
			{
				(_spBoard.getChildByName("questionBoard_"+_pageID) as QuestionBoard).onClaerAllBtnClick();
			}else{
				_defaultBoard.onClaerAllBtnClick();
			}
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_startY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
		}
		
		private function onPlay_btnClick(event:MouseEvent):void
		{
			if(_spBoard.visible)
			{
				(_spBoard.getChildByName("questionBoard_"+_pageID) as QuestionBoard).play();
			}else{
				_defaultBoard.play();
			}
			
		}
		
		private function onStop_btnClick(event:MouseEvent):void
		{
			_tools.record_btn.gotoAndStop(1);
			_tools.play_btn.visible=true;
			if(_spBoard.visible)
			{
				(_spBoard.getChildByName("questionBoard_"+_pageID) as QuestionBoard).stop();
			}else{
				_defaultBoard.stop();
			}
			
		}
		
		private function onRecord_btnClick(event:MouseEvent):void
		{
			_tools.record_btn.gotoAndStop(2);
			if(_spBoard.visible)
			{
				(_spBoard.getChildByName("questionBoard_"+_pageID) as QuestionBoard).onRecordBtnClick();
			}else{
				_defaultBoard.onRecordBtnClick();
			}
			
		}
		
		private function onHideBtnClick(e:MouseEvent):void
		{
			_pageID=0;
			_spBoard.visible = false;
//			changeBoard(0);
		}
		
		public function changeWenTi():void
		{
			while(_spBtn.numChildren>0)
			{
				if(_spBtn.getChildAt(0) is WenTiBtn)
				{//trace("释放");
					(_spBtn.getChildAt(0) as WenTiBtn).dispose();
				}
				_spBtn.removeChildAt(0);	
			}
			
			while(_spBoard.numChildren>0)
			{
				if(_spBoard.getChildAt(0) is QuestionBoard)
				{//trace("释放");
					(_spBoard.getChildAt(0) as QuestionBoard).dispose();
				}
				_spBoard.removeChildAt(0);	
			}
			_spBoard.visible = false;
			_spBoard.x = 46.7+19;
			_spBoard.y = 19;
			_pageID = 0;
			_i=0;
			if(ApplicationData.getInstance().smallBoardArr.length>0){//trace("更新了")
				addBoardThumb(ApplicationData.getInstance().smallBoardArr[_i]);
				addBoard(ApplicationData.getInstance().smallBoardArr[_i]);
			}else{
				return;
			}
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
				addBoard(ApplicationData.getInstance().smallBoardArr[_i]);
			}else{
				trace("问题加载完成")
			}
		}
		
		public function onCloseBtnClick(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onSpBtnClick(e:MouseEvent):void
		{
			if(e.target.name.split("_")[0]!="btn")return;
			_spBoard.visible = true;
			_pageID = int(e.target.name.split("_")[1]);
			changeBoard(_pageID);
		}
		
		public function onBianKuangDown(e:MouseEvent):void
		{
			if(e==null)
			{
				_downX = mouseX;
				_downY = mouseY;
				_tempX = mouseX;
				_tempX = mouseY;
				_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
				_startY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;	
			}else{
				_downX = mouseX;
				_downY = mouseY;
				_tempX = mouseX;
				_tempX = mouseY;
				_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
				_startY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;	
				stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
				stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
				if(!isXiFu){
					_timer.reset();
					_timer.start();	
				}
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
					Tweener.addTween(this,{x:(ConstData.stageWidth-this.width)*0.5,y:(ConstData.stageHeight-this.height)*0.5,time:0.5});
				}
			}else{
				if(!isXiFu){
					_speedX = 0;
					_speedY = 0;
					//	this.addEventListener(Event.ENTER_FRAME,onObjFrame);
				}else{
					isXiFu =false;
					Tweener.addTween(this,{x:(ConstData.stageWidth-this.width)*0.5,y:(ConstData.stageHeight-this.height)*0.5,time:0.5});
				}
			}
		}
		
		public function clearAll():void
		{
			while(_spBoard.numChildren>0)
			{
				(_spBoard.getChildAt(0) as QuestionBoard).dispose();
				_spBoard.removeChildAt(0);
			}
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