package com.views.components.camera
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Video;

	/**
	 * 获取摄像头画面
	 * @author 祥子
	 * 
	 */	
	public class GetVideo extends Sprite
	{
		private var _camera:Camera;
		private var _stageW:Number;
		private var _stageH:Number;
		private var _video:Video;
		private var _str:String;
		
		public function GetVideo()
		{
			//_camera = Camera.getCamera();
		}
		
		public function startGetVideo():void
		{
			closeCamera();
			_camera = Camera.getCamera();
//			trace(_camera,"_camera");
			if(_camera!=null)
			{
				_stageW = 640;
				_stageH = 360;
				_camera.setMode(_stageW,_stageH,40);
				_camera.setQuality(0,100);
				_camera.addEventListener(StatusEvent.STATUS,onCameraStatus);
				if(_video==null)
				{
					_video = new Video();
					_video.width = _stageW;
					_video.height = _stageH;
					this.addChild(_video);
				}
				_video.attachCamera(_camera);
				//trace("摄像头启动了")
			}else{
//				trace("没有检测到摄像头，请检查摄像头是否连接正常");
				_str = "没有检测到摄像头，请检查摄像头是否连接正常";
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function onCameraStatus(e:StatusEvent):void
		{
//			trace("摄像头开始使用了");
			_str = "摄像头开始使用了";
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		public function closeCamera():void
		{
			_camera = Camera.getCamera(null); 
			_camera = null; 
			if(_video){
				_video.attachCamera(null);
			}
		}

		public function get stageW():Number
		{
			return _stageW;
		}

		public function get stageH():Number
		{
			return _stageH;
		}

		public function get str():String
		{
			return _str;
		}


	}
}