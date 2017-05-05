package com.scxlib
{
	import com.controls.ToolKit;
	import com.models.vo.MediaVO;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.text.TextFormat;

	/**
	 * 
	 * @author 祥子
	 * 加载图片类
	 */	
	public class LoaderImage extends Sprite
	{
		private var _ldr:Loader;
		private var _stageW:Number=0;
		private var _stageH:Number=0;
		private var _isZiShiYing:Boolean=true;
		private var _bg:LoaderBGRes;
		private var _isBg:Boolean;
		private var _mediaVO:MediaVO;
		
		public function LoaderImage()
		{
			this.mouseChildren = false;
			_bg = new LoaderBGRes();
			this.addChild(_bg);
			_bg.visible = false;
			_bg.startBtn.visible = false;
			_bg.startBtn.mouseEnabled = false;
			_bg.startBtn.mouseChildren = false;
			
			_bg.titT.embedFonts = true;
			_bg.titT.defaultTextFormat = new TextFormat("SongTi_font",14,0xFFFFFF);
			
			_ldr = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEnd);
			_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLdrIOError);
		}
		
		private function onLdrIOError(event:IOErrorEvent):void
		{
			trace("onLdrIOError");
		}
		
		public function setPath(vo:MediaVO):void
		{
			_mediaVO = vo;
//			trace(vo.thumb,"++++");
			_ldr.load(new URLRequest(vo.thumb));
			_bg.titT.text = vo.title;
		}
		
		/**
		 * 设置加载图片的的宽高
		 * w h 图片在w h 内     
		 */		
		public function setWH(w:Number,h:Number,isBg:Boolean,isZiShiYing:Boolean=true):void
		{
			_isBg = isBg;
			_isZiShiYing = isZiShiYing;
			_stageW= w;
			_stageH= h;
		}
		
		private function onLdrEnd(e:Event):void
		{
			(_ldr.content as Bitmap).smoothing = true;
			if(_isZiShiYing)
			{
				_ldr.scaleX = _ldr.scaleY = Math.min(_stageW/_ldr.contentLoaderInfo.width,_stageH/_ldr.contentLoaderInfo.height);
			}else{
				_ldr.width = _stageW;
				_ldr.height = _stageH;
			}
			
			if(_isBg==true)
			{
				_bg.visible = true;
				_bg.img.addChild(_ldr);
			}else{
				this.addChild(_ldr);
			}
		//	Tool.log(_mediaVO.path.split("/")[_mediaVO.path.split("/").length-1].split(".")[1]+"添加了视频标记")
			if(_mediaVO.path.split("/")[_mediaVO.path.split("/").length-1].split(".")[1]=="flv")
			{//trace("添加了视频标记");
				_bg.startBtn.x = (_stageW-_bg.startBtn.width)*0.5;
				_bg.startBtn.y = (_stageH-_bg.startBtn.height)*0.5;
				this.addChild(_bg.startBtn);
				_bg.startBtn.mouseEnabled = false;
				_bg.startBtn.mouseChildren = false;
				this.mouseChildren = false;
				_bg.startBtn.visible = true;
			}
			
			var point:Point = stage.globalToLocal(this.localToGlobal(new Point(this.x,this.y)));
			_mediaVO.globalP = point;
		}
		
		/**
		 *清除图片 
		 */		
		public function dispose():void
		{
			if(_ldr)
			{
				if(_ldr.parent)
				{
					_ldr.parent.removeChild(_ldr);
				}
				
				_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrEnd);
				_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLdrIOError);
				_ldr.unloadAndStop();
				_ldr=null;
			}
			this.removeChild(_bg);
		}

		public function get mediaVO():MediaVO
		{
			return _mediaVO;
		}

	}
}