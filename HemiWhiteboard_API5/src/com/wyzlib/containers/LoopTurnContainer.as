package com.wyzlib.containers 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author wang
	 */
	public class LoopTurnContainer extends Sprite 
	{
		private var _sp_con:Sprite;
		private var _sp_con_mask:Sprite;
		
		private var ConClass:Class;
		
		private var _pageHeight:Number = 0;
		
		private var _disTime:Timer;
		private var _tempY:Number = 0;
		private var _moveY:Number = 0;
		private var _downY:Number = 0;
		
		private var _speed:Number = 0;
		/**
		 * 减速系数,数值越大，惯性越小
		 */
		private var _speedDis:Number = 1.15;
		private var _conY:Number = 0;
		private var _targetName:String;
		private var _targetObj:DisplayObject;
		private var _stageW:Number = 0;
		private var _stageH:Number = 0;
		
		private var _moveDis:Number = 0;
		private var _twObjV_0:Number=0;
		private var _twObjS:Number=0;
		private var _twObjT:Number=12;
		private var _twObjA:Number=0;
		private var _currentFrame:Number = 0;
		private var _conArr:Array = [];
		private var _pageSum:Number;
		/**
		 *一个列表的高度 
		 */		
		private var _oneListH:Number=0;
		private var _nowSelectObjID:int;
		private var _objHeadName:String="";
		public function LoopTurnContainer(w:Number,h:Number) 
		{
			_stageW = w;
			_stageH = h;
			initContent();
			initListener();
		}
		
		private function initContent():void 
		{
			_sp_con = new Sprite();
			_sp_con_mask = new Sprite();
			_sp_con_mask.graphics.beginFill(0x000000);
			_sp_con_mask.graphics.drawRect(0, 0, _stageW, _stageH);
			_sp_con_mask.graphics.endFill();
			_sp_con.mask = _sp_con_mask;
			this.addChild(_sp_con);
//			_sp_con.y=10;
//			_sp_con_mask.y=10;
			this.addChild(_sp_con_mask);			
			
			_disTime = new Timer(50, 0);
		}
		
		private function initListener():void 
		{
			_sp_con.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
			_disTime.addEventListener(TimerEvent.TIMER, onTimer);
		}
		/**
		 * 设置显示类名
		 * @param	className
		 * @param	objHeadName   列表中对象名称头
		 */
		public function setContent(className:String,objHeadName:String):void
		{
			_objHeadName=objHeadName;
			ConClass = getDefinitionByName(className) as Class;
			var con:DisplayObject = new ConClass();
			_pageSum = Math.ceil(_sp_con_mask.height / con.height);
			_conArr.length = 0;
			_conArr.push(con);
			_sp_con.addChild(con);
			_oneListH=con.height;
			var tempY:Number=con.height;
			for (var i:int = 0; i < _pageSum*3-1; i++) 
			{
				var item:DisplayObject = new ConClass();
				item.y= tempY;
				_sp_con.addChild(item);
				tempY += item.height;
				_conArr.push(item);
			}
			_pageHeight =Number(_sp_con.height)/ 3;
			conY= -_pageHeight;
		}
		/**
		 * 点下
		 * @param	e
		 */
		private function onDown(e:MouseEvent):void 
		{
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ENTER_FRAME, onMoveToObjEnterFrame);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onUp);
			_downY = mouseY;
			_tempY = mouseY;
			_moveY = mouseY;
			_disTime.reset();
			_disTime.start();
		}
		/**
		 * 移动
		 * @param	e
		 */
		private function onMove(e:MouseEvent):void 
		{
			//trace("move", mouseX);
			conY+= mouseY - _moveY;
			_moveY = mouseY;
		}
		/**
		 * 弹起后做判断
		 * @param	e
		 */
		private function onUp(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onUp);
			_speed = mouseY - _tempY;
			_disTime.reset();
			if (Math.abs(_speed) > 10) {
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}else {				
				if (Math.abs(mouseY - _downY) < 20) {
					//trace("点击", e.target.name);
					_targetName = e.target.name;
					selectObj(e.target as DisplayObject);
					this.dispatchEvent(new Event(Event.CHANGE));
				}else{
						selectNameObj(_objHeadName+nowSelectObjID);
				}
			}
		}
		/**
		 * 指定某个名称的对象
		 * @param	nam	对象的名称
		 */
		public function selectNameObj(nam:String):void
		{
			var arr:Array = [];
			for (var i:int = 0; i < _conArr.length; i++) 
			{
				var obj:DisplayObject = _conArr[i].getChildByName(nam) as DisplayObject;
				//trace(obj);
				var point:Point = this.globalToLocal(obj.parent.localToGlobal(new Point(obj.x, obj.y)));
				var objPro:Object = new Object();
				objPro.obj = obj;
				objPro.dis = Math.abs(_stageH - point.y);
//				trace("point.y",point.y)
				arr.push(objPro);
			}
			arr.sortOn("dis", Array.NUMERIC);			
			selectObj(arr[0].obj);
		}
		/**
		 * 指定某个名称的对象
		 * @param	nam	对象的名称
		 */
		public function getNameObjAll(nam:String):Array
		{
			var arr:Array = [];			
			for (var i:int = 0; i < _conArr.length; i++) 
			{
				var obj:DisplayObject = _conArr[i].getChildByName(nam) as DisplayObject;
				arr.push(obj);
			}
			return arr;
		}
		/**
		 * 选中的二级对象，根据该对象距离舞台中心的坐标差值，进行运动
		 * @param	obj
		 */
		public function selectObj(obj:DisplayObject):void
		{
			_targetObj = obj;
			_targetName = _targetObj.name;
			var point:Point = this.globalToLocal(obj.parent.localToGlobal(new Point(obj.x, obj.y)));
			_twObjS = _stageH - point.y;
			_currentFrame = 0;
			if (Math.abs(_twObjS) < 2){
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeEventListener(Event.ENTER_FRAME, onMoveToObjEnterFrame);
			this.addEventListener(Event.ENTER_FRAME, onMoveToObjEnterFrame);
			_twObjA=2*_twObjS/(_twObjT*_twObjT);
			_twObjV_0 = Math.sqrt(Math.abs(2 * _twObjA * _twObjS));
			//trace("要移动的距离",  _stageH * 0.5,point.y,_twObjS);
		}
		/**   
		 * 
		 * 
		 * 
		 * 
		 * 将某个对象移动到中心
		 * @param	e
		 */
		private function onMoveToObjEnterFrame(e:Event):void 
		{
			
			_currentFrame++;
			var nowVt:Number = _twObjA * (_twObjT-_currentFrame);
			var oldVt:Number = _twObjA * (_twObjT-_currentFrame+1);
			var spee:Number=((nowVt*nowVt)-(_twObjV_0*_twObjV_0))/(2*_twObjA)-((oldVt*oldVt)-(_twObjV_0*_twObjV_0))/(2*_twObjA);
			//var spee:Number = _twObjV +_twObjA*;
			//_twObjV = _twObjV - _twObjA;
			conY -= spee;
			if(_currentFrame>=_twObjT){
				this.removeEventListener(Event.ENTER_FRAME, onMoveToObjEnterFrame);
				//trace("dispatchEvent  onMoveToObjEnterFrame",nowSelectObjID);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 
		 * 实时刷新，用于更新惯性
		 * @param	e
		 */
		private function onEnterFrame(e:Event):void 
		{
			_speed = _speed / _speedDis;
			conY += _speed;	
			if (Math.abs(_speed) < 0.2) {
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				var id:Number=(Math.abs((conY%_pageHeight)%_oneListH)+Math.round(Math.round(_stageH/_moveDis)/2)*_moveDis)/_moveDis;
				if(id!=nowSelectObjID){
					selectNameObj(_objHeadName+nowSelectObjID);
				}else{
					//trace("dispatchEvent  onEnterFrame",nowSelectObjID);
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}			
					
		}
		
		/**
		 *当前处于中间位置的对象ID 
		 * @return id
		 * 
		 */		
		public function get nowSelectObjID():int
		{
			//_nowSelectObjID=Math.round((Math.abs((conY%_pageHeight)%_oneListH)+Math.round(Math.round(_stageH/_moveDis)/2)*_moveDis)/_moveDis);
			_nowSelectObjID=int((Math.abs((conY%_pageHeight)%_oneListH)+Math.round(Math.round(_stageH/_moveDis)/2)*_moveDis)/_moveDis);
			//trace("%int",_nowSelectObjID,int(_oneListH/_moveDis));
			_nowSelectObjID=_nowSelectObjID%int(_oneListH/_moveDis);			
			return _nowSelectObjID;
		}		
		
		private function onTimer(e:TimerEvent):void 
		{
			_tempY = mouseY;
		}
		
		public function get conY():Number 
		{
			_conY=_sp_con.y;
			return _conY;
		}
		/**
		 * 内容的X坐标，并判断内容显示位置
		 */
		public function set conY(value:Number):void 
		{
			_conY = value;
			
			if (_conY < -_pageHeight * 2) {
				//trace("_conY < -_pageHeight * 2");
				_conY +=_pageHeight;
			}
			if (_conY > -_pageHeight) {
				//trace("_conY > -_pageHeight");
				_conY-=_pageHeight;
			}
			_sp_con.y = _conY;
		}
		/**
		 * 获取点击对象的最里层名字
		 */
		public function get targetName():String 
		{
			return _targetName;
		}
		/**
		 * 点击的对象
		 */
		public function get targetObj():DisplayObject 
		{
			return _targetObj;
		}

		/**
		 * 将要移动的距离
		 */
		public function get moveDis():Number
		{
			return _moveDis;
		}

		/**
		 * @private
		 */
		public function set moveDis(value:Number):void
		{
			_moveDis = value;
		}

	}

}