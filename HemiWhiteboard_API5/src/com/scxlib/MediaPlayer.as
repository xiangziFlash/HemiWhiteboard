package com.scxlib
{
	import com.adobe.images.BMPDecoder;
	import com.controls.ToolKit;
	import com.controls.utilities.VideoControl;
	import com.lylib.components.media.SwfPlayer;
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.MediaType;
	import flash.net.NetConnection;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	
	/**
	 *  媒体播放器  jpg png swf flv
	 * @author xiangZi
	 * 
	 */	
	public class MediaPlayer extends Sprite
	{
		private var _mediaType:String="";
		private var _mediaVO:MediaVO;
		private var _picLdr:Loader;
		private var _swfPlayer:SwfPlayer;
		
		private var _sW:Number=0;
		private var _sH:Number=0;
		
		//		private var _toolBar:PlayerBarRes;
		private var _toolBar:MovieClip;
		private var _downX:Number;
		private var _downMouseX:Number;
		
		private var _LifepPad:Number=192;	
		private var _RightpPad:Number=1350;	
		private var _RightSound:Number=1876;	
		private var _lifeSound:Number=1753;	
		private var _xiShu:Number;
		
		private var _nowTime:Number;//媒体播放的当前时间
		private var _totalTime:Number;//媒体的总时间
		private var _video:VideoControl;
		private var _nowPlayTime:uint;
		private var _startBtn:MovieClip;
		private var _isPlay:Boolean=false;
		private var _spTool:Sprite;
		
		private var _playerBg:PlayerRes;
		private var _tuYa:GraffitiBoardMouse;
		private var _lineThickness:int = 5;
		private var _lineStyle:int = 1;
		private var _isCir:Boolean =false;
		private var _isEraser:Boolean =false;
		private var _lcolor:uint = 0xFF0000;
		private var _imageBmpd:BitmapData;
		private var _obj:DisplayObject;
		private var _bmp:Bitmap;
		
		private var _stageW:Number=0;
		private var _stageH:Number=0;
		private var _fileBmp:File;
		private var _bmpDec:BMPDecoder;
		private var bmp:Bitmap;
		private var _textF:TextField;
		private var _txtRunTime:TextField;
		private var _txtTotalTime:TextField;
		private var _playTime:Number;
		private var _zongTime:Number;
		
		private var _soundMouseX:Number=0;
		private var _soundDownX:Number=0;
		private var _soundTempX:Number=0;
		private var _nc:NetConnection;

		private var _bmp2:Bitmap;
		private var _imageBmp:Bitmap;

		private var _widthBoo:Boolean;
		public var changeFun:Function;
		
		public function MediaPlayer()
		{
			_playerBg = new PlayerRes();
			_spTool = new Sprite();
			_spTool.graphics.beginFill(0, 0);
			//trace(ApplicationData.getInstance().screenX,ApplicationData.getInstance().screenY,"XYXYX");
			_spTool.graphics.drawRect(0, 0, 1920, 1080);
			_spTool.graphics.endFill();
			//_toolBar = new PlayerBarRes();
			_toolBar =_playerBg.playBar; 
			//_startBtn = _playerBg.startBtn;
			this.addChild(_playerBg);
			this.addChild(_spTool);
			this.addChild(_toolBar);
			
			_toolBar.ListLineMask.mask = _toolBar.ListLine;
			
			_tuYa = new GraffitiBoardMouse();
			_tuYa.touchEnd = touchEnd;
			_tuYa.setWH(1920, 1080);
			_spTool.addChild(_tuYa);
			//_spTool.addChild(_toolBar);
//			_spTool.addChild(_startBtn);
			_tuYa.lcolor = _lcolor;
			_tuYa.isCir = false;
			_tuYa.isEraser = false;
			_tuYa.lineStyle = _lineStyle;
			_tuYa.lineThickness = _lineThickness;
			
			_textF = new TextField();
			_textF.defaultTextFormat = new TextFormat("YaHei_font",20,0xFFFF00);
			_textF.autoSize = "left";
			
			_txtRunTime = _toolBar.getChildByName("playTime") as TextField;
			_txtTotalTime = _toolBar.getChildByName("allTime") as TextField;
			
			_txtRunTime.embedFonts=true;
			_txtRunTime.mouseEnabled=false;
			_txtRunTime.defaultTextFormat=new TextFormat("HeiTi_font",15,0xC6C6C6);
			_txtRunTime.autoSize=TextFieldAutoSize.LEFT;
			_txtRunTime.text="00:00";
			
			_txtTotalTime.embedFonts=true;
			_txtTotalTime.mouseEnabled=false;
			_txtTotalTime.defaultTextFormat=new TextFormat("HeiTi_font",15,0xC6C6C6);
			_txtTotalTime.autoSize=TextFieldAutoSize.LEFT;
			_txtTotalTime.text="00:00";
			
			_tuYa.isGongYong = true;
			//_startBtn = new KaiShiBtnRes();
			//			_playerBg.mouseChildren = true;
			//			_tuYa.visible = false;
			_tuYa.mouseEnabled = false;
			_playerBg.playBar.kongZhi.gotoAndStop(2);
			_toolBar.soundBtn.x = 1819;
			_toolBar.soundMask.width = _toolBar.soundBtn.x-_lifeSound;
			removeListener();
			initListener();
		}
		
		public function changeStyle(lc:uint,ls:int,lt:int,ic:Boolean,ie:Boolean):void
		{
			_tuYa.lcolor = lc;
			_tuYa.isCir = ic;
			_tuYa.isEraser = ie;
			_tuYa.lineStyle = ls;
			_tuYa.lineThickness = lt;
		}
		
		public function touchEnd():void
		{
			if(changeFun)
			{
				changeFun();
			}
		}
		
		public function hideTuYa():void
		{
			//			_tuYa.visible = false;
			_tuYa.mouseEnabled = false;
			removeListener();
		}
		
		public function showTuYa():void
		{
			//			_tuYa.visible = true;
			_tuYa.mouseEnabled = true;
			addListener();
		}
		
		public function clear():void
		{
			_tuYa.clear();
		}
		
		public function addListener():void
		{
			//_tuYa.addListener();
			_tuYa.noTuYa = false;
		}
		
		public function removeListener():void
		{
			//			_tuYa.removeListener();
			_tuYa.noTuYa = true;
		}
		
		public function zanTingMedia():void
		{
			_isPlay=false;
			_playerBg.playBar.kongZhi.gotoAndStop(2);
			if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
			{
				_video.pauseVideo();
				//_playerBg.playBar.kongZhi.gotoAndStop(2);
			}else if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
				_swfPlayer.pausePlay();
			}
		}
		
		private function initListener():void
		{
			_playerBg.doubleClickEnabled = true;
			this.doubleClickEnabled = true;
			_tuYa.doubleClickEnabled = true;
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				if(this.getChildAt(i) is Sprite)
				{
					(this.getChildAt(i) as Sprite).doubleClickEnabled = true;
				}
			}
			_playerBg.startBtn.addEventListener(MouseEvent.CLICK,onStartBtnClick);
			_playerBg.playBar.kongZhi.addEventListener(MouseEvent.MOUSE_DOWN,onBarClick);
			_toolBar.listBar.addEventListener(MouseEvent.MOUSE_DOWN,onListBarDown);
			_toolBar.listBar.addEventListener(TouchEvent.TOUCH_BEGIN,onListBarTOUCH_BEGIN);
			_toolBar.soundBtn.addEventListener(MouseEvent.MOUSE_DOWN,onSoundBtnDown);
			_toolBar.soundBtn.addEventListener(TouchEvent.TOUCH_BEGIN,onSoundBtnTOUCH_BEGIN);
			_playerBg.content.addEventListener(MouseEvent.CLICK,onContentClick);	
			//			this.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		}
		
		public function changeRotation():void
		{
			if(_obj == null)return;
//			trace( _obj.width, _obj.height,"changeRotation");
			_obj.rotation +=90;
			if(_obj.rotation == 90 )
			{
//				trace("1")
				_obj.scaleX = _obj.scaleY = 1;
				_obj.scaleX = _obj.scaleY = Math.min(1920 / _obj.width , 1080 / _obj.height);
				_obj.x = (1920 + _obj.width) * 0.5;
				_obj.y = (1080 - _obj.height) * 0.5;
			} else if(_obj.rotation == 180) {
//				trace("2")
				_obj.scaleX = _obj.scaleY = 1;
				_obj.scaleX = _obj.scaleY = Math.min(1920 / _obj.width , 1080 / _obj.height);
				_obj.x = (1920 + _obj.width) * 0.5;
				_obj.y = (1080 + _obj.height) * 0.5;
			} else if(_obj.rotation == -90) {
//				trace("3")
				_obj.scaleX = _obj.scaleY = 1;
				_obj.scaleX = _obj.scaleY = Math.min(1920 / _obj.width , 1080 / _obj.height);
				_obj.x = (1920-_obj.width) * 0.5;
				_obj.y = (1080 + _obj.height) * 0.5;
			} else if(_obj.rotation == 0) {
//				trace("4")
				_obj.scaleX = _obj.scaleY = 1;
				_obj.scaleX = _obj.scaleY = Math.min(1920 / _obj.width , 1080 / _obj.height);
				_obj.x = (1920 - _obj.width) * 0.5;
				_obj.y = (1080 - _obj.height) * 0.5;
			}
			
			_tuYa.rotation = _obj.rotation;
			_tuYa.scaleX = _tuYa.scaleY = 1;
			_tuYa.scaleX = _tuYa.scaleY = Math.min(1920 / _tuYa.width , 1080 / _tuYa.height);
			if(_widthBoo)
			{
				if(_tuYa.rotation == 180)
				{
//					trace("====1")
					_tuYa.x = _obj.x;
					_tuYa.y = _obj.y + 35;
				} else if(_tuYa.rotation == 0)
				{//trace("------1")
					_tuYa.x = _obj.x;
					_tuYa.y = _obj.y - 40;
				} else {
					_tuYa.x = _obj.x;
					_tuYa.y = _obj.y;
				}
			} else {
				_tuYa.x = _obj.x;
				_tuYa.y = _obj.y;
			}
		}
		
		/**
		 * 
		 * @param bmpd
		 * 
		 */		
		public function addBitmapData(bmpd:BitmapData):void
		{
//			trace(bmpd.width,bmpd.height,"addBitmapData");
			_playerBg.startBtn.visible = false;
			_toolBar.visible= false;
			_bmp = new Bitmap(bmpd);
			_bmp.cacheAsBitmap = true;
			
			if(bmpd.width > 1920)
			{
				trace("_widthBoo")
				_widthBoo = true;
			}
			_bmp.scaleX = _bmp.scaleY = Math.min(ApplicationData.getInstance().screenX/_bmp.width, ApplicationData.getInstance().screenY/_bmp.height);
			_bmp.x = (ApplicationData.getInstance().screenX-_bmp.width)*0.5;
			_bmp.y = (ApplicationData.getInstance().screenY-_bmp.height)*0.5;
			_playerBg.content.addChild(_bmp);
			_obj = _bmp;
			setStageWH(_sW,_sH);
		}
		
		/**
		 * 
		 * @param vo 媒体MediaVO
		 * @param sw 媒体的宽度
		 * @param sh 媒体的高度
		 * 
		 */			
		public function setMediaVO(vo:MediaVO,sw:Number,sh:Number,isBg:Boolean):void
		{
			_sW = sw;
			_sH = sh;
			_mediaVO = vo;
			//			_mediaType = vo.path.split(".")[1];
			ToolKit.log("isHimi     "+vo.isHimi);
			_playerBg.visible = true;
			ToolKit.log(vo.path);
			_mediaType = vo.type;
			if(_mediaVO.isBmpd)
			{
				addBitmapData(_mediaVO.bmpd);
				return;
			}
			ToolKit.log(_mediaType);
			ToolKit.log("_mediaType  "+_mediaType);
//			trace("_mediaType  "+_mediaType);
			if (_mediaType == MediaVO.IMAGE||_mediaType=="jpg"||_mediaType=="JPG"||_mediaType=="png"||_mediaType=="PNG"||_mediaType=="image") 
			{
				_playerBg.content.removeEventListener(MouseEvent.CLICK,onContentClick);
				if (_picLdr != null) {
					_picLdr.unloadAndStop();
					_picLdr.visible = false;
				}
				if (_swfPlayer != null) {
					_swfPlayer.unloadAndStop();
					_swfPlayer.visible = false;
				}
				if(_video){
					_video.closeVideo();
				}
				if (_picLdr == null) {
					_picLdr = new Loader();
					this.addChild(_picLdr);//trace(_mediaType,"_mediaType")
					_picLdr.contentLoaderInfo.addEventListener(Event.COMPLETE, onPicLoaded);
					_picLdr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				}
//				_picLdr.load(new URLRequest(vo.path));
				if(vo.isBmpd)
				{
					vo.btyeArray.position = 0;
					_picLdr.loadBytes(vo.btyeArray);
				}else{
					_picLdr.load(new URLRequest(vo.path));
				}
				_picLdr.visible = true;
				//				_picLdr.mouseEnabled = false;
				_playerBg.startBtn.visible = false;
				_toolBar.visible= false;
				
			}else if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf")
			{
				_playerBg.content.removeEventListener(MouseEvent.CLICK,onContentClick);
				_playerBg.content.addEventListener(MouseEvent.CLICK,onContentClick);
				if (_picLdr != null) {
					_picLdr.unloadAndStop();
					_picLdr.visible = false;
				}
				if (_swfPlayer != null) {
					_swfPlayer.unloadAndStop();
					_swfPlayer.visible = false;
				}
				if(_video){
					_video.closeVideo();
				}
				if(!_swfPlayer){
					_swfPlayer = new SwfPlayer();
					//					this.addChild(_swfPlayer);
					_swfPlayer.addEventListener(Event.CLOSE,onSWFClose);
					_swfPlayer.addEventListener(Event.COMPLETE,onSWFLoaded);
				}
				_swfPlayer.visible = true;
				_swfPlayer.Load(vo.path);
				_toolBar.visible= true;
				_playerBg.startBtn.visible = false;
				//				_swfPlayer.mouseEnabled = false;
			}else if(_mediaType == MediaVO.VIDEO||_mediaType=="flv"||_mediaType=="FLV"||_mediaType=="video")
			{
				_playerBg.content.removeEventListener(MouseEvent.CLICK,onContentClick);
				_playerBg.content.addEventListener(MouseEvent.CLICK,onContentClick);
				if (_picLdr != null) {
					_picLdr.unloadAndStop();
					_picLdr.visible = false;
				}
				
				if(_swfPlayer!=null)
				{
					_swfPlayer.unloadAndStop();
					_swfPlayer.visible = false;
				}
				if(_video == null)
				{
					_video = new VideoControl();
					_video.doubleClickEnabled = true;
					_video.addEventListener(Event.CLOSE,onVideoClose);//视频播放完成 派发关闭事件
					_video.addEventListener(Event.INIT,endVideo);
				}
				
				_video.scaleX = _video.scaleY = Math.min(1920/_video.width,1080/_video.height);
				_video.x = (1920-_video.width)*0.5;
				_video.y = (1080-_video.height)*0.5;
				_video.playVideo(vo.path,false,false);
				_video.setSeek(0);
				_video.pauseVideo();
				_playerBg.content.addChild(_video);
				_toolBar.visible= true;
				_isPlay = false;
				_playerBg.startBtn.visible = false;
				setStageWH(_sW,_sH);
				_obj = _video;
				this.addEventListener(Event.ENTER_FRAME,onEnterFrame);	
			}else if(_mediaType==".bmp"||_mediaType==".BMP"||_mediaType=="bmp"||_mediaType=="BMP"){
				_playerBg.content.removeEventListener(MouseEvent.CLICK,onContentClick);
				if (_picLdr != null) {
					_picLdr.unloadAndStop();
					_picLdr.visible = false;
				}
				if (_swfPlayer != null) {
					_swfPlayer.unloadAndStop();
					_swfPlayer.visible = false;
				}
				if(_video){
					_video.closeVideo();
				}
				_fileBmp = new File(vo.path);
				_fileBmp.load();
				_fileBmp.addEventListener(Event.COMPLETE,onFileBmpEnd);
				_playerBg.startBtn.visible = false;
				_toolBar.visible= false;
			}
		}
		
		private function onFileBmpEnd(event:Event):void
		{
			_fileBmp.removeEventListener(Event.COMPLETE,onFileBmpEnd);
			try
			{
				if(_bmpDec == null)
				{
					_bmpDec = new BMPDecoder();
				}
				var bit:BitmapData=_bmpDec.decode(event.target.data);
				_bmp=new Bitmap(bit)
				_imageBmpd = bit;
				_bmp.scaleX=_bmp.scaleY=Math.min(ApplicationData.getInstance().screenX/bit.width,ApplicationData.getInstance().screenY/bit.height);
				_bmp.x=(ApplicationData.getInstance().screenX-_bmp.width)*0.5;
				_bmp.y=(ApplicationData.getInstance().screenY-_bmp.height)*0.5;
				_playerBg.content.addChild(_bmp);
				setStageWH(_sW,_sH);
			} 
			catch(error:Error) 
			{
				//trace("加载出错了")
				stage.addChild(_textF);
				_textF.text = "加载出错了";
				_textF.x = (195-_textF.textWidth)*0.5;
				_textF.y = (80-_textF.textHeight)*0.5;
				var openFile:File = File.desktopDirectory.resolvePath(_mediaVO.path);
				openFile.openWithDefaultApplication();
				Tweener.addTween(this,{time:0.2,delay:0.4,onComplete:moveEnd});
				
				function moveEnd():void
				{
					stage.removeChild(_textF);
				}
			}
			
		}
		
		/**
		 * 图片加载完成
		 * */
		private function onPicLoaded(e:Event):void
		{
			_picLdr.scaleX = _picLdr.scaleY = Math.min(1920/_picLdr.width, 1080/_picLdr.height);
//			_picLdr.scaleX = _picLdr.scaleY = Math.min(_picLdr.width / ApplicationData.getInstance().screenX,_picLdr.width / ApplicationData.getInstance().screenY);
			
			var sp:Sprite = new Sprite();
			sp.addChild(_picLdr);
			try
			{
				var bmpd:BitmapData = new BitmapData(sp.width, sp.height, true, 0);
				bmpd.draw(sp);
				_imageBmpd = bmpd;
				_imageBmp = new Bitmap(bmpd);
				_imageBmp.x = (1920-_picLdr.width)*0.5;
				_imageBmp.y = (1080-_picLdr.height)*0.5;
				_imageBmp.smoothing = true;
				_playerBg.content.addChild(_imageBmp);
				
				if(_picLdr)
				{
					sp.removeChild(_picLdr);
					(_picLdr.content as Bitmap).bitmapData.dispose();
					(_picLdr.content as Bitmap).bitmapData = null;
					_picLdr.unloadAndStop();
					_picLdr = null;
					sp = null;
				}
				_obj = _imageBmp;
				setStageWH(_sW,_sH);
			}catch(error:Error) 
			{
				//trace("加载出错了")
				stage.addChild(_textF);
				_textF.text = "加载出错了";
				_textF.x = (195-_textF.textWidth)*0.5;
				_textF.y = (80-_textF.textHeight)*0.5;
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
			}
		}
		
		private function endVideo(event:Event):void
		{
			_zongTime = _video.duration;
			_txtTotalTime.text = String(_zongTime);
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
//			trace("onIOError");
			if(_mediaVO.btyeArray == null)return;
			_mediaVO.btyeArray.position = 0;
			var bmpd:BitmapData = new BitmapData(1920,1080,true,0);
			bmpd.setPixels(new Rectangle(0, 0, 1920, 1080), _mediaVO.btyeArray);
			var bmp1:Bitmap = new Bitmap(bmpd);
			_imageBmpd = bmpd;
			bmp1.smoothing = true;	
			bmp1.scaleX = bmp1.scaleY = Math.min(1920/bmp1.width, 1080/bmp1.height);
			bmp1.x = (1920-bmp1.width)*0.5;
			bmp1.y = (1080-bmp1.height)*0.5;
			_playerBg.content.addChild(bmp1);
			_obj = bmp1;
			setStageWH(_sW,_sH);
		}
		/**
		 * swf 加载完成
		 * @param e
		 * 
		 */		
		private function onSWFLoaded(e:Event):void
		{
			_swfPlayer.scaleX=_swfPlayer.scaleY = Math.min(ApplicationData.getInstance().screenX/_swfPlayer.stageW,ApplicationData.getInstance().screenY/_swfPlayer.stageH);
			_swfPlayer.x = (ApplicationData.getInstance().screenX-_swfPlayer.stageW*_swfPlayer.scaleX)*0.5;
			_swfPlayer.y = (ApplicationData.getInstance().screenY-_swfPlayer.stageH*_swfPlayer.scaleY)*0.5;
			//			_tuYa.visible = false;
			removeListener();
			_spTool.addChildAt(_swfPlayer,0);
			setStageWH(_sW,_sH);
			_swfPlayer.play();
			_obj = _swfPlayer;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function uploadMedia(vo:MediaVO):void
		{
			_nc = new NetConnection();
			if(_mediaType == MediaType.VIDEO)
			{
				ToolKit.log("视频服务器地址  "+"rtmp://"+vo.ipAddress+"/whiteBoardFile/videos");
				_nc.connect("rtmp://"+vo.ipAddress+"/whiteBoardFile/videos");
			}
			_nc.client = this;
			_nc.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
		}
		
		private function netStatusHandler(e:NetStatusEvent):void
		{
			switch (e.info.code)
			{
				case "NetConnection.Connect.Success" :
					ToolKit.log("视频地址链接成功了 NetConnection.Connect.Success  "+_mediaVO.path);
					if(_mediaType == MediaVO.VIDEO)
					{
						playSteamVideo();
					}else if(_mediaType == MediaVO.IMAGE)
					{
						
					}
					break;
				case "NetConnection.Connect.Rejected" :
				case "NetConnection.Connect.Failed" :
					ToolKit.log("视频链接  NetConnection.Connect.Failed");
					break;
			}
		}
		
		private function playSteamVideo():void
		{
			_playerBg.content.removeEventListener(MouseEvent.CLICK,onContentClick);
			_playerBg.content.addEventListener(MouseEvent.CLICK,onContentClick);
			ToolKit.log("视频播放  "+_mediaVO.path+_mediaVO.ipAddress),
			_video.setNetVideo(_nc,_mediaVO.path.split(".")[0],true);
			_video.setSeek(0);
			_video.scaleX = _video.scaleY = Math.min(1920/_video.width,1080/_video.height);
			_video.x = (1920-_video.width)*0.5;
			_video.y = (1080-_video.height)*0.5;
			_playerBg.content.addChild(_video);
			
			_toolBar.visible= true;
			_isPlay = false;
			_playerBg.startBtn.visible = false;
			setStageWH(_sW,_sH);
			_obj = _video;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},100);
		}
		
		private function onBarClick(e:MouseEvent):void
		{
			e.stopPropagation();
			e.stopImmediatePropagation();
			if(_isPlay)
			{
				_isPlay=false;
				_playerBg.playBar.kongZhi.gotoAndStop(2);
				if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
					_swfPlayer.pausePlay();
					//					_startBtn.visible = true;
				}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
				{
					_video.pauseVideo();
					//					_startBtn.visible = true;
				}
			}else{
				_isPlay=true;
				_playerBg.playBar.kongZhi.gotoAndStop(1);
				if(_mediaType==_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
					_startBtn.visible = false;
					_swfPlayer.play();
				}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
				{
					_video.resumeVideo();
//					_startBtn.visible = false;
				}
			}
		}
		
		private function onContentClick(e:MouseEvent):void
		{
			if(_isPlay){
				_isPlay = false;
				_playerBg.playBar.kongZhi.gotoAndStop(2);
				if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
					_swfPlayer.pausePlay();
					//					_startBtn.visible = true;
				}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
				{
					_video.pauseVideo();
					//					_startBtn.visible = true;
				}
			}else{
				_isPlay = true;
				_playerBg.playBar.kongZhi.gotoAndStop(1);
				if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
//					_startBtn.visible = false;
					_swfPlayer.play();
				}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
				{
					_video.resumeVideo();
//					_startBtn.visible = false;
				}
			}
		}
		
		private function onStartBtnClick(e:MouseEvent):void
		{
			if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
//				_startBtn.visible = false;
				_isPlay=true;
				_playerBg.playBar.kongZhi.gotoAndStop(1);
				_swfPlayer.play();
			}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
			{
				_isPlay=true;
				_playerBg.playBar.kongZhi.gotoAndStop(1);
				_video.resumeVideo();
//				_startBtn.visible = false;
			}
			//(_toolBar.kongZhi as MovieClip).gotoAndStop(1);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if(_toolBar == null)
			{
				this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				return;
			}
			
			if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
				if(_swfPlayer.currentFrame==_swfPlayer.totalFrames-1){
					_swfPlayer.gotoAndPlay(1);
				}
				_toolBar.listBar.x = 192+1300*(_swfPlayer.currentFrame/_swfPlayer.totalFrames);
			}else if(_mediaType == MediaVO.VIDEO||_mediaType=="flv"||_mediaType=="FLV"||_mediaType=="video")
			{
				_playTime = _video.playTime;
				//trace(_playTime,"_playTime",_zongTime)
				_txtRunTime.text = String(_playTime);
				_txtTotalTime.text=String(int(Math.round(_zongTime)/60)<10?"0"+int(Math.round(_zongTime)/60):int(Math.round(_zongTime)/60))+":"+String(Math.round(_zongTime)%60<10?"0"+Math.round(_zongTime)%60:Math.round(_zongTime)%60);
				_txtRunTime.text=String(int(Math.round(_playTime)/60)<10?"0"+int(Math.round(_playTime)/60):int(Math.round(_playTime)/60))+":"+String(Math.round(_playTime)%60<10?"0"+Math.round(_playTime)%60:Math.round(_playTime)%60);
				_toolBar.listBar.x = 192+1300*(_video.playTime/_video.duration);
			}
			
			_toolBar.ListLineMask.x = _toolBar.listBar.x;
		}
		
		private function onSoundBtnDown(e:MouseEvent):void
		{
			e.stopPropagation();
			_soundDownX = mouseX;
			_soundTempX = mouseX;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onSoundMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onSoundUp);
		}
		
		private function onSoundMove(e:MouseEvent):void
		{
			e.stopPropagation();
			_toolBar.soundBtn.x += (mouseX - _soundDownX)/_toolBar.scaleX;
			_toolBar.soundMask.width=_toolBar.soundBtn.x-_lifeSound;
			_soundDownX = mouseX;
			
			//			trace(_toolBar.listBar.x,"_toolBar.listBar.x")
			if (_toolBar.soundBtn.x>= _RightSound)
			{
				_toolBar.soundBtn.x=_RightSound;
			}
			if (_toolBar.soundBtn.x<=_lifeSound)
			{
				_toolBar.soundBtn.x=_lifeSound;
			}
		}
		
		private function onSoundUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSoundMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSoundUp);
			var volume:Number = (_toolBar.soundBtn.x-_lifeSound)/123;
//			trace(_toolBar.soundBtn.x-_lifeSound,_RightSound,_lifeSound,"_RightSound-_lifeSound",volume);
			
			if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
				//_swfPlayer.gotoAndPlay(int(_swfPlayer.totalFrames*_xiShu));
				//	_swfPlayer
			}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
			{
				//	_nowPlayTime = _video.duration * _xiShu;
				//_video.setSeek(_nowPlayTime);
				//	_isPlay=true;
				//	_playerBg.playBar.kongZhi.gotoAndStop(1);
				//	_video.resumeVideo();
//				trace(volume,"volume");
				_video.volume = volume;
			}
			
		}
		
		private function onListBarDown(e:MouseEvent):void
		{
			e.stopPropagation();
			_isPlay=false;
			_playerBg.playBar.kongZhi.gotoAndStop(2);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			//_video.pauseVideo();
			if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
				_swfPlayer.stop();
			}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
			{
				_video.pauseVideo();
			}
			
			_downX = mouseX;
			_downMouseX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onChangeMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onChangeUp);
		}
		private function onListBarTOUCH_BEGIN(e:TouchEvent):void
		{
			e.stopPropagation();
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onChangeTOUCH_MOVE);
			stage.addEventListener(TouchEvent.TOUCH_END, onChangeTOUCH_END);
		}
		
		private function onSoundBtnTOUCH_BEGIN(e:TouchEvent):void
		{
			e.stopPropagation();
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onSoundBtnTOUCH_MOVE);
			stage.addEventListener(TouchEvent.TOUCH_END, onChangeTOUCH_END);
		}
		
		protected function onChangeMove(event:MouseEvent):void
		{
			event.stopPropagation();
			_toolBar.listBar.x += (mouseX - _downMouseX)/_toolBar.scaleX;
			_toolBar.ListLineMask.x=_toolBar.listBar.x;
			_downMouseX = mouseX;
			
			//			trace(_toolBar.listBar.x,"_toolBar.listBar.x")
			if (_toolBar.listBar.x>= _RightpPad)
			{
				_toolBar.listBar.x=_RightpPad;
			}
			if (_toolBar.listBar.x<=_LifepPad)
			{
				_toolBar.listBar.x=_LifepPad;
			}
		}
		
		private function onChangeTOUCH_MOVE(e:TouchEvent):void
		{
			e.stopPropagation();
		}
		
		private function onChangeTOUCH_END(e:TouchEvent):void
		{
			e.stopPropagation();
			stage.removeEventListener(TouchEvent.TOUCH_MOVE, onSoundBtnTOUCH_MOVE);
			stage.removeEventListener(TouchEvent.TOUCH_END, onSoundBtnTOUCH_END);
		}
		
		private function onSoundBtnTOUCH_END(event:TouchEvent):void
		{
			event.stopPropagation();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onSoundBtnTOUCH_MOVE);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onSoundBtnTOUCH_END);
		}
		
		private function onSoundBtnTOUCH_MOVE(event:TouchEvent):void
		{
			event.stopPropagation();
		}
		
		protected function onChangeUp(event:MouseEvent):void
		{
			event.stopPropagation();
			if (mouseX > _LifepPad && mouseX < _RightpPad )
			{
				_toolBar.listBar.x += (mouseX - _downMouseX)/_toolBar.scaleX;
				_toolBar.ListLineMask.x=_toolBar.listBar.x;
				_downMouseX = mouseY;
			}
			_xiShu = (_toolBar.listBar.x - _LifepPad)/(_toolBar.ListLine.width-_toolBar.listBar.width);
			if(_mediaType == MediaVO.SWF||_mediaType==".swf"||_mediaType==".SWF"||_mediaType=="swf"){
				_swfPlayer.gotoAndPlay(int(_swfPlayer.totalFrames*_xiShu));
				_isPlay=true;
				_playerBg.playBar.kongZhi.gotoAndStop(1);
			}else if(_mediaType == MediaVO.VIDEO||_mediaType==".flv"||_mediaType==".FLV"||_mediaType=="video")
			{
				_nowPlayTime = _video.duration * _xiShu;
				_video.setSeek(_nowPlayTime);
				_isPlay=true;
				_playerBg.playBar.kongZhi.gotoAndStop(1);
				_video.resumeVideo();
			}
//			_startBtn.visible = false;
			//_toolBar.kongZhi.gotoAndStop(1);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onChangeMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onChangeUp);
			//_video.addEventListener(VideoControl.FULL,onVideoFullEnd);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			onEnterFrame(null);
		}
		/**
		 * 
		 * @param w 舞台的宽度
		 * @param h 舞台的高度
		 * 控制播放器的大小
		 */		
		public function setStageWH(w:Number,h:Number):void
		{
			//_playerBg.scaleX = _playerBg.scaleY = Math.min(w / ApplicationData.getInstance().screenX, h/ApplicationData.getInstance().screenY);
			//_spTool.scaleX = _spTool.scaleY = Math.min(w / ApplicationData.getInstance().screenX, h/ApplicationData.getInstance().screenY);
			//			_toolBar.scaleX = _toolBar.scaleY = Math.min(w / 1905, h/105);
			//			_toolBar.y = _playerBg.width-_toolBar.height;
			//			_startBtn.x = (_playerBg.width-_startBtn.width)*0.5
			//			_startBtn.y = (_playerBg.height-_startBtn.height)*0.5
			Tweener.addTween(this,{time:0.05,onComplete:scaleEnd});
			function scaleEnd():void
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		public function setWH(w:Number,h:Number,boo:Boolean):void
		{
			_playerBg.scaleX = _playerBg.scaleY = Math.min(w / ApplicationData.getInstance().screenX, h/ApplicationData.getInstance().screenY);
			_spTool.scaleX = _spTool.scaleY = Math.min(w / ApplicationData.getInstance().screenX, h/ApplicationData.getInstance().screenY);
		}
		
		public function resumeVideo():void
		{
			if(_video){
				_video.resumeVideo();
			}
			_playerBg.playBar.kongZhi.gotoAndStop(1);
		}
		
		public function chongZhi():void
		{
			if(_mediaVO == null)return;
			if(_mediaVO.type == MediaType.VIDEO)
			{
				_video.setSeek(0);
				_video.pauseVideo();
				_isPlay=false;
				_playerBg.playBar.kongZhi.gotoAndStop(2);
			}
		}
		
		/**
		 * 视频播放完成
		 * @param e
		 * 
		 */		
		private function onVideoClose(e:Event):void
		{
			_video.setSeek(0);
			_video.resumeVideo();
			_isPlay=true;
			_playerBg.playBar.kongZhi.gotoAndStop(1);
		}
		/**
		 * swf 播放完成
		 * 
		 */		
		private function onSWFClose():void
		{
			_swfPlayer.gotoAndPlay(1);
		}
		
		public function pauseMedia():void
		{
			if (_swfPlayer != null) {
				_swfPlayer.pausePlay();
			}
			if(_video){
				_video.pauseVideo();
			}
			_playerBg.playBar.kongZhi.gotoAndStop(2);
		}
		
		/*public function cheXiao():void
		{
			if(_tuYa.stepID>0){
				_tuYa.stepID--;
				_tuYa.bmpd = _tuYa.jiLuArr[_tuYa.stepID].clone();
				_tuYa.bmp.bitmapData=_tuYa.bmpd;
			}else{
				_tuYa.bmp.bitmapData = null
				_tuYa.stepID=-1;
			}	
		}
		
		public function chongZuo():void
		{
			if(_tuYa.stepID<_tuYa.jiLuArr.length-1){
				_tuYa.stepID++;
				_tuYa.bmpd = _tuYa.jiLuArr[_tuYa.stepID].clone();
				_tuYa.bmp.bitmapData=_tuYa.bmpd;
			}
		}*/
		
		public function dispose():void
		{
			//			trace("mediaPlayer Dispose")
			_playerBg.startBtn.removeEventListener(MouseEvent.CLICK,onStartBtnClick);
			_playerBg.playBar.kongZhi.removeEventListener(MouseEvent.MOUSE_DOWN,onBarClick);
			_toolBar.listBar.removeEventListener(MouseEvent.MOUSE_DOWN,onListBarDown);
			_toolBar.listBar.removeEventListener(TouchEvent.TOUCH_BEGIN,onListBarTOUCH_BEGIN);
			_toolBar.soundBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onSoundBtnDown);
			_toolBar.soundBtn.removeEventListener(TouchEvent.TOUCH_BEGIN,onSoundBtnTOUCH_BEGIN);
			_playerBg.content.removeEventListener(MouseEvent.CLICK,onContentClick);
			if(_video)
			{
				_video.removeEventListener(Event.CLOSE,onVideoClose);//视频播放完成 派发关闭事件
				_video.removeEventListener(Event.INIT,endVideo);
				_video.closeVideo();
				_video = null;
			}
			
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.removeChild(_playerBg);
			this.removeChild(_spTool);
			this.removeChild(_toolBar);
			if (_picLdr != null) {
				//				(_picLdr.content as Bitmap).bitmapData.dispose();
				_picLdr.unloadAndStop();
				_picLdr.visible = false;
				_picLdr=null;
			}
			if (_swfPlayer != null) {
				_swfPlayer.unloadAndStop();
				_swfPlayer.visible = false;
			}
			
			if(_bmp){
				if(_bmp.bitmapData)
				{
					_bmp.bitmapData.dispose();
					_bmp.bitmapData =null;
				}
				_bmp =null;
			}
			
			if(_bmp2)
			{
				if(_bmp2.bitmapData)
				{
					_bmp2.bitmapData.dispose();
					_bmp2.bitmapData =null;
				}
				_bmp2 = null;
			}
			if(_fileBmp){
				_bmp.bitmapData.dispose();
			}
			_imageBmpd = null;
			
			if(_imageBmp)
			{
				if(_imageBmp.bitmapData)
				{
					_imageBmp.bitmapData.dispose();
					_imageBmp.bitmapData = null;
				}
				_imageBmp = null;
			}
			if(_bmpDec)
			{
				_bmpDec = null;
			}
			
			_tuYa.dispose();
			_spTool.removeChild(_tuYa);
			_mediaVO.dispose();
			_mediaVO = null;
			
			_playerBg=null;
			_obj = null;
			_spTool = null;
			_toolBar = null;
			_tuYa = null;
		}
		
		public function get lineThickness():int
		{
			return _lineThickness;
		}
		
		public function set lineThickness(value:int):void
		{
			_lineThickness = value;
		}
		
		public function get lineStyle():int
		{
			return _lineStyle;
		}
		
		public function set lineStyle(value:int):void
		{
			_lineStyle = value;
		}
		
		public function get isCir():Boolean
		{
			return _isCir;
		}
		
		public function set isCir(value:Boolean):void
		{
			_isCir = value;
		}
		
		public function get isEraser():Boolean
		{
			return _isEraser;
		}
		
		public function set isEraser(value:Boolean):void
		{
			_isEraser = value;
		}
		
		public function get lcolor():uint
		{
			return _lcolor;
		}
		
		public function set lcolor(value:uint):void
		{
			_lcolor = value;
		}
		
		public function get imageBmpd():BitmapData
		{
			return _imageBmpd;
		}
		
		public function get obj():DisplayObject
		{
			return _obj;
		}
		
		public function get stageW():Number
		{
			return _stageW;
		}
		
		public function get stageH():Number
		{
			return _stageH;
		}
		
		public function get tuYa():GraffitiBoardMouse
		{
			return _tuYa;
		}
		
		public function set tuYa(value:GraffitiBoardMouse):void
		{
			_tuYa = value;
		}
		
		public function get isPlay():Boolean
		{
			return _isPlay;
		}
		
		public function get playerBg():PlayerRes
		{
			return _playerBg;
		}
		
		public function get mediaType():String
		{
			return _mediaType;
		}
		
		
	}
}