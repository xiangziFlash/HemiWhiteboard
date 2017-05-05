package com.wyzlib.containers
{
	import com.wyzlib.events.MyMoveSpriteEvent;
	import com.tweener.transitions.Tweener;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * ----------1.01-------新加一个移动到指定位置
	 * ----------1.02-------修改移动完成后派发的事件
	 * ----------1.1-------修改移动方式简化程序
	 * ----------1.11-------修复高度或宽度小于遮罩后移动问题
	 * ----------1.12-------修改getChildByName的读取方式
	 * @author wang
	 * @version 1.02 版本号  //
	 */
	public class MyMoveSprite extends Sprite
	{
		/**
		 * 装对象的容器
		 */
		public var sp_con:Sprite;
		private var sp_con_mask:Sprite;
		private var sp_con_bg:Sprite;
		private var _tempChild:Sprite;
		private var _downX:Number;
		private var _upX:Number;
		private var _tempX:Number;
		private var _moveX:Number;
		private var _downY:Number;		
		private var _moveY:Number;
		private var _upY:Number;
		private var _tempY:Number;
		
		private var _endX:Number;
		private var _endY:Number;
		
		private var _pageNum:int;
		private var _pageID:int;
		/**
		 * 定义多少为移动的条件
		 */
		public var dis:Number =50;//
		private var _moveDis:Number = 50;
		/**
		 * 定义移动的起始X值
		 */
		public var startX:Number = 0;
		/**
		 * 定义移动的起始y值
		 */
		public var startY:Number = 0;
		/**
		 * 是否是横向移动
		 */
		public var isHeng:Boolean;
		/**
		 * 是否移动
		 */
		public var isMove:Boolean=true;
		public var isMoveEnd:Boolean = true;
		
		private var _isDown:Boolean;		
		private var _event:MyMoveSpriteEvent;
		
		
		//private var _moveObject:MoveObjectNew;		
		
		public function MyMoveSprite() 
		{
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			sp_con = new Sprite();
			sp_con_mask = new Sprite();
			sp_con_mask.graphics.beginFill(0x000000);
			sp_con_mask.graphics.drawRect(0, 0, 1, 1);
			sp_con_mask.graphics.endFill();
			sp_con.mask = sp_con_mask;
			super.addChild(sp_con);
			super.addChild(sp_con_mask);
			//_moveObject = new MoveObjectNew();
		}
		
		private function initListener():void
		{
			sp_con.addEventListener(MouseEvent.MOUSE_DOWN, onSpCon_Down);
			//sp_con.addEventListener(MouseEvent.MOUSE_UP, onSpCon_Up);
			//sp_con.addEventListener(MouseEvent.MOUSE_OUT, onSpCon_Out);
			//sp_con.addEventListener(MouseEvent.ROLL_OUT, onSpCon_Out);
			sp_con.doubleClickEnabled = true;
			sp_con.addEventListener(MouseEvent.DOUBLE_CLICK, onSpCon_DoubleClick);
			//_moveObject.addEventListener(Event.COMPLETE, onMoveEnd);
		}
		
		/**
		 * 添加显示对象
		 * @param	child 显示对象
		 */
		override public function addChild(child:DisplayObject):DisplayObject 
		{			
			isMoveEnd = true;
			if (child is Sprite) {
				_tempChild = child as Sprite;
				//_tempChild.doubleClickEnabled = true;
				sp_con.addChild(_tempChild);				
			}else {
				sp_con.addChild(child);				
			}						
			if (sp_con_bg == null) {
				sp_con_bg = new Sprite();
				var shap:Shape = new Shape();
				shap.graphics.beginFill(0x000000,0);
				shap.graphics.drawRect(0, 0, sp_con.width, sp_con.height);				
				shap.graphics.endFill();
				sp_con_bg.addChild(shap);
				sp_con_bg.name = "con_bg";
				sp_con.addChildAt(sp_con_bg,0);
			}else {				
				while (sp_con_bg.numChildren > 0) {
					sp_con_bg.removeChildAt(0);
				}				
				var shap1:Shape = new Shape();
				shap1.graphics.beginFill(0x000000, 0);				
				shap1.graphics.drawRect(0, 0, sp_con.width, sp_con.height);
				shap1.graphics.endFill();		
				sp_con_bg.addChild(shap1);				
				sp_con_bg.x = 0;
				sp_con_bg.y = 0;
			}
			if (isHeng) {				
				_pageNum = Math.ceil(sp_con.width / moveDis);
			}else {						
				_pageNum = Math.ceil(sp_con.height / moveDis);
			}
			//trace(isMove);
			
			super.addChild(sp_con);
			sp_con.addChildAt(sp_con_bg,0);
			super.addChild(sp_con_mask);
			sp_con.mask = sp_con_mask;
			//trace("**",sp_con_bg,sp_con_bg.x,sp_con_bg.y,sp_con_bg.height);
			return child;
			this.getChildByName
		}
		
		/**
		 * 根据显示对象名字获取实例
		 * @param	name 对象名字
		 */
		override public function getChildByName (name:String) : DisplayObject 
		{
			return sp_con.getChildByName(name) as DisplayObject;
		}
		
		/**
		 * 设置遮罩层的宽和高
		 * @param	_x 遮罩的横坐标
		 * @param	_y 遮罩的纵坐标
		 * @param	_w 遮罩的宽度
		 * @param	_h 遮罩的高度
		 */
		public function setMask(_x:Number,_y:Number,_w:Number, _h:Number):void
		{
			sp_con_mask.x = _x;
			sp_con_mask.y = _y;
			sp_con_mask.width = _w;
			sp_con_mask.height = _h;				
		}
		
		/**
		 * 设置内容背景
		 * @param	_x 背景的横坐标
		 * @param	_y 背景的纵坐标
		 * @param	_isSetWH 是否设置自定义宽度高度
		 * @param	_w 背景的宽度
		 * @param	_h 背景的高度
		 * @param	_color 背景的颜色值
		 * @param	_alpha 背景的透明度
		 */
		public function setBG(_x:Number=0,_y:Number=0,_isSetWH:Boolean=false,_w:Number=0,_h:Number=0,_color:uint=0x000000,_alpha:Number=0):void
		{
			isMoveEnd = true;
			if (!_isSetWH) {
				_w = sp_con.width;
				_h = sp_con.height;				
				//trace(_h);
			}
			
			if (sp_con_bg == null) {
				sp_con_bg = new Sprite();
				var shap:Shape = new Shape();
				shap.graphics.beginFill(_color,_alpha);
				shap.graphics.drawRect(0, 0, _w, _h);				
				shap.graphics.endFill();
				sp_con_bg.addChild(shap);
				sp_con_bg.x = _x;
				sp_con_bg.y = _y;
				sp_con_bg.name = "con_bg";
				sp_con.addChildAt(sp_con_bg,0);
			}else {				
				while (sp_con_bg.numChildren > 0) {
					sp_con_bg.removeChildAt(0);
				}				
				var shap1:Shape = new Shape();
				shap1.graphics.beginFill(_color, _alpha);				
				shap1.graphics.drawRect(0, 0, _w, _h);
				shap1.graphics.endFill();		
				sp_con_bg.addChild(shap1);
				//trace("meibioan",_h);
				sp_con_bg.x = _x;
				sp_con_bg.y = _y;
			}
			if (isHeng) {
				
				_pageNum = Math.ceil(sp_con.width / moveDis);
			}else {	
				
				_pageNum = Math.ceil(sp_con.height / moveDis);
			}
		}
		
		/**
		 * 将内容移至尾处
		 */
		public function gotoTail():void
		{
			if (isHeng) {	
				sp_con.x = -sp_con.width + sp_con_mask.width;
			}else {
				sp_con.y = -sp_con.height + sp_con_mask.height;				
			}
		}
		
		/**
		 * 显示该容器未显示完的对象
		 */
		public function showMore():void
		{
			isMoveEnd = false;
			if (isHeng) {	
				//sp_con.x = -sp_con.width + sp_con_mask.width;
				Tweener.addTween(sp_con, { x:0, time:Math.abs(sp_con.width - sp_con_mask.width + 300) / 600 , onComplete:showMoreEnd } );			
			}else {
				//sp_con.y = -sp_con.height + sp_con_mask.height;
				Tweener.addTween(sp_con, { y:0, time:Math.abs(sp_con.height - sp_con_mask.height+300)/600 ,onComplete:showMoreEnd } );
			}
			
			
			//if (isHeng) {					
				//Tweener.addTween(sp_con, { x: -sp_con.width + sp_con_mask.width, time:Math.abs(sp_con.width - sp_con_mask.width + 300) / 600, onComplete:function() { 
																																											//Tweener.addTween(sp_con, { x:0, time:Math.abs(sp_con.width - sp_con_mask.width + 300) / 600 , onComplete:showMoreEnd } ); }} )
			//}else {
				//Tweener.addTween(sp_con, { y: -sp_con.height + sp_con_mask.height, time:Math.abs(sp_con.height - sp_con_mask.height + 300) / 600, onComplete:function() { 
																																												//Tweener.addTween(sp_con, { y:0, time:Math.abs(sp_con.height - sp_con_mask.height+300)/600 ,onComplete:showMoreEnd } ); }} );
			//}
		}
		
		/**
		 * 显示完更多内容后
		 */
		private function showMoreEnd():void
		{
			isMoveEnd = true;
			_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_MORE_MOVE_END);
			this.dispatchEvent(_event);
		}
		
		/**
		 * 恢复到初始位置
		 */
		public function huiFu():void
		{
			if (isHeng) {
				sp_con.x = startX;
			}else {
				sp_con.y = startY;
			}
			_pageID = 0;
		}
		
		/**
		 * 清空内容
		 */
		public function clearAll():void
		{
			while (sp_con.numChildren > 0) {
				sp_con.removeChildAt(0);
			}
		}
		
		/**
		 * 清除一部分内容
		 * @param	num 还需要剩余几层
		 */
		public function clear(num:int):void
		{
			while (sp_con.numChildren > num) {
				sp_con.removeChildAt(0);
			}
		}
		
		/**
		 * 清除容器内的指定层
		 * @param	index
		 */
		public function RemoveChildAt(index:int):void
		{
			sp_con.removeChildAt(index);
		}
		
		/**
		 * 鼠标按下记录坐标
		 */
		private function onSpCon_Down(e:MouseEvent):void 
		{				
			//if (isMoveEnd&&isMove) {
			if (isMoveEnd) {		
				_isDown = true;		
				_downX = this.mouseX;
				_moveX = this.mouseX;
				_downY = this.mouseY;
				_moveY = this.mouseY;
				_tempX = sp_con.x;
				_tempY = sp_con.y;
				if (isMove) {
					stage.addEventListener(MouseEvent.MOUSE_MOVE, onSpCon_Move);	
					stage.addEventListener(MouseEvent.MOUSE_UP, onSpCon_Up);		
				}							
			}
			
			
		}
		
		private function onSpCon_Move(e:MouseEvent):void 
		{
			if (isHeng) {			
				if (isMove) {
					sp_con.x += this.mouseX - _moveX;
					_moveX = this.mouseX;
				}								
			}else {
				if (isMove) {					
					sp_con.y += this.mouseY - _moveY;
					_moveY = this.mouseY;
				}					
			}
		}
		
		/**
		 * 鼠标弹起移动容器
		 */
		private function onSpCon_Up(e:MouseEvent):void 
		{			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSpCon_Move);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSpCon_Up);				
			_upX = this.mouseX;
			_upY = this.mouseY;
			_isDown = false;
			if (Math.abs(_upX - _downX) >= dis || Math.abs(_upY - _downY) >= dis) {				
				//左右判断					
				if (_downX - _upX >= dis) {
					//trace("向左移动");											
					if (isHeng && isMove&&isMoveEnd) {										
						_pageID = Math.ceil((startX-sp_con.x) / moveDis);						
					}
					_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_LEFT_MOVE);
					this.dispatchEvent(_event);					
				}else if(_downX - _upX <= -dis){
					//trace("向右移动");					
					if (isHeng && isMove && isMoveEnd) {	
						_pageID = Math.floor((startX - sp_con.x) / moveDis);						
					}
					_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_RIGHT_MOVE);
					this.dispatchEvent(_event);
					
				}
				
				//上下移动
				if (_downY - _upY >= dis) {
					//trace("向上移动");					
					if (!isHeng && isMove&&isMoveEnd) {
						_pageID = Math.ceil((startY - sp_con.y) / moveDis);					
					}
					
					_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_TOP_MOVE);
					this.dispatchEvent(_event);
					
				}else if(_downY - _upY <= -dis){
					//trace("向下移动");							
					if (!isHeng && isMove && isMoveEnd) {						
						_pageID = Math.floor((startY-sp_con.y) / moveDis);						
					}	
					_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_BOTTOM_MOVE);
					this.dispatchEvent(_event);
					
				}	
				
				if (_pageID < 0) {
					_pageID = 0;
				}
				if (_pageID >= _pageNum) {
					_pageID = _pageNum - 1;
				}
				gotoAndStop(_pageID);
				
			}
			//else {					
				//点击事件
				//trace(e.target.name);
				//if (e.target.name != "con_bg") {
					//恢复位置
					//huiFuSeat();
					//_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_CLICK);
					//_event.obj = e.target as DisplayObject;
					//_event.currentTargetName = e.currentTarget.name;
					//_event.targetName = e.target.name;
					//dispatchEvent(_event);
					//isMoveEnd = true;					
				//}else {
					//huiFuSeat();
				//}
				//
			//}
			
			//如果点击事件只满足一个方向，则不能成为点击但要执行恢复原位
			if (Math.abs(_upX - _downX) < dis && Math.abs(_upY - _downY) < dis) {
				//点击事件				
				if (e.target.name != "con_bg") {
					//恢复位置					
					_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_CLICK);
					_event.obj = e.target as DisplayObject;
					_event.currentTargetName = e.currentTarget.name;
					_event.targetName = e.target.name;
					dispatchEvent(_event);
					isMoveEnd = true;					
				}else {
					
				}
				huiFuSeat();
			}			
		}
		
		private function moveEnd():void
		{
			isMoveEnd = true;
			_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_MOVE_END);				
			dispatchEvent(_event);
		}
		
		/**
		 * 双击事件
		 */
		private function onSpCon_DoubleClick(e:MouseEvent):void 
		{
			//trace("afdsfdfdsfsd", e.target.name);
			if (e.target.name != "con_bg") {
				_event = new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_DOUBLE_CLICK);
				_event.currentTargetName = e.currentTarget.name;
				_event.targetName = e.target.name;
				dispatchEvent(_event);
			}
		}
		
		/**
		 * 鼠标离开后恢复原来位置
		 */
		private function onSpCon_Out(e:MouseEvent):void 
		{
			if (_isDown) {				
				//if (this.mouseX < sp_con_mask.x || this.mouseX > sp_con_mask.x + sp_con_mask.width || this.mouseY < sp_con_mask.y || this.mouseY > sp_con_mask.y + sp_con_mask.height) {
					_isDown = false;
					sp_con.removeEventListener(MouseEvent.MOUSE_MOVE, onSpCon_Move);						
					huiFuSeat();						
			  //}
				
			}
		}
		
		/**
		 * 恢复移动之前的位置
		 */
		private function huiFuSeat():void {
			//trace("恢复到拖动前的位置");
			if (_pageID >= _pageNum - 1 && isMove && isMoveEnd) {
				isMoveEnd = false;	
				_pageID = _pageNum - 1;
				Tweener.removeTweens(sp_con);
				if (isHeng) {					
					if (sp_con.width < sp_con_mask.width) {
						Tweener.addTween(sp_con, { x:startX, time:0.5,onComplete:moveEnd } );
					}else {
						Tweener.addTween(sp_con, { x:startX-sp_con.width+sp_con_mask.width, time:0.5,onComplete:moveEnd } );
					}
					
				}else {
					if (sp_con.height < sp_con_mask.height) {
						Tweener.addTween(sp_con, { y:startY, time:0.5,onComplete:moveEnd } );
					}else {
						Tweener.addTween(sp_con, { y:startY-sp_con.height+sp_con_mask.height, time:0.5,onComplete:moveEnd } );
					}
					
				}
			}else if (isMove && isMoveEnd) {		
				isMoveEnd = false;	
				Tweener.removeTweens(sp_con);
				if (isHeng) {
					Tweener.addTween(sp_con, { x:startX-_pageID*_moveDis, time:0.5,onComplete:moveEnd } );
				}else {
					Tweener.addTween(sp_con, { y:startY-_pageID*_moveDis, time:0.5,onComplete:moveEnd } );
				}						
			}		
		}
		
		/**
		 * 移动到指定位置
		 * @param	id 移动到的索引位置
		 * @param	isTweener
		 */
		public function gotoAndStop(id:int,isTweener:Boolean=true):void
		{
			//trace("hahahah");
			_pageID = id;
			if (isHeng) {
				_endX = startX - _pageID * _moveDis;
				if (_endX <= startX - sp_con.width + sp_con_mask.width && isMove && isMoveEnd) {
					_pageID = _pageNum - 1;
					isMoveEnd = false;						
					Tweener.removeTweens(sp_con);
					if (sp_con.width < sp_con_mask.width) {
						_endX = startX;
					}else {
						_endX = startX-sp_con.width+sp_con_mask.width;
					}
					if (isTweener) {
						Tweener.addTween(sp_con, { x:_endX, time:0.5,onComplete:moveEnd } );
					}else {
						sp_con.x = _endX;
						moveEnd();
					}				
					
				}else if (isMove&&isMoveEnd) {				
					isMoveEnd = false;	
					Tweener.removeTweens(sp_con);				
					if (isTweener) {
						Tweener.addTween(sp_con, { x:_endX, time:0.5,onComplete:moveEnd } );
					}else {
						sp_con.x = _endX;
						moveEnd();
					}
				}
			}else {
				_endY = startY - _pageID * _moveDis;
				if (_endY <= startY - sp_con.height + sp_con_mask.height && isMove && isMoveEnd) {
					_pageID = _pageNum - 1;
					isMoveEnd = false;	
					Tweener.removeTweens(sp_con);	
					if (sp_con.height < sp_con_mask.height) {
						_endY = startY;
					}else {
						_endY = startY-sp_con.height+sp_con_mask.height;
					}
					if (isTweener) {
						Tweener.addTween(sp_con, { y:_endY, time:0.5,onComplete:moveEnd } );
					}else {
						sp_con.y = _endY;
						moveEnd();
					}				
					
				}else if (isMove&&isMoveEnd) {				
					isMoveEnd = false;	
					Tweener.removeTweens(sp_con);				
					if (isTweener) {
						Tweener.addTween(sp_con, { y:_endY, time:0.5,onComplete:moveEnd } );
					}else {
						sp_con.y = _endY;
						moveEnd();
					}
				}
			}		
			
		}
		
		/**
		 * 移动完成后
		 */
		private function onMoveEnd(e:Event):void 
		{
			isMoveEnd = true;
			this.dispatchEvent(new MyMoveSpriteEvent(MyMoveSpriteEvent.CON_MOVE_END));
		}		
		
		/**
		 * 设置移动距离
		 */
		public function get moveDis():Number { return _moveDis; }
		
		public function set moveDis(value:Number):void 
		{
			_moveDis = value;
			if (isHeng) {
				_pageNum = Math.ceil(sp_con.width / moveDis);
			}else {				
				_pageNum = Math.ceil(sp_con.height / moveDis);
			}
		}
		/**
		 * 当前画面所在页数
		 */
		public function get pageID():int { return _pageID; }
		/**
		 * 容器根据移动距离划分了多少页
		 */
		public function get pageNum():int { return _pageNum; }
		
	}

}