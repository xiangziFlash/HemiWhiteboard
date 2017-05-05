package com.controls.utilities
{
	import com.controls.ToolKit;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;

	/**
	 * 视频控制核心组件
	 * ----------1.10-------将恢复播放的方法名字修正为resumeVideo，修改了视频的大小控制
	 * ----------1.20-------修改了访问不到文件头时让视频大小强拉为舞台大小
	 * ----------1.21-------播放参数添加了视频声音值的设置   2013/6/21
	 * ----------1.22-------修改视频播放完成所派发的事件名称   2013/6/21
	 * 
	 * @author wang
	 * @version 1.22 版本号
	 */
	public class  VideoControl extends Sprite
	{
		private var _videoConnection:NetConnection;
		private var _videoStream:NetStream;
		private var _video:Video;
		/**
		 * 视频文件的信息
		 */
		private var _videoData:Object;
		/**
		 * 视频缓冲结束,准备播放的事件名称
		 */
		public static const FULL:String = "full";	
		/**
		 * 视频播放完成
		 */
		public static const VIDEO_PLAY_END:String = "video_play_end";
		/**
		 * 视频总时间
		 */
		private var _duration:uint;
		/**
		 * 当前播放的时间
		 */
		private var _playTime:Number;
		
		private var _sond:Sound ;
		private var _volume:Number=0.5;//音量
		
		private var _stageWidth:Number;
		private var _stageHeight:Number;
		private var _isAutoPlay:Boolean;//是否自动播放
		private var _isOne:Boolean;
		/**
		 * 自适应
		 * */
		private var _isAdaptive:Boolean=true;
		
		public function VideoControl()
		{
			_video=new Video()			
			
			_videoConnection = new NetConnection();
			_videoConnection.connect(null);
			
			
			_videoStream = new NetStream(_videoConnection);
			var customClient:Object = new Object();//回调函数初始化
			customClient.onMetaData = onMetaData;
			
			volume = 0.5;
			
			_videoStream.client = customClient;
			_video.attachNetStream(_videoStream);
			addChild(_video);
			_videoStream.addEventListener(NetStatusEvent.NET_STATUS, onNET_STATUS);
			
		}
		/**
		 * 
		 * @param nc
		 * @param mediaPath 视频的url
		 * @param	isAutoPlay	视频是否自动播放
		 * @param	isAdaptive	视频大小是否跟舞台适应    true  自适应  false  按照舞台大小赋值
		 * @param	volume	视频默认声音值
		 * 
		 */		
		public function setNetVideo(nc:NetConnection,mediaPath:String,isAutoPlay:Boolean=true,isAdaptive:Boolean=true,volume:Number=0.5):void
		{
			ToolKit.log("setNetVideo 视频名称  "+mediaPath);
			_isOne = true;
			_videoStream = new NetStream(nc);
			var customClient:Object = new Object();//回调函数初始化
			customClient.onMetaData = onMetaData;
			volume = 0.5;
			_videoStream.client = customClient;
			_video.attachNetStream(_videoStream);
			addChild(_video);
			
			_isAutoPlay = isAutoPlay;
			_isAdaptive=isAdaptive;
			
			_videoStream.play(mediaPath);
			_videoStream.addEventListener(NetStatusEvent.NET_STATUS, onNET_STATUS);
		}
		
		
		/**
		 * 回调函数
		 */
		private function onMetaData(data:Object):void 
		{
			_videoData = data;
			_duration = data.duration;
			ToolKit.log("回调函数"+_duration);
			this.dispatchEvent(new Event(Event.INIT));
			setVideoSize(_stageWidth,_stageHeight);
			//setVideoSize(data.width,data.height);
		}
		
		/**
		 * 播放某视频，默认为自动播放
		 * @param	url			视频的url
		 * @param	isAutoPlay	视频是否自动播放
		 * @param	isAdaptive	视频大小是否跟舞台适应    true  自适应  false  按照舞台大小赋值
		 * @param	volume	视频默认声音值
		 */
		public function playVideo(url:String,isAutoPlay:Boolean=true,isAdaptive:Boolean=true,volume:Number=0.5):void
		{			
			_isOne = true;
			//_videoStream = new NetStream(_videoConnection);
			var customClient:Object = new Object();//回调函数初始化
			customClient.onMetaData = onMetaData;
			_videoStream.client = customClient;
			this.volume=volume;
			_video.attachNetStream(_videoStream);
			_videoStream.addEventListener(NetStatusEvent.NET_STATUS, onNET_STATUS);
			
			_isAutoPlay = isAutoPlay;
			_isAdaptive=isAdaptive;
			_videoStream.play(url);
		}
		/**
		 * 关闭前一个或后一个视频流
		 */
		public function closeVideo():void
		{
			_videoStream.close();
		}
		/**
		 * 视频继续播放控制
		 */
		public function resumeVideo():void
		{trace("视频继续播放控制");
			//_isAutoPlay = true;
			_videoStream.resume();			
		}
		/**
		 * 视频暂停控制
		 */
		public function pauseVideo():void
		{trace("视频暂停控制");
			_videoStream.pause();
		}
		/**
		 * 视频停止控制，播放头调到0位置
		 */
		public function stopVideo():void
		{
			_videoStream.seek(0);
			_videoStream.pause();
		}
		
		/**
		 * 设置视频播放头的位置
		 * @param	longNum
		 */
		public function setSeek(longNum:Number):void
		{
			_videoStream.seek(longNum);
			//videoStream.pause();
		}
		
		
		private function onNET_STATUS(e:NetStatusEvent):void 
		{
			//trace(e.info.code);
			//trace(video.videoWidth, video.videoHeight);
//			_videoStream.removeEventListener(NetStatusEvent.NET_STATUS, onNET_STATUS);
			switch(e.info.code) {
				case "NetStream.Play.Stop":
					ToolKit.log("视频播放结束");	
					//					pauseVideo();
					this.dispatchEvent(new Event(Event.COMPLETE));
					this.dispatchEvent(new Event(VIDEO_PLAY_END));
					break;
				case "NetStream.Play.Start":
					ToolKit.log("视频播放已开始");	
					setVideoSize(_stageWidth,_stageHeight);
					//setVideoSize(_video.videoWidth,_video.videoHeight);
					break;
				case "NetStream.Buffer.Full":
					ToolKit.log("NetStream.Buffer.Full");	
					//pauseVideo();
					if (_isOne) {
						_isOne = false;
						
						if (!_isAutoPlay) {
							//pauseVideo();
						}
						setVideoSize(_stageWidth,_stageHeight);
					}
//					trace(_isAutoPlay,"************************");
					this.dispatchEvent(new Event(FULL));
					break;
			}
			
		}
		
		public function setVideoSize(w:Number,h:Number):void
		{
			_stageWidth = w;
			_stageHeight = h;
			//trace("_isAdaptive",_isAdaptive,_videoData);
			if (_videoData == null) {
				_video.width = stageWidth;
				_video.height =stageHeight;
				return;
			}
			
			if(_isAdaptive){
				_video.width = Math.min(stageWidth / _videoData.width, stageHeight /_videoData.height)*_videoData.width;
				_video.height = Math.min(stageWidth / _videoData.width, stageHeight /_videoData.height)*_videoData.height;
				/*var dis:Number=Math.min(stageWidth / _video.width, stageHeight /_video.height);
				_video.width = dis*_video.width;
				_video.height = dis*_video.height;*/
				
			}else{
				_video.width = stageWidth;
				_video.height =stageHeight;
			}
			//trace(_videoData.width,_videoData.height,stageWidth,stageHeight,_video.scaleX);
			_video.x = (stageWidth - _video.width) * 0.5;
			_video.y = (stageHeight - _video.height) * 0.5;
			
			//_video.width=400;
			//_video.height=300;
		}
		
		/**
		 * 获取总时间
		 */
		public function get duration():uint { return _duration; }
		
		/**
		 * 获取时间
		 */
		public function get playTime():Number {  _playTime = _videoStream.time;   return _playTime; }
		
		public function get volume():Number { return _volume; }
		
		public function set volume(value:Number):void 
		{
			_volume = value;
			var sondtransfrom:SoundTransform = new SoundTransform();
			sondtransfrom.volume=_volume;
			_videoStream.soundTransform = sondtransfrom;
		}
		
		public function get stageWidth():Number 
		{
			return _stageWidth;
		}
		
		public function set stageWidth(value:Number):void 
		{
			_stageWidth = value;
		}
		
		public function get stageHeight():Number 
		{
			return _stageHeight;
		}
		
		public function set stageHeight(value:Number):void 
		{
			_stageHeight = value;
		}
		
		public function get isAutoPlay():Boolean
		{
			return _isAutoPlay;
		}
		
		public function set isAutoPlay(value:Boolean):void
		{
			_isAutoPlay = value;
		}
		
		
	}
	
}