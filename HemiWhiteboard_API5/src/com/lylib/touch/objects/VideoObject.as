package com.lylib.touch.objects
{
	import com.lylib.components.media.VideoScreen;
	import com.lylib.layout.Padding;
	import com.lylib.touch.element.HorizontalSlider;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TouchEvent;

	/**
	 * 可缩放旋转视频对象，继承自 RotatableScalable
	 * @author 刘渊
	 */	
	public class VideoObject extends Sprite
	{
		
		private var _padding:Padding;
		private var _url:String;
		private var _initWidth:Number;
		private var _initHeight:Number;
		
		private var _bg:Sprite;
		private var _video:VideoScreen;
		private var play_btn:Sprite;
		private var pause_btn:Sprite;
		private var scrubSlider:HorizontalSlider;
		private var volumeSlider:HorizontalSlider;
		
		private var _allowMaxScale:Boolean = false;
		
		/**
		 * @param url				视频的地址
		 * @param initWidth		初始化宽度
		 * @param initHeight		初始化高度
		 * @param bg				背景
		 * @param padding			边距
		 * 
		 */
		public function VideoObject(url:String, initWidth:Number=400, initHeight:Number=300, bg:Sprite=null, padding:Padding=null)
		{
			super();
			
			this._url = url;
			this._initWidth = initWidth;
			this._initHeight = initHeight;
			
			if(padding != null)
			{
				this._padding = padding;
			}else
			{
				this._padding = new Padding();
			}
			
			this._bg = bg;
			if(_bg==null)
			{
				_bg = new Sprite();
				_bg.graphics.beginFill(0xffffff,0.5);
				_bg.graphics.drawRect(-initWidth/2,-initHeight/2,initWidth,initHeight);
				_bg.graphics.endFill();
			}
			else
			{
				_bg.width = initWidth;
				_bg.height = initHeight;
				_bg.x = -_bg.width/2;
				_bg.y = -_bg.height/2;
			}
			addChild(_bg);
			
			_video = new VideoScreen(initWidth-_padding.left-_padding.right-25, initHeight-_padding.top-_padding.bottom-25);
			_video.autoPlay = false;
			_video.onVideoEnd = onVideoEnd;
			_video.onMetaData = onMetaData;
			_video.x = -_video.width/2 - 12.5;
			_video.y = -_video.height/2 - 12.5;
			_video.open(_url);
			addChild(_video);
			
			//播放暂停按钮
			play_btn = new Sprite();
			play_btn.graphics.beginFill(0x00CC00, 0.0);
			play_btn.graphics.drawRect(-initWidth/2 + _padding.left, -initHeight/2+_padding.top, 50, 50);
			play_btn.graphics.endFill();												
			play_btn.graphics.beginFill(0x000000, 0.5);
			play_btn.graphics.moveTo(-initWidth/2 + _padding.left+8, -initHeight/2+_padding.top+7);
			play_btn.graphics.lineTo(-initWidth/2 + _padding.left+8, -initHeight/2+_padding.top+7);
			play_btn.graphics.lineTo(-initWidth/2 + _padding.left+28, -initHeight/2+_padding.top+17);			
			play_btn.graphics.lineTo(-initWidth/2 + _padding.left+8, -initHeight/2+_padding.top+27);			
			play_btn.graphics.lineTo(-initWidth/2 + _padding.left+8, -initHeight/2+_padding.top+7);	
			play_btn.graphics.endFill();
			play_btn.blendMode="invert";
			addChild(play_btn);
			
			pause_btn = new Sprite();
			pause_btn.graphics.beginFill(0xFFFFFF,0.0);
			pause_btn.graphics.drawRect(-initWidth/2 + _padding.left, -initHeight/2+_padding.top, 50, 50);
			pause_btn.graphics.endFill();			
			pause_btn.graphics.beginFill(0x000000, 0.5);
			pause_btn.graphics.drawRect(-initWidth/2 + _padding.left+9, -initHeight/2+_padding.top+7, 6, 20);
			pause_btn.graphics.drawRect(-initWidth/2 + _padding.left+19, -initHeight/2+_padding.top+7, 6, 20);
			pause_btn.graphics.endFill();
			pause_btn.blendMode="invert";	
			addChild(pause_btn);
			pause_btn.visible = false;
			
			play_btn.addEventListener(TouchEvent.TOUCH_BEGIN, onButtonDown);
			pause_btn.addEventListener(TouchEvent.TOUCH_BEGIN, onButtonDown);
			
			
			//滑动条
			scrubSlider = new HorizontalSlider(_video.width,20);
			scrubSlider.x = _video.x;
			scrubSlider.y = _video.y + _video.height + 5;
			//scrubSlider.alpha = 0.5;
			scrubSlider.setValue(0);
			addChild(scrubSlider);
			
			volumeSlider = new HorizontalSlider(_video.height,20);
			volumeSlider.x = _video.x + _video.width + 5;			
			volumeSlider.y= _video.y + _video.height;
			volumeSlider.rotation-=90;	
			//volumeSlider.alpha = 0.5;
			volumeSlider.setValue(0.5);
			addChild(volumeSlider);
			
			scrubSlider.addEventListener(Event.CHANGE, onScrubSlider);
			volumeSlider.addEventListener(Event.CHANGE, onVolumeSlider);
		}
		
		
		private function onButtonDown(e:TouchEvent):void
		{
			if(_video.playing)
			{
				_video.pause();
				play_btn.visible = true;
				pause_btn.visible = false;
			}
			else
			{
				_video.play();
				play_btn.visible = false;
				pause_btn.visible = true;
			}
		}
		
		
		/**
		 * 当视频播放结束
		 */		
		private function onVideoEnd():void
		{
			_video.pause();
			play_btn.visible = true;
			pause_btn.visible = false;
		}
		
		
		/**
		 * 当获得到元数据
		 */		
		private function onMetaData(data:Object):void
		{
				
		}
		
		
		private function onScrubSlider(e:Event):void
		{
			_video.seek(scrubSlider.sliderValue* _video.duration);
		}
		
		
		private function onVolumeSlider(e:Event):void
		{
			//_video.setVolume(volumeSlider.sliderValue);
			_video.volume = volumeSlider.sliderValue
		}
		

		protected function loop(e:Event):void
		{
			if(!scrubSlider.isActive)
			{
				scrubSlider.setValue(_video.time/_video.duration);
			}
		}

		
		
		
		/**
		 * 暂停
		 */		
		public function pause():void
		{
			_video.pause();
			play_btn.visible = true;
			pause_btn.visible = false;
		}
		
	}
}