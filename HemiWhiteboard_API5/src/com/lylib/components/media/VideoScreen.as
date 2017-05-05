package com.lylib.components.media
{
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	public class VideoScreen extends Sprite
	{
		
		private var _conn:NetConnection;
		private var _stream:NetStream;
		private var _video:Video;
		private var _soundTrans:SoundTransform;
		
		private var _url:String;
		private var _screenWidth:Number;
		private var _screenHeight:Number;
		private var _videoSizeType:String = VideoSizeType.SIZE_TO_FIT;
		private var _autoPlay:Boolean = true;
		private var _playing:Boolean = false;
		private var _isInit:Boolean = true;
		private var _isClickIn:Boolean;
		
		private var _duration:uint;			//视频时间长度
		private var _videoWidth:uint;			//视频宽度
		private var _videoHeight:uint;			//视频高度
		private var _filesize:Number;			//视频文件大小
		
		private var _onMetaData:Function;
		private var _onVideoEnd:Function;
		private var _onVideoFull:Function;
		
		public function VideoScreen(screenWidth:Number=NaN, screenHeight:Number=NaN)
		{
			this._screenWidth = screenWidth;
			this._screenHeight = screenHeight;

			_conn = new NetConnection();
			_conn.connect(null);
			
			var client:Object = new Object();
			client.onMetaData = onMetaDataFun;
			
			_soundTrans = new SoundTransform(0.5);
			
			_stream = new NetStream(_conn);
			//_stream.bufferTime = 30;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusEvent);
			_stream.client = client;
			_stream.soundTransform = _soundTrans;
			
			this.graphics.beginFill(0x000000);
			if(isNaN(screenWidth) || isNaN(screenHeight))
			{
				this.graphics.drawRect(0,0,100,100);
				_video = new Video(100, 100);
			}else{
				//两者都不空
				this.graphics.drawRect(0,0,screenWidth,screenHeight);
				_video = new Video(screenWidth, screenHeight);
			}
			this.graphics.endFill();
			
			_video.attachNetStream(_stream);
			addChild(_video);
		}
		
		private function onMetaDataFun(data:Object):void
		{	//trace("onMetaData", data.width);
			_duration = data.duration;
			_videoWidth = data.width;
			_videoHeight = data.height;
			_filesize = data.filesize;
			

			setVideoSizeType(_videoSizeType);
			
			if(isNaN(_screenWidth) && isNaN(_screenHeight))
			{
				//初始化时没传尺寸的参数，保持视频的原始宽度高度
				_screenWidth = _videoWidth;
				_screenHeight = _videoHeight;
			}
			else if(!isNaN(_screenWidth) && isNaN(_screenHeight))
			{
				_screenHeight = _videoHeight * (_screenWidth/_videoWidth);
			}
			else if(isNaN(_screenWidth) && !isNaN(_screenHeight))
			{
				_screenWidth = _videoWidth * (_screenHeight/_videoHeight);
			}

			setVideoSize(_screenWidth, _screenHeight);
			
			if(_onMetaData != null)
			{
				//回调函数
				//_onMetaData();
			}
		}
		
		private function netStatusEvent(e:NetStatusEvent):void
		{
//			if(_video.videoWidth > 0 && _video.width != _video.videoWidth) {
//				trace("读取到宽度",e.info.code, _video.videoWidth);
//			}
			//Main.tt.appendText(e.info.code+"   ");
			switch(e.info.code)
			{
				case "NetStream.Play.Start":
					//if(_video.videoWidth > 0 && _video.width != _video.videoWidth) {
						//trace("start", _video.videoWidth);
					//}
					break;
				case "NetStream.Buffer.Full":
					//trace("缓冲区已满并且流将开始播放");
					if (_onVideoFull != null) {
						_onVideoFull();
					}
					//Main.tt.appendText("_isInit: "+_isInit + "   ");
					if(_isInit)
					{	//载入新的影片
						_isInit = false;
						if(!_autoPlay)
						{	//不自动播放，暂停到第一秒							
							_playing = false;
							seek(0);
						}
						else
						{
							_playing = true;
						}
					}else {
						_playing = _isClickIn;
					}
					//Main.tt.appendText("_playing: "+_playing + "   ");
					break;
				case "NetStream.Seek.Notify":
					//trace("seek.notify");
					if(_playing)
					{
						_stream.resume();
					}
					else
					{
						//_stream.pause();
					}
					break;
				case "NetStream.Play.Stop":
					//trace("播放已结束");
					_playing = false;
					_isClickIn = false;
					seek(0);
					if(onVideoEnd!=null)
					{
						onVideoEnd();
					}
					break;
			}
		}
		
		/**
		 * 打开一个视频
		 * @param url	视频的地址
		 */		
		public function open(url:String):void
		{
			if(_url != url)
			{
				_isInit = true;
				_url = url;
				_stream.play(url);
			}
			else
			{
				_isInit = false;
				_stream.seek(0);
			}
		}
		
		/**
		 * 恢复回放暂停的视频流。如果视频已在播放，则调用此方法将不会执行任何操作。
		 */		
		public function play():void
		{
			_playing = true;
			_isClickIn = true;
			_stream.resume();
		}
		
		
		/**
		 * 暂停播放的视频流
		 */		
		public function pause():void
		{
			_playing = false;
			_isClickIn = false;
			_stream.pause();
		}
		
		
		/**
		 * 定位视频到对应时间
		 * @param offset	以秒为单位
		 */		
		public function seek(offset:Number):void
		{
			_stream.seek(offset);
		}
		
		
		
		public function setVolume(value:Number):void
		{
			_soundTrans.volume = value;
			_stream.soundTransform = _soundTrans;
		}
		
		
		/**
		 * 设置视频屏幕的尺寸
		 * @param width		屏幕的宽
		 * @param height		屏幕的高
		 * 
		 */		
		public function setVideoSize(width:uint, height:uint):void
		{
			_screenWidth = width;
			_screenHeight = height;
			
			if(_videoSizeType == VideoSizeType.SIZE_TO_FIT)
			{
				sizeToFit();
			}
			else if(_videoSizeType == VideoSizeType.ACTUAL_SIZE)
			{
				actualSize();
			}
		}
		
		public function setVideoSizeType(videoSizeType:String):void
		{
			_videoSizeType = videoSizeType;
		}
		
		private function sizeToFit():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0,0,_screenWidth,_screenHeight);
			this.graphics.endFill();
			
			var ratio:Number;
			if(_screenWidth>0 && _screenHeight>0){
				ratio = Math.min(_screenWidth / _videoWidth, _screenHeight / _videoHeight);
			}else{
				return;
			}
			_video.width = _videoWidth * ratio;
			_video.height = _videoHeight * ratio;
			
			_video.x = (_screenWidth-_video.width)/2;
			_video.y = (_screenHeight-_video.height)/2;
		}
		
		private function actualSize():void
		{
			_video.width = _videoWidth;
			_video.height = _videoHeight;
			
			if( _screenWidth<_videoWidth || _screenHeight<_videoHeight )
			{
				return;
			}
			else
			{
				this.graphics.clear();
				this.graphics.beginFill(0x000000);
				this.graphics.drawRect(0,0,_screenWidth,_screenHeight);
				this.graphics.endFill();
			}
			
			_video.x = (_screenWidth-_video.width)/2;
			_video.y = (_screenHeight-_video.height)/2;
		}

		public function dispose():void{
			_stream.close();
			_conn.close();
			removeChild(_video);
		}
		
		/**
		 * 播放头的位置（以秒为单位）。
		 */		
		public function get time():Number
		{
			return _stream.time;
		}
		
		/**
		 * 视频时间长度
		 */		
		public function get duration():uint
		{
			return _duration;
		}

		/**
		 * 视频宽度
		 */		
		public function get videoWidth():uint
		{
			return _videoWidth;
		}

		/**
		 * 视频高度
		 */		
		public function get videoHeight():uint
		{
			return _videoHeight;
		}

		/**
		 * 視頻文件大小
		 */		
		public function get filesize():Number
		{
			return _filesize;
		}

		
		/**
		 * 告诉我们已经有几秒钟数据进入缓冲区了
		 */		
		public function get bufferLength():Number
		{
			return _stream.bufferLength;
		}
		
		public function get bytesLoaded():uint
		{
			return _stream.bytesLoaded;
		}
		
		public function get bytesTotal():uint
		{
			return _stream.bytesTotal;
		}

		/**
		 * 视频是否自动播放
		 */		
		public function get autoPlay():Boolean
		{
			return _autoPlay;
		}
		public function set autoPlay(value:Boolean):void
		{
			_autoPlay = value;
		}

		
		/**
		 * 视频当前是否正在播放
		 */		
		public function get playing():Boolean
		{
			return _playing;
		}


		/**
		 * 获得到元数据的回调函数
		 */		
		public function get onMetaData():Function
		{
			return _onMetaData;
		}
		public function set onMetaData(value:Function):void
		{
			_onMetaData = value;
		}
		
		/**
		 * 当视频播放结束的回调函数
		 */		
		public function get onVideoEnd():Function
		{
			return _onVideoEnd;
		}
		public function set onVideoEnd(value:Function):void
		{
			_onVideoEnd = value;
		}

		
		/**
		 * 音量
		 */		
		public function get volume():Number
		{
			return _soundTrans.volume;
		}
		public function set volume(value:Number):void
		{
			setVolume(value);
		}
		
		public function get onVideoFull():Function { return _onVideoFull; }
		
		public function set onVideoFull(value:Function):void 
		{
			_onVideoFull = value;
		}

	}
}