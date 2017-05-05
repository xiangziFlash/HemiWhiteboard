package com.scxlib
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class GraffitiLayer extends Sprite
	{
		private var _graffitiBoard:GraffitiBoardMouse;
//		private var _tools:ToolUIRes;
		private var _lineThickness:int=5;
		private var _lColor:uint=0x383838;
		
		private var _isEraser:Boolean;
		private var _lineStyle:int;
		private var _isCir:Boolean;
		private var _isRecord:Boolean;
		
		public function GraffitiLayer()
		{
			super();
			initContent();
		}
		
		private function initContent():void
		{
			_graffitiBoard=new GraffitiBoardMouse();
			this.addChild(_graffitiBoard);
			_graffitiBoard.isGongYong = true;
		//	_tools=new ToolUIRes();
		//	this.addChild(_tools);
		//	_tools.y=_graffitiBoard.height;
			
		//	_tools.play_btn.visible=false;
			
			initListener();
		}
		
		public function addListener():void
		{
//			_graffitiBoard.addListener();
			_graffitiBoard.noTuYa = false;
		}
		
		public function removeListener():void
		{
//			_graffitiBoard.removeListener();
			_graffitiBoard.noTuYa = true;
		}
		
		private function initListener():void
		{
//			_tools.palette_btn.addEventListener(MouseEvent.CLICK,onPalette_btnClick);
//			_tools.strokeWeight_btn.addEventListener(MouseEvent.CLICK,onStrokeWeight_btnClick);
//			_tools.strokeStyles_btn.addEventListener(MouseEvent.CLICK,onStrokeStyles_btnClick);
//			_tools.circleSelect.addEventListener(MouseEvent.CLICK,onCircleSelectClick);
//			_tools.eraser_btn.addEventListener(MouseEvent.CLICK,onEraser_btnClick);
//			_tools.claerAll_btn.addEventListener(MouseEvent.CLICK,onClaerAll_btnClick);
//			_tools.record_btn.addEventListener(MouseEvent.CLICK,onRecord_btnClick);
//			_tools.stop_btn.addEventListener(MouseEvent.CLICK,onStop_btnClick);
//			_tools.play_btn.addEventListener(MouseEvent.CLICK,onPlay_btnClick);
//			_tools.expand_btn.addEventListener(MouseEvent.CLICK,onExpand_btnClick);
//			_tools.fit_btn.addEventListener(MouseEvent.CLICK,onFit_btnClick);
//			_tools.minimize_btn.addEventListener(MouseEvent.CLICK,onMinimize_btnClick);
//			_tools.fullScreen_btn.addEventListener(MouseEvent.CLICK,onFullScreen_btnClick);
//			_tools.lock_btn.addEventListener(MouseEvent.CLICK,onLock_btnClick);
//			_tools.new_btn.addEventListener(MouseEvent.CLICK,onNew_btnClick);
//			_tools.close_btn.addEventListener(MouseEvent.CLICK,onClose_btnClick);
		}
		
		public function setSize(w:Number,h:Number):void
		{
			_graffitiBoard.setWH(w,h);
			//_tools.scaleX=_tools.scaleY=w/_tools.width;
		}
		protected function onClose_btnClick(event:MouseEvent):void
		{
		//	trace("关闭");
			//this.dispatchEvent(new GraffitiEvent(GraffitiEvent.CLOSE));
		}
		
		protected function onNew_btnClick(event:MouseEvent):void
		{
		//	trace("新建");
			//this.dispatchEvent(new GraffitiEvent(GraffitiEvent.ADD));
		}
		
		protected function onLock_btnClick(event:MouseEvent):void
		{
		//	trace("锁定");
			//this.dispatchEvent(new GraffitiEvent(GraffitiEvent.LOCK));
		}
		
		protected function onFullScreen_btnClick(event:MouseEvent):void
		{
			//trace("全屏");
//			if(_tools.fullScreen_btn.currentFrame==1)
//			{
//				_tools.fullScreen_btn.gotoAndStop(2);
//			}else
//			{
//				_tools.fullScreen_btn.gotoAndStop(1);
//			}
//			
//			this.dispatchEvent(new GraffitiEvent(GraffitiEvent.FULLSCREE));
		}
		
		protected function onMinimize_btnClick(event:MouseEvent):void
		{
			//trace("最小化");
//			this.dispatchEvent(new GraffitiEvent(GraffitiEvent.MINIMZE));
		}
		
		protected function onFit_btnClick(event:MouseEvent):void
		{
		//	trace("最适位置");
//			this.dispatchEvent(new GraffitiEvent(GraffitiEvent.FITPOSITION));
			
		}
		
		protected function onExpand_btnClick(event:MouseEvent):void
		{
		//	trace("拓展按钮");
//			this.dispatchEvent(new GraffitiEvent(GraffitiEvent.EXPAND));
		}
		
		protected function onPlay_btnClick(event:MouseEvent):void
		{
			
		}
		
		public function play():void
		{
			_graffitiBoard.play();
		}
		
		public function stop():void
		{
			if(_graffitiBoard.isRecord)
			{
				//_tools.record_btn.gotoAndStop(1);
				_graffitiBoard.stop();
				//_tools.play_btn.visible=true;
			}
		}
		
		protected function onStop_btnClick(event:MouseEvent):void
		{
			if(_graffitiBoard.isRecord)
			{
				//_tools.record_btn.gotoAndStop(1);
				_graffitiBoard.stop();
			//	_tools.play_btn.visible=true;
			}
			
		}
		
		public function onRecord_btnClick():void
		{
			_graffitiBoard.xmlRecord.newXML();
			_graffitiBoard.isRecord=true;
		}
		
		public function onClaerAll_btnClick():void
		{
			_graffitiBoard.clear();
		}
		
		public function onEraser_btnClick():void
		{
			_graffitiBoard.isEraser=true;
			_graffitiBoard.isCir=false;
		}
		
		public function onCircleSelectClick():void
		{
			_graffitiBoard.isCir=true;
			_graffitiBoard.isEraser=false;
		}
		
		public function onStrokeStyles_btnClick(id:int):void
		{
			_graffitiBoard.lineStyle=id;
			_graffitiBoard.isCir=false;
			_graffitiBoard.isEraser=false;
		}
		
		public function onStrokeWeight_btnClick(num:int):void
		{
			_graffitiBoard.lineThickness=num;
			_graffitiBoard.isCir=false;
			_graffitiBoard.isEraser=false;
		}
		
		public function onPalette_btnClick(color:uint):void
		{
			_graffitiBoard.lcolor=color;
			_graffitiBoard.isCir=false;
			_graffitiBoard.isEraser=false;
		}
		
		public function reset():void
		{
//			_tools.play_btn.visible=false;
			_graffitiBoard.isRecord=false;
			_graffitiBoard.isEraser=false;
			_graffitiBoard.isCir=false;
			_graffitiBoard.clear();
		}
		
		public function clear():void
		{
			_graffitiBoard.clear();
		}

		public function get lineThickness():int
		{
			return _lineThickness;
		}

		public function set lineThickness(value:int):void
		{
			_lineThickness = value;
		}

		public function get lColor():uint
		{
			return _lColor;
		}

		public function set lColor(value:uint):void
		{
			_lColor = value;
		}

		public function get isEraser():Boolean
		{
			return _isEraser;
		}

		public function set isEraser(value:Boolean):void
		{
			_isEraser = value;
		}

		public function get lineStyle():int
		{
			return _lineStyle;
		}

		public function set lineStyle(value:int):void
		{
			_lineStyle = value;
		}

		/**
		 * 是否是圈选删除
		 */
		public function get isCir():Boolean
		{
			return _isCir;
		}

		/**
		 * @private
		 */
		public function set isCir(value:Boolean):void
		{
			_isCir = value;
		}

		public function get isRecord():Boolean
		{
			return _isRecord;
		}

		public function set isRecord(value:Boolean):void
		{
			_isRecord = value;
		}



	}
}