package com.lylib.touch.objects
{
	import com.lylib.layout.LayoutManager;
	import com.lylib.layout.Padding;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	import flash.utils.ByteArray;
	
	/**
	 * swf加载完成
	 */	
	[Event(type="flash.events.Event", name="complete")]
	
	/**
	 * swf加载异常
	 */	
	[Event(type="flash.events.IOErrorEvent", name="ioError")]
	
	/**
	 * 可以加载一个swf,自定义背景
	 */	
	public class SwfObject extends Sprite
	{
		protected var _ldr:Loader;
		protected var _bg:Sprite;
		protected var _mask:Shape;
		protected var _padding:Padding; 
		protected var _url:Object;
		protected var _initWidth:Number;
		protected var _initHeight:Number;
		protected var _initRotation:Number;
		protected var _swfWidth:Number;
		protected var _swfHeight:Number;
		private var _type:String=".jpg";
		private var _swfScale:Number;
		protected var _loaded:Boolean = false;
		/**
		 * 
		 * @param url				swf的路径或者ByteArray
		 * @param initWidth			初始化宽
		 * @param initHeight		初始化高
		 * @param initAngle			初始化角度
		 * @param bg				背景
		 * @param padding			上下左右的边距
		 * 
		 */		
		public function SwfObject(data:Object=null, initWidth:Number=NaN, initHeight:Number=NaN, initAngle:Number=0, bg:Sprite=null, padding:Padding=null)
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
			//addChildAt(_bg, 0);
			
			_ldr = new Loader();
			addChild(_ldr);
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onSwfLoaded);
			_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);			
			if(_url!=null){
				load(_url);
			}			
			
			_mask = new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, 10, 10);
			this.addChild(_mask);
			_ldr.mask = _mask;
			_ldr.doubleClickEnabled = true;
			//做的动画swf最恶心的地方是舞台外面也有动画元素，必须在此做遮罩
		}
		
		/**
		 * 加载成功
		 */		
		protected function onSwfLoaded(e:Event):void
		{
			if(e.target.content is Bitmap){
				_type = ".jpg";
			}else{
				_type = ".swf";
			}
			_loaded = true;
			_swfWidth = _mask.width= _ldr.contentLoaderInfo.width;
			_swfHeight = _mask.height= _ldr.contentLoaderInfo.height;
			_swfScale = _ldr.width/_ldr.contentLoaderInfo.width;
			_ldr.x = _mask.x = -_swfWidth/2;
			_ldr.y = _mask.y = -_swfHeight/2;
			
			_bg.width  = _swfWidth + _padding.left + _padding.right;
			_bg.height = _swfHeight + _padding.top + _padding.bottom;
			_bg.x = -_bg.width/2;
			_bg.y = -_bg.height/2;
			trace("加载成功");
			LayoutManager.sizeToFit(this, _ldr.width*(_initWidth/_swfWidth),  _ldr.height*(_initHeight/_swfHeight));//swf本身的大小与swf舞台大小也不一致
			
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		public function sizeToFit(initW:Number,initH:Number):void
		{
			_initWidth = initW;
			_initHeight = initH;
			LayoutManager.sizeToFit(this, _ldr.width*(_initWidth/_swfWidth),  _ldr.height*(_initHeight/_swfHeight));
		}
		/**
		 * 加载出现异常
		 */		
		protected function onIoError(e:IOErrorEvent):void
		{
			var evt:IOErrorEvent = e;
			this.dispatchEvent( evt );
			trace("加载异常");
		}
		
		
		/**
		 * 加载
		 */		
		public function load(url:Object):void
		{
			_loaded = false;
			_ldr.unloadAndStop();
			if (url is String)
			{
				_ldr.load(new URLRequest(String(url)));
			}
			else if (url is ByteArray)
			{
				//trace(url);
				_ldr.loadBytes(url as ByteArray);
			}
		}
		
		public function unloadAndStop():void
		{
			_ldr.unloadAndStop();
		}
		/**
		 * 禁用
		 */		
		public function dispose():void
		{
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onSwfLoaded);
			_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			_ldr.unloadAndStop();
			removeChild(_ldr);
			_ldr = null;
			_padding = null;
			if(_bg != null)
			{
				removeChild(_bg);
				_bg = null;
			}
		}
		override public function get width():Number{
			
		   return _mask.width;
		}
		override public function get height():Number{
			
			return _mask.height;
		}
		
		/**
		 * swf是否加载完成
		 */
		public function get loaded():Boolean { return _loaded; }

		
		/**
		 * 加载swf与背景的边距
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
		 * 加载swf的舞台宽度
		 */		
		public function get swfWidth():Number
		{
			return _swfWidth;
		}
		
		/**
		 * 加载swf的舞台高度
		 */		
		public function get swfHeight():Number
		{
			return _swfHeight;
		}
	
		
		/**
		 * 要加载swf的路径
		 */		
		public function get url():Object
		{
			return _url;
		}
		public function set url(value:Object):void
		{
			_url = value;
		}

		public function get type():String
		{
			return _type;
		}

		public function set type(value:String):void
		{
			_type = value;
		}

		public function get swfScale():Number
		{
			return _swfScale;
		}

		public function set swfScale(value:Number):void
		{
			_swfScale = value;
		}


	}
}