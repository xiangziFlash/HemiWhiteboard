package com.lylib.touch.objects
{
	import com.lylib.layout.LayoutManager;
	import com.lylib.layout.Padding;
	import flash.utils.ByteArray;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * 图片加载完成
	 */	
	[Event(type="flash.events.Event", name="complete")]
	
	/**
	 * 图片加载异常
	 */	
	[Event(type="flash.events.IOErrorEvent", name="ioError")]
	
	/**
	 * 可以加载一张图片,自定义背景
	 * @author 	刘渊
	 * @version	2.0.1.2011-2-13_beta
	 */	
	public class ImageObject extends Sprite
	{
		protected var _ldr:Loader;
		protected var _bg:Sprite;
		
		protected var _padding:Padding; 
		protected var _url:Object;
		protected var _initWidth:Number;
		protected var _initHeight:Number;
		protected var _initRotation:Number;
		protected var _imageWidth:Number;
		protected var _imageHeight:Number;
		protected var _loaded:Boolean = false;
		/**
		 * 
		 * @param url				图片的路径或者ByteArray
		 * @param initWidth			初始化宽
		 * @param initHeight		初始化高
		 * @param initAngle			初始化角度
		 * @param bg				背景
		 * @param padding			上下左右的边距
		 * 
		 */		
		public function ImageObject(data:Object, initWidth:Number=NaN, initHeight:Number=NaN, initAngle:Number=0, bg:Sprite=null, padding:Padding=null)
		{
			super();
			
			_url = data;
			
			_initWidth = initWidth;
			_initHeight = initHeight;
			rotation = initAngle;	//此方法以覆盖
			
			_padding = padding;
			if (_padding == null)
			{
				_padding = new Padding();
			}
			
			_bg = bg;
			if(_bg==null)
			{
				_bg = new Sprite();
				_bg.graphics.beginFill(0xffffff,0.5);
				_bg.graphics.drawRect(0,0,100,100);
				_bg.graphics.endFill();
			}
			
			if (!isNaN(_initWidth) && !isNaN(_initHeight))
			{
				_bg.width = initWidth;
				_bg.height = initHeight;
			}
			
			_bg.x = -_bg.width/2
			_bg.y = -_bg.height/2;
			addChildAt(_bg, 0);
			
			_ldr = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
			_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			load(_url);
			addChild(_ldr);
		}
		
		/**
		 * 加载成功
		 */		
		protected function onImageLoaded(e:Event):void
		{
			(_ldr.content as Bitmap).smoothing = true;
			_loaded = true;
			_imageWidth = _ldr.width;
			_imageHeight = _ldr.height;
			
			_ldr.x = -_ldr.width/2;
			_ldr.y = -_ldr.height/2;
			
			_bg.width = _ldr.width + _padding.left + _padding.right;
			_bg.height = _ldr.height + _padding.top + _padding.bottom;
			_bg.x = -_bg.width/2
			_bg.y = -_bg.height/2;
			
			LayoutManager.sizeToFit(this, _initWidth, _initHeight);
			
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		/**
		 * 加载出现异常
		 */		
		protected function onIoError(e:IOErrorEvent):void
		{
			var evt:IOErrorEvent = e;
			this.dispatchEvent( evt );
		}
		
		
		/**
		 * 加载
		 */		
		public function load(url:Object):void
		{
			if ((url is String) || (url is XML))
			{
				_ldr.load(new URLRequest(url.toString()));
			}
			else if (url is ByteArray)
			{
				//trace(url);
				_ldr.loadBytes(url as ByteArray);
			}
		}
		
		
		/**
		 * 禁用
		 */		
		public function dispose():void
		{
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			removeChild(_ldr);
			_ldr = null;
			_padding = null;
			if(_bg != null)
			{
				removeChild(_bg);
				_bg = null;
			}
		}
		
		/**
		 * 图片是否加载完成
		 */
		public function get loaded():Boolean { return _loaded; }

		
		/**
		 * 加载图片与背景的边距
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
		 * 要加载图片的路径
		 */		
		public function get url():Object
		{
			return _url;
		}
		public function set url(value:Object):void
		{
			_url = value;
		}


	}
}