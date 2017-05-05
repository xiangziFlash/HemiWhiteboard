package com.views.components.pageMoveMedia
{
	import com.controls.utilities.VideoControl;
	import com.lylib.components.media.SwfPlayer;
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.sketchpad.VideoPlayer;
	import com.views.components.Player;
	import com.windows.FullAppWindow;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author wang
	 */
	public class PageMoveMediaSP1 extends Sprite 
	{
		private var _picLdr:Loader;
		private var _soundPlayer:Player;
		private var _swfPlayer:SwfPlayer;
		private var _stageW:Number=0;
		private var _stageH:Number=0;
		private var _bottomBarH:Number = 0;
		private var _vo:MediaVO;
//		private var _video:VideoControl;
		private var _video:VideoPlayer;
		private var _time:Timer;
		
		private var _bg:Shape;
		private var _color:uint = 0xD9D9D9;
		
		private var _isPlay:Boolean;
		private var _stopIcon:MediaStopIconRes;
		private var _isShow:Boolean;
		private var _mediaType:String="";
		private var _mask:Sprite;
		private var _dis:Number = 0;//播放条距底部距离
		private var _spScaleX:Number;
		private var _spScaleY:Number;
		private var _isLoadEnd:Boolean;
		private var _swfLoaded:Boolean;
		/**
		 * 自适应
		 * */
		private var _isAdaptive:Boolean;
		private var _fullWin:FullAppWindow;
		private var _bmp:Bitmap;
		
		public function PageMoveMediaSP1() 
		{
			//this.mouseChildren= false;
			_bg = new Shape();
			this.addChild(_bg);
		}
		
		/**
		 * 设置显示的媒体
		 * @param	vo	显示的媒体信息
		 * @param	time 多久更换媒体，视频的话该参数无效
		 * @param	isAutoPlay 是否自动播放
		 */
		public function setContent(vo:MediaVO,isAutoPlay:Boolean=true,isAdaptive:Boolean=true,time:Number=5*1000):void
		{
			_vo = vo;
//			trace("---",_vo.path);
			if(_vo.path.split(".")[1]=="swf"||_vo.path.split(".")[1]=="SWF") 
			{
				_mediaType = MediaVO.SWF;
			}else if(_vo.path.split(".")[1]=="jpg"||_vo.path.split(".")[1]=="JPG"||_vo.path.split(".")[1]=="png"||_vo.path.split(".")[1]=="png")
			{
				_mediaType = MediaVO.IMAGE;
			}else if(_vo.path.split(".")[1]=="flv"||_vo.path.split(".")[1]=="FLV"||_vo.path.split(".")[1]=="mp4"||_vo.path.split(".")[1]=="MP4"){
				_mediaType = MediaVO.VIDEO;
			}else if(_vo.path.split(".")[1]=="mp3"||_vo.path.split(".")[1]=="MP3"){
				_mediaType = MediaVO.MP3;
			}
		//	trace("setContent",_mediaType);
			if(_mediaType==null) return;				
			
			_isAdaptive=isAdaptive;
			if (_mediaType == MediaVO.IMAGE||_mediaType == MediaVO.PPT||_mediaType == MediaVO.SWF) {
				if (_picLdr != null) {
					_picLdr.unloadAndStop();
					_picLdr.visible = false;
				}
				if (_picLdr == null) {
					_picLdr = new Loader();
					this.addChild(_picLdr);
					_picLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, onPicLoaded);
					_picLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
					_time = new Timer(5 * 1000, 0);
					_time.addEventListener(TimerEvent.TIMER, onTimer);
				}
				_picLdr.visible = true;
				_picLdr.mouseEnabled = false;
//				trace("开始加载",_mediaType,vo.path);
				_isLoadEnd=false;
				var str:String="";
				if(_mediaType == MediaVO.PPT||_mediaType == MediaVO.SWF){//trace("swfs")
					str = _vo.thumb;
					if(_mediaType == MediaVO.SWF){
						if (_swfPlayer != null) {
							_swfPlayer.unloadAndStop();
							_swfPlayer.visible = false;
						}
						if(!_swfPlayer){
							_swfPlayer = new SwfPlayer();
							this.addChild(_swfPlayer);
							_swfPlayer.addEventListener(Event.COMPLETE,onSWFLoaded);
							_stopIcon = new MediaStopIconRes();
							_stopIcon.mouseEnabled = false;
						}
						_swfPlayer.visible = true;
//						_isLoadEnd=false;
						_swfLoaded = false;
//					
						_stopIcon.visible = false;
						_stopIcon.alpha = 0;
//						_stopIcon.x = (_stageW - _stopIcon.width) * 0.5;
//						_stopIcon.y = (_stageH - _stopIcon.height) * 0.5;
						this.addChild(_stopIcon);
					}
				}else{
					str = _vo.path;
				}
				//trace(str,"===");
				_picLdr.load(new URLRequest(str));
				if (_video != null) {
					//_video.closeVideo();
					_video.stop();
					_video.visible = false;
				}
			}else if (_mediaType== MediaVO.VIDEO) {
				if (_video == null) {
				//	trace("视频+++++++++++++++++++++++++++")
					//_video = new VideoControl();
					//_video.setVideoSize(_stageW, _stageH);
					//_video.addEventListener(Event.CLOSE, onPlayEnd);
					_video = new VideoPlayer();
					_video.setVideoSize(_stageW,_stageH);
					_stopIcon = new MediaStopIconRes();
					//_video.addEventListener(MouseEvent.MOUSE_DOWN,click);
					
				}
				
//				_video.addEventListener(VideoControl.FULL, onVideoComplete);
				_video.addEventListener(Event.RESIZE, onVideoResize);
				_video.addEventListener(Event.INIT, onVideoComplete);
				_video.addEventListener(Event.CHANGE,onVideoPlayClick);
//				_video.playVideo(PATH.uPanStr+_vo.path, false);
//				if(ApplicationData.getInstance().UDiskModel){
//					_video.setVideoURL(ApplicationData.getInstance().UDiskPath+_vo.path);
//				}else{
//					_video.setVideoURL(ApplicationData.getInstance().assetsPath+_vo.path);
//				}
				_video.setVideoURL(_vo.path);
				_stopIcon.mouseEnabled = false;
				_stopIcon.visible = false;
				_stopIcon.x = (_stageW - _stopIcon.width) * 0.5;
				_stopIcon.y = (_stageH - _stopIcon.height) * 0.5;
				_video.visible = true;
				
				
				if (_picLdr != null) {
					_picLdr.unloadAndStop();
					_picLdr.visible = false;
				}
			}else if(_mediaType == MediaVO.MP3){
				if(_soundPlayer==null){
					_soundPlayer = new Player();
					_soundPlayer.scaleY = _soundPlayer.scaleX=1.3;
					_soundPlayer.x = (_stageW-_soundPlayer.width)*0.5;
					_soundPlayer.y = (_stageH-_soundPlayer.height)-_dis;
					_soundPlayer.addEventListener(Event.COMPLETE,onSoundLoaded);
				}
				_soundPlayer.visible = true;
				if(ApplicationData.getInstance().UDiskModel){
					_soundPlayer.setUrl(vo.path);
				}else{
					_soundPlayer.setUrl(vo.path);
				}
				_soundPlayer.alpha = 0.8;
				_soundPlayer.setTitle(vo.title);
				_picLdr = new Loader();
				if(_soundPlayer.coverByteArray==null){
//					if(ApplicationData.getInstance().UDiskModel){
//						_picLdr.load(new URLRequest(ApplicationData.getInstance().UDiskPath+_vo.thumb));
//					}else{
//						_picLdr.load(new URLRequest(ApplicationData.getInstance().assetsPath+_vo.thumb));
//					}
					_picLdr.load(new URLRequest(_vo.thumb));
				}else{
					_picLdr.loadBytes(_soundPlayer.coverByteArray);
				}
				//_soundPlayer.addEventListener(Event.CLOSE,onClosePlayer);
				_picLdr.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			}
			
		
			stop();
			this.addEventListener(Event.REMOVED_FROM_STAGE, onREMOVED_FROM_STAGE);
		}
		private function onVideoStop(e:MouseEvent):void
		{
			_stopIcon.visible = false;
		
		}
		private function onClosePlayer(e:Event):void
		{
			_soundPlayer.visible = false;
		}
		private function onComplete(e:Event):void
		{
			_picLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			var bmp:Bitmap = e.target.content as Bitmap;
//			if(bmp.width>_stageW){
//				bmp.width = _stageW;
//				bmp.scaleY = scaleX;
//				
//			}
//			if(bmp.height>_stageH){
//				bmp.height = _stageH;
//				bmp.scaleX = bmp.scaleY;
//			}
//			
			
			bmp.width = _soundPlayer.width;
			bmp.scaleY = bmp.scaleX;
			bmp.x = (_stageW-bmp.width)*0.5;
			bmp.y = (_stageH-bmp.height)*0.5;
			this.addChild(bmp);
			this.addChild(_soundPlayer);
			_picLdr = null;
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		private function onVideoPlayClick(e:Event):void{
			_video.playControl();
			isPlay = !isPlay;
		}
		public function click(e:MouseEvent=null):void
		{
			if (_mediaType == MediaVO.VIDEO) {
				isPlay = !isPlay;
				_video.playControl();
			}else if(_mediaType == MediaVO.SWF){
				if(!_swfLoaded){
					_bmp.bitmapData.dispose();
					isPlay = false;
					_swfPlayer.Load(_vo.path);
					_swfLoaded = true;
				}else{
					isPlay = !isPlay;
					if(_isPlay){
						_swfPlayer.startPlay();
					}else{
						_swfPlayer.pausePlay();
					}
				}
				
			}else if(_mediaType == MediaVO.PPT){
//				if(!_fullWin){
//					_fullWin = new FullAppWindow();
//				}
//				if(_fullWin.closed){
//					_fullWin = new FullAppWindow();
//				}
//				var fullVO:FullShowAppVO=new FullShowAppVO();
//				fullVO.appUrl= PATH.uPanStr+"ShowPPT_V2.exe";
//				fullVO.appType=FullShowAppVO.EXE_APP;
//				if(PATH.isURead){
//					fullVO.args.push(PATH.uPanStr+_vo.path);
//				}else{
//					fullVO.args.push(PATH.currPath+_vo.path);
//				}
//				
//				_fullWin.openApp(fullVO);
//				_fullWin.hideBackBtn();
				var fileURL:String = "";
//				if(ApplicationData.getInstance().UDiskModel){
//					fileURL = ApplicationData.getInstance().UDiskPath+_vo.path;
//				}else{
//					fileURL = ApplicationData.getInstance().assetsPath+_vo.path;
//				}
				fileURL = _vo.path;
				var file:File = new File(fileURL);
//				trace(file.nativePath);
				file.openWithDefaultApplication(); 
			}
		}
		
		/**
		 * 设置舞台大小
		 * @param	w 舞台宽度
		 * @param	h 舞台高度
		 */
		public function setSatgeWH(w:Number,h:Number):void
		{
			_stageW = w;
			_stageH = h;
			_bg.graphics.clear();
			_bg.graphics.beginFill(_color,0);
			_bg.graphics.drawRect(0, 0, w, h);
			_bg.graphics.endFill();
			if (!_mask) {
				_mask = new Sprite();
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(_color,0);
			_mask.graphics.drawRect(0, 0, w, h);
			_mask.graphics.endFill();
			this.addChild(_mask);
			this.mask = _mask;
			
			//trace("00000",_mediaType,_vo.path,_isLoadEnd);
			if (_video != null&&_mediaType == MediaVO.VIDEO) {
				if(_isAdaptive){
					_video.setVideoSize(_stageW,_stageH);
				}
			}
			if (_picLdr != null&&(_mediaType == MediaVO.IMAGE||_mediaType == MediaVO.PPT||_mediaType == MediaVO.SWF)&&_isLoadEnd&&(!_swfLoaded)) {
				//trace("1111",_picLdr.contentLoaderInfo);
				if(_isAdaptive){
					_picLdr.scaleX=_picLdr.scaleY = Math.min(_stageW / _picLdr.contentLoaderInfo.width, _stageH /_picLdr.contentLoaderInfo.height);
				}else if (_picLdr.width > _stageW || _picLdr.height > _stageH) {
					_picLdr.scaleX=_picLdr.scaleY = Math.min(_stageW / _picLdr.contentLoaderInfo.width, _stageH /_picLdr.contentLoaderInfo.height);
				}
				
				_picLdr.x = (_stageW - _picLdr.contentLoaderInfo.width*_picLdr.scaleX) * 0.5;
				_picLdr.y = (_stageH - _picLdr.contentLoaderInfo.height*_picLdr.scaleY) * 0.5;
				
				_spScaleX = _picLdr.scaleX*_picLdr.contentLoaderInfo.width;
				_spScaleY = _picLdr.scaleY;
				
				_bmp.scaleX = _picLdr.scaleX;
				_bmp.scaleY = _picLdr.scaleY;
				_bmp.x = _picLdr.x;
				_bmp.y = _picLdr.y;
			}
			if(_swfPlayer!=null&&_mediaType == MediaVO.SWF&&_swfLoaded){
				if(_isAdaptive){
					_swfPlayer.scaleX=_swfPlayer.scaleY = Math.min(_stageW / _swfPlayer.stageW, _stageH /_swfPlayer.stageH);
				}else if (_picLdr.width > _stageW || _picLdr.height > _stageH) {
					_swfPlayer.scaleX=_swfPlayer.scaleY = Math.min(_stageW / _swfPlayer.stageW, _stageH /_swfPlayer.stageH);
				}
				
				_swfPlayer.x = (_stageW - _swfPlayer.stageW*_swfPlayer.scaleX) * 0.5;
				_swfPlayer.y = (_stageH - _swfPlayer.stageH*_swfPlayer.scaleY) * 0.5;
				
				_spScaleX = _swfPlayer.scaleX*_swfPlayer.stageW;
				_spScaleY = _swfPlayer.scaleY;
			}
		}
		
		/**
		 * 图片加载完成
		 */
		private function onPicLoaded(e:Event):void 
		{
			//trace("加载完成");
			_isLoadEnd=true;
			_bmp = new Bitmap((_picLdr.content as Bitmap).bitmapData,"auto",true);
			setSatgeWH(_stageW, _stageH);
			this.addChild(_bmp);
//			this.addChild(_picLdr);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * swf加载完成
		 */
		private function onSWFLoaded(e:Event):void
		{
//			_isLoadEnd=true;
			_swfLoaded = true;
			_swfPlayer.stop();
			setSatgeWH(_stageW, _stageH);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * 视频加载完成
		 */
		private function onVideoComplete(e:Event):void 
		{
//			trace("fdsd");
//			_video.removeEventListener(VideoControl.FULL, onVideoComplete);
//			_video.x = (_stageW-_video.width)*0.5;
//			this.addChild(_video);
//			this.addChild(_stopIcon);
//			_video.removeEventListener(Event.INIT, onVideoComplete);
//			trace("init");
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		private function onVideoResize(e:Event):void
		{
			_video.x = (_stageW-_video.width)*0.5;
			this.addChild(_video);
			this.addChild(_stopIcon);
			_video.removeEventListener(Event.RESIZE, onVideoResize);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		/**
		 * 音乐加载完成
		 */
		private function onSoundLoaded(e:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 恢复原始状态，并停止动作
		 */
		public function reset():void
		{
			//trace(_vo,"+++");
			if (_mediaType == MediaVO.IMAGE) {
				_time.reset();
			}else if(_mediaType == MediaVO.SWF){
				_swfLoaded = false;
				_swfPlayer.unloadAndStop();
				
				_picLdr.unloadAndStop();
			}else if (_mediaType == MediaVO.VIDEO) {
//				_video.stopVideo();
				_video.stop();
				isPlay = false;
			}else if(_mediaType == MediaVO.MP3){
				_soundPlayer.reset();
				_picLdr.unloadAndStop();
			}
			
		}
		/**
		 * 打开动作
		 */
		public function play():void
		{
			if (_mediaType == MediaVO.IMAGE) {
				_time.reset();
				_time.start();
			}else if(_mediaType == MediaVO.SWF){
			
			}else if (_mediaType == MediaVO.VIDEO) {
//				_video.resumeVideo();
				_video.resume();
				isPlay = true;
			}else if(_mediaType == MediaVO.MP3){
				_soundPlayer.playPlayer();
			}
			
		}
		
		/**
		 * 停止动作
		 */
		public function stop():void
		{
			if (_mediaType == MediaVO.IMAGE) {
				_time.reset();
				_time.stop();
			}else if(_mediaType == MediaVO.SWF){
				if(_swfLoaded){
					_swfPlayer.unloadAndStop();
					_picLdr.unloadAndStop();
					_swfLoaded = false;
//					if(ApplicationData.getInstance().UDiskModel){
//						_picLdr.load(new URLRequest(ApplicationData.getInstance().UDiskPath+_vo.thumb));
//					}else{
//						_picLdr.load(new URLRequest(ApplicationData.getInstance().assetsPath+_vo.thumb));
//					}
					_picLdr.load(new URLRequest(_vo.thumb));
				}
			}else if (_mediaType == MediaVO.VIDEO) {
//				_video.stopVideo();
				_video.stop();
				isPlay = false;
			}else if(_mediaType == MediaVO.MP3){
				_soundPlayer.stopPlayer();
			}
		}
		public function unload():void
		{
			if (_mediaType == MediaVO.IMAGE) {
				if(_picLdr){
					_picLdr.unloadAndStop();
					_picLdr=null;
				}
			}else if(_mediaType == MediaVO.SWF){
				if(_picLdr){
					_picLdr.unloadAndStop();
					_picLdr=null;
				}
				if(_swfPlayer){
					_swfPlayer.unloadAndStop();
					_swfPlayer = null;
				}
				_swfLoaded = false;
			}else if (_mediaType == MediaVO.VIDEO) {
//				_video.stopVideo();
				_video.stop();
				isPlay = false;
			}else if(_mediaType == MediaVO.MP3){
				_soundPlayer.reset();
				if(_picLdr){
					_picLdr.unloadAndStop();
					_picLdr=null;
				}
			}
		}
		
		/**
		 * 视频播放完成，对外派发结束放映事件
		 */
		private function onPlayEnd(e:Event):void 
		{
//			_video.setSeek(0);
//			_video.pauseVideo();
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * 播放完成，对外派发结束放映事件
		 */
		private function onTimer(e:TimerEvent):void 
		{
			_time.reset();
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		/**
		 * 检测本身从舞台删除后，清理本身
		 */
		private function onREMOVED_FROM_STAGE(e:Event):void 
		{//trace("身从舞台删除后，清理本身")
			removeEventListener(Event.REMOVED_FROM_STAGE, onREMOVED_FROM_STAGE);
			dispose();
		}
		public function dispose():void
		{
			if(_bmp!=null)
			{
				_bmp.bitmapData.dispose();
				_bmp=null;
			}
			if (_picLdr != null) {
				_picLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE, onPicLoaded);
				_picLdr.unloadAndStop();
				this.removeChild(_picLdr);
				_picLdr = null;
			}
			try
			{
				if (_video != null) {
					_video.removeEventListener(Event.CLOSE, onPlayEnd);
					_video.removeEventListener(VideoControl.FULL, onVideoComplete);
					//_video.closeVideo();
					_video.dispose();
					this.removeChild(_video);
					_video = null;
				}
			} 
			catch(error:Error) 
			{
				trace("视频删除出错")
			}
			
			if(_swfPlayer!=null){
				_swfPlayer.unloadAndStop();
				this.removeChild(_swfPlayer);
				_swfPlayer = null;
				_swfLoaded = false;
			}
			if(_soundPlayer!=null){
				_soundPlayer.reset();
				this.removeChild(_soundPlayer);
				_soundPlayer = null;
			}
		}
		public function setPlayerBarFull(dis:Number):void
		{
			_dis = dis;
			if (_mediaType == MediaVO.VIDEO) {
				_video.setPlayerBarFull(_dis);
			}else if(_mediaType == MediaVO.MP3){
				_soundPlayer.y = (_stageH-_soundPlayer.height)-_dis;
			}
		}
		private function setPosition(obj:DisplayObjectContainer,x:Number,y:Number):void
		{
			obj.x = x;
			obj.y = y;
		}
		public function get stageH():Number 
		{
			return _stageH;
		}
		
		public function get stageW():Number 
		{
			return _stageW;
		}
		
		public function get bottomBarH():Number 
		{
			return _bottomBarH;
		}
		
		public function set bottomBarH(value:Number):void 
		{
			_bottomBarH = value;
		}
		
		private function get isPlay():Boolean 
		{
			return _isPlay;
		}
		
		private function set isPlay(value:Boolean):void 
		{
			_isPlay = value;
			if (_isPlay) {
				_stopIcon.visible = false;
			}else {
				_stopIcon.visible = true;
			}
		}
		public function get isShow():Boolean 
		{
			return _isShow;
		}
		
		public function set isShow(value:Boolean):void 
		{
			_isShow = value;
		}
		
		public function get vo():MediaVO 
		{
			return _vo;
		}

		public function get spScaleY():Number
		{
			return _spScaleY;
		}

		public function get spScaleX():Number
		{
			return _spScaleX;
		}


	}

}