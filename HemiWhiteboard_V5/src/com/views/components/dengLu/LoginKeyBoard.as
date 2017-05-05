package com.views.components.dengLu
{
	import com.cndragon.baby.plugs.Login.KeyBoard;
	import com.events.LoginEvent;
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.media.StageVideo;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class LoginKeyBoard extends Sprite
	{
		private var _keyboard:KeyBoard;
		private var _userTex:TextField;
		private var _passWordTex:TextField;
		private var _landconf:XML;
		private var _tempName:String="UserT";//默认用户名文本框被选中
		private var _tempindex:int;
		private var _txt1:String;
		private var _txt2:String;
		private var _arr:Array = ["q","w","e","r","t","y","u","i","o","p","7","8","9","a","s","d","f","g","h","j","k","l","","4","5","6","z","x","c","v","b","n","m","0","1","2","3"]; 
		private var _id:int;//记录是第几个用户进入
		private var _xml:XML;
		private var process:NativeProcess;
		private var file:File;
		private var nativeProcessStartupInfo:NativeProcessStartupInfo;
		private var _tt:TextField;
		private var _stageVideo:StageVideo
		
		public function LoginKeyBoard()
		{
		}
		
		public function dispose():void
		{
		}
		
		public function initialize():void
		{
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_keyboard =  new KeyBoard();
//			_keyboard.x =695;
//			_keyboard.y = 307;
			this.addChild(_keyboard);
			_keyboard.UserT.text = "";
			_keyboard.Password.text = "";
//			trace("添加键盘");
			_userTex = _keyboard.getChildByName("UserT") as TextField;
			_passWordTex = _keyboard.getChildByName("Password") as TextField;
			_landconf = ApplicationData.getInstance().configXML;
			
			_tt = new TextField();
			_tt.embedFonts = true;
			_tt.defaultTextFormat = new TextFormat("YaHei_font",20,0xFF0000);
			_tt.autoSize = "left";
			_tt.x = 50;
			_tt.y = 70;
			_tt.mouseEnabled = false;
			this.addChild(_tt);
			_userTex.text = "123";
			_passWordTex.text = "123";
			//process = new NativeProcess();
			//file = new File();
			//NativeApplication.nativeApplication.autoExit = true;
			//file = file.resolvePath("C:/Windows/System32/cmd.exe");
			
			//var processArg:Vector.<String> = new Vector.<String>();
			//processArg[0] = "/c";// 加上/c，表示是cmd的参数
			//trace(ApplicationData.getInstance().assetsPath+"osk.exe","    000000")
		//	processArg[1] = ApplicationData.getInstance().assetsPath+"osk.exe";//bat的路径，建议用绝对路径，如果是相对的，可以用File转一下
			
			//nativeProcessStartupInfo = new NativeProcessStartupInfo();
			//nativeProcessStartupInfo.executable = file;
			
			//nativeProcessStartupInfo.arguments = processArg;
		}
		
		private function initListener():void
		{
			for(var i:int=0;i<37;i++)
			{
				_keyboard["btn_"+i].addEventListener(MouseEvent.MOUSE_DOWN,onBtnClick);
				_keyboard["btn_"+i].addEventListener(MouseEvent.MOUSE_UP,onBtnUp);
				_keyboard["btn_"+i].gotoAndStop(1);
				(_keyboard["btn_"+i] as MovieClip).mouseChildren =false;
				_keyboard["btn_"+i].buttonMode=true;
			}
			
			_userTex.addEventListener(FocusEvent.FOCUS_IN,textInputHandler);
			_passWordTex.addEventListener(FocusEvent.FOCUS_IN,textInputHandler);
			_userTex.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_passWordTex.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_keyboard.landedBtn.addEventListener(MouseEvent.CLICK,onlandClick);
			_keyboard.landedBtn.buttonMode = true;
			_keyboard.canBtn.addEventListener(MouseEvent.CLICK,onClearClick);
			_keyboard.UDiskLogin.addEventListener(MouseEvent.CLICK,onUDiskLoginClick);
			_keyboard.canBtn.buttonMode = true;
			_passWordTex.displayAsPassword = true;
		}
		
		private function onUDiskLoginClick(event:MouseEvent):void
		{
//			this.dispatchEvent(new LoginEvent(LoginEvent.PIANHAO));
//			trace(ApplicationData.getInstance().UDiskJieRu,"UDiskJieRu");
			if(ApplicationData.getInstance().UDiskJieRu==false)
			{
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"没有检测到U盘，请检查是否已接入。");
				Tweener.addTween(_keyboard,{time:1,onComplete:waitEnd});
				function waitEnd():void
				{
					NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"没有检测到U盘");
				}
				return;
			}
			if(ApplicationData.getInstance().UDiskJieRu==true)
			{
				if(ApplicationData.getInstance().UDiskModel)
				{
					ApplicationData.getInstance().userXML = ApplicationData.getInstance().UDiskXML;
					NotificationFactory.sendNotification(NotificationIDs.UDISK_FILE);
				}else{
					//							trace("再次接入")
					NotificationFactory.sendNotification(NotificationIDs.RE_LOGIN);
				}
			}
			//hidePanel();
		}
		
		public function setParams(params:*):void
		{
		}
		
		protected function onDown(event:MouseEvent):void
		{
//			if (process.running)
//			{
//				return;
//			}
//			process.start(nativeProcessStartupInfo);
			stage.focus = event.currentTarget as TextField;
			_tempindex = (event.currentTarget as TextField).caretIndex;
			
			if (_tempindex < (event.currentTarget as TextField).length - 1) {
				_txt1 = (event.currentTarget as TextField).text.substr(0, _tempindex);
				_txt2 = (event.currentTarget as TextField).text.substr(_tempindex, (event.currentTarget as TextField).text.length - 1);				
			}else if (_tempindex == (event.target as TextField).length) {
				_txt1 = (event.currentTarget as TextField).text.substr(0, _tempindex);
				_txt2 = "";			
			}			
		}
		
		protected function textInputHandler(event:FocusEvent):void
		{
			stage.focus = event.currentTarget as TextField;
			_tempName = event.currentTarget.name;		
			_tempindex = (event.currentTarget as TextField).caretIndex;
		}
		
		private function onBtnClick(e:MouseEvent):void
		{
			var id:int = e.target.name.split("_")[1];
			e.target.gotoAndStop(2);			
			
			if (_tempName == "UserT") {
				stage.focus = _userTex;				
				if (_userTex.caretIndex < _userTex.text.length ) {
					_txt1 = _userTex.text.substr(0, _userTex.caretIndex);
					_txt2 = _userTex.text.substr(_userTex.caretIndex, _userTex.text.length - 1);
					_userTex.text = _txt1 + _arr[id] + _txt2;
					_userTex.setSelection(_txt1.length+1, _txt1.length+1);
				//	trace(_userTex.text,"_userTex.text")
				}else {					
					_userTex.appendText(_arr[id]);
					_userTex.setSelection(_userTex.text.length, _userTex.text.length);
				}
			}
			
			if (_tempName == "Password") 
			{					
				stage.focus = _passWordTex;				
				if (_passWordTex.caretIndex < _passWordTex.text.length ) {
					_txt1 = _passWordTex.text.substr(0, _passWordTex.caretIndex);
					_txt2 = _passWordTex.text.substr(_passWordTex.caretIndex, _passWordTex.text.length - 1);
					_passWordTex.text = _txt1 + _arr[id] + _txt2;
					_passWordTex.setSelection(_txt1.length+1, _txt1.length+1);
				}else {
					_passWordTex.appendText(_arr[id]);
					_passWordTex.setSelection(_passWordTex.text.length, _passWordTex.text.length);
				}				
			}
		}
		
		private function onBtnUp(e:MouseEvent):void
		{
			e.target.gotoAndStop(1);
			for(var i:int=0;i<37;i++)
			{				
				_keyboard["btn_"+i].gotoAndStop(1);
			}
		}
		/**
		 * 登录按钮
		 * */
		private function onlandClick(e:MouseEvent):void			
		{	
//			trace("点击登录")
			var file:File = new File(ApplicationData.getInstance().assetsPath+"users/"+_userTex.text+".xml");
			if(file.exists){
				//trace("存在");
				var ldr:URLLoader = new URLLoader();
				ldr.load(new URLRequest(ApplicationData.getInstance().assetsPath+"users/"+_userTex.text+".xml"));
				ldr.addEventListener(Event.COMPLETE,onuserXmlEnd);
			}else{
//				trace("用户名不存在或者密码不正确111",_passWordTex.text);
				_tt.text = "用户名不存在或者密码不正确";
				Tweener.addTween(_tt,{time:0.5,onComplete:changeEnd});
				
				function changeEnd():void
				{
					_tt.text = "";
					_passWordTex.text = "";
				}
			}
		}		
		
		protected function onuserXmlEnd(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			ApplicationData.getInstance().userXML = xml;
			ApplicationData.getInstance().userName = xml.username;
			if(xml.password == _passWordTex.text){
				//trace("用户名和密码正确");
				ApplicationData.getInstance().UDiskModel = false;
				ApplicationData.getInstance().localLessonLogin = true;
				var eve:LoginEvent = new LoginEvent(LoginEvent.LOGIN);
				eve.xml = ApplicationData.getInstance().userXML;
				this.dispatchEvent(eve);
			}else{
//				trace("用户名不存在或者密码不正确000",_passWordTex.text);
				_tt.text = "用户名不存在或者密码不正确";
				Tweener.addTween(_tt,{time:0.5,onComplete:changeEnd});
				
				function changeEnd():void
				{
					_tt.text = "";
					_passWordTex.text = "";
				}
			}
		}
		/**
		 * 消除按钮
		 * */
		private function onClearClick(e:MouseEvent):void
		{
			if (_tempName == "UserT") {
				stage.focus = _userTex;
				if (_txt1 == null) {					
					var txt5:String = _userTex.text;
					var txt6:String = txt5.substr(0, txt5.length - 1);
					_userTex.text = txt6;
				}else {					
					if (_txt2 == "") {
						stage.focus = _userTex;
						if (_tempindex == _userTex.text.length) {							
							var txt8:String = _userTex.text.substr(0, _userTex.text.length - 1);				
							_userTex.text = txt8;							
							_userTex.setSelection(txt8.length, txt8.length);	txt8 = txt8.substr(0, txt8.length - 1);	
						}else {							
							var txt7:String = _txt1.substr(0, _txt1.length - 1);				
							_userTex.text = txt7 ;
							_txt1 = _txt1.substr(0, _txt1.length - 1);
							_userTex.setSelection(txt7.length, txt7.length);	
						}						
					}else {					
						var txt3:String = _txt1.substr(0, _txt1.length );				
						_userTex.text = txt3 + _txt2;
						_txt1 = _txt1.substr(0, _txt1.length - 1);
						_userTex.setSelection(txt3.length, txt3.length);		
					}					
				}					
			}
			
			if (_tempName == "Password") {
				stage.focus = _passWordTex;
				if (_txt1 == null) {
					//trace("正在清除");
					var txt12:String = _passWordTex.text;
					var txt13:String = txt12.substr(0, txt12.length - 1);
					_passWordTex.text = txt13;
				}else {					
					if (_txt2 == "") {
						stage.focus = _passWordTex;
						if (_tempindex == _passWordTex.text.length) {							
							var txt14:String = _passWordTex.text.substr(0, _passWordTex.text.length - 1);				
							_passWordTex.text = txt14;							
							_passWordTex.setSelection(txt14.length, txt14.length);	txt14 = txt14.substr(0, txt14.length - 1);	
						}else {						
							var txt15:String = _txt1.substr(0, _txt1.length - 1);				
							_passWordTex.text = txt15 ;
							_txt1 = _txt1.substr(0, _txt1.length - 1);
							_passWordTex.setSelection(txt15.length, txt15.length);	
						}						
					}else {						
						var txt16:String = _txt1.substr(0, _txt1.length );				
						_passWordTex.text = txt16 + _txt2;
						_txt1 = _txt1.substr(0, _txt1.length - 1);
						_passWordTex.setSelection(txt16.length, txt16.length);		
					}					
				}					
			}			
		}
		
		public function huiFu():void
		{
			_userTex.text ="";
			_passWordTex.text ="";
			_userTex.text = "123";
			_passWordTex.text = "123";
//			ApplicationData.getInstance().localLessonLogin = false;
		}
		
		public function exitKeyBoard():void
		{
			if (process.running)
			{//trace("关闭")
				process.exit();
			}
		}
		
	}
}