package com.lylib.touch.objects
{
	import com.lylib.layout.LayoutManager;
	import com.lylib.layout.Padding;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.geom.Transform;
	import flash.net.URLRequest;
	
	/**
	 * 可以加载一张图片,自定义背景
	 * @author 	刘渊
	 * @version	2.0.3.2011-2-17_beta
	 */	
	public class ImageObject2 extends Sprite
	{
		protected var _ldr:Loader;
		private var _bg:DisplayObject;
		
		private var _url:String;
		private var _loaded:Boolean;
		private var _smoothing:Boolean = true;
		private var _padding:Padding;
		
		private var _initWidth:Number;
		private var _initHeight:Number;
		protected var _loadBeforeWidth:Number;
		protected var _loadBeforeHeight:Number;
		private var _imageWidth:Number;
		private var _imageHeight:Number;
		
		/**
		 * @param url				图片的路径
		 * @param initWidth		初始化宽
		 * @param initHeight		初始化高
		 * @param initAngle		初始化角度
		 * @param bg				背景
		 * @param padding			上下左右的边距
		 */	
		public function ImageObject2(url:String, initWidth:Number=NaN, initHeight:Number=NaN, initAngle:Number=0, bg:Sprite=null, padding:Padding=null)
		{
			this.url = url;
			this.initWidth = initWidth;
			this.initHeight = initHeight;
			this.rotation = initAngle;
			this.background = bg;
			if(padding==null)
			{
				padding = new Padding();
			}
			this.padding = padding;
			
			_ldr = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_ldr.load(new URLRequest(url));
			addChild(_ldr);
		}
		
		
		/**
		 * 加载图片
		 * @param url	图片的路径
		 * 
		 */		
		public function load(url:String):void
		{
			_imageWidth = _imageHeight = NaN; 
			this.url = url;
			_ldr.load(new URLRequest(url));
		}
		
		
		/**
		 * 禁用
		 */		
		public function dispose():void
		{
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onError);
			removeChild(_ldr);
			_ldr = null;
			_padding = null;
			if(_bg != null)
			{
				removeChild(_bg);
				_bg = null;
			}
		}
		
		protected function onComplete(e:Event):void
		{
			//设置平滑
			(_ldr.content as Bitmap).smoothing = _smoothing;
			
			_imageWidth = _ldr.content.width;
			_imageHeight = _ldr.content.height;
			
			_ldr.x = -_ldr.width/2;
			_ldr.y = -_ldr.height/2;
			
			if(!isNaN(initWidth) || !isNaN(initHeight))
			{
				LayoutManager.sizeToFit(this, initWidth, initHeight);
			}
			else
			{
				if(_loadBeforeWidth)
				{
					this.width = _loadBeforeWidth;
					_loadBeforeWidth = NaN;
				}
				if(_loadBeforeHeight)
				{
					this.height = _loadBeforeHeight;
					_loadBeforeHeight = NaN;
				}
			}
			
			
			if(_bg!=null)background = _bg;
			
			var evt:Event = e;
			this.dispatchEvent(evt);
		}
		
		protected function onError(e:IOErrorEvent):void
		{
			var evt:IOErrorEvent = e;
			this.dispatchEvent(evt);
		}
		
		//------------------------- getter & setter ------------------------------//
		
		override public function set width(value:Number):void
		{
			if(isNaN(imageWidth))
			{
				_loadBeforeWidth = value;
				return;
			}
			else
			{
				super.width = value;
				if(background)
				{
					background.width = imageWidth + (padding.left+padding.right)/scaleX;
					background.x = -background.width/2;
				}
			}
		}
		
		override public function set height(value:Number):void
		{
			if(isNaN(imageHeight))
			{
				_loadBeforeHeight = value;
				return;
			}
			else
			{
				super.height = value;
				if(background)
				{
					background.height = imageHeight + (padding.top+padding.bottom)/scaleY;
					background.y = -background.height/2;
				}
			}
		}
		
		override public function set scaleX(value:Number):void
		{
			super.scaleX = value;
			if(background!=null && !isNaN(imageWidth)){
				background.width = imageWidth + (padding.left+padding.right)/scaleX;
				background.x = -background.width/2;
			}
		}
		
		override public function set scaleY(value:Number):void
		{
			super.scaleY =value;
			if(background!=null && !isNaN(imageHeight)){
				background.height = imageHeight + (padding.top+padding.bottom)/scaleY;
				background.y = -background.height/2;
			}
		}
		
		
		
		public function get background():DisplayObject
		{
			return _bg;
		}
		public function set background(value:DisplayObject):void
		{
			_bg = value;
			if(isNaN(imageWidth) || isNaN(imageWidth))return;
			addChildAt(_bg,0);
			background.width = imageWidth + (padding.left+padding.right)/scaleX;
			background.height = imageHeight + (padding.top+padding.bottom)/scaleY;
			background.x = -background.width/2;
			background.y = -background.height/2;
		}

		/**
		 * 加载图片的宽度
		 */		
		public function get imageWidth():Number
		{
			return _imageWidth;
		}

		/**
		 * 加载图片的高度
		 */	
		public function get imageHeight():Number
		{
			return _imageHeight;
		}

		/**
		 * 图片与背景的边距
		 */		
		public function get padding():Padding
		{
			return _padding;
		}
		public function set padding(value:Padding):void
		{
			_padding = value;
		}

		/**
		 * 图片加载完成
		 */		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		public function set loaded(value:Boolean):void
		{
			_loaded = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set url(value:String):void
		{
			_url = value;
		}

		/**
		 * 允许平滑
		 */		
		public function get smoothing():Boolean
		{
			return _smoothing;
		}
		public function set smoothing(value:Boolean):void
		{
			_smoothing = value;
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


	}
}