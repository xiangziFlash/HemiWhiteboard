package  com.views.components.panel
{
	import com.models.ApplicationData;
	import com.models.vo.FullShowAppVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.views.components.CatorContainer;
	import com.windows.FullAppWindow;
	import com.windows.MinAppWindow;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	public class GongZhuPanel extends Sprite
	{
		private var _gongZhuPanelRes:GongZhuPanelRes;
		private var _isClock:Boolean;
		private var _timer:Timer;
		private var _cator:CatorContainer;
		private var _isJiSuanQi:Boolean;
		private var fullWin:MinAppWindow;
		private var _process:NativeProcess;
		
		public function GongZhuPanel()
		{
			_gongZhuPanelRes = new GongZhuPanelRes();
			this.addChild(_gongZhuPanelRes);
			
			_timer = new Timer(500);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.reset();
			_timer.stop();
			
			_gongZhuPanelRes.addEventListener(MouseEvent.CLICK,onGongZhuClick);
			//this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			//this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		
		private function onGongZhuClick(event:MouseEvent):void
		{
			if(event.target.name.split("_")[0]!="btn")return;
			if(event.target.name=="btn_0"){
				var file1:File=File.applicationDirectory;   
				var path:String=file1.nativePath+"/";
				var pattern:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
				path = path.replace(pattern, "/");

				/*var vo:FullShowAppVO = new FullShowAppVO();
				vo.appType = FullShowAppVO.EXE_APP;
				vo.appUrl = path+"Server/capture.exe";
				NotificationFactory.sendNotification(NotificationIDs.CAMERA_VIDEO_LUZHI,vo);*/
				NotificationFactory.sendNotification(NotificationIDs.CAMERA_VIDEO_LUZHI);
//				var vo:FullShowAppVO = new FullShowAppVO();
//				vo.appType = FullShowAppVO.EXE_APP;
//				vo.appUrl = path+"VideoPlay/VideoPlay.exe";
//				NotificationFactory.sendNotification(NotificationIDs.CAMERA_VIDEO_LUZHI,vo);
			}else if(event.target.name=="btn_1"){//时钟
				if(_isClock){
					_isClock =false;
				}else{
					_isClock = true;
				}
				NotificationFactory.sendNotification(NotificationIDs.OPEN_CLOCK,_isClock);
			}else if(event.target.name=="btn_2"){//计算器
//				if(_isJiSuanQi){
//					_isJiSuanQi =false;
//				}else{
//					_isJiSuanQi = true;
//				}
				NotificationFactory.sendNotification(NotificationIDs.OPEN_JISUANQI);
			}
		}
		
		private function onOver(e:MouseEvent):void
		{
			_timer.stop();
		}
		
		public function onOut(e:MouseEvent):void
		{
//			_timer.reset();
//			_timer.start();
		}
		
		public function gotoStop(id:int):void
		{
			_gongZhuPanelRes.gotoAndStop(id);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			this.visible = false;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function openExe(vo:FullShowAppVO):void
		{
			var file:File = new File(vo.appUrl);
			//file = new File("c:\windows\system32\ping.exe");
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = file;		
			nativeProcessStartupInfo.arguments = vo.args;
			if(!_process){
				_process = new NativeProcess();
			}else{
				_process.exit(true);
			}
			_process.addEventListener(NativeProcessExitEvent.EXIT,onEXIT);
		//	_process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR,onIO_ERROR);
			_process.start(nativeProcessStartupInfo);
		}
		
		/**
		 * 加载应用程序出错，自动关闭
		 * */
		private function onIO_ERROR(event:IOErrorEvent):void
		{
			_process=null;
			closeApp();
		}
		
		private function onEXIT(event:NativeProcessExitEvent):void
		{
			_process=null;
			closeApp();
		}
		/**
		 * 关闭应用程序
		 */
		private function closeApp():void 
		{			
		
		}
	}
}