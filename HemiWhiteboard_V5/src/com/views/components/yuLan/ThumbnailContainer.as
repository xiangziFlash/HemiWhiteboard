package com.views.components.yuLan
{
	import com.cndragon.baby.plugs.Yulan.ThumbnailContainerRes;
	import com.cndragon.baby.plugs.Yulan.ThumbnailRes;
	import com.lylib.layout.LayoutManager;
	import com.lylib.utils.LoaderQueue;
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ThumbnailContainer extends Sprite
	{
		private var _thumbnailContainerRes:ThumbnailContainerRes;
		private var _voArr:Array=[];
		private var _count:int;
		private var _thumbCon:Sprite;
		private var _thumbMask:Shape;
		private var _downY:Number;
		private var _thumbDownY:Number;
		private var _thumbID:int;
		private var _isShow:Boolean = true;
		public function ThumbnailContainer()
		{
			initContent();
			initEventListener();
		}
		private function initContent():void
		{
			_thumbnailContainerRes = new ThumbnailContainerRes();
			_thumbCon = new Sprite();
			_thumbMask = new Shape();
			_thumbMask.graphics.beginFill(0);
			_thumbMask.graphics.drawRect(0,0,91,540);
			_thumbMask.graphics.endFill();
			_thumbCon.mask = _thumbMask;
			_thumbnailContainerRes.addChild(_thumbCon);
			_thumbnailContainerRes.addChild(_thumbMask);
			
			this.addChild(_thumbnailContainerRes);
		}
		private function initEventListener():void
		{
			_thumbCon.addEventListener(MouseEvent.MOUSE_DOWN,onThumbDown);
			_thumbnailContainerRes.tapBtn.addEventListener(MouseEvent.CLICK,onTapClick);
		}
		private function onTapClick(e:MouseEvent):void
		{
			if(_isShow){
				Tweener.addTween(this,{x:960,time:0.5,transition:"easeOutQuint"});
			}else{
				Tweener.addTween(this,{x:960-90,time:0.5,transition:"easeOutQuint"});
			}
			_isShow = !_isShow;
		}
		private function onThumbDown(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onThumbMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onThumbUp);
			Tweener.removeTweens(_thumbCon);
			_thumbDownY = _thumbCon.mouseY;
			_downY = mouseY;
		}
		private function onThumbMove(e:MouseEvent):void
		{
			_thumbCon.y = mouseY - _thumbDownY;
			_thumbDownY = _thumbCon.mouseY;
		}
		private function onThumbUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onThumbMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onThumbUp);
			
			if(_thumbCon.y>=0){
				Tweener.addTween(_thumbCon,{y:0,time:0.8,transition:"easeOutCubic"});
			}else if(_thumbCon.y<=_thumbMask.height-_thumbCon.height){
				Tweener.addTween(_thumbCon,{y:_thumbMask.height-_thumbCon.height,time:0.8,transition:"easeOutCubic"});
			}
				
			if(Math.abs(_downY-mouseY)<5){
				if(e.target.name.split("_")[0]=="thumb"){
					_thumbID = e.target.name.split("_")[1];
					this.dispatchEvent(new Event(Event.SELECT));
					if(_isShow){
						Tweener.addTween(this,{delay:5,x:960,time:0.5,transition:"easeOutQuint",onComplete:function():void{_isShow = !_isShow;}});
					}
					
				}
			}
		}
		public function setThumbnail(voArr:Array):void
		{
			dispose();
			_voArr = voArr;
			for(var i:int = 0;i<_voArr.length;i++){
				if(ApplicationData.getInstance().UDiskModel){
					LoaderQueue.getInstance().addRes((_voArr[i] as MediaVO).thumb, onThumbLoaded);
				}else{
					LoaderQueue.getInstance().addRes((_voArr[i] as MediaVO).thumb, onThumbLoaded);
				}
				
			}
		}
		private function onThumbLoaded(obj:DisplayObject):void
		{
			
			var thumb:ThumbnailRes = new ThumbnailRes();
			LayoutManager.sizeToFit(obj,88,88);
			thumb.addChild(obj);
			
			thumb.name = "thumb_"+_count;trace(obj);
			obj.y = (88-obj.height)*0.5+1;
			obj.x = (88-obj.width)*0.5+1;
			thumb.width = thumb.height = 90;
			thumb.y = _count*90;
			_thumbCon.addChild(thumb);
			_count++;
		}
		private function ioErrFunction(path:String):void
		{
			trace("error------------",path);
		}
		public function dispose():void
		{
			while(_thumbCon.numChildren){
				if(_thumbCon.getChildAt(0) is Bitmap){
					(_thumbCon.getChildAt(0) as Bitmap).bitmapData.dispose();
				}
				_thumbCon.removeChildAt(0);
			}
			_count=0;
			_thumbCon.y = 0;
		}

		public function get thumbID():int
		{
			return _thumbID;
		}

		public function set thumbID(value:int):void
		{
			_thumbID = value;
		}

	}
}