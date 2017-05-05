package com.views.components.yuLan
{
	import com.lylib.layout.LayoutManager;
	import com.models.vo.MediaVO;
	import com.tweener.transitions.Tweener;
	import com.views.components.Graffiti;
	import com.views.components.pageMoveMedia.PageMoveMediaSP;
	import com.views.containers.PenRes;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class MediaContainer extends Sprite
	{
		private var _mediaPageArr:Array=[];
		private var _drawPageArr:Array=[];
		private var _pageNum:int;
		private var _voArr:Array=[];
		private var _pageID:int;//当前需要显示对象的ID
		private var _prevID:int;//上一个显示对象的ID
		private var _mask:Shape;
		private var _initWidth:Number=1920*0.5;
		private var _initHeight:Number=1080*0.5;
		private var _mediaContainer:Sprite;
		private var _mediaSp:Sprite;
		private var _drawSp:Sprite;
		private var _downX:Number;
		private var _downConX:Number;
		private var _dis:Number=0;
		private var _isLock:Boolean;//是否锁定，锁定则不能拖动，只能涂鸦
		private var _isMoving:Boolean;//正在执行动画
		private var _isFullscrren:Boolean;
		private var _penRes:PenRes;
		private var _pointArr:Array = [new Point(),new Point()];
		private var _takePhotoSp:Sprite;
		private var _ldr:Loader = new Loader();
		private var _isFirstSave:Boolean;
		private var _count:int;
		private var _countArr:Array=[];
		private var _thumbnailContainer:ThumbnailContainer;
		public var isTweening:Boolean;
		public function MediaContainer()
		{
			initContent();
			initEventListener();
		}
		private function initContent():void
		{
			_penRes = new PenRes();
			_mediaContainer = new Sprite();
			this.graphics.beginFill(0x333333,1);
			this.graphics.drawRect(0,0,_initWidth,_initHeight);
			_mask = new Shape();
			_mask.graphics.beginFill(0,0.5);
			_mask.graphics.drawRect(0,0,_initWidth,_initHeight);
			_mask.graphics.endFill();
			
			_mediaContainer.mask = _mask;
			_thumbnailContainer = new ThumbnailContainer();
			//setPosition(_thumbnailContainer,_initWidth - 90,0 );
			//_mediaContainer.doubleClickEnabled = true;
			_mediaSp = new Sprite();
			_drawSp = new Sprite();
			
			
//			this.addChild(_penRes);
			this.addChild(_mediaContainer);
			this.addChild(_mask);
		//	this.addChild(_thumbnailContainer);//隐藏图标
		}
		private function initEventListener():void
		{
			_mediaContainer.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_thumbnailContainer.addEventListener(Event.SELECT,onThumbSelect);
		}
		private function onThumbSelect(e:Event):void
		{
			showSelectPage(_thumbnailContainer.thumbID);
		}
		private function onDown(e:MouseEvent):void
		{
//			trace(isTweening,"isTweening");
			if(isTweening) return;
			e.stopPropagation();
			_mediaContainer.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
			if(_isLock){
				_penRes.width = _penRes.height =  4;
				_penRes.x=mouseX;
				_penRes.y=mouseY;
				_pointArr[0].x=_penRes.x;
				_pointArr[0].y=_penRes.y;
				_pointArr[1].x=_penRes.x+_penRes.width;
				_pointArr[1].y=_penRes.y+_penRes.height;
			}else{
				_downX = mouseX;
				_downConX = _mediaContainer.mouseX;
			}
			
			
		}
		private function onMove(e:MouseEvent):void
		{
			if(_isLock){
				_drawPageArr[_pageID].graphics.beginFill(0xff0000);
				_penRes.x=mouseX;
				_penRes.y=mouseY;
				_drawPageArr[_pageID].graphics.moveTo(_penRes.x,_penRes.y);
				_drawPageArr[_pageID].graphics.lineTo(_penRes.x,_penRes.y);
				_drawPageArr[_pageID].graphics.lineTo(_penRes.x+_penRes.width,_penRes.y+_penRes.height);
				_drawPageArr[_pageID].graphics.lineTo(_pointArr[1].x,_pointArr[1].y);
				_drawPageArr[_pageID].graphics.lineTo(_pointArr[0].x,_pointArr[0].y);
				_drawPageArr[_pageID].graphics.endFill();
				_pointArr[0].x=_penRes.x;
				_pointArr[0].y=_penRes.y;
				_pointArr[1].x=_penRes.x+_penRes.width;
				_pointArr[1].y=_penRes.y+_penRes.height;
			}else{
				_mediaContainer.x = mouseX-_downConX;
				_downConX = _mediaContainer.mouseX;
			}
		}
		private function onUp(e:MouseEvent):void
		{
			_mediaContainer.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			
			if(_isLock){
				
			}else{
				if(_downX>mouseX+50){
					//向左拖
					showNext();
				}else if(_downX<mouseX-50){
					//向右拖
					showPrev();
				}else{
					//点击
					(_mediaPageArr[pageID] as PageMoveMediaSP).click();
					isTweening = false;
					Tweener.addTween(_mediaContainer,{x:-_initWidth*_pageID,time:0.2,transition:"easeOutCubic"});
				}
			}
		}
		public function showPrev():void
		{
			//if(isTweening) return;
			_prevID = _pageID;
			(_mediaPageArr[_pageID] as PageMoveMediaSP).stop();
			_pageID--;
			isTweening = true;
			if(_pageID<=0){
				_pageID = 0;
				moveEnd();
				Tweener.addTween(_mediaContainer,{x:-_initWidth*_pageID,time:0.8,transition:"easeOutCubic"});
			}else{
				rightMoveEnd();
				Tweener.addTween(_mediaContainer,{x:-_initWidth*_pageID,time:0.8,transition:"easeOutCubic"});
			}
			
		}
		
		public function showNext():void
		{
			//if(isTweening) return;
			_prevID = _pageID;
			(_mediaPageArr[_pageID] as PageMoveMediaSP).stop();
			_pageID++;
			isTweening = true;
			if(_pageID>=_pageNum-1){
				_pageID = _pageNum-1;
				moveEnd();
				Tweener.addTween(_mediaContainer,{x:-_initWidth*_pageID,time:0.8,transition:"easeOutCubic"});
			}else{
				leftMoveEnd();
				Tweener.addTween(_mediaContainer,{x:-_initWidth*_pageID,time:0.8,transition:"easeOutCubic",onUpdate:update});
			}
			
		}
		
		private function update():void
		{
			//trace("update");
		}
		private function moveEnd():void
		{
			isTweening = false;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		private function leftMoveEnd():void
		{
			
			if(_pageID-2>=0){
				isTweening = false;
				(_mediaPageArr[_pageID-2] as PageMoveMediaSP).unload();
			}
			if(_pageID+1<=_pageNum-1){
				(_mediaPageArr[_pageID+1] as PageMoveMediaSP).setContent(_voArr[pageID+1]);
			}else{
				isTweening = false;
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		private function rightMoveEnd():void
		{
			
			if(_pageID+2<=_pageNum-1){
				isTweening = false;
				(_mediaPageArr[_pageID+2] as PageMoveMediaSP).unload();
			}
			if(pageID-1>=0){
				(_mediaPageArr[_pageID-1] as PageMoveMediaSP).setContent(_voArr[pageID-1]);
			}else{
				isTweening = false;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		/**
		 * voArr 包含所有内容的数组
		 * pageID 要显示对象的ID
		 * 设置内容 
		 * */
		public function setContent(voArr:Array,pageID:int):void
		{
			_mediaPageArr=[];
			_drawPageArr = [];
			_voArr=[];
			_voArr = voArr;
			_prevID = -1;
			_pageID = pageID;
			_pageNum = voArr.length;
//			_mediaContainer.x = 0;
			clearContainer(_mediaContainer);
			
			for(var i:int;i<_pageNum;i++){
				var sp:Sprite = new Sprite();
				var media:PageMoveMediaSP = new PageMoveMediaSP();
				var graffiti:Graffiti = new Graffiti();
				sp.addChild(media);
				sp.addChild(graffiti);
				sp.x = i*_initWidth;
				sp.name = "page_"+i;
				_mediaContainer.addChild(sp);
				_mediaPageArr.push(media);
				_drawPageArr.push(graffiti);
				media.setSatgeWH(_initWidth,_initHeight);
				media.addEventListener(Event.COMPLETE,onMediaLoaded);
			}
			
			if(_pageNum==1){
				pageID = 0;
				(_mediaPageArr[pageID] as PageMoveMediaSP).setContent(_voArr[pageID]);
			}else if(_pageNum==2){
				(_mediaPageArr[0] as PageMoveMediaSP).setContent(_voArr[0]);
				(_mediaPageArr[1] as PageMoveMediaSP).setContent(_voArr[1]);
			}else{
//				(_mediaPageArr[0] as PageMoveMediaSP).setContent(_voArr[0]);
//				(_mediaPageArr[1] as PageMoveMediaSP).setContent(_voArr[1]);
//				(_mediaPageArr[2] as PageMoveMediaSP).setContent(_voArr[2]);
				if(_pageID == 0){
					(_mediaPageArr[0] as PageMoveMediaSP).setContent(_voArr[0]);
					(_mediaPageArr[1] as PageMoveMediaSP).setContent(_voArr[1]);
					(_mediaPageArr[2] as PageMoveMediaSP).setContent(_voArr[2]);
				}else if(_pageID ==_pageNum-1){
					(_mediaPageArr[_pageID-2] as PageMoveMediaSP).setContent(_voArr[_pageID-2]);
					(_mediaPageArr[_pageID-1] as PageMoveMediaSP).setContent(_voArr[_pageID-1]);
					(_mediaPageArr[_pageID] as PageMoveMediaSP).setContent(_voArr[_pageID]);
				}else{
					(_mediaPageArr[_pageID-1] as PageMoveMediaSP).setContent(_voArr[_pageID-1]);
					(_mediaPageArr[_pageID] as PageMoveMediaSP).setContent(_voArr[_pageID]);
					(_mediaPageArr[_pageID+1] as PageMoveMediaSP).setContent(_voArr[_pageID+1]);
				}
			}
			_mediaContainer.x = -_initWidth*_pageID;
			_thumbnailContainer.setThumbnail(_voArr);
		}
		
		private function onMediaLoaded(e:Event):void
		{
			isTweening = false;
			
		}
		public function showSelectPage(pageID:int):void
		{
			if(pageID == _pageID) return;
			clearMedia();
			_pageID = pageID;
			_mediaContainer.x = -_initWidth*_pageID;
			if(_pageNum == 2){
				(_mediaPageArr[0] as PageMoveMediaSP).setContent(_voArr[0]);
				(_mediaPageArr[1] as PageMoveMediaSP).setContent(_voArr[1]);
			}else if(_pageNum >2){
				if(_pageID == 0){
					(_mediaPageArr[0] as PageMoveMediaSP).setContent(_voArr[0]);
					(_mediaPageArr[1] as PageMoveMediaSP).setContent(_voArr[1]);
					(_mediaPageArr[2] as PageMoveMediaSP).setContent(_voArr[2]);
				}else if(_pageID ==_pageNum-1){
					(_mediaPageArr[_pageID-2] as PageMoveMediaSP).setContent(_voArr[_pageID-2]);
					(_mediaPageArr[_pageID-1] as PageMoveMediaSP).setContent(_voArr[_pageID-1]);
					(_mediaPageArr[_pageID] as PageMoveMediaSP).setContent(_voArr[_pageID]);
				}else{
					(_mediaPageArr[_pageID-1] as PageMoveMediaSP).setContent(_voArr[_pageID-1]);
					(_mediaPageArr[_pageID] as PageMoveMediaSP).setContent(_voArr[_pageID]);
					(_mediaPageArr[_pageID+1] as PageMoveMediaSP).setContent(_voArr[_pageID+1]);
				}
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
			
		}
		public function setPlayerBarFull(dis:Number):void
		{
			_dis = dis;
			for(var i:int = 0;i<_pageNum;i++){
				(_mediaPageArr[i] as PageMoveMediaSP).setPlayerBarFull(dis);
			}
			
		}
		
		public function clearContainer(obj:DisplayObjectContainer):void
		{
			while(obj.numChildren){
				if((obj.getChildAt(0) as DisplayObjectContainer).getChildAt(0) is PageMoveMediaSP){
					((obj.getChildAt(0) as DisplayObjectContainer).getChildAt(0) as PageMoveMediaSP).dispose();
				}
				obj.removeChildAt(0);
			}
		}
		public function clearGraffiti():void
		{
			_drawPageArr[_pageID].graphics.clear();
		}
		public function clearContent():void
		{
			(_mediaPageArr[_pageID] as PageMoveMediaSP).unload();
			clearContainer(_mediaSp);
			clearContainer(_drawSp);
		}
		private function clearMedia():void
		{
			if((_mediaPageArr[_pageID] as PageMoveMediaSP)==null)return;
			(_mediaPageArr[_pageID] as PageMoveMediaSP).unload();
//			trace(_mediaPageArr.length,_pageNum,"pagenum");
			for(var i:int = 0;i<_pageNum;i++){
				(_mediaPageArr[i] as PageMoveMediaSP).unload();
			}
		}
		public function setPosition(container:DisplayObject,_x:Number=0,_y:Number=0,isTween:Boolean=false):void
		{
			if(isTween){
				Tweener.addTween(container,{x:_x,y:_y,time:0.5});
			}else{
				container.x = _x;
				container.y = _y;
			}
			
		}
		public function get pageID():int
		{
			return _pageID;
		}
		
		public function get isLock():Boolean
		{
			return _isLock;
		}
		
		public function set isLock(value:Boolean):void
		{
			_isLock = value;
		}

		public function get isMoving():Boolean
		{
			return _isMoving;
		}

		public function set isMoving(value:Boolean):void
		{
			_isMoving = value;
		}

		public function get initWidth():Number
		{
			return _initWidth;
		}

		public function set initWidth(value:Number):void
		{
			_initWidth = value;
		}

		public function get initHeight():Number
		{
			return _initHeight;
		}

		public function set initHeight(value:Number):void
		{
			_initHeight = value;
		}

		public function get isFullscrren():Boolean
		{
			return _isFullscrren;
		}

		public function set isFullscrren(value:Boolean):void
		{
			_isFullscrren = value;
		}

	}
}