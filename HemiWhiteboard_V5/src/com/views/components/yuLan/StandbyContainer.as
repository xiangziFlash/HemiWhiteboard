package com.views.components.yuLan
{
	import com.lylib.utils.LoaderQueue;
	import com.models.ApplicationData;
	import com.tweener.transitions.Tweener;
	
	import fl.motion.easing.Elastic;
	import fl.transitions.Blinds;
	import fl.transitions.Fade;
	import fl.transitions.Fly;
	import fl.transitions.Iris;
	import fl.transitions.Photo;
	import fl.transitions.PixelDissolve;
	import fl.transitions.Rotate;
	import fl.transitions.Squeeze;
	import fl.transitions.Transition;
	import fl.transitions.TransitionManager;
	import fl.transitions.Wipe;
	import fl.transitions.Zoom;
	import fl.transitions.easing.None;
	import fl.transitions.easing.Strong;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	public class StandbyContainer extends Sprite
	{
		private var _ldr:URLLoader = new URLLoader();
		private var _loaded:Boolean;
		private var _imageContainer:Sprite;
		private var _xml:XML;
		private var _timer:Timer;
		private var _count:int;
		private var _id:int;
		private var _len:int;
		private var _imageArr:Array=[];
		private var _sound:Sound;
		private var _channel:SoundChannel;
		private var _soundArr:Array=[];
		private var _soundCount:int;
		
		private var _nextMC:MovieClip;
		private var _oldMC:MovieClip;
		
		public function StandbyContainer()
		{
			initContent();
			initEventListener();
		}
		
		private function initContent():void
		{
			
			_imageContainer = new Sprite();
			_imageContainer.graphics.beginFill(0x333333);
			_imageContainer.graphics.drawRect(0,0,1920,1080);
			_imageContainer.graphics.endFill();
			_imageContainer.visible = false;
			this.addChild(_imageContainer);
			this.mouseChildren = false;
		}
		private function initEventListener():void
		{
		}
		private function onTimer(e:TimerEvent):void
		{
			//trace(_imageArr[_len-1].name);
			randomInMask(_imageContainer.getChildAt(_imageContainer.numChildren-2) as MovieClip);
			//Tweener.addTween(this,{delay:3,onComplete:function():void{_imageContainer.setChildIndex(_imageArr[_len-2],0);_imageArr.unshift(_imageArr.pop());}});
		}
		
		public function load(url:String):void
		{
			if(!_loaded){
				_ldr.load(new URLRequest(url));
				_ldr.addEventListener(Event.COMPLETE,onXMLLoaded);
			}
		}
		private function onXMLLoaded(e:Event):void
		{
			_loaded = true;
			_xml = XML(e.target.data);
			_len = _xml.image.item.length();
			_id = 0;
			for(var i:int=0;i<_xml.image.item.length();i++){
				LoaderQueue.getInstance().addRes(ApplicationData.getInstance().assetsPath+"待机动画/"+_xml.image.item[i],onComplete);
			}
			_timer = new Timer(int(_xml.time)*1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
		}
		
		private function onComplete(obj:DisplayObject):void
		{
			obj.x = (1920-obj.width)*0.5;
			obj.y = (1080-obj.height)*0.5;
			
			var mc:MovieClip = new MovieClip();
			mc.name = "mc_"+_id;
			mc.addChild(obj);
			_imageContainer.addChild(mc);
			_imageArr.push(mc);
			_id++;
			//trace(_id);
			if(_id >= _xml.image.item.length()){
				play();
			}
		}
		public function play():void
		{
			_imageContainer.visible = true;
			for(var i:int = 0;i<_imageArr.length;i++){
				_imageArr[i].visible = false;	
				_imageContainer.addChild(_imageArr[1]);
			}
			_imageContainer.addChild(_imageArr[1]);
			_imageContainer.addChild(_imageArr[2]);
			_imageContainer.addChild(_imageArr[0]);
			_imageContainer.swapChildrenAt(1,0);
			//_imageArr[_len-1].visible = true;							
			
			_timer.start();
			randomInMask(_imageContainer.getChildAt(_imageContainer.numChildren-1) as MovieClip);
			/*Tweener.addTween(this,{delay:3,onComplete:function():void{
				_imageContainer.setChildIndex(_imageArr[_len-2],0);
				_imageArr.unshift(_imageArr.pop());

			}});*/
			
			if(!_sound){
				_sound = new Sound();
				//_channel = new SoundChannel();
				for(var j:int=0;j<_xml.sound.item.length();j++){
					_soundArr.push(_xml.sound.item[j]);
				}
				_sound.load(new URLRequest(ApplicationData.getInstance().assetsPath+"待机动画/"+_xml.sound.item[0]));
				_sound.addEventListener(Event.COMPLETE,onSoundLoaded);
				
				
			}
			_channel=_sound.play();
			_channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
		}
		private function onSoundLoaded(e:Event):void
		{
			trace("soundLoaded");
			//_channel=_sound.play();
			
		}
		private function onSoundComplete(e:Event):void
		{
			trace("soundPlayEnd");
			_soundCount++;
			if(_soundCount == _xml.sound.item.length()){
				_soundCount = 0;
			}
			_sound = null;
			if(!_sound){
				_sound = new Sound();
				for(var j:int=0;j<_xml.sound.item.length();j++){
					_soundArr.push(_xml.sound.item[j]);
				}
				_sound.load(new URLRequest(ApplicationData.getInstance().assetsPath+"待机动画/"+_xml.sound.item[_soundCount]));
				_sound.addEventListener(Event.COMPLETE,onSoundLoaded);
				_channel.stop();
				_channel=_sound.play();
				_channel.addEventListener(Event.SOUND_COMPLETE,onSoundComplete);
			}
			
		}
		public function reset():void
		{
			_channel.stop();
			_sound = null;
			_timer.stop();
			_timer.reset();
			
			for(var i:int = 0;i<_imageArr.length;i++){
				_imageArr[i].visible = false;	
				_imageContainer.addChild(_imageArr[1]);
			}
			_imageContainer.addChild(_imageArr[1]);
			_imageContainer.addChild(_imageArr[2]);
			_imageContainer.addChild(_imageArr[0]);
			_imageContainer.swapChildrenAt(1,0);
		}
		private function randomInMask(MC:MovieClip):void
		{
			//picRandom = Math.round( Math.random() * 10 );
			
			_imageContainer.addChild(MC);
			MC.visible=true;
			_nextMC=MC;
			Tweener.addTween(MC,{time:3,onComplete:moveEnd});
			
			switch(24) {
				
				//淡化过渡（淡入、淡出）:
				case 1 :TransitionManager.start(MC,{type:Fade, direction:Transition.IN, duration:3, easing:None.easeNone}); break;  
				case 2 :TransitionManager.start(MC,{type:Fade, direction:Transition.IN, duration:3, easing:None.easeIn}); break;
				//飞行过渡（九个不同的方向):
				case 3 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:1}); break;
				case 4 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:2}); break;
				case 5 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:3}); break;
				case 6 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:4}); break;
				case 7 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:5}); break;
				case 8 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:6}); break;
				case 9 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:7}); break;
				case 10 :TransitionManager.start(MC,{type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:8}); break;
				case 11 :TransitionManager.start(MC, { type:Fly, direction:Transition.IN, duration:3, easing:Elastic.easeOut, startPoint:9 } ); break;
				//划入划出过渡--左上，1；上中，2；右上，3；左中，4；右中，6；左下，7；下中，8；右下，9:
				case 12 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:1}); break;
				case 13 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:2}); break;
				case 14 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:3}); break;
				case 15 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:4}); break;
				case 16 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:6}); break;
				case 17 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:7}); break;
				case 18 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:8}); break;
				case 19 :TransitionManager.start(MC,{type:Wipe, direction:Transition.IN, duration:2, easing:None.easeNone, startPoint:9}); break;
				//光圈过渡:
				case 20 :TransitionManager.start(MC, {type:Iris, direction:Transition.IN, duration:2, easing:Strong.easeOut, startPoint:1, shape:Iris.CIRCLE}); break;
				case 21 :TransitionManager.start(MC, {type:Iris, direction:Transition.IN, duration:2, easing:Strong.easeOut, startPoint:2, shape:Iris.SQUARE}); break;
				case 22 :TransitionManager.start(MC, {type:Iris, direction:Transition.IN, duration:2, easing:Strong.easeOut, startPoint:5, shape:Iris.CIRCLE}); break;
				case 23 :TransitionManager.start(MC, { type:Iris, direction:Transition.IN, duration:2, easing:Strong.easeOut, startPoint:8, shape:Iris.SQUARE } ); break;
				//遮帘(纵向、横向):
				case 24 :TransitionManager.start(MC,{type:Blinds, direction:Transition.IN, duration:2, easing:None.easeNone, numStrips:10, dimension:1}); break;
				case 25 :TransitionManager.start(MC,{type:Blinds, direction:Transition.IN, duration:2, easing:None.easeNone, numStrips:20, dimension:1}); break;
				case 26 :TransitionManager.start(MC,{type:Blinds, direction:Transition.IN, duration:2, easing:None.easeNone, numStrips:20, dimension:0 } ); break;
				//挤压过渡(二个方向):
				case 27 :TransitionManager.start(MC,{type:Squeeze, direction:Transition.IN, duration:2, easing:Elastic.easeOut, dimension:1}); break;
				case 28 :TransitionManager.start(MC,{type:Squeeze, direction:Transition.IN, duration:2, easing:Elastic.easeOut, dimension:2 } ); break;
				//渐变暴光:
				case 29 :TransitionManager.start(MC,{type:Photo, direction:Transition.IN, duration:1, easing:None.easeNone } ); break;
				//旋转过渡:
				case 30 :TransitionManager.start(MC,{type:Rotate, direction:Transition.IN, duration:3, easing:Strong.easeInOut, ccw:false, degrees:360 } ); break;
				//像素溶解: 
				case 31 :TransitionManager.start(MC,{type:PixelDissolve, direction:Transition.IN, duration:2, easing:None.easeNone, xSections:50, ySections:50 } ); break;
				case 32 :TransitionManager.start(MC,{type:PixelDissolve, direction:Transition.IN, duration:2, easing:None.easeNone, xSections:100, ySections:100 } ); break;
				//弹性缩放:
				case 33 :TransitionManager.start(MC,{type:Zoom, direction:Transition.IN, duration:2, easing:Elastic.easeOut}); break;
			}
		
		}
		
		private function moveEnd():void
		{
			//trace("zhizhizhizhi")
			if(_oldMC){
				_imageContainer.addChildAt(_oldMC,0);
			}
			_oldMC=_nextMC;
		}
	}
}