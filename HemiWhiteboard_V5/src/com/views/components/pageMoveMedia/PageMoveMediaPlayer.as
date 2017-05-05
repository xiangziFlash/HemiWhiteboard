package com.views.components.pageMoveMedia 
{
	import com.events.TuYaEvent;
	import com.models.vo.MediaVO;
	import com.tweener.transitions.Tweener;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author wang
	 */
	public class PageMoveMediaPlayer extends Sprite 
	{
		private var _voArr:Array = [];
		private var _vo:MediaVO;
		private var _pageID:int;
		private var _pageNum:int;
		
		private var _sp_con:Sprite;
		private var _sp_con_mask:Sprite;
		private var _mediaPlayerArr:Array = [];
		
		private var _mediaPlayer0:PageMoveMediaSP;
		private var _mediaPlayer1:PageMoveMediaSP;
		private var _mediaPlayer2:PageMoveMediaSP;
		private var _tempMediaPlayer0:PageMoveMediaSP;
		private var _tempMediaPlayer1:PageMoveMediaSP;
		private var _tempMediaPlayer2:PageMoveMediaSP;
		private var _tempMediaPlayer:PageMoveMediaSP;
		private var _oldMediaPlayer:PageMoveMediaSP;
		
		private var _stageW:Number=0;
		private var _stageH:Number=0;
		private var _mediaPlayerID:int;//文章在数组中的索引
		private var _mediaPlayerObjID:int;//当前文章对象在3个中的索引
		
		private var _isIF:Boolean=true;//是否判断
		private var _isHuaMove:Boolean = false;//是否还要启动移动
		
		private var _moveX:Number;
		private var _downX:Number;		
		private var _upX:Number;
		private var _downY:Number;
		private var _isAnimation:Boolean = true;
		private var _isPaiFa:Boolean;
		private var _bottomBarH:Number = 0;
		private var _isShow:Boolean;
		
		private var _bg:Shape;
		private var _color:uint = 0xD9D9D9;
		private var _gripSp:Sprite;
		public function PageMoveMediaPlayer() 
		{
			initContent();
			initListener();
		}
		/**
		 * 构造显示列表
		 */
		private function initContent():void 
		{
			_bg = new Shape();
			this.addChild(_bg);
			_sp_con = new Sprite();
			_sp_con_mask = new Sprite();
			this.addChild(_sp_con);
			this.addChild(_sp_con_mask);
			_sp_con.mask = _sp_con_mask;
			
			_mediaPlayer0 = new PageMoveMediaSP();
			_mediaPlayer1 = new PageMoveMediaSP();
			_mediaPlayer2 = new PageMoveMediaSP();
			_mediaPlayer0.name = "ar_0";
			_mediaPlayer1.name = "ar_1";
			_mediaPlayer2.name = "ar_2";
			//_sp_con.addChild(_mediaPlayer0);
			_sp_con.addChild(_mediaPlayer1);
			//_sp_con.addChild(_mediaPlayer2);
			
			_tempMediaPlayer0 = _mediaPlayer0;
			_tempMediaPlayer1 = _mediaPlayer1;
			_tempMediaPlayer2 = _mediaPlayer2;
		}
		/**
		 * 添加事件
		 */
		private function initListener():void 
		{
			
		}
		
		
		public function addGripSp(sp:Sprite):void
		{
			_gripSp = sp as Sprite;//trace(_gripSp);
		}
		public function addStageDown():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onConDown);
		}
		public function removeStageDown():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onConDown);
		}
		
		/**
		 * 设置当前的文章组件
		 * @param	article
		 */
		private function setListener(article:PageMoveMediaSP):void
		{
			//if (_tempMediaPlayer == article) {
				//return;
			//}
			if (_oldMediaPlayer != null&&_oldMediaPlayer!=_tempMediaPlayer) {
				_oldMediaPlayer.reset();
				_oldMediaPlayer.stop();
				_oldMediaPlayer.removeEventListener(Event.COMPLETE, onMedia_COMPLETE);
				
			}
			_tempMediaPlayer = article;			
			_tempMediaPlayer.play();
			_tempMediaPlayer.addEventListener(Event.COMPLETE, onMedia_COMPLETE);
			
			
			_vo = _tempMediaPlayer.vo;
			//trace(_vo.title);
			_oldMediaPlayer = _tempMediaPlayer;
		}
		
		private function onMedia_COMPLETE(e:Event):void 
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 设置文章组件的舞台宽度高度
		 * @param	w
		 * @param	h
		 */
		public function setSatgeWH(w:Number, h:Number):void
		{
			_stageW = w;
			_stageH = h;
			_bg.graphics.clear();
			_bg.graphics.beginFill(_color);
			_bg.graphics.drawRect(0, 0, w, h);
			_bg.graphics.endFill();
			
			
			_mediaPlayer0.setSatgeWH(w, h);
			_mediaPlayer1.setSatgeWH(w, h);
			_mediaPlayer2.setSatgeWH(w, h);
			_sp_con_mask.graphics.clear();
			_sp_con_mask.graphics.beginFill(0x000000);
			_sp_con_mask.graphics.drawRect(0, 0, w, h);
			_sp_con_mask.graphics.endFill();
			
			_tempMediaPlayer0.x = 0;
			_tempMediaPlayer1.x = _stageW;
			_tempMediaPlayer2.x = 2*_stageW;
		}
		/**
		 * 设置文章列表的内容
		 * @param	arr  	MediaPlayerVO的数组
		 * @param	showID  要显示的文章ID
		 */
		public function setContent(arr:Array,showID:int=0):void
		{
			_mediaPlayerID = showID;
			//if (_mediaPlayerArr === arr) {
				//trace("数组相同，执行跳转");
				//gotoPage(_mediaPlayerID, true);
				//return;
			//}
			_mediaPlayerArr = [];
			_mediaPlayerArr = arr;
			while (_sp_con.numChildren > 0) {
				if (_sp_con.getChildAt(0) is PageMoveMediaSP) {
					(_sp_con.getChildAt(0) as PageMoveMediaSP).isShow = false;
				}
				_sp_con.removeChildAt(0);				
			}
			resetMediaPlayerObj();
			if (_mediaPlayerID > 0) {
				if (_mediaPlayerArr.length > 2) {
					if (_mediaPlayerID == _mediaPlayerArr.length - 1) {
						_mediaPlayerObjID = 2;
					}else {
						_mediaPlayerObjID = 1;
					}
				}else {
					_mediaPlayerObjID = 1;
				}
			}else {
				_mediaPlayerObjID = 0;
			}
			
			_tempMediaPlayer = this["_tempMediaPlayer" + _mediaPlayerObjID] as PageMoveMediaSP;
			_sp_con.x = -_mediaPlayerObjID * _stageW;
			
			for (var i:int = 0; i < _mediaPlayerArr.length&&i<3; i++) 
			{
				var id:int = _mediaPlayerID - (_mediaPlayerObjID - i);
				//trace(id, _mediaPlayerID);
				//trace(this["_tempMediaPlayer" + id]);
				//trace(_mediaPlayerArr[id])
				this["_tempMediaPlayer" + i].setContent(_mediaPlayerArr[id]);
				_sp_con.addChild(this["_tempMediaPlayer" + i]);
				this["_tempMediaPlayer" + i].isShow = true;
				this["_tempMediaPlayer" + i].stop();
				//trace("文章外部",arr[id].propertyVO.xmlItemID, arr[id].propertyVO.xmlListID);
			}
			setListener(_tempMediaPlayer);		
			
		}
		
		/**
		 * 跳转到指定页
		 * @param id 文章索引
		 * @param isAnimation 是否执行动画
		 */
		public function gotoPage(id:int,isAnimation:Boolean=true):void
		{
			if (_tempMediaPlayer.vo.mediaID == id) {
				return;
			}
			_mediaPlayerID = id;
			if (_tempMediaPlayer.vo.mediaID > id) {
				if (_mediaPlayerObjID == 0) {
					_mediaPlayerObjID++;
				}
				this["_tempMediaPlayer" + (_mediaPlayerObjID - 1)].setContent(_mediaPlayerArr[id]);
				moveCon(_mediaPlayerObjID-1, isAnimation);
			}
			
			if (_tempMediaPlayer.vo.mediaID < id) {
				if (_mediaPlayerObjID == _mediaPlayerArr.length-1||_mediaPlayerObjID==2) {
					_mediaPlayerObjID--;
				}
				this["_tempMediaPlayer" + (_mediaPlayerObjID + 1)].setContent(_mediaPlayerArr[id]);
				moveCon(_mediaPlayerObjID+1, isAnimation);
			}
			//moveCon(id, isAnimation);
			
		}

		/**
		 * 鼠标点下后
		 */
		private function onConDown(e:MouseEvent):void 
		{
			_downX = this.mouseX;
			_downY = this.mouseY;
			_moveX = this.mouseX;
			_isIF = true;
			_isHuaMove = false;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStage_Move);	
			stage.addEventListener(MouseEvent.MOUSE_UP, onStage_Up);
		}
		
		/**
		 * 跟随鼠标移动
		 */
		private function onStage_Move(e:MouseEvent):void 
		{
			//if (_isIF) {
				if (Math.abs(this.mouseX - _downX )> 20&&_isIF) {
					_isIF = false;
					_isHuaMove = true;
					//_tempMediaPlayer.isMove = false;
				}
				if (Math.abs(this.mouseY - _downY ) > 20&&_isIF) {
					_isIF = false;
					_isHuaMove = false;
				}
			//}
			if (_isHuaMove) {
				_sp_con.x += this.mouseX - _moveX;//trace(_gripSp.x,"++---");
				if(_gripSp){//trace(_gripSp.x);
					_gripSp.x+=this.mouseX-_moveX;
				}
				
				_moveX = this.mouseX;
			}
			
		}
		public function stageMove(sp:DisplayObjectContainer):void
		{
			sp.x+=this.mouseX - _moveX;
		}
		private function onStage_Up(e:MouseEvent):void 
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStage_Move);	
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStage_Up);
			//_tempMediaPlayer.isMove = true;
			if (Math.abs(_moveX - _downX) > 50) {
				_isPaiFa = true;
				if (_moveX > _downX) {
					_mediaPlayerID--;
					if (_mediaPlayerID < 0) {
						_mediaPlayerID = 0;
					}
					moveCon(_mediaPlayerObjID-1);
				}else {
					_mediaPlayerID++;
					if (_mediaPlayerID > _mediaPlayerArr.length-1) {
						_mediaPlayerID = _mediaPlayerArr.length - 1;
					}
					moveCon(_mediaPlayerObjID+1);
				}
			}else {
				_tempMediaPlayer.click();
				Tweener.addTween(_sp_con, { x: -_mediaPlayerObjID * _stageW, time:0.5 } );
				this.dispatchEvent(new Event(Event.SELECT));
			}
			
			
			
		}
		
		/**
		 * 移动内容
		 * @param	id
		 * @param isAnimation 是否执行动画 默认执行
		 */
		private function moveCon(id:int,isAnimation:Boolean=true):void 
		{
			
			//trace(id);
			if (id < 0) {
				id = 0;
			}
			if (_mediaPlayerArr.length > 3) {
				if (id > 2) {
					id = 2;
				}
			}else {
				if (id > _mediaPlayerArr.length - 1) {
					id = _mediaPlayerArr.length - 1;
				}
			}
			
			_mediaPlayerObjID = id;
			//trace(_mediaPlayerObjID, -_mediaPlayerObjID * _stageW);
			if (isAnimation) {				
				Tweener.addTween(_sp_con, {x:-_mediaPlayerObjID*_stageW,time:0.5,onComplete:onMoveEnd } );
			}else {
				onMoveEnd();
			}
			
		}
		
		private function onMoveEnd():void 
		{
			//trace("执行到那页",_mediaPlayerObjID);
			
			if (_mediaPlayerArr.length >= 3) {
				if (_mediaPlayerObjID == 0) {
					if (_mediaPlayerID > 0) {
						_tempMediaPlayer = _tempMediaPlayer0;
						_tempMediaPlayer0 = _tempMediaPlayer2;
						_tempMediaPlayer2 = _tempMediaPlayer1;
						_tempMediaPlayer1 = _tempMediaPlayer;										
						_mediaPlayerObjID = 1;
						
					}
				}else if (_mediaPlayerObjID == 1) {
					if (_mediaPlayerID == 0) {
						_tempMediaPlayer = _tempMediaPlayer0;
						_tempMediaPlayer0 = _tempMediaPlayer1;
						_tempMediaPlayer1 = _tempMediaPlayer2;
						_tempMediaPlayer2 = _tempMediaPlayer;
						_mediaPlayerObjID = 0;
					}else if (_mediaPlayerID == _mediaPlayerArr.length-1) {
						_tempMediaPlayer = _tempMediaPlayer2;
						_tempMediaPlayer2 = _tempMediaPlayer1;
						_tempMediaPlayer1 = _tempMediaPlayer0;
						_tempMediaPlayer0 = _tempMediaPlayer;	
						_mediaPlayerObjID = 2;
					}
					
				}else if (_mediaPlayerObjID == 2) {
					if (_mediaPlayerID < _mediaPlayerArr.length-1) {
						_tempMediaPlayer = _tempMediaPlayer1;
						_tempMediaPlayer1 = _tempMediaPlayer2;
						_tempMediaPlayer2 = _tempMediaPlayer0;
						_tempMediaPlayer0 = _tempMediaPlayer;						
						_mediaPlayerObjID = 1;
					}
				}
				//trace(_mediaPlayerObjID);
				_tempMediaPlayer0.x = 0;
				_tempMediaPlayer1.x = _stageW;
				_tempMediaPlayer2.x = 2 * _stageW;	
				_sp_con.x = -_mediaPlayerObjID * _stageW;
			}
			_tempMediaPlayer = this["_tempMediaPlayer" + _mediaPlayerObjID] as PageMoveMediaSP;
			//trace("是否派发", _isPaiFa);
			for (var i:int = 0; i < 3; i++) 
			{
				if (this["_tempMediaPlayer" + i].isShow) {
					var id:int = _tempMediaPlayer.vo.mediaID - (_mediaPlayerObjID - i);
					//trace(_tempMediaPlayer.vo.mediaID,(this["_tempMediaPlayer" + i] as PageMoveMediaSP).vo.mediaID, id);
					if ((this["_tempMediaPlayer" + i] as PageMoveMediaSP).vo.mediaID != id&&id>=0&&id< _mediaPlayerArr.length) {
						
						this["_tempMediaPlayer"+i].setContent(_mediaPlayerArr[id]);
					}
				}
				
				if (i != _mediaPlayerObjID) {
					this["_tempMediaPlayer" + i].reset();
				}
				//trace("是否派发", _isPaiFa,this["_tempMediaPlayer" + i]);
			}
			
			setListener(_tempMediaPlayer);
			
			_pageID = _mediaPlayerID;
			_pageNum = _mediaPlayerArr.length;
			if (_isPaiFa) {
				
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
			_isPaiFa = false;
		}
		
		private function resetMediaPlayerObj():void
		{
			_tempMediaPlayer0 = _mediaPlayer0;
			_tempMediaPlayer1 = _mediaPlayer1;
			_tempMediaPlayer2 = _mediaPlayer2;
			_tempMediaPlayer0.x = 0;
			_tempMediaPlayer1.x = _stageW;
			_tempMediaPlayer2.x = 2 * _stageW;	
			_sp_con.x = -_mediaPlayerObjID * _stageW;
			
		}
		
		public function get stageH():Number 
		{
			return _stageH;
		}
		
		public function get stageW():Number 
		{
			return _stageW;
		}
		
		public function get bottomBarH():Number 
		{
			return _bottomBarH;
		}
		
		public function set bottomBarH(value:Number):void 
		{
			_bottomBarH = value;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
		public function set color(value:uint):void 
		{
		    _color = value;
			_bg.graphics.clear();
			_bg.graphics.beginFill(_color,1);			
			_bg.graphics.drawRect(0, 0, _stageW, _stageH);
			_bg.graphics.endFill();
		}
		
		public function get pageID():int 
		{
			_pageID = _tempMediaPlayer.vo.mediaID;
			return _pageID;
		}
		
		public function get pageNum():int 
		{
			_pageNum=_mediaPlayerArr.length
			return _pageNum;
		}
	}

}