package com.views.components.board
{
	import com.greensock.TweenLite;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.tweener.transitions.Tweener;
	
	import fl.motion.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-5-7 上午10:42:47
	 * 
	 */
	public class BoardBackGround extends Sprite
	{
		private  var _bgLdr:Loader;
//		private var _bgArr:Array=["assets/backGround/1.jpg","assets/backGround/2.jpg","assets/backGround/3.jpg","assets/backGround/4.jpg","assets/backGround/5.jpg"];
		private var _tempBmpd:BitmapData;
		private var _tempBmp:Bitmap;
		
		public function BoardBackGround()
		{
			initViews();
		}
		
		private function initViews():void
		{
			_bgLdr = new Loader();
			_bgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE,onBgLdrEnd);
			_bgLdr.contentLoaderInfo.addEventListener(ErrorEvent.ERROR ,onBgLdrERROR);
			_bgLdr.load(new URLRequest(ApplicationData.getInstance().bgs[0].nativePath));
		}
		
		private function onBgLdrERROR(event:Event):void
		{
			trace("onBgLdrERROR");
		}
		
		private function onBgLdrEnd(event:Event):void
		{
			_tempBmpd = (_bgLdr.content as Bitmap).bitmapData.clone();
			(_bgLdr.content as Bitmap).smoothing=true;
			_bgLdr.x = _bgLdr.y = 0;
			_bgLdr.width = 1920;
			_bgLdr.height = 1080;
			this.addChild(_bgLdr);
//			TweenLite.to(_tempBmp,0.5,{visible:false});
//			TweenLite.to(_tempBmp, 0.2, {visible:false, ease:Linear.easeNone});
//			TweenLite.to(_bgLdr,0.2,{visible:true, ease:Linear.easeNone});
			
			Tweener.addTween(_tempBmp, {time:0.2, visible:false});
			Tweener.addTween(_bgLdr,{time:0.2,visible:true});
		}
		/**
		 *切換塗鴉板背景 
		 */		
		public function changeBoardBg(index:int):void
		{
			//trace(index,"index");
			if(_tempBmp==null)
			{
				_tempBmp = new Bitmap(_tempBmpd);
				this.addChild(_tempBmp);
				_tempBmp.visible = false;
			}else{
				_tempBmp.bitmapData = _tempBmpd;
			}
			_tempBmp.smoothing=true;
			Tweener.addTween(_tempBmp, {time:0.5,visible:true});
			Tweener.addTween(_bgLdr,{time:0.5,visible:false});
			
			if(_bgLdr == null)
			{
				_bgLdr = new Loader();
				_bgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE,onBgLdrEnd);
				_bgLdr.contentLoaderInfo.addEventListener(ErrorEvent.ERROR ,onBgLdrERROR);
			}
			try
			{
				_bgLdr.load(new URLRequest(ApplicationData.getInstance().bgs[index].nativePath));
			} 
			catch(error:Error) 
			{
				
			}
//			trace("bg",ApplicationData.getInstance().bgs[index].nativePath);
		}
		
		public function dispose():void
		{
			if(_tempBmp.bitmapData)
			{
				_tempBmp.bitmapData.dispose();
				_tempBmp = null;
			}
			if(_bgLdr)
			{
				this.removeChild(_bgLdr);
				_bgLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBgLdrEnd);
				_bgLdr.load(new URLRequest(ApplicationData.getInstance().bgs[0].nativePath));
				_bgLdr.unloadAndStop();
				_bgLdr =null;
			}
		}
	}
}