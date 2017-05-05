package com.lylib.components.media
{
	import com.utils.ForcibleLoader;
	
	import flash.display.AVM1Movie;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

	/**
	 * ...
	 * @author FrostYen
	 */
	public class SwfPlayer extends MovieClip 
	{
		private var _loader:Loader;;
		private var _urlR:URLRequest;
		private var _url:String;
		private var _container:MovieClip;
		private var _mask:Shape;
		private var _forcibleLoader:ForcibleLoader;
		private var _stageW:Number;//swf实际的舞台宽度
		private var _stageH:Number;//swf实际的舞台高度
		public function SwfPlayer() 
		{
			_mask = new Shape();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0, 0, 10, 10);
			_mask.graphics.endFill();
			this.mask = _mask;
			
			this.addEventListener(MouseEvent.CLICK,onThisClick);
		}
		/**
		 * 加载swf
		 * @param	url swf路径
		 */
		public function Load(url:String):void{
			this._url=url;
			if(!_loader){
				_loader= new Loader()
			}
			_urlR=new URLRequest(_url);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_loader.load(_urlR);
		}
		
		private function onComplete(event:Event):void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			if (_loader.content is AVM1Movie) {//如果是as2.0或者1.0代码生成的swf
				trace("_loader.content is AVM1Movie");
				_loader.unloadAndStop();
				_forcibleLoader = new ForcibleLoader(_loader);
				_forcibleLoader.load(_urlR);
				return;
			}
			
			//trace(_loader.contentLoaderInfo,_loader,"_loader");
			try
			{
				_container = MovieClip(_loader.content);
				_stageW = _loader.contentLoaderInfo.width;
				_stageH = _loader.contentLoaderInfo.height;
				this.addChild(_container);
			} 
			catch(error:Error) 
			{
				//trace(_loader.width,"_loader.width");
				
				_stageW = _loader.width;
				_stageH = _loader.height;
				this.addChild(_loader);
			}
			
			_mask.width = _stageW;
			_mask.height = _stageH;
			
			this.addChild(_mask);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * 播放下一帧
		 */
		public function nextPlay():void{
			if(_container.currentFrame==_container.totalFrames){
				stop();
			}
			else{
				_container.nextFrame();
			}
		}
		/**
		 * 播放上一帧
		 */      
		public function prevPlay():void{
			if(_container.currentFrame==1){
				stop();
			}
			else{
				_container.prevFrame();
			}
		}
		/**
		 * 开始播放
		 */
		public function startPlay():void
		{
			_container.play();
		}
		/**
		 * 暂停播放
		 */
		public function pausePlay():void
		{
			_container.stop();
		}
		
		/**
		 * 卸载加载的swf
		 */
		public function unloadAndStop():void
		{
			
			if(_loader){
				_loader.unloadAndStop();
				_loader = null;
				
			}
			if(_container){
				_container.parent.removeChild(_container);
				_container = null;
			}
			
		}
		
		public function onThisClick(e:MouseEvent):void
		{
			trace("+++++++++++++++")
		}
		
		public function get stageW():Number 
		{
			return _stageW;
		}
		
		public function set stageW(value:Number):void 
		{
			_stageW = value;
		}
		
		public function get stageH():Number 
		{
			return _stageH;
		}
		
		public function set stageH(value:Number):void 
		{
			_stageH = value;
		}
		
	}

}