package  com.wyzlib.containers
{
	import com.models.ApplicationData;
	import com.tweener.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	/**
	 * 半圆旋转展示组件   需要传入一个显示列表数组
	 * 
	 * version 0.1 2013/3/30
	 * @author huanshi
	 */
	public class SemicircleRotationComponent extends Sprite
	{
		private var _conSP:Sprite;
		private var _objArr:Array=[];
		private var _showNum:int=5;		
		/**
		 * 每一个分配的度数
		 */
		private var _itemDu:Number=180/_showNum;
		/**
		 * 记录点下时的rotation
		 */
		private var _downRotation:Number;
		private var _moveRotation:Number;
		private var _maxRotation:Number;
		private var _minRotation:Number;
		private var _nowRotation:Number;
		private var _downX:Number;
		private var _downY:Number;
		private var _moveX:Number;
		private var _moveY:Number;
		private var _isClick:Boolean=true;
		
		private var _twStartRotation:Number;
		private var _currentFrame:int=0;
		private var _twRotationS:Number;//移动的总角度值
		private var _twRotationV:Number;//移动的初始角度速度
		private var _twRotationT:Number;//移动的时间    以帧计算
		private var _twRotationA:Number;//移动的角度加速度
		private var _twRotationEnd:Number;//移动的最终角度
		private var _isLeft:Boolean;
		private var _directionArr:Array=[];
		private var _index:int=0;
		private var _minArr:Array=[0,-36,-36,-72];
		private var _maxArr:Array=[0,0,36,36];
		private var _isSelect:Boolean;
		public var isKongZhi:Boolean=true;//是否接受控制。
		/**
		 * 开始的动画，true为向右  false为向左
		 */
		public var isStartFangXiang:Boolean=true;
		//private var _time:Timer=new Timer(5*1000,0);
		private var _radius:Number=20;
		private var _bg:Shape;


		public function SemicircleRotationComponent()
		{
			super();
			initContent();
			initListener();
			
		}
		
		private function initContent():void
		{
			_bg=new Shape();
			_bg.graphics.beginFill(0,0);
			_bg.graphics.drawCircle(0,0,_radius);
			_bg.x=0;
			_bg.y=0;
			this.addChild(_bg);
			_conSP=new Sprite();
			this.addChild(_conSP);
		}
		
		private function initListener():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onADDED_TO_STAGE);
			//_time.addEventListener(TimerEvent.TIMER,onTIMER);
		}
		
		private function onADDED_TO_STAGE(event:Event):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,onMOUSE_DOWN);
		}
		
		/**
		 * 设置显示的内容
		 * @param	arr  显示对象数组
		 */
		public function setArr(arr:Array):void
		{
			if(arr.length<=0){
				return;
			}
			//trace(arr.length);
			clearAll();
			_objArr=arr;
			//trace(_objArr.length);
			if(_objArr.length<_showNum){
				_minRotation=_minArr[_objArr.length-1];
				_maxRotation=_maxArr[_objArr.length-1];
				//trace("<<<<<",_minRotation,_maxRotation);
			}else{
				//trace(_itemDu*(arr.length-5));
				_minRotation=-72-_itemDu*(arr.length-5);
				_maxRotation=72;
				//trace(">>>>",_minRotation,_maxRotation);
			}
			//trace("aaaa",_minRotation,_maxRotation);
			showObj();
			if(_objArr.length<5){
				//trace(_objArr.length,int((_objArr.length-1)/2),_objArr[int((_objArr.length-1)/2)]);
				var tempRo:Number=_objArr[int((_objArr.length-1)/2)].recordRotation;
				//trace("tempRo",tempRo);
				for (var j:int = 0; j < _objArr.length; j++) 
				{
					_objArr[j].rotation-=tempRo;
					_objArr[j].recordRotation-=tempRo;
				}				
				_index=int((_objArr.length-1)/2);
				
			}else{
				_index=int(_showNum/2);
			}
			
		}
		/**
		 * 开始动画
		 */
		public function startTW(id:int=0):void
		{
			if(isStartFangXiang){
				_nowRotation=_minRotation-72;
				_conSP.rotation=_minRotation-72;
			}else{
				_nowRotation=_maxRotation+72;
				_conSP.rotation=_maxRotation+72;
			}
			
			upDateShow();
			if(_objArr.length<5){
				showItem(id,0.5*Math.ceil(_objArr.length/4));
			}else{
				showItem(id,0.5*Math.ceil(_objArr.length/4));
			}
			
		}
		
		/**
		 * 布局显示对象
		 */
		private function showObj():void
		{
			for (var i:int = 0; i < _objArr.length; i++) 
			{
				_conSP.addChild(_objArr[i]);
				(_objArr[i] as DisplayObject).rotation=-int(_showNum/2)*_itemDu+i*_itemDu;
				_objArr[i].recordRotation=-int(_showNum/2)*_itemDu+i*_itemDu;
				(_objArr[i] as Sprite).mouseChildren=false;
				_objArr[i].name="obj_"+i;
			}
			
			_conSP.rotation=0;
			_nowRotation=0;
			upDateShow();
		}		
		
		private function onMOUSE_DOWN(event:MouseEvent):void
		{
			//_time.reset();
			//if(!isKongZhi){
//			if(!ApplicationData.getInstance().isKongXian){
//				return;
//			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
			stage.addEventListener(MouseEvent.MOUSE_UP,onMOUSE_UP);			
			this.removeEventListener(Event.ENTER_FRAME,onTWUpdate);
			_isClick=true;
			_isSelect=false;
			_downRotation=_nowRotation;
			_downX= mouseX;
			_downY = mouseY;
			
			_moveX = mouseX;
			_moveY = mouseY;
			_directionArr.length=0;
		}
		
		private function onMOUSE_MOVE(event:MouseEvent):void
		{
			//_conSP.rotation=Math.atan2(mouseY - _conSP.y, mouseX - _conSP.x)/ Math.PI * 180-_downRotation;
			var a:Number=Point.distance(new Point(mouseX,mouseY),new Point(_moveX,_moveY));
			var b:Number=Point.distance(new Point(_conSP.x,_conSP.y),new Point(_moveX,_moveY));
			var c:Number=Point.distance(new Point(mouseX,mouseY),new Point(_conSP.x,_conSP.y));
			//trace(a,b,c,(b*b+c*c-a*a)/(2*b*c));
			var tempRotaion:Number=Math.acos((b*b+c*c-a*a)/(2*b*c))/ Math.PI * 180;
			
			var moveT:Number=(_moveX-_conSP.x)/b;
			var nowT:Number=(mouseX-_conSP.x)/c;
			if(_moveY>0){
				if(nowT>moveT){
					tempRotaion=-tempRotaion;
				}
			}else{
				if(nowT<moveT){
					tempRotaion=-tempRotaion;
				}
			}
			if(tempRotaion>0){
				//trace("right");
				_directionArr.push("right");
			}
			if(tempRotaion<0){
				//trace("left");
				_directionArr.push("left");
			}
			if(_directionArr.length>3){
				_directionArr.shift();
			}
			//var tempRotaion:Number=Math.atan2(mouseY - _conSP.y, mouseX - _conSP.x);
			//_moveRotation=(tempRotaion>0?tempRotaion:360+tempRotaion)-_moveRotation;
			_conSP.rotation+=tempRotaion;
			_nowRotation+=tempRotaion;
			if(Math.abs(_nowRotation-_downRotation)>1){
				_isClick=false;
			}
			//trace(_nowRotation);
			//_moveRotation=tempRotaion;
			_moveX = mouseX;
			_moveY = mouseY;			
			upDateShow();
		}
		
		private function onMOUSE_UP(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMOUSE_MOVE);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onMOUSE_UP);
			//_time.reset();
			//_time.start();
			//_conSP.rotation=_downRotation+Math.atan2(mouseY - _conSP.y, mouseX - _conSP.x)/ Math.PI * 180;
			//trace(_nowRotation,_minRotation,_maxRotation);
			//trace("onMOUSE_UP",event.target.name,_isClick,_maxRotation,_minRotation);
			if(_nowRotation>_maxRotation){
				//trace("_maxRotation",_maxRotation);
				_twStartRotation=_nowRotation;
				_twRotationS=_maxRotation-_nowRotation;
				_twRotationT=int(0.5*stage.frameRate);
				_twRotationEnd=_maxRotation;
				tweenerConRotation();
				_isClick=false;
				return;
			}
			if(_nowRotation<_minRotation){
				//trace("_minRotation",_minRotation);
				_twStartRotation=_nowRotation;
				_twRotationS=_minRotation-_nowRotation;
				_twRotationT=int(0.5*stage.frameRate);
				_twRotationEnd=_minRotation;
				tweenerConRotation();
				_isClick=false;
				return;
			}
			
			if(_isClick){
				if(event.target.name.split("_")[0]=="obj"){
					trace(event.target.name.split("_")[1]);
					showItem(int(event.target.name.split("_")[1]))
					return;
				}
			}
			//trace(String(_directionArr).split("left").length,String(_directionArr).split("right").length);
			var id:int=0;
			if(String(_directionArr).split("left").length>String(_directionArr).split("right").length){
				id=Math.ceil(Math.abs(_nowRotation-72)/36);
			}else{
				id=int(Math.abs(_nowRotation-72)/36);
			}
			if(id>=_objArr.length){
				id=_objArr.length-1;
			}
			if(id<0){
				id=0;
			}
			_twStartRotation=_nowRotation;
			_twRotationS=-_objArr[id].recordRotation-_nowRotation;
			//trace(_twRotationS,_nowRotation);
			_twRotationT=int(0.5*stage.frameRate);
			_twRotationEnd=-_objArr[id].recordRotation;
			tweenerConRotation();
			
		}
		
		private function onTIMER(event:TimerEvent):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
			//_time.reset();
		}
		
		/**
		 * 显示第几个
		 */
		public function showItem(id:int,time:Number=0.5):void
		{
			if(id>=_objArr.length){
				id=_objArr.length-1;
			}
			if(id<0){
				id=0;
			}
			if(_objArr.length<=0){
				return;
			}
			_twStartRotation=_nowRotation;
			_twRotationS=-_objArr[id].recordRotation-_nowRotation;
			//trace("_isClick");
			_isSelect=true;
			//trace("stage",stage);
			_twRotationT=int(0.5*stage.frameRate);
			_twRotationEnd=-_objArr[id].recordRotation;
			tweenerConRotation();
		}
		
		private function tweenerConRotation():void
		{
			//trace("tweenerConRotation",_twRotationEnd);
			_currentFrame=0;
			_twRotationV=2*_twRotationS/_twRotationT;
			_twRotationA=-_twRotationV/_twRotationT;
			this.removeEventListener(Event.ENTER_FRAME,onTWUpdate);
			this.addEventListener(Event.ENTER_FRAME,onTWUpdate);
		}
		
		private function onTWUpdate(e:Event):void
		{
			
			var spee:Number=_twRotationV+_twRotationA*_currentFrame;
			_conSP.rotation+=spee;
			_nowRotation+=spee;
			//trace(spee);
			
			upDateShow();
			if(_currentFrame>=_twRotationT-3){
				_conSP.rotation=_twRotationEnd;
				_nowRotation=_twRotationEnd;
				_index=Math.round(Math.abs(_nowRotation-_maxRotation)/36);
				this.removeEventListener(Event.ENTER_FRAME,onTWUpdate);
				this.dispatchEvent(new Event(Event.SELECT));
				//trace(_index);
			}
			/*if(spee<0&&_twRotationA<0){
				//trace("aaaaaa");
				_conSP.rotation=_twRotationEnd;
				_nowRotation=_twRotationEnd;
				this.removeEventListener(Event.ENTER_FRAME,onTWUpdate);
			}
			if(spee>0&&_twRotationA>0){
				//trace("bbbbb");
				_conSP.rotation=_twRotationEnd;
				_nowRotation=_twRotationEnd;
				this.removeEventListener(Event.ENTER_FRAME,onTWUpdate);
			}*/
			_currentFrame++;
		}
		
		/**
		 * 更新显示
		 */
		private function upDateShow():void
		{
			for (var i:int = 0; i < _objArr.length; i++) 
			{
				if(Math.abs(_objArr[i].recordRotation+_nowRotation)>144){
					(_objArr[i] as DisplayObject).visible=false;
				}else{
					(_objArr[i] as DisplayObject).visible=true;
				}
			}
		}
		
		
		/**
		 * 清除显示对象和数组
		 */
		public function clearAll():void
		{
			while(_conSP.numChildren>0){
				_conSP.removeChildAt(0);
			}
			for (var i:int = 0; i < _objArr.length; i++) 
			{
				_objArr[i]=null;
			}
			
			_objArr.length=0;
			
		}

		/**
		 * 显示的个数，默认为5个
		 */
		public function get showNum():int
		{
			return _showNum;
		}

		/**
		 * @private
		 */
		public function set showNum(value:int):void
		{
			_showNum = value;
			_itemDu=180/_showNum;
		}

		/**
		 * 当先显示的第几个
		 */
		public function get index():int
		{
			return _index;
		}

		/**
		 * 是否是选择查看的
		 */
		public function get isSelect():Boolean
		{
			return _isSelect;
		}

		/**
		 * 背景半径默认20
		 */
		public function get radius():Number
		{
			return _radius;
		}

		/**
		 * @private
		 */
		public function set radius(value:Number):void
		{
			_radius = value;
			_bg.width=_radius*2;
			_bg.height=_radius*2;
		}


	}
}