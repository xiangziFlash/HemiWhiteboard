package com.views.components.camera
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StageVideoAvailabilityEvent;
	import flash.events.StageVideoEvent;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.StageVideo;
	import flash.media.StageVideoAvailability;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class GetStageVideo extends Sprite
	{
		private var camera:Camera;
		private var stageVideo:StageVideo;
		private var _statusField:TextField;
		public var stageW:Number=0;
		public var stageH:Number=0;
		private var _bmpd:BitmapData;
		private var _bmp:Bitmap;
		
		public function GetStageVideo()
		{
			
		}
		
		public function addCamera():void
		{
			if(stage==null)
			{
				addEventListener(Event.ADDED_TO_STAGE,init);
			}else{
				init();
			}
		}
		
		private function init():void
		{
			removeEventListener(Event.ADDED_TO_STAGE,init);
			
			_statusField = new TextField();
			_statusField.embedFonts = true;
			_statusField.defaultTextFormat = new TextFormat("YaHei_font",20,0x0B0B0B);
			_statusField.autoSize = "left";
			this.addChild(_statusField);
			
			_statusField.text = "正在链接摄像头......";
			_statusField.x = (960-_statusField.width)*0.5;
			_statusField.y = (540-_statusField.height)*0.5;
			stage.addEventListener(StageVideoAvailabilityEvent.STAGE_VIDEO_AVAILABILITY, availabilityChanged);
		}
		
		private function availabilityChanged(e:StageVideoAvailabilityEvent):void
		{
//			_statusField.appendText("StageVideo => " + e.availability + "\n");
			if(e.availability == StageVideoAvailability.AVAILABLE)
			{
				stageVideo = stage.stageVideos[0];
				
				attachCamera();
			}
		}
		
		private function attachCamera():void 
		{
//			_statusField.appendText("Camera.isSupported => " + Camera.isSupported + "\n");
			if(Camera.isSupported){
				camera = Camera.getCamera();
//				trace(camera.width,camera.height,"6++");
				if(camera!=null)
				{
					camera.setMode(stageW,stageH,40);
					camera.setQuality(0,100);
					_bmpd = new BitmapData(camera.width, camera.height);
					stageVideo.addEventListener(StageVideoEvent.RENDER_STATE, onRenderState);
					stageVideo.attachCamera(camera);
				}else{
					_statusField.text ="未检测到摄像头，请检测设备";
				}
				
			}
		}
		
		private function onRenderState(e:StageVideoEvent):void
		{
			_statusField.text ="";
			stageVideo.viewPort = new Rectangle(0, 0,stageW,stageH);
//			stageVideo.viewPort = new Rectangle(0, 0,960,540);
		}
		
		public function closeVideo():void
		{
			camera = Camera.getCamera(null); 
			camera = null; 
			if(stageVideo){
				stageVideo.attachCamera(null);
			}
		}
		
		public function drawVideo():void
		{
			camera.drawToBitmapData(_bmpd);
		}

		public function get bmpd():BitmapData
		{
			return _bmpd;
		}

		
	}
	
}
