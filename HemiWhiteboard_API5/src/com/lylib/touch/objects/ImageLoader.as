/**
 * ImageLoader
 * 可以加载一张图片,自定义背景,继承RotatableScalable类具有旋转缩放的多点触控功能
 * 目前还是存在Bug，如需沟通请与 hiliuyuan@gmail.com 联系
 *
 * @author		刘渊
 * @version	1.0.2.110110_beta
 */

package com.lylib.touch.objects
{
	import com.lylib.layout.LayoutManager;
	import com.lylib.layout.Padding;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	/**
	 * 图片加载完成
	 */	
	[Event(type="flash.events.Event", name="complete")]
	
	
	/**
	 * 可以加载一张图片,自定义背景,继承RotatableScalable类具有旋转缩放的多点触控功能
	 * @author 刘渊
	 */	
	public class ImageLoader extends RotatableScalable1
	{
		private var _ldr:Loader;
		private var _bg:Sprite;
		
		private var _padding:Padding; 
		private var _url:String;
		private var _initWidth:Number;
		private var _initHeight:Number;
		private var _initRotation:Number;
		private var _loaded:Boolean = false;
		/**
		 * 
		 * @param url				图片的路径
		 * @param initWidth		初始化宽
		 * @param initHeight		初始化高
		 * @param bg				背景
		 * @param padding			上下左右的边距
		 * 
		 */		
		public function ImageLoader(url:String, initWidth:Number=NaN, initHeight:Number=NaN, bg:Sprite=null, padding:Padding=null, initRotation:Number=0)
		{
			super();
			
			_url = url;
			
			_initWidth = initWidth;
			_initHeight = initHeight;
			rotation = initRotation;	//此方法以覆盖
			
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
			_ldr.load(new URLRequest(url));
			addChild(_ldr);
		}
		
		private function onImageLoaded(e:Event):void
		{
			_loaded = true;
			
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			_ldr.x = -_ldr.width/2;
			_ldr.y = -_ldr.height/2;
			
			_bg.width = _ldr.width + _padding.left + _padding.right;
			_bg.height = _ldr.height + _padding.top + _padding.bottom;
			_bg.x = -_bg.width/2
			_bg.y = -_bg.height/2;
			//addChildAt(_bg, 0);
			
			LayoutManager.sizeToFit(this, _initWidth, _initHeight);
			
			this.rotation = _initRotation;
			
			this.dispatchEvent( new Event(Event.COMPLETE) );
		}
		
		
		/**
		 * 禁用
		 */		
		override public function dispose():void
		{
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoaded);
			removeChild(_ldr);
			_ldr = null;
			
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
		
		override public function set rotation(value:Number):void 
		{
			_initRotation = value;
			if (loaded) {
				super.rotation = _initRotation;
			}
		}
	}
}