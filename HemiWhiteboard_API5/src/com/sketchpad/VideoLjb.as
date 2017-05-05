package com.sketchpad
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	/**
	 * ...
	 * @author ljb
	 */
	public class VideoLjb extends Sprite 
	{
		private var _videoConnection:NetConnection;
		public var _videoStream:NetStream;
		public var _video:Video;
		public var _duration:uint = 0;
		private var _videoData:Object;
		private var _stageWidth:Number=0;
		private var _videoWidth:Number=0;
		private var _stageHeight:Number=0;
		private var _videoHeight:Number=0;
		private var _isOne:Boolean;
		private var _isAutoPlay:Boolean;
		public var isAutoSize:Boolean;
		public function VideoLjb() 
		{
			_videoConnection = new NetConnection();
			_videoConnection.connect(null);
			_videoStream = new NetStream(_videoConnection);
			_video = new Video();
			var client:Object = new Object();
			client.onMetaData = onMetaData;//元数据事件
			_videoStream.client = client;
			_video.attachNetStream(_videoStream);
			this.addChild(_video);
			this.doubleClickEnabled = true;
			_videoStream.addEventListener(NetStatusEvent.NET_STATUS, onStatus);
		}
		
		

		protected function onStatus(e:NetStatusEvent):void
		{
			//trace(e.info.code);
			switch(e.info.code) {
				case "NetStream.Play.Stop":
					//trace("视频播放结束");	
					this.dispatchEvent(new Event(Event.COMPLETE));
					break;
				case "NetStream.Play.Start":
					//trace("视频播放已开始");	
					setVideoSize(_stageWidth,_stageHeight);
					//setVideoSize(_video.videoWidth,_video.videoHeight);
					break;
				case "NetStream.Buffer.Full":
					//pauseVideo();
					//trace("缓冲已经达到");
					if (_isOne) {
						_isOne = false;
						if (!_isAutoPlay) {
							//pauseVideo();
						}
						setVideoSize(_stageWidth,_stageHeight);
						this.dispatchEvent(new Event(Event.INIT));
					}
					
					break;
			}			
			
		}
		/**
		 * 回调函数
		 */
		private function onMetaData(data:Object):void 
		{
			
			_videoData = data;
			_duration = data.duration;
			//trace(_videoData.width,_videoData.height,"视频原始大小");
			if(_stageWidth == 0||_stageHeight==0){
				_stageWidth = _videoData.width;
				_stageHeight = _videoData.height;
			}
			if(!isAutoSize)
			{
				if((_stageWidth>600)||(_stageHeight>337))
				{
					_stageWidth=600;
					_stageHeight=337;
				}
			}
			
			setVideoSize(_stageWidth,_stageHeight);
		}
		public function setVideoSize(w:Number,h:Number):void
		{
			_stageWidth = w;
			_stageHeight = h;
			
			if (_videoData == null) {
				return;
			}
			_video.width = Math.min(stageWidth / _videoData.width, stageHeight /_videoData.height)*_videoData.width;
			_video.height = Math.min(stageWidth / _videoData.width, stageHeight /_videoData.height)*_videoData.height;
			_videoWidth = _video.width;
			_videoHeight = _video.height;
			
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		
		public function get stageWidth():Number
		{
			return _stageWidth;
		}
		
		public function get stageHeight():Number
		{
			return _stageHeight;
		}

		public function get isOne():Boolean
		{
			return _isOne;
		}

		public function set isOne(value:Boolean):void
		{
			_isOne = value;
		}

		public function get videoWidth():Number
		{
			return _videoWidth;
		}

		public function get videoHeight():Number
		{
			return _videoHeight;
		}


	}

}