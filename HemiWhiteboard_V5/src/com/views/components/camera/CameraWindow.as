package com.views.components.camera
{
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.BitmapData;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CameraWindow extends NativeWindow
	{
		private var _cameraRes:StageVideoCameraRes;
		private var _getStageVideo:GetStageVideo;
		private var _downX:Number=0;
		private var _downY:Number=0;
		
		public function CameraWindow(initOptions:NativeWindowInitOptions=null)
		{
			var initOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			initOptions.systemChrome="none";
			initOptions.resizable=false;
//			initOptions.transparent = true;
			super(initOptions);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			this.width = 960;
			this.height = 540;
			_cameraRes = new StageVideoCameraRes();
			this.stage.addChild(_cameraRes);
			
			_getStageVideo = new GetStageVideo();
			this.stage.addChild(_getStageVideo);
//			_getStageVideo.scaleX = _getStageVideo.scaleY = 0.5;
//			_cameraRes.scaleX = _cameraRes.scaleY = 0.5;
			
			_cameraRes.addEventListener(MouseEvent.MOUSE_DOWN,onResDown);
		}
		
		public function startCamera():void
		{
			this.alwaysInFront = true;
			_getStageVideo.stageW = 960;
			_getStageVideo.stageH = 540;
			_getStageVideo.addCamera();
//			_getStageVideo.scaleX = _getStageVideo.scaleY = 0.5;
			_cameraRes.scaleX = _cameraRes.scaleY = 0.5;
		}
		
		public function showWindows():void
		{
			this.activate();
			this.alwaysInFront = true;
		}
		
		private function onResDown(e:MouseEvent):void
		{
			_downX = stage.mouseX;
			_downY = stage.mouseY;
			this.startMove();
			stage.addEventListener(MouseEvent.MOUSE_UP,onResUp);
		}
		
		private function onResUp(event:MouseEvent):void
		{
			if(Math.abs(stage.mouseX-_downX)<5&&Math.abs(stage.mouseY-_downY)<5)
			{
				if(event.target.name=="btn_0")
				{
					_getStageVideo.drawVideo();
					NotificationFactory.sendNotification(NotificationIDs.OPP_CAMERA,_getStageVideo.bmpd.clone());
				}else if(event.target.name=="btn_2"){
					_getStageVideo.closeVideo();
					if(!this.closed)
					{
						this.close();
					}
				}
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,onResUp);
		}
	}
}