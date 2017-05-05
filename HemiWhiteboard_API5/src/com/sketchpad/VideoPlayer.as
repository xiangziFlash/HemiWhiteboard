package com.sketchpad
{
	import com.cndragon.baby.plugs.Sketchpad.VideoPlayerRes;
	import com.lylib.layout.LayoutManager;
	import com.tweener.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.events.TouchEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	
	public class VideoPlayer extends Sprite
	{
		private var _videoPlayer:VideoPlayerRes;
		private var _video:VideoLjb;
		private var _sondtransfrom:SoundTransform;
		private var _disX:Number;
		private var _startX:Number;
		private var _stopX:Number;
		private var _disX2:Number;
		private var _time:Number;
		private var _voleumBox:VoleumBox;
		private var _isMute:Boolean;
		private var _spMask:Sprite;
		private var _currentVoleum:Number=0.5; 
		private var _width:Number;
		private var _dis:Number = 0;
		public function VideoPlayer()
		{
			initContent();
			super();
		}
		
		private function initContent():void
		{
			_videoPlayer=new VideoPlayerRes();
			this.addChild(_videoPlayer);
			_videoPlayer.playerBar.scroll_p.alpha=0;
			_video = new VideoLjb();
			_videoPlayer.addChild(_video );
			_videoPlayer.addChild(_videoPlayer.playerBar);
			_sondtransfrom = new SoundTransform();
			_sondtransfrom.volume =_currentVoleum;
			_video._videoStream.soundTransform = _sondtransfrom;
//			_videoPlayer.playerBar.visible=false;
			_voleumBox=new VoleumBox();
			_voleumBox.x=559;
			_voleumBox.y=239;
			this.addChild(_voleumBox);
			
			_voleumBox.visible=false;
			_videoPlayer.doubleClickEnabled = true;
			_videoPlayer.video.doubleClickEnabled = true;
			_videoPlayer.playerBar.play_btn.buttonMode =true;
			//_videoPlayer.playerBar.progressBar.mask=_videoPlayer.playerBar.progressBarMask;
			_videoPlayer.playerBar.removeChild(_videoPlayer.playerBar.progressBarMask);
			_videoPlayer.playerBar.progressBar.width = 1;
			initListener();
		}
		public function setVideoURL(str:String):void
		{
			_video.isOne=true;
			_video._videoStream.play(str);
		}

		public function setVideoSize(w:Number,h:Number):void
		{
			_video.isAutoSize=true;
			_video.setVideoSize(w,h);
		}
		private function initListener():void
		{
			_videoPlayer.addEventListener(MouseEvent.MOUSE_DOWN,onVideoDown);
			_videoPlayer.playerBar.play_btn.addEventListener(MouseEvent.MOUSE_DOWN,onPlayDown);
			_videoPlayer.playerBar.scroll_p.addEventListener(MouseEvent.MOUSE_DOWN, onScoll_pDown);
			_videoPlayer.playerBar.scroll_p.addEventListener(TouchEvent.TOUCH_BEGIN, onScoll_pBegin);
			_videoPlayer.playerBar.voleum_btn.addEventListener(MouseEvent.MOUSE_DOWN,onVoleumBtnDown);
			_videoPlayer.playerBar.voleum_btn.addEventListener(TouchEvent.TOUCH_BEGIN,onVoleumBtnBegin);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			_video.addEventListener(Event.COMPLETE,onComplete);
			_video.addEventListener(Event.RESIZE,onVideoResize);
			_video.addEventListener(Event.INIT,onVideoInit);
			_voleumBox.addEventListener(Event.CHANGE,onVoleumChange);
			_voleumBox.addEventListener(Event.CANCEL,onMute);
			_voleumBox.addEventListener(Event.CLOSE,onVoleumClose);
		}
		private function onVoleumClose(e:Event):void
		{
			Tweener.addTween(_voleumBox,{delay:10,time:0.5,visible:false});
		}
		private function onVideoInit(e:Event):void
		{
//			this.stop();
			this.dispatchEvent(new Event(Event.INIT));
		}
		private function onVideoResize(event:Event):void
		{
			// TODO Auto-generated method stub
			//trace("接收到完成事件",_video.videoWidth,_video.videoHeight,_videoPlayer.playerBar.width,_videoPlayer.playerBar.scaleX);
			//LayoutManager.sizeToFit(_videoPlayer.playerBar,_video.stageWidth,_video.stageWidth);
		
			_videoPlayer.playerBar.width = _video.videoWidth;
			_videoPlayer.playerBar.scaleY = _videoPlayer.playerBar.scaleX;
			
			_videoPlayer.playerBar.y = _video.videoHeight - _videoPlayer.playerBar.height-_dis;
			_voleumBox.scaleX = _voleumBox.scaleY = _videoPlayer.playerBar.scaleY;
			_voleumBox.x=_videoPlayer.playerBar.width-_voleumBox.width - 5;
			_voleumBox.y=_videoPlayer.playerBar.y-_voleumBox.height;
			this.dispatchEvent(new Event(Event.RESIZE));
			
		}
		
		public function getPlayerBar():MovieClip
		{
			return _videoPlayer.playerBar;
		}
		public function voleumBoxF():void
		{
			_voleumBox.y=_videoPlayer.playerBar.y-_voleumBox.height;
		}
		public function voleumBoxUF():void
		{
			_voleumBox.y=_videoPlayer.playerBar.y-_voleumBox.height;
		}
		public function setPlayerBarFull(dis:Number):void
		{
			_dis = dis;

			_videoPlayer.playerBar.y = _video.videoHeight - _videoPlayer.playerBar.height-dis;
		}
		private function onMute(event:Event):void
		{
			Tweener.addTween(_voleumBox,{delay:10,time:0.5,visible:false});
			if(_voleumBox.isMute){
				_sondtransfrom.volume =0;
				_video._videoStream.soundTransform = _sondtransfrom;
				_videoPlayer.playerBar.voleum_btn.gotoAndStop(2);
			}else{
				
				_sondtransfrom.volume =_currentVoleum;
				_video._videoStream.soundTransform = _sondtransfrom;
				_videoPlayer.playerBar.voleum_btn.gotoAndStop(1);
			}
		}
		private function onVoleumChange(event:Event):void
		{
			if(_voleumBox.isMute)
			{
				_sondtransfrom.volume =0;
				_currentVoleum=_voleumBox.value;
				_video._videoStream.soundTransform = _sondtransfrom;
			}else
			{
				_sondtransfrom.volume =_voleumBox.value;
				_currentVoleum=_voleumBox.value;
				_video._videoStream.soundTransform = _sondtransfrom;
			}
			Tweener.removeTweens(_voleumBox);
		}
		private function onVoleumBtnDown(event:MouseEvent):void
		{
			//_voleumBox.visible=true;
			event.stopPropagation();
			_videoPlayer.playerBar.voleum_btn.addEventListener(MouseEvent.MOUSE_UP,onVoleumBtnUP);
		}
		
		private function onScoll_pBegin(e:TouchEvent):void
		{
			e.stopPropagation();
			
			stage.addEventListener(TouchEvent.TOUCH_MOVE, onScoll_pTOUCH_MOVE);
			stage.addEventListener(TouchEvent.TOUCH_END, onScoll_pTOUCH_END);
		}
		
		private function onScoll_pTOUCH_END(event:TouchEvent):void
		{
			event.stopPropagation();
		}
		
		private function onScoll_pTOUCH_MOVE(event:TouchEvent):void
		{
			event.stopPropagation();
		}
		
		private function onVoleumBtnBegin(e:TouchEvent):void
		{
			e.stopPropagation();
			_videoPlayer.playerBar.voleum_btn.addEventListener(TouchEvent.TOUCH_END,onVoleumBtnEnd);
		}
		
		private function onVoleumBtnEnd(e:TouchEvent):void
		{
			e.stopPropagation();
		}
		
		private function onVoleumBtnUP(event:MouseEvent):void
		{
			_voleumBox.visible=true;
			Tweener.addTween(_voleumBox,{delay:10,time:0.5,visible:false});
		}
		
		private function onScoll_pDown(event:MouseEvent):void
		{
			//trace(event.target,event.target.name);
			event.stopPropagation();
			//trace("截止事件流");
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_startX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onScoll_pMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onScoll_pUp);
		}
		
		protected function onScoll_pUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onScoll_pMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onScoll_pUp);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onScoll_pMove(event:MouseEvent):void
		{
			event.stopPropagation();
			_stopX = mouseX;
			if(_videoPlayer.playerBar.progressBar.width<_videoPlayer.playerBar.progressBarMask.width){
				if(mouseX>_startX){
					_videoPlayer.playerBar.progressBar.width += (mouseX-_startX)/_videoPlayer.playerBar.scaleX;
				}else{
					_videoPlayer.playerBar.progressBar.width -= (_startX-mouseX)/_videoPlayer.playerBar.scaleX;
				}
				_time = _video._duration * _videoPlayer.playerBar.progressBar.width/_videoPlayer.playerBar.progressBarMask.width;
				_video._videoStream.seek(_time);
				_startX = mouseX;
			}

		}
		
		protected function onComplete(event:Event):void
		{
			_videoPlayer.playerBar.play_btn.gotoAndStop(2);
			_video._videoStream.seek(0);
			_video._videoStream.pause();
			
		}
		
		protected function onEnterFrame(event:Event):void
		{
			_videoPlayer.playerBar.progressBar.width = Math.round(_video._videoStream.time)/Math.round(_video._duration)* _videoPlayer.playerBar.progressBarMask.width;
			_videoPlayer.playerBar.videoTime.text = String(int(Math.round(_video._videoStream.time) / 60)<10?"0"+int(Math.round(_video._videoStream.time) / 60):int(Math.round(_video._videoStream.time) / 60)) + ":" + String(Math.round(_video._videoStream.time) % 60<10?"0"+Math.round(_video._videoStream.time) % 60:Math.round(_video._videoStream.time) % 60)+"/"+"0"+int(Math.round(_video._duration)/60)+":"+String((Math.round(_video._duration)%60)<10?"0"+(Math.round(_video._duration)%60):Math.round(_video._duration)%60);
		}
		
		protected function onVideoDown(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			stage.addEventListener(MouseEvent.MOUSE_UP,onVideoUp);
			//Tweener.removeTweens([_videoPlayer.playerBar,_voleumBox]);
			Tweener.removeAllTweens();
			_videoPlayer.playerBar.visible=true;
			
			if(_voleumBox.visible==true)
			{
				_voleumBox.visible=false;
			}
			this.dispatchEvent(e);
		}
		
		
		protected function onVideoUp(event:MouseEvent):void
		{
			
			stage.removeEventListener(MouseEvent.MOUSE_UP,onVideoUp);
			Tweener.addTween(_videoPlayer.playerBar,{delay:10,time:0.5,visible:false});
			//Tweener.addTween(_voleumBox,{delay:10,time:0.5,visible:false});
		}

		private function onPlayDown(e:MouseEvent):void
		{
			trace("e.target.name",e.target.name);
			e.stopPropagation();
			Tweener.removeTweens(_videoPlayer.playerBar);
			_videoPlayer.playerBar.play_btn.addEventListener(MouseEvent.MOUSE_UP,onPlayUp);
		}
		
		private function onPlayUp(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		public function playControl():void
		{
			if(_videoPlayer.playerBar.play_btn.currentFrame == 1){
				pause();
			}else if(_videoPlayer.playerBar.play_btn.currentFrame == 2){
				resume();
			}
		}
		public function resume():void
		{
			_videoPlayer.playerBar.play_btn.gotoAndStop(1);
			_video._videoStream.resume();
		}
		public function pause():void
		{
			_videoPlayer.playerBar.play_btn.gotoAndStop(2);
			_video._videoStream.pause();
		}
		public function stop():void
		{
			_video._videoStream.seek(0);
			_video._videoStream.pause();
			_videoPlayer.playerBar.play_btn.gotoAndStop(2);
		}
		public function dispose():void
		{
			_video._videoStream.seek(0);
			_video._videoStream.pause();
			_video._videoStream.close();
			_video.parent.removeChild(_video );
			
			this.removeChild(_voleumBox);
			this.removeChild(_videoPlayer);
			
			_videoPlayer.removeEventListener(MouseEvent.MOUSE_DOWN,onVideoDown);
			_videoPlayer.playerBar.play_btn.removeEventListener(MouseEvent.MOUSE_DOWN,onPlayDown);
			_videoPlayer.playerBar.scroll_p.removeEventListener(MouseEvent.MOUSE_DOWN, onScoll_pDown);
			_videoPlayer.playerBar.voleum_btn.removeEventListener(MouseEvent.MOUSE_DOWN,onVoleumBtnDown);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			_video.removeEventListener(Event.COMPLETE,onComplete);
			_video.removeEventListener(Event.RESIZE,onVideoResize);
			_video.removeEventListener(Event.CHANGE,onVideoResize);
			_voleumBox.removeEventListener(Event.CHANGE,onVoleumChange);
			_voleumBox.removeEventListener(Event.CANCEL,onMute);
			_video = null;
		}
		override public function get width():Number
		{
			return _video.videoWidth;
		}
		
		override public function get height():Number
		{
			return _video.videoHeight;
		}
	}
}