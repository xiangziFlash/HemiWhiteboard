package com.windows
{
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.AutoOppMedia;
	import com.scxlib.ShotScreen;
	import com.tweener.transitions.Tweener;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.media.SoundMixer;
	import flash.system.Capabilities;
	import flash.utils.setTimeout;
	
	public class CloseButtonWindow extends NativeWindow
	{
		private var _spCon:Sprite;
		private var closeBtn:FullShowAppBackBtnRes;
		private var _shotScreen:ShotScreen;
		private var _tiShiKuang:ShotScreenTiShiRes;
		private var _promptBoxWindow:PromptBoxWindow;
		
		public function CloseButtonWindow()
		{
			var winArgs:NativeWindowInitOptions = new NativeWindowInitOptions();
			winArgs.systemChrome = NativeWindowSystemChrome.NONE;
			//winArgs.transparent = false;
			winArgs.transparent = true;
			super(winArgs);
			
			closeBtn = new FullShowAppBackBtnRes();
			closeBtn.x = closeBtn.y = 0;
//			closeBtn.x = Capabilities.screenResolutionX - closeBtn.width;
//			closeBtn.y = Capabilities.screenResolutionY - closeBtn.height;
		
			this.stage.addChild(closeBtn);
			closeBtn.visible = true;
			closeBtn.tiShiTT.mouseChildren = false;
			closeBtn.tiShiTT.enabled = false;
			closeBtn.tiShiTT.mouseEnabled = false;
			closeBtn.tiShiTT.visible = false;
			closeBtn.addEventListener(MouseEvent.CLICK, onExit);
//			closeBtn.addEventListener(MouseEvent.CLICK, onExit1);
			this.alwaysInFront=true;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.alwaysInFront = true;
			this.x = Capabilities.screenResolutionX - closeBtn.width;
			this.y = Capabilities.screenResolutionY - closeBtn.height;
		}
		
		private function onExit1(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onExit(event:MouseEvent):void
		{
			if(event.target.name=="btn_0")
			{//截图
				NotificationFactory.sendNotification(NotificationIDs.START_SHOTSCREEN,2);
				closeBtn.visible = false;
				_shotScreen = new ShotScreen();
				_shotScreen.shotScreen();
				_shotScreen.addEventListener(ShotScreen.SHOT_COMPLETE,onShotScreenEnd0);
			}else if(event.target.name=="btn_1"){
				this.dispatchEvent(new Event(Event.CLOSE));
				close();
			}
		}
		
		private function onShotScreenEnd0(event:Event):void
		{
			NotificationFactory.sendNotification(NotificationIDs.START_SHOTSCREEN,1);
			closeBtn.visible = true;
			this.dispatchEvent(new Event(Event.COMPLETE));
			_shotScreen.removeEventListener(ShotScreen.SHOT_COMPLETE,onShotScreenEnd0);
			
			AutoOppMedia.setLocalPath(ApplicationData.getInstance().appPath+"jiepin.png");
			//closeBtn.tiShiTT.visible = true;
			if(_promptBoxWindow==null)
			{
				_promptBoxWindow = new PromptBoxWindow();
			}
			_promptBoxWindow.showWin("正在保存到白板");
			setTimeout(function ():void
			{
				_promptBoxWindow.hideWin();
				delFile(ApplicationData.getInstance().appPath+"jiepin.png");
				delFile(ApplicationData.getInstance().appPath+"jiepin_s.png");
			},2000);
		}
		
		private function onClosing(evt:Event):void{
			evt.preventDefault();
			this.visible=false;
		}
		
		/**删除文件
		 * path:文件路径
		 * 当软件关闭的时候让视频保存的图片删除  清理硬盘空间
		 */
		private function delFile(str:String):void
		{
			var delDirectory:File =new File(str);
			if(!delDirectory.exists)return;
			delDirectory.deleteDirectory(true);
		}
		
		/**
		 * 显示窗口
		 * */
		public function show():void{			
			if(this.active){
				
			}else{
				this.activate();				
			}
			this.visible = true;		
			
		}
		
		/**
		 * 隐藏窗口
		 * */
		public function hide():void{			
			if(this.active){
				
			}else{
				this.activate();				
			}
			this.visible = true;				
		}
		
		public function hideBackBtn():void
		{
			closeBtn.visible = false;
		}
	}
}