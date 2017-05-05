/**
 * RotatableScalable
 * 继承此类可以让对象具有旋转缩放的多点触控功能
 * 目前还是存在Bug，如需沟通请与 hiliuyuan@gmail.com 联系
 *
 * @author		刘渊
 * @version	1.0.8.2011-2-10_beta
 */

package com.lylib.touch.objects
{
	import com.lylib.touch.TouchOptions;
	import com.lylib.touch.TouchPoint;
	import com.tweener.transitions.DynamicRegistrationTweener;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class MultiPointRotationScale extends Sprite
	{	
		/**
		 * 存放触摸点
		 */	
		private var _points:Vector.<TouchPoint> = new Vector.<TouchPoint>();
		
		/**
		 * 存放触摸点的ID
		 */		
		private var _touchIDs:Array=[];
		
		/**
		 * 中心点
		 */
		private var _centerPoint:Point = new Point();
		
		/**
		 * 基准点1
		 */		
		private var _point1:TouchPoint = new TouchPoint();
		
		/**
		 * 基准点2
		 */		
		private var _point2:TouchPoint = new TouchPoint();
		
		/**
		 * _point1 与 _point2 之间的距离
		 */	
		private var _distance:Number = int.MIN_VALUE;
		
		/**
		 * _point1 与 _point2 的角度
		 */		
		private var _angle:Number;
		
		/**
		 * x方向增量
		 */		
		private var _dx:Number;
		
		/**
		 * y方向增量
		 */		
		private var _dy:Number;
		
		/**
		 * 比例增量
		 */		
		private var _ds:Number;
		
		/**
		 * 角度增量
		 */		
		private var _dAngle:Number;
		
		//private var ball:Ball = new Ball(0xff0000);
		
		
		private var _noRotat:Boolean = false;
		private var _noScale:Boolean = false;
		private var _noFloat:Boolean = true;
		private var _noDrag:Boolean = false;
		private var _maxScale:Number = 3;
		private var _minScale:Number = 0.15;
		private var _dScalse:Number = 0.1;
		
		protected var _maxWidth:Number;
		protected var _maxHeight:Number;
		protected var _minWidth:Number;
		protected var _minHeight:Number;
		
		public var touchEndFun:Function;
		public var touchMoveFun:Function;
		public var touchBeginFun:Function;
		
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
		private var _timeID:int;
		
		public function MultiPointRotationScale()
		{
			super();
			
			_timer = new Timer(100);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			addEventListeners();
		}
		
		
		/**
		 * 触摸开始
		 * @param e
		 */		
		private function onTouchBegin(e:TouchEvent):void
		{
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
			this.removeEventListener(Event.ENTER_FRAME,onObjFrame);
		//	if(_touchIDs.length==0)
			//{//trace("執行了")
			//	_timer.reset();
			//	_timer.start();
			//	_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
				//_startY = this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
				//trace("begin",_startX,_startY);
			//}
			
			//如果 this 里面有子对象，坐标会出错，所以将全局坐标转换为 this 的坐标
			var p1:Point = new Point(e.stageX, e.stageY);
			var p2:Point = this.globalToLocal(p1);
			
			var touchPoint:TouchPoint = new TouchPoint(	e.touchPointID,
				e.stageX,
				e.stageY, 
				p2.x,
				p2.y);
			addTouchPoint(touchPoint);
			if(touchBeginFun){
				touchBeginFun();
			}
			e.stopPropagation();
		}
		
		/**
		 * 触摸结束
		 * @param e
		 */		
		private function onTouchEnd(e:TouchEvent):void
		{
			removeTouchPoint( e.touchPointID );
			
			
			e.stopPropagation();
		}
		
		private function weiYi():void
		{
			_upX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_upY =  this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
			//trace("weiYi",_startX,_startY);
			//触控结束的回调函数
			if(Math.abs(_upX-_startX)>5||Math.abs(_upY-_startY)>5)
			{//trace("enterFrame")
				//trace("執行le慣性")
				_timer.stop();
				_speedX = _upX-_startX;
				_speedY = _upY-_startY;
				//trace(_speedX,_speedY,"xyxyxy")
				Tweener.removeTweens(this);
				this.removeEventListener(Event.ENTER_FRAME,onObjFrame);
				this.addEventListener(Event.ENTER_FRAME,onObjFrame);
			}else{
				_speedX = 0;
				_speedY = 0;
				Tweener.removeTweens(this);
				this.removeEventListener(Event.ENTER_FRAME,onObjFrame);
				this.addEventListener(Event.ENTER_FRAME,onObjFrame);
		
			}
			
		}
		
		private function onObjFrame(e:Event):void
		{
			this.x += _speedX;
			this.y += _speedY;
			
			_speedX /=_moCaLi;
			_speedY /=_moCaLi;
			
			if(Math.abs(_speedX)<=0.09){//trace("慣性執行完成");
				allTouchEnd();
				_timer.stop();
				this.removeEventListener(Event.ENTER_FRAME,onObjFrame);
			}
		}
		
		
		/**
		 * 触摸移动
		 * @param e
		 */		
		private function onTouchMove(e:TouchEvent):void
		{
			//trace("move",e.currentTarget);
			updatePoints(e);
			if(touchMoveFun){
				touchMoveFun();
			}
			e.stopPropagation();//trace(maxWidth,maxHeight);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_startX = this.transform.pixelBounds.left+this.transform.pixelBounds.width*0.5;
			_startY = this.transform.pixelBounds.top+this.transform.pixelBounds.height*0.5;
		}
		
		private function onTouchRollOut(e:TouchEvent):void 
		{
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			stage.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
		}
		
		
		protected function loop(e:Event):void
		{
			
			if( _points.length == 1)
			{
				//只存在移动
				if(!noDrag){
					_dx = _point1.stageX - this.localToGlobal(_centerPoint).x;
					_dy = _point1.stageY - this.localToGlobal(_centerPoint).y;
					//trace(_point1.stageX, this.localToGlobal(_centerPoint).x);
					Tweener.addTween(this,{time:0.4, x:x+_dx, y:y+_dy});
				}
				
			}
			else if(_points.length > 1)
			{
				//计算比例
				if( !noScale )
				{
					var newDistance:Number = TouchPoint.distanceStage(_point1,_point2);
					_ds = newDistance / _distance;
					if(_ds * scaleX > maxScale + _dScalse)
					{
						_ds = 1 + maxScale - scaleX + _dScalse;
					}
					else if(_ds * scaleX < minScale - _dScalse)
					{
						_ds = 1 + minScale - scaleX - _dScalse;
					}
					
					this.scaleX *= _ds;
					this.scaleY *= _ds;
					_distance = newDistance;
				}
				else
				{
					_ds = 1;
				}
				
				
				
				//计算角度
				if( !noRotat)
				{
					var newAngle:Number = getDoublePointAngle( _point1, _point2 );
					if( (newAngle > 0 && _angle < 0) || (newAngle < 0 && _angle > 0) )
					{
						
					}else{
						_dAngle = R2D(newAngle - _angle);
					}
					this.rotation += 2*_dAngle;
					_angle = newAngle
				}
				else
				{
					_dAngle = 0;
				}
				
				
				
				//调整 x y
				var newCenterX:Number = (_point1.stageX + _point2.stageX)/2;
				var newCenterY:Number = (_point1.stageY + _point2.stageY)/2;
				
				_dx = newCenterX - this.localToGlobal(_centerPoint).x;
				_dy = newCenterY - this.localToGlobal(_centerPoint).y;
				
				this.scaleX /= _ds;
				this.scaleY /= _ds;
				this.rotation -= 2*_dAngle;
				if(!noDrag){
					Tweener.addTween(this,{time:0.4, x:x+_dx, y:y+_dy, scaleX:scaleX*_ds, scaleY:scaleY*_ds, rotation:rotation+2*_dAngle});
				}
				
			}
		}
		
		
		
		/**
		 * 添加一个触摸点
		 * @param p
		 */
		private function addTouchPoint(touchPoint:TouchPoint):void
		{
			//判断是否有重复点
			var i:int = 0;
			
			if (_touchIDs.indexOf(touchPoint.touchID) >= 0 || _touchIDs.length+1 > TouchOptions.maxTouchCount)
			{
				return;
			}
			
			//没有重复点，添加
			//if(_points.length<2)
			//{
			_touchIDs.push( touchPoint.touchID );
			_points.push( touchPoint );
			//trace("添加后",_points.length);
			//}
			
			
			if(_points.length == 1)
			{
				_point1 = _points[0];
				_centerPoint.x = _point1.localX;
				_centerPoint.y = _point1.localY;
				//_startY =_point1.stageX;
				//_startX =_point1.stageY;
				
				//----------------添加阴影，浮起效果--------------------
				if(!noFloat)
				{
					Tweener.addTween(this, {scaleX:(15/width*scaleX)+scaleX,scaleY:(15/height*scaleY)+scaleY,  time:0.3, transition:"easeinoutquad"});	
					var dropshadow:DropShadowFilter = new DropShadowFilter(10, 45, 0x000000, 0.70, 15, 15);
					this.filters=[dropshadow];
				}
				//----------------添加阴影，浮起效果--------------------
			}
			else if(_points.length == 2)
			{
				_point1 = _points[0];
				_point2 = _points[1];
				
				_centerPoint.x = (_point1.localX + _point2.localX)/2;
				_centerPoint.y = (_point1.localY + _point2.localY)/2;
				
				_distance = TouchPoint.distanceStage(_point1,_point2);
				
				_angle = getDoublePointAngle( _point1, _point2 );
			}
				//大于2点
			else
			{
				for(i=0; _points[i]!=null && i<_points.length-1; i++)
				{
					var distance:Number = TouchPoint.distanceStage(touchPoint,_points[i]);
					if( distance > _distance )
					{
						_distance = distance;
						_point1 = _points[i];
						_point2 = touchPoint;
					}
				}
				_centerPoint.x = (_point1.localX + _point2.localX)/2;
				_centerPoint.y = (_point1.localY + _point2.localY)/2;
				
				_angle = getDoublePointAngle( _point1, _point2 );
			}
			
			reset();
		}
		
		
		/**
		 * 移除一个触摸点
		 * @param 
		 */		
		private function removeTouchPoint(touchID:int):void
		{
			if(_points.length==0)return;
			
			var i:int = _touchIDs.length - 1;
			while (i >= 0)
			{
				if (_touchIDs[i] == touchID)
				{
					_touchIDs.splice(i, 1);
					_points[i] = null;
					delete _points[i];
					_points.splice(i, 1);
					//trace("删除后",_points.length);
					break;
				}
				i -= 1;
			}
			
			if(_points.length == 0)
			{//trace("----------------");
				stage.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
				stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
				
				if(!noFloat)
				{
					//--------------去掉阴影---------------------------------------------------
					if (scaleX-(15/width*scaleX)>this.minScale && scaleY-(15/height*scaleY)>this.minScale)
						Tweener.addTween(this, {scaleX:scaleX-(15/width*scaleX),scaleY:scaleY-(15/height*scaleY),  time:0.3, transition:"easeinoutquad"});	
					else
					{	
						if (scaleX-(15/width*scaleX)<this.minScale && scaleY-(15/height*scaleY)<this.minScale)
							Tweener.addTween(this, {scaleX:minScale,scaleY:minScale,  time:0.3, transition:"easeinoutquad"});		
						else
						{
							if (scaleX-(15/width*scaleX)<this.minScale)
								Tweener.addTween(this, {scaleX:minScale,scaleY:scaleY-(15/height*scaleY),  time:0.3, transition:"easeinoutquad"});	
							else
								Tweener.addTween(this, {scaleX:scaleX-(15/width*scaleX),scaleY:minScale,  time:0.3, transition:"easeinoutquad"});		
						}
					}
					this.filters=[];
					//--------------去掉阴影---------------------------------------------------	
				}
				
				//
			}
			else if(_points.length == 1)
			{
				//_distance = int.MIN_VALUE;
				_point1 = _points[0];
				_centerPoint.x = _point1.localX;
				_centerPoint.y = _point1.localY;
				//trace("----------", _point1.stageX, this.localToGlobal(_centerPoint).x);
				//------------------------恢复到最大尺寸或最小尺寸-----------------------------
				if(!noScale)
				{
					if(scaleX > maxScale)
					{
						Tweener.addTween(this, {time:0.5, scaleX:maxScale, scaleY:maxScale});
					}
					else if(scaleX < minScale)
					{
						Tweener.addTween(this, {time:0.5, scaleX:minScale, scaleY:minScale});
					}
				}
			}
			else if(_points.length == 2)
			{
				_point1 = _points[0];
				_point2 = _points[1];
				_distance = TouchPoint.distanceStage(_point1, _point2);
				
				_centerPoint.x = (_point1.localX + _point2.localX)/2;
				_centerPoint.y = (_point1.localY + _point2.localY)/2;
			}
				//大于2点, 暂时取消
			else
			{
				_distance = int.MIN_VALUE;
				for( i=0; i<_points.length-1; i++)
				{
					for(var j:int=i+1; j<_points.length; j++)
					{
						var d:Number = TouchPoint.distanceStage(_points[i],_points[j]);
						if( _distance < d )
						{
							_distance = d;
							_point1 = _points[i];
							_point2 = _points[j];
						}
					}
				}
				_centerPoint.x = (_point1.localX + _point2.localX)/2;
				_centerPoint.y = (_point1.localY + _point2.localY)/2;
			}
			if(_touchIDs.length==0){
				//weiYi();
				allTouchEnd();
			}
			//ball.x = _centerPoint.x;
			//ball.y = _centerPoint.y;
			
			reset();
		}
		
		
		
		private function updatePoints(e:TouchEvent):void
		{
			for(var i:int = 0; i<_points.length; i++)
			{
				if(_points[i].touchID == e.touchPointID)
				{
					//trace(_points[i].stageX - e.stageX, _points[i].stageY - e.stageY);
					
					_points[i].stageX = e.stageX;
					_points[i].stageY = e.stageY;
					
					//_startY = e.stageX;
				//	_startX = e.stageY;
					
				}
			}
		}
		
		
		private function reset():void
		{
			_dAngle = 0;
			_ds = 0;
			_dx = 0;
			_dy = 0;
		}
		
		
		
		/**
		 * 计算两点之间的角度，返回一个弧度
		 * @param p1	
		 * @param p2
		 * @return 	返回一个弧度
		 * 
		 */		
		private function getDoublePointAngle( p1:TouchPoint, p2:TouchPoint ):Number
		{
			var dy:Number = p2.stageY - p1.stageY;
			var dx:Number = p2.stageX - p1.stageX;
			//trace(Math.atan2( dy, dx ), dy);
			return Math.atan2( dy, dx );
		}
		
		
		
		/**
		 * 弧度转化成角度
		 * @param angle
		 * @return 
		 * 
		 */		
		private function R2D(angle:Number):Number
		{
			return angle * 180 / Math.PI;
		}
		
		//所有点弹起
		public function allTouchEnd():void
		{
			if(touchEndFun){
				touchEndFun();
			}
		}
		
		/**
		 * 设置可以缩放的最小尺寸。
		 * 注意：此方法会改变 minScale 的值
		 * 	     如果想调用ImageLoader的setMinSize方法，请在ImageLoader派发complete事件之后调用，因为ImageLoader异步加载图片
		 * @param	minWidth
		 * @param	minHeight
		 */
		public function setMinSize(minWidth:Number = NaN, minHeight:Number = NaN):void
		{
			_minWidth = minWidth;
			_minHeight = minHeight;
			
			var ratio:Number;
			if( !isNaN(minWidth) && isNaN(minHeight) ){
				ratio = minWidth / (this.width / this.scaleX);
			}else if( isNaN(minWidth) && !isNaN(minHeight) ){
				ratio = minHeight / (this.height / this.scaleY);
			}else if(!isNaN(minWidth) && !isNaN(minHeight)){
				ratio = Math.min(minWidth / (this.width / this.scaleX), minHeight / (this.height / this.scaleY) );
			}else{
				return;
			}
			
			if (ratio != Infinity)
			{
				this.minScale = ratio;
			}
			//trace(this.scaleX, minScale);
			//trace(this.width * minScale, this.height * minScale);
		}
		
		
		public function setMaxSize(maxWidth:Number = NaN, maxHeight:Number = NaN):void
		{
			_maxWidth = maxWidth;
			_maxHeight = maxHeight;
			
			var ratio:Number;
			if( !isNaN(maxWidth) && isNaN(maxHeight) ){
				ratio = maxWidth / (this.width / this.scaleX);
			}else if( isNaN(maxWidth) && !isNaN(maxHeight) ){
				ratio = minHeight / (this.height / this.scaleY);
			}else if(!isNaN(maxWidth) && !isNaN(maxHeight)){
				ratio = Math.min(maxWidth / (this.width / this.scaleX), maxHeight / (this.height / this.scaleY) );
			}else{
				return;
			}
			
			if (ratio != Infinity)
			{
				this.maxScale = ratio;
			}
		}
		
		
		/**
		 * 添加监听
		 */
		public function addEventListeners():void
		{
			this.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			this.addEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			this.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			//	this.addEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouchRollOut);
			this.addEventListener(TouchEvent.TOUCH_ROLL_OVER, onTouchRollOut);
			this.addEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouchEnd);
			this.addEventListener(Event.ENTER_FRAME, loop);
		}
		
		
		
		/**
		 * 移除所有监听
		 */
		public function removeEventListeners():void
		{
			if(stage){
				stage.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			}
			this.removeEventListener(TouchEvent.TOUCH_BEGIN, onTouchBegin);
			this.removeEventListener(TouchEvent.TOUCH_END, onTouchEnd);
			this.removeEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
			this.removeEventListener(TouchEvent.TOUCH_ROLL_OVER, onTouchRollOut);
			this.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, onTouchEnd);
			this.removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		/**
		 * 禁用
		 */	
		public function dispose() : void
		{
			removeEventListeners();
			
			if (_touchIDs != null)
			{
				_touchIDs.splice(0, _touchIDs.length);
			}
			if (_points != null)
			{
				_points.splice(0, _points.length);
			}
			_touchIDs = null;
			_points = null;
			_centerPoint = null;
			_point1 = null;
			_point2 = null;
		}
		
		//----------------------------- getter  and setter -----------------------------------------//
		
		/**
		 * 关闭旋转功能
		 */
		public function get noRotat():Boolean
		{
			return _noRotat;
		}
		public function set noRotat(value:Boolean):void
		{
			_noRotat = value;
		}
		
		/**
		 * 关闭缩放功能
		 */
		public function get noScale():Boolean
		{
			return _noScale;
		}
		public function set noScale(value:Boolean):void
		{
			_noScale = value;
		}
		
		/**
		 * 最大比例
		 */
		public function get maxScale():Number
		{
			return _maxScale;
		}
		public function set maxScale(value:Number):void
		{
			_maxScale = value;
		}
		
		/**
		 * 最小比例
		 */
		public function get minScale():Number
		{
			return _minScale;
		}
		public function set minScale(value:Number):void
		{
			_minScale = value;
		}
		
		/**
		 * 关闭浮起效果，如果图片尺寸很大时建议关闭
		 */
		public function get noFloat():Boolean
		{
			return _noFloat;
		}
		public function set noFloat(value:Boolean):void
		{
			_noFloat = value;
		}
		
		/**
		 * 缩放的缓冲值
		 * 在缩放时，对象的 scale 不会大于 maxScale + dScalse，且不会小于 minScale - dScalse
		 * 缩放结束后恢复到 maxScale 或 minScale
		 */
		public function get dScalse():Number
		{
			return _dScalse;
		}
		public function set dScalse(value:Number):void
		{
			_dScalse = value;
		}
		
		
		public function get noDrag():Boolean
		{
			return _noDrag;
		}
		
		public function set noDrag(value:Boolean):void
		{
			_noDrag = value;
		}
		
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
		}
		
		public function get maxHeight():Number
		{
			return _maxHeight;
		}
		
		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
		}
		
		public function get minWidth():Number
		{
			return _minWidth;
		}
		
		public function set minWidth(value:Number):void
		{
			_minWidth = value;
		}
		
		public function get minHeight():Number
		{
			return _minHeight;
		}
		
		public function set minHeight(value:Number):void
		{
			_minHeight = value;
		}
	}
}