package com.views.components
{
	import com.MusicPlayerRes;
	import com.lylib.codec.ID3V23Parser;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	/**
	 * 
	 * @author 祥子
	 * 音乐播放器
	 */		
	public class Player extends Sprite
	{
		private var _player:MusicPlayerRes;
		private var _play_btn:MovieClip;
		private var _progress_point:MovieClip;
		private var _textContent:TextField;
		private var _timeContent:TextField;
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _position:Number;
		private var _close_btn:MovieClip;
		private var _progress_barWidth:Number=409;
		private var _startX:Number;
		private var _stopX:Number;
		private var _disX:Number;
		private var _time:Number;
		private var _voleum_b:MovieClip;
		private var _voleum_p:MovieClip;
		private var _startX2:Number;
		private var _stopX2:Number;
		private var _disX2:Number;
		private var _tempVoleumBarWidth:Number;
		private var _voleum_bMask:MovieClip;
		private var _sondtransfrom:SoundTransform;
		private var _voleum:Number=0.5;
		private var _length:Number=0;
//		private var _bar:Sprite;
		private var _getCover:Boolean = true;
		public var coverByteArray:ByteArray;
		private var _bar:MovieClip;
		public function Player()
		{
			super();
			initContent();
		}
		
		private function initContent():void
		{
			_player=new MusicPlayerRes();
			this.addChild(_player);
			_play_btn=_player.getChildByName("play_btn") as MovieClip;
			_close_btn=_player.getChildByName("close_btn") as MovieClip;
			_progress_point=_player.getChildByName("progress_point") as MovieClip;
			_voleum_b=_player.getChildByName("voleum_b") as MovieClip;
			_voleum_bMask=_player.getChildByName("voleum_bMask") as MovieClip;
			_voleum_p=_player.getChildByName("voleum_p") as MovieClip;
			_textContent=_player.getChildByName("textContent")as TextField;
			_bar = _player.getChildByName("bar") as MovieClip;
			_textContent.autoSize=TextFieldAutoSize.LEFT;
			_textContent.defaultTextFormat = new TextFormat("YaHei_font",12,0xCCCCCC);
			_timeContent=_player.getChildByName("timeContent") as TextField;
			_timeContent.autoSize=TextFieldAutoSize.LEFT;
			_tempVoleumBarWidth=_voleum_b.width-_voleum_p.width;
			_voleum_b.mask=_voleum_bMask;
			_voleum_bMask.x=_voleum_p.x-_tempVoleumBarWidth/2
			_voleum_p.x=_voleum_p.x+_tempVoleumBarWidth/2;
			_bar.width = 0;
//			_bar=new Sprite();
//			this.addChild(_bar);
//			
//			_bar.x=21;
//			_bar.y=68.5;
			this.addEventListener(Event.REMOVED_FROM_STAGE,onREMOVED_FROM_STAGE);
		}
		private function onCloseDown(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		protected function onCloseUp(event:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
			//this.removeChild(_bar);
			_channel.stop();
			//this.removeChild(_player);
		}
		private function onPlayDown(e:MouseEvent):void
		{
			e.stopPropagation();
		}
		
		protected function onPlayUp(event:MouseEvent):void
		{
			if((event.target as MovieClip).currentFrame==1)
			{
				_position=_channel.position;
				_channel.stop();
				(event.target as MovieClip).gotoAndStop(2);
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			}else
			{
				_position=_channel.position;
				_channel=_sound.play(_position);
				_sondtransfrom.volume=_voleum;
				_channel.soundTransform=_sondtransfrom;
				(event.target as MovieClip).gotoAndStop(1);
				this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		public function setUrl(str:String):void
		{
			if(_sound)
			{
				reset();
			}
			_sound=new Sound();
//			trace(str,"str")
			_sound.load(new URLRequest(str));
			_sound.addEventListener(Event.ID3,onID3);
			_channel=_sound.play();
			
			_channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
			_sound.addEventListener(Event.COMPLETE,onSoundLoaded);
			_sondtransfrom = new SoundTransform();
			_sondtransfrom.volume = 0.5;
			_channel.soundTransform=_sondtransfrom;
			_progress_point.x = 56;
//			_bar.graphics.beginFill(0xe0f29c);
//			_bar.graphics.drawRect(0, 0, 1, 5);
//			_bar.graphics.endFill();
			_play_btn.gotoAndStop(2);
			_play_btn.buttonMode = true;
			_close_btn.buttonMode = true;
			_play_btn.addEventListener(MouseEvent.MOUSE_DOWN,onPlayDown);
			_play_btn.addEventListener(MouseEvent.MOUSE_UP,onPlayUp);
			_close_btn.addEventListener(MouseEvent.MOUSE_DOWN,onCloseDown);
			_close_btn.addEventListener(MouseEvent.MOUSE_UP,onCloseUp);
			
			_progress_point.addEventListener(MouseEvent.MOUSE_DOWN, onProgress_pDown);
			_player.getChildByName("volumArea").addEventListener(MouseEvent.MOUSE_DOWN, onVolume_pDown);
			
			if(_getCover){
				var file:File = File.applicationDirectory.resolvePath(str);
				var fs:FileStream = new FileStream();
				fs.open(file, FileMode.READ);
				var data:ByteArray = new ByteArray();
				fs.readBytes(data);
				var id3v2:ID3V23Parser = new ID3V23Parser(data);
				id3v2.parse();
				data = id3v2.apic;
				fs.close();
				if(id3v2.apic.length!=0){
					coverByteArray = data;
				}
				
			}
			
		}
		
		private function onSoundLoaded(e:Event):void
		{
			_play_btn.gotoAndStop(2);
			_channel.stop();
			//_channel=_sound.play(_position);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		protected function onSoundComplete(event:Event):void
		{
			_play_btn.gotoAndStop(2);
			//_sound.play(0);
			_channel.stop();
		}
		public function reset():void
		{
			_channel.stop();
			_progress_point.x = 56;
			_bar.width = 0;
			_tempVoleumBarWidth=_voleum_b.width-_voleum_p.width;
			_voleum_bMask.x=55-_tempVoleumBarWidth/2
			_voleum_p.x=55+_tempVoleumBarWidth/2;
		
			_play_btn.gotoAndStop(2);
			_play_btn.removeEventListener(MouseEvent.MOUSE_DOWN,onPlayDown);
			_play_btn.removeEventListener(MouseEvent.MOUSE_UP,onPlayUp);
			_close_btn.removeEventListener(MouseEvent.MOUSE_DOWN,onCloseDown);
			_close_btn.removeEventListener(MouseEvent.MOUSE_UP,onCloseUp);
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			_progress_point.removeEventListener(MouseEvent.MOUSE_DOWN, onProgress_pDown);
			_player.getChildByName("volumArea").removeEventListener(MouseEvent.MOUSE_DOWN, onVolume_pDown);
			_sound=null;
		}
		public function stopPlayer():void
		{
			_channel.stop();
			_play_btn.gotoAndStop(1);
			_position= 0;
			
		}
		public function playPlayer():void
		{
			_play_btn.gotoAndStop(2);
			_channel = _sound.play(_position);
			
		}
		
		private function onREMOVED_FROM_STAGE(event:Event):void
		{
			
		}
		protected function onVolume_pDown(event:MouseEvent):void
		{
			event.stopPropagation();
			_startX2 = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onVolume_pMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onVolume_pUp);
		}
		
		protected function onVolume_pUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onVolume_pMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onVolume_pUp);
		}
		
		protected function onVolume_pMove(event:MouseEvent):void
		{
			_stopX2 = mouseX;
			_disX2 = _voleum_p.x + _stopX2 - _startX2;
			_startX2 = _stopX2;
			_voleum_p.x = _disX2;
			_voleum_bMask.x=_disX2-_voleum_bMask.width;
			if (_voleum_p.x <= 55)
			{
				_voleum_p.x = 55;
			}
			if (_voleum_p.x >= 55+_tempVoleumBarWidth)
			{
				_voleum_p.x =55+_tempVoleumBarWidth;
			}
			_voleum=(_disX2-55)/_tempVoleumBarWidth;
			_sondtransfrom.volume=_voleum;
			_channel.soundTransform=_sondtransfrom;
		}
		
		protected function onProgress_pDown(event:MouseEvent):void
		{
			event.stopPropagation();
			_channel.stop();
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			_startX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onProgress_pMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onProgress_pUp);
		}
		
		protected function onProgress_pUp(event:MouseEvent):void
		{
			_play_btn.gotoAndStop(1);
			_channel=_sound.play(_position);
			_sondtransfrom.volume=_voleum;
			_channel.soundTransform=_sondtransfrom;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onProgress_pMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onProgress_pUp);
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		protected function onProgress_pMove(event:MouseEvent):void
		{
			_stopX = mouseX;
			_disX = _progress_point.x + _stopX - _startX;
			
			_progress_point.x = _disX;
			_startX = _stopX;
			
			_bar.width = _disX-56;
			if (_progress_point.x <= 56)
			{
				_progress_point.x = 56;
			}
			if (_progress_point.x >= 56+_progress_barWidth)
			{
				_progress_point.x =56+_progress_barWidth;
			}
//			_time = _sound.length * (_disX - 21) /_progress_barWidth;
			_position = _sound.length * (_disX - 56) /_progress_barWidth;
			
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var barWidth:int = 409;
			var barHeight:int = 8;
			var loaded:int = _sound.bytesLoaded;
			var total:int = _sound.bytesTotal;
			var length:int = _sound.length;
			var positon:int = _channel.position;
			if (total > 0)
			{
				var presentBuffered:Number = loaded / total;
				length /= presentBuffered;
				var precentPlayed:Number = positon / length;
				if(precentPlayed){
//					_bar.graphics.beginFill(0xe0f29c);
//					_bar.graphics.drawRect(0, 0, barWidth * precentPlayed, barHeight);
//					_bar.graphics.endFill();
					_bar.width = barWidth * precentPlayed;
					_progress_point.x=56+barWidth * precentPlayed;
				}
			}
			_timeContent.text=String(int(int(_channel.position/1000)/60)<10?"0"+int(int(_channel.position/1000)/60):int(int(_channel.position)/60))+":"+String(int(int(_channel.position/1000)%60)<10?"0"+int(int(_channel.position/1000)%60):int(int(_channel.position/1000)%60))+"/"+String(int(int(_sound.length/1000)/60)<10?"0"+int(int(_sound.length/1000)/60):int(int(_sound.length/1000)/60))+":"+String(int(int(_sound.length/1000)%60)<10?"0"+int(int(_sound.length/1000)%60):int(int(_sound.length/1000)%60));
		}
		
		private function onID3(event:Event):void
		{
//			trace(_sound.id3.songName,"歌名")
			try
			{
				_textContent.text=_sound.id3.songName;
			} 
			catch(error:Error) 
			{
				trace("获取歌名出错");
			}
			
			
		}
		
		public function setTitle(str:String):void
		{
			_textContent.text = str;
		}
	}
}