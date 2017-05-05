package com.views.components.yuLan
{
	import com.cndragon.baby.plugs.Yulan.SoundPotRes;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class SoundBar extends Sprite
	{
		private var _voArr:Array=[];
		private var _sound:Sound;
		private var _channel:SoundChannel = new SoundChannel();
		private var _urlR:URLRequest = new URLRequest();
		private var _prevSound:SoundPotRes;
		private var _isPlaying:Boolean;
		private var _position:Number;
		public function SoundBar()
		{
			super();
		}
		
		public function setSoundInfo(voArr:Array):void
		{
			_voArr = voArr;
			for(var i:int;i<voArr.length;i++){
				var soundPot:SoundPotRes = new SoundPotRes();
				soundPot.name = "soundPot_"+i;
				soundPot.x = (soundPot.width+5)*i;
				soundPot.tit.mouseEnabled = false;
				soundPot.num.mouseEnabled = false;
				soundPot.num.text = String(i+1);
				soundPot.tit.text = voArr[i].title;
				this.addChild(soundPot);
				soundPot.addEventListener(MouseEvent.CLICK,onSoundClick);
			}
			
		}
		private function onSoundClick(e:MouseEvent):void
		{
			var n:int = e.currentTarget.name.split("_")[1];
			var soundPot:SoundPotRes = e.currentTarget as SoundPotRes;
			if(_prevSound==null){
				_prevSound = soundPot;
				_prevSound.num.textColor = 0xff9900;
				_prevSound.tit.textColor = 0xff9900;
			}else{
				_prevSound.num.textColor = 0x666666;
				_prevSound.tit.textColor = 0x666666;
				
				if(_prevSound == soundPot){
					if(_isPlaying){
						_position = _channel.position;
						_channel.stop();
						_prevSound.num.textColor = 0x666666;
						_prevSound.tit.textColor = 0x666666;
						
					}else{
						_prevSound.num.textColor = 0xff9900;
						_prevSound.tit.textColor = 0xff9900;
						_channel = _sound.play(_position) ;
					}
					_isPlaying = !_isPlaying;
					return;
				}else{
					_prevSound = soundPot;
					_prevSound.num.textColor = 0xff9900;
					_prevSound.tit.textColor = 0xff9900;
				}
			}
			if(_sound){
				_sound = null;
				_channel.stop();
			}
			_sound = new Sound();
			
			_urlR.url = _voArr[n].path;
			
			_sound.load(_urlR);
			_channel = _sound.play();
			_isPlaying = true;
		}
		public function dispose():void
		{
			_voArr=[];
			if(_sound){
				_sound = null;
				_channel.stop();
			}
			while(this.numChildren){
				this.getChildAt(0).addEventListener(MouseEvent.CLICK,onSoundClick);
				this.removeChildAt(0);
			}
		}
	}
}