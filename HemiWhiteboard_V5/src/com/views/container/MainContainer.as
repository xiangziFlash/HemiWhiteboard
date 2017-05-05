package com.views.container
{
	import com.charts.DrawPieGraph;
	import com.controls.ToolKit;
	import com.events.LoginEvent;
	import com.greensock.TweenLite;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.msgs.AddHimiMediaMSG;
	import com.models.msgs.ClientType;
	import com.models.msgs.ControlType;
	import com.models.msgs.HandleMSG;
	import com.models.msgs.IMSG;
	import com.models.msgs.MSGType;
	import com.models.msgs.MsgHeader;
	import com.models.vo.MediaVO;
	import com.models.vo.StyleVO;
	import com.models.vo.TuXingVO;
	import com.models.vo.UserVO;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.notification.SimpleNotification;
	import com.plter.air.windows.utils.NativeCommand;
	import com.plter.air.windows.utils.ShowCmdWindow;
	import com.res.FileTiShiRes;
	import com.res.UserNumRes;
	import com.res.WangLuoTiShiRes;
	import com.scxlib.GetDateName;
	import com.scxlib.MediaPeiLie;
	import com.scxlib.OppMedia;
	import com.scxlib.ReceiveFileList;
	import com.tweener.transitions.Tweener;
	import com.views.components.CameraPhoto;
	import com.views.components.CatorContainer;
	import com.views.components.CopyLesson;
	import com.views.components.DatagramSocketComponents;
	import com.views.components.DisplaySprite;
	import com.views.components.DrawShapeFill;
	import com.views.components.FuWuQi;
	import com.views.components.HemiContent;
	import com.views.components.HimiLinkContent;
	import com.views.components.HistoryContent;
	import com.views.components.InitServerComponents;
	import com.views.components.LoadingPage;
	import com.views.components.PPTYuLan;
	import com.views.components.SaveLocalImage;
	import com.views.components.SaveMedia;
	import com.views.components.SettingEnvironment;
	import com.views.components.SmallBoardWindows;
	import com.views.components.SocketComponents;
	import com.views.components.SpotlightComponents;
	import com.views.components.TanZhaoDeng;
	import com.views.components.UDiskModel;
	import com.views.components.YingGuangBi;
	import com.views.components.board.BlackBoard;
	import com.views.components.board.BlackBoardContainer;
	import com.views.components.board.BoardThumb;
	import com.views.components.board.SmallBoard;
	import com.views.components.board.SmallBoardContainer;
	import com.views.components.dengLu.LoginPlugin;
	import com.views.components.menu.Menus;
	import com.views.components.shuXueGongZhu.DengBianSanJiao;
	import com.views.components.shuXueGongZhu.LiangJiaoQi;
	import com.views.components.shuXueGongZhu.YuanGui;
	import com.views.components.shuXueGongZhu.YuanGui2;
	import com.views.components.shuXueGongZhu.ZhiChi;
	import com.views.components.shuXueGongZhu.ZhiJiaoSanJiao;
	import com.views.components.tools.PhoneTools1;
	import com.views.components.tools.PhoneTools2;
	import com.views.components.tools.Tools;
	import com.views.components.user.PhoneUser;
	import com.views.components.user.PhoneUserContent;
	import com.views.menu.LoadingBar;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.SyncEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.net.DatagramSocket;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.net.dns.AAAARecord;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	public class MainContainer extends Sprite  implements ILogic
	{
		static public const NAME:String="MainContainer";
		
		private var _tools:Tools;
		private var _spCon:DisplaySprite;
		private var _blackBoardContainer:BlackBoardContainer;
		private var mainApp:NativeWindow;
		private var _chuanLianBtn:ZhuoMianBtnRes;
		private var _boardThumb:BoardThumb;
		private var _dowmY:Number;
		private var _tempY:Number;
		private var _bgID:int=0;
//		private var _smallBoard:SmallBoard;
		private var _smallBoardCon:SmallBoardContainer;
		private var _stageBmpd:BitmapData;
		private var _loadingBar:LoadingBar;
		private var _yingGuangBi:YingGuangBi;
		private var _loginPlugin:LoginPlugin;
		private var _uDiskMod:UDiskModel;   
		private var _cator:CatorContainer;
		private var _zhiChi:ZhiChi;
		private var _zhiJoapSanJiao:ZhiJiaoSanJiao;
		private var _dengBianSanJiao:DengBianSanJiao;
		private var _yuanGui:YuanGui;
		private var _yuanGui2:YuanGui2;
		private var _liangJiaoQi:LiangJiaoQi;
		private var _phoneTools1:PhoneTools1;
		private var _phoneTools2:PhoneTools2;
		private var _desBtn:DesBtnRes;
		private var _userNumRes:UserNumRes;
		private var _smallWindowns:SmallBoardWindows;
		private var _fuWuQi:FuWuQi;
		private var _copyData:CopyLesson;
		private var _stageTT:TextField;
		private var _loadingPage:LoadingPage;
//		private var _tanZhangDeng:SpotlightComponents;
		private var _tanZhangDeng:TanZhaoDeng;
		private var _hitSp:Sprite;
		
		private var _nc:NetConnection;
//		private var _whiteBoardRemoteSO:SharedObject;
		private var _sharedByteArray:ByteArray;
		/*private var _hemiCon:HemiContent;*/
		private var _phoneUserCon:PhoneUserContent;

		private var _voteTitleType:String;
		private var _saveLocalFile:SaveLocalImage;
		
		private var _himiLinkCon:HimiLinkContent;
		private var _process:NativeProcess;
		private var _pptYuLan:PPTYuLan;
		private var _process1:NativeProcess;
		private var _settingEnvironment:SettingEnvironment;
		private var _netTimer:Timer;
		private var _isNet:Boolean = true;
		private var _wangLuoTiShi:WangLuoTiShiRes
		private var _process3:NativeProcess;
		private var _receiveFileList:ReceiveFileList;
		private var _fileTiShi:FileTiShiRes;
		private var _process4:NativeProcess;
		
		private var _saveID:int;
		private var _saveNum:int;
		private var _filePath:String = "";
		private var _saveTimer:Timer;
		private var _isSaveOpp:Boolean = true;
		private var _tempOpp:OppMedia;
		private var _isNew:Boolean;
		private var _isPingBao:Boolean;
		private var _saveArrs:Vector.<OppMedia> = new Vector.<OppMedia>;
		private var _boards:Vector.<BlackBoard> = new Vector.<BlackBoard>;
		private var _initServer:InitServerComponents;
		
		public function MainContainer()
		{
			
		}
		
		public function ininContent():void
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
			mainApp = NativeApplication.nativeApplication.openedWindows[0] as NativeWindow;
			var styleVO:StyleVO = new StyleVO();
			ApplicationData.getInstance().styleVO = styleVO;
			_spCon=NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			this.addChild(_spCon);
			ConstData.spCon = _spCon;
			_tools = new Tools();
			_tools.x = 0;
			_tools.y = 1080-_tools.height;
			
			_blackBoardContainer = new BlackBoardContainer()
			
			_chuanLianBtn = new ZhuoMianBtnRes();
			_chuanLianBtn.x = 1866;
			_chuanLianBtn.y = -912;
			
			_boardThumb = new BoardThumb();
			_boardThumb.scaleX = _boardThumb.scaleY = 1.5;
			_boardThumb.x = 1830;//1853
			_boardThumb.y = 965;
			
			_loadingBar = new LoadingBar();
			
			_yingGuangBi = new YingGuangBi();
			
			_loginPlugin = new LoginPlugin();
			
			_uDiskMod = new UDiskModel();
			
			_phoneTools1 = new PhoneTools1();
			_phoneTools1.y = 1080;
			
			_phoneTools2 = new PhoneTools2();
			_phoneTools2.x = 321.05;
			_phoneTools2.y = -150;
			_spCon.addTopSprite(_phoneTools2);
			_phoneTools2.visible = false;
			
			_desBtn = new DesBtnRes();
			_desBtn.x = 10;
			_desBtn.y = 950;
			_desBtn.scaleX = _desBtn.scaleY = 0.5;
			
			_saveLocalFile = new SaveLocalImage();
//			ConstData.saveLocalFile = _saveLocalFile;
//			_smallBoard = new SmallBoard();
//			_smallBoard.name = "smallBoard";
//			_smallBoard.isXiFu = true;
//			_smallBoard.x = -1550;
//			_smallBoard.y = (1080-64-_smallBoard.height)*0.5;
				
			_loadingPage = new LoadingPage();
			
			_pptYuLan = new PPTYuLan();
			_pptYuLan.closeServer();
			_pptYuLan.openServer();
			ConstData.pptYuLan = _pptYuLan;
			
			/*_netTimer = new Timer(2000);
			_netTimer.addEventListener(TimerEvent.TIMER,onNetTimer);
			_netTimer.reset();
			_netTimer.stop();
			*/
			_smallBoardCon = new SmallBoardContainer();
			_smallBoardCon.name = "smallBoard";
			_smallBoardCon.isXiFu = true;
			_smallBoardCon.scaleX = ConstData.stageScaleX;
			_smallBoardCon.scaleY =   ConstData.stageScaleY;
			_smallBoardCon.x = -(_smallBoardCon.width-20);
			_smallBoardCon.y = (ConstData.stageHeight-64-_smallBoardCon.height)*0.5;
			_smallWindowns = new SmallBoardWindows();
			_smallWindowns.x = _smallWindowns.y = 0;
			_smallWindowns.showWindows();
			
			_tanZhangDeng = new TanZhaoDeng();
			_tanZhangDeng.visible = false;
//			_tanZhangDeng = new SpotlightComponents();
//			_smallWindowns.stage.addChild(_smallBoard);
			_smallWindowns.stage.addChild(_smallBoardCon);
			
			_spCon.addBottomSprite(_blackBoardContainer);
			_spCon.addTopSprite(_tools);
			_spCon.addTopSprite(_phoneTools1);
			_spCon.addPanelSprite(_boardThumb);
			_spCon.addPanelSprite(_chuanLianBtn);
			_spCon.addPanelSprite(_loginPlugin);
			_spCon.addMenuSprite(_yingGuangBi);
			
			/*var datagramSocket:DatagramSocketComponents = new DatagramSocketComponents();
			 
			_userNumRes = new UserNumRes();
			_userNumRes.x = 14;
			_userNumRes.y = 950;
			_spCon.addPanelSprite(_userNumRes);
			_userNumRes.visible =  true;
			_userNumRes.numTitle.embedFonts = true;
			_userNumRes.numTitle.defaultTextFormat = new TextFormat("YaHei_font", 11, 0xFFFFFF);
			_userNumRes.numTitle.text = String(ApplicationData.getInstance().users.length);
			
		
			
			/*_hemiCon = new HemiContent();
			_hemiCon.x = 100;
			_hemiCon.y = 900;
			_spCon.addPanelSprite(_hemiCon);
//			ConstData.hemiContent = _hemiCon;
			_hemiCon.visible = false;*/
		
//			this.addChild(_fuWuQi);
			
			_loadingBar.visible =false;
			_loginPlugin.visible =false;
			_phoneTools1.visible = false;
			_loadingPage.visible = false;
//			_desBtn.visible = false;
			
			_hitSp = new Sprite();
			_hitSp.graphics.beginFill(0,0);
			_hitSp.graphics.drawRect(0,0,Capabilities.screenResolutionX,Capabilities.screenResolutionY);
			_hitSp.graphics.endFill();
			_hitSp.mouseChildren = false;
			_hitSp.mouseEnabled = false;
			_spCon.addHitSprite(_hitSp);
			_hitSp.x = _hitSp.y = 5;
			ApplicationData.getInstance().hitSp = _hitSp;

			var socket:SocketComponents = new SocketComponents();
			socket.updata = socketUpData;
			ConstData.socket = socket;
			
			initListener();
			setNativeProcess();
			
			_saveTimer = new Timer(2500);
			_saveTimer.addEventListener(TimerEvent.TIMER,onSaveTimer);
			_saveTimer.reset();
			_saveTimer.stop();
		}
		
		public function setNativeProcess():void
		{
			ToolKit.getProcessExist("nsmanage",nsmanageBack);
//			ToolKit.getProcessExist("MeetingBoardServer",meetingBoardServerBack);
			ToolKit.getProcessExist("EE4WebCam",EE4WebCamBack);
			ToolKit.getProcessExist("WebSocketsTestServer",webServerBack);
		}
		
		private function onAddStage(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,onAddStage);
			_initServer = new InitServerComponents();
			_initServer.x = _initServer.y = 0;
			_initServer.setStuteFun = initServer;
			ConstData.initServer = _initServer;
			stage.addChild(_loadingPage);
			stage.addChild(_tanZhangDeng);
			_initServer.scaleX = ConstData.stageScaleX;
			_initServer.scaleY = ConstData.stageScaleY;
			
			_loadingPage.scaleX = ConstData.stageScaleX;
			_loadingPage.scaleY = ConstData.stageScaleY;
			
			_tanZhangDeng.scaleX = ConstData.stageScaleX;
			_tanZhangDeng.scaleY = ConstData.stageScaleY;
			_wangLuoTiShi = new WangLuoTiShiRes();
			_wangLuoTiShi.tt.embedFonts = true;
			_wangLuoTiShi.tt.defaultTextFormat = new TextFormat("YaHei_font", 17, 0xFF0000);
			_wangLuoTiShi.tt.autoSize = TextFieldAutoSize.CENTER;
//			stage.addChild(_wangLuoTiShi);
			_wangLuoTiShi.x = 1920 - _wangLuoTiShi.width - 80;
			_wangLuoTiShi.y = 20;
			_wangLuoTiShi.tt.text = "正在配置环境";
			ConstData.wangLuoTiShi = _wangLuoTiShi;
			
			_fileTiShi = new FileTiShiRes();
			_fileTiShi.scaleX = _fileTiShi.scaleY = 0.7;
			_fileTiShi.x = 60;
			stage.addChild(_fileTiShi);
			stage.addChild(_initServer);
			_fileTiShi.gotoAndStop(1);
			_fileTiShi.visible = false;
			_fileTiShi.addEventListener(MouseEvent.CLICK,onFileTiShiClick);
			
//			initServer(3);
		}
		
		private function initServer(type:int):void
		{
			if(type == 3) {
				ToolKit.getProcessExist("HimiWhiteBoardServer",meetingBoardServerBack);
			} else if(type == 1){
				_initServer.visible = false;
			}
		}
		
		private function initListener():void
		{
			_chuanLianBtn.addEventListener(MouseEvent.MOUSE_DOWN,onChuangLianBtnDown);
			_smallBoardCon.addEventListener(Event.CLOSE,onSmallBoardClose);
//			_smallBoard.addEventListener(Event.CLOSE,onSmallBoardClose);
			_uDiskMod.addEventListener(Event.CHANGE,onUDiskModeChange);
			_uDiskMod.addEventListener(Event.CLOSE,onUDiskModeClose);
			_loginPlugin.addEventListener(Event.CLOSE,onLoginPluginClose);
			_loginPlugin.addEventListener(LoginEvent.LOGIN,onLogin);
			_loginPlugin.addEventListener(LoginEvent.AGAINLOGIN,onAgainLogin);
			_desBtn.addEventListener(MouseEvent.CLICK,onDesBtnClick);
			_tanZhangDeng.addEventListener(Event.CLOSE,onTanZhaoDengClose);
		}
		
		private function onUserNumResClick(event:MouseEvent):void
		{
			if(ConstData.users.length==0)
			{
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"没有用户接入");
				setTimeout(function ():void
				{
					NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
				},1500);
				return; 
			}
			
			if(_phoneUserCon.visible)
			{
				Tweener.addTween(_phoneUserCon,{time:0.5,visible:false,alpha:0});
			} else {
				Tweener.addTween(_phoneUserCon,{time:0.5,visible:true,alpha:1});
			}
			
		}
		
		private function phoneUserConClose():void
		{
			Tweener.addTween(_phoneUserCon,{time:0.5,visible:false,alpha:0});
		}
		
		private function nsmanageBack(boo:Boolean):void
		{
			if(!boo){
				ToolKit.log("没检测到nsmanage，启动nsmanage");
				opennsmanageServer();
//				ConstData.openProcess(ApplicationData.getInstance().appPath+"assets/WhiteBoardServer/WhiteBoardServer.exe");
			} else {
				ToolKit.log("nsmanage已存在");
			}
		}
		
		private function opennsmanageServer():void
		{
			ToolKit.log("opennsmanageServer");
			var nc:NativeCommand = new NativeCommand();
			var file:File =new File(ApplicationData.getInstance().appPath+"assets/nsmanage/nsmanage.exe");
			var processArgs:Vector.<String> = new Vector.<String>(); 
			processArgs.push("runserver"); 
			processArgs.push("0.0.0.0:1986"); 
			nc.exec(file,processArgs);
		}
		
		
		private function meetingBoardServerBack(boo:Boolean):void
		{
//			trace("meetingBoardServerBack"+boo);
			if(!boo){
				ToolKit.log("没检测到WhiteBoardServer，启动WhiteBoardServer");
				ToolKit.openProcess(ApplicationData.getInstance().appPath+"assets/WhiteBoardServer/HimiWhiteBoardServer.exe");
			} else {
				ToolKit.log("WhiteBoardServer已存在");
			}
		}
		
		private function EE4WebCamBack(boo:Boolean):void
		{
			//			trace("meetingBoardServerBack"+boo);
			if(!boo){
				ToolKit.log("没检测到EE4WebCam，启动EE4WebCam");
				ToolKit.openProcess(ApplicationData.getInstance().appPath+"PPT/EE4WebCam.exe");
			} else {
				ToolKit.log("EE4WebCam已存在");
			}
		}
		
		/*private function SaveImageBack(boo:Boolean):void
		{
			//			trace("meetingBoardServerBack"+boo);
			if(!boo){
				ToolKit.log("没检测到SaveImage，启动SaveImage");
				ToolKit.openProcess(ApplicationData.getInstance().appPath+"assets/tool/SaveImage/SaveImage.exe");
			} else {
				ToolKit.log("SaveImage已存在");
			}
		}*/
		
		private function webServerBack(boo:Boolean):void
		{
			if(!boo){
				ToolKit.log("没检测到WebSocketsTestServer，启动WebSocketsTestServer");
				ToolKit.openProcess(ApplicationData.getInstance().appPath+"assets/webserver/WebSocketsTestServer.exe");
			} else {
				ToolKit.log("WebSocketsTestServer已存在");
			}
		}
		
		private function openProcess(path:String):void
		{
			var nc:NativeCommand = new NativeCommand();//trace(File.applicationDirectory.url);
			var file:File =new File(path);
			nc.exec(file);
		}
		
		private function onFileTiShiClick(event:MouseEvent):void
		{
			if(_receiveFileList)
			{
				Tweener.addTween(_receiveFileList, {y:0, time:0.3, visible:true,onComplete:changeEnd});
			}
			
			function changeEnd():void
			{
				_fileTiShi.visible = false;
				_fileTiShi.gotoAndStop(1);
			}
		}
		
		private function showLog(str:String,time:int):void
		{
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING, str);
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},time * 1000);
		}
		
		private function socketUpData(str:String):void
		{
//			trace("更新数据完成 " + str);
			ToolKit.log("接收到的消息为："+str);
			//			var msgType:String = str.split("-")[0];
			var msgObj:IMSG=HandleMSG.getObj(str);
			ToolKit.log(msgObj.getSendClient()+" msgObj.getSendClient()");
			ToolKit.log(msgObj.getMsgHeader()+" msgObj.getMsgHeader()");
			if(msgObj == null)return;
			if(msgObj.getMsgHeader() == null)return;
			if(msgObj.getMsgHeader() != MsgHeader.CONDRAGON)return;
			ToolKit.log(msgObj.getMsgType()+" msgObj.getMsgType()");
			switch(msgObj.getMsgType())
			{
				case MSGType.ADD_MEDIA_MSG:
				{
				//	trace("用户上传媒体素材成功 请更新" , msgObj.getUserName(), msgObj.getUserIP(),msgObj.getSendClient(),msgObj.getControlType());
					var fileName:String = msgObj.getMediaPath();
					ToolKit.log(fileName+"<<<<fileName");
					var vo:MediaVO=new MediaVO();
					vo.formatString(fileName);
					vo.path=fileName;
					vo.title = fileName.split("@@@")[1];
					vo.copyPath=fileName;
					vo.isBmpd = false;
					vo.isZiDong = true;
					vo.globalP = new Point(1920*0.5, 1080*0.5);
					NotificationFactory.sendNotification(NotificationIDs.ADD_GHONEMEDIA,vo);
					break;
				}
					
				case MSGType.Login_MSG:
				{
					//condragon%LoginMSG-&clientType=phone&userID=o09Gps2lY0IdvXScOSpNlTbxRysg&userName=xiang.karl&userHard=http://wx.qlogo.cn/mmopen/Q3auHgzwzM712ykbNcibsZjDCPaOUQqr64ffnvg2TsMPal5qHF17rzcNXSbaE5IGltbUlInQDpCT5dSaaaxica5A/0&end
					if(ConstData.users.length >= 40)
					{
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING, "用户已达到上限");
						
						setTimeout(function ():void
						{
							NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
						}, 1500);
						return;
					}
					ToolKit.log("用户已接入  "+msgObj.getUserName() +" \n" +msgObj.getUserThumb() +" \n" + msgObj.getUserIP());
					if(ConstData.users.indexOf(msgObj.getUserIP()) != -1) 
					{
						ToolKit.log("用户已存在");
						return;
					}
					var userVO:UserVO = new UserVO();
					userVO.userName = msgObj.getUserName();
					userVO.userThumb = msgObj.getUserThumb();
					userVO.userIP = msgObj.getUserIP();
					ConstData.users.push(msgObj.getUserIP());
					
					if(_userNumRes == null)
					{
						_userNumRes = new UserNumRes();
						_userNumRes.x = 14;
						_userNumRes.y = 950;
						_spCon.addPanelSprite(_userNumRes);
						_userNumRes.visible =  true;
						_userNumRes.numTitle.embedFonts = true;
						_userNumRes.numTitle.defaultTextFormat = new TextFormat("YaHei_font", 11, 0xFFFFFF);
						_userNumRes.addEventListener(MouseEvent.CLICK,onUserNumResClick);
					}
					
					_userNumRes.numTitle.text = String(ConstData.users.length);
					
					if(_phoneUserCon == null)
					{
						_phoneUserCon = new PhoneUserContent();
						_phoneUserCon.x = (1920 - _phoneUserCon.width) * 0.5;
						_phoneUserCon.y = (1080 - _phoneUserCon.height) * 0.5;
						_phoneUserCon.closeFun = phoneUserConClose;
						this.addChild(_phoneUserCon);
					}
					_phoneUserCon.visible = false;
					_phoneUserCon.addUser(userVO);
					
					break;
				}
					
				case MSGType.Vote_MSG:
				{
//					trace("Vote_MSG--",msgObj.getVoteType());
//					if(msgObj.getControlType() == ControlType.OPEN)
					if(msgObj.getVoteType() == "0")
					{
						ToolKit.log("发起投票");
						ConstData.voteUsers.length = 0;
						ConstData.votes.length = 0;
						_voteTitleType = msgObj.getQuestionsType();
//					} else if(msgObj.getControlType() == ControlType.STOP)
					} else if(msgObj.getVoteType() == "2")
					{
						ToolKit.log("结束投票");
						/*NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在分析数据，请稍候...");
						generateVoteData();*/
//					} else if(msgObj.getControlType() == ControlType.VOTING){
					} else if(msgObj.getVoteType() == "1"){
						ToolKit.log("手机投票");
						voteDataFengXi(msgObj);
					}
					/*if(int(msgObj.getVoteType()) == 0)
					{
						
						//trace("开始投票", _voteTitleType);
					} else if(int(msgObj.getVoteType()) == 1)
					{
						//trace("手机投票");
//						if(ConstData.isVoting)return;
						voteDataFengXi(msgObj);
					} else if(int(msgObj.getVoteType()) == 2)
					{
						//trace("结束投票");
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在分析数据，请稍候...");
						generateVoteData();
					}*/
					break;
				}
					
				case MSGType.PPT_MSG:
				{
				//	trace(msgObj.getMsgType(),"PPT控制",msgObj.getControlType());
					ConstData.pptYuLan.controlPPT(msgObj.getControlType());
					break;
				}
					
				case MSGType.PHONE_CLOSE_MSG:
				{
					//trace("PHONE_CLOSE_MSG---",ApplicationData.getInstance().users.length)
					/*for (var i:int = 0; i < ApplicationData.getInstance().users.length; i++) 
					{
					//	trace(ApplicationData.getInstance().users[i].userIP, msgObj.getUserIP(),"-ip");
						if(ApplicationData.getInstance().users[i].userIP == msgObj.getUserIP())
						{
							ApplicationData.getInstance().users.splice(i,1);
							if(_phoneUserCon)
							{
								_phoneUserCon.removePhoneUser(msgObj.getUserIP());
							}
						}
					}
					if(_phoneUserCon)
					{
						_phoneUserCon.addAllPhoneUser();
					}
					for (var j:int = 0; j < ConstData.ips.length; j++) 
					{
						if(ConstData.ips[j] ==  msgObj.getUserIP())
						{
							ConstData.ips.splice(j,1);
						}
					}
					//trace("userVO.userName" ,userVO.userName , "userVO.userIP", userVO.userIP);
					if(_userNumRes)
					{
						_userNumRes.numTitle.text = String(ApplicationData.getInstance().users.length);
					}
					
					if(ApplicationData.getInstance().users.length == 0)
					{
//						TweenLite.to(_phoneUserCon,0.5,{visible:false,alpha:0});
						Tweener.addTween(_phoneUserCon,{time:0.5,visible:false,alpha:0});
						_phoneUserCon.removeAllPhoneUser();
					}*/
					break;
				}
					
				case MSGType.ADD_HIMIMEDIA_MSG:
				{
					ToolKit.log((msgObj as AddHimiMediaMSG).isHimi + "   ADD_HIMIMEDIA_MSG");
					ToolKit.log("msgNum   " + String(ApplicationData.getInstance().msgNum)+  "    "+msgObj.getUserName());
					if((msgObj as AddHimiMediaMSG).isHimi == "true")
					{
						if(String(ApplicationData.getInstance().msgNum) != msgObj.getUserName())
						{
							ApplicationData.getInstance().xiangCeVO.isTimer = false;
							ApplicationData.getInstance().xiangCeVO.modelID = 0;
							ApplicationData.getInstance().xiangCeVO.isModel = true;
							ApplicationData.getInstance().xiangCeVO.isHemi = false;
							ApplicationData.getInstance().xiangCeVO.isVisible = true;
							NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
							ApplicationData.getInstance().xiangCeVO.isClear = false;
							
							setTimeout(function ():void
							{
								ApplicationData.getInstance().xiangCeVO.isVisible = false;
								NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
							},50);
							
							setTimeout(function ():void
							{
								if(_himiLinkCon == null)
								{
									_himiLinkCon = new HimiLinkContent();
									_spCon.addPanelSprite(_himiLinkCon);
								}
								_himiLinkCon.gotoPlay((msgObj as AddHimiMediaMSG).thumb,(msgObj as AddHimiMediaMSG).mediaPath);
							},100);
						}
					} else {
						if(String(ApplicationData.getInstance().msgNum) != msgObj.getUserName())
						{
													trace("msgObj.getMediaPath()",msgObj.getMediaPath())
							var stagePoint:Point = new Point(1920*0.5,1080*0.5);
							var obj:MediaVO = new MediaVO();
							obj.isFull = true;
							obj.globalP = stagePoint;
							obj.globaX = stagePoint.x;
							obj.globaY = stagePoint.y;
							obj.path = msgObj.getMediaPath();
							obj.isServer = true;
							obj.formatString(obj.path);
							NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);
						}
					}
					break;
				}
			}
		}
		
		public function closeNativeProcess():void
		{
			_smallWindowns.closePPTYuLan();
		}
		
		private function voteDataFengXi(msgObj:IMSG):void
		{
//			trace("voteDataFengXi")
			//投票数据统计
			if(ConstData.voteUsers.indexOf(msgObj.getUserIP()) == -1)
			{
//				trace(msgObj.getUserName(),"msgObj.getUserName()");
//				trace(msgObj.getUserIP(),"msgObj.getUserIP()");
//				trace(msgObj.getAnswer(),"msgObj.getAnswer()");
				var userVO:UserVO  = new UserVO();
				userVO.userName = msgObj.getUserName();
				userVO.userIP = msgObj.getUserIP();
				userVO.voteType = msgObj.getVoteType();
				userVO.answer = msgObj.getAnswer();
				userVO.questionsType = int(msgObj.getQuestionsType());
				ConstData.voteUsers.push(msgObj.getUserIP());
				ConstData.votes.push(userVO);
			} else {
//				trace("----")
				for (var i:int = 0; i < ConstData.votes.length; i++) 
				{
					if(ConstData.votes[i].userIP == msgObj.getUserIP())
					{
						ConstData.votes[i].answer = msgObj.getAnswer();
					}
				}
			}
			/*
			if(int(msgObj.getTitleType()) == 0)
			{//abcd型
				
			} else if(int(msgObj.getTitleType()) == 0)
			{//是否型
				
			}*/
		}
		
		private function generateVoteData():void
		{
//			trace(ConstData.voteTitleType,"ConstData.voteTitleType");
			var total:int = ConstData.votes.length;
			ConstData.voteResults.length = 0;
			for (var i:int = 0; i < int(ConstData.voteTitleType); i++) 
			{
				var obj:Object = new Object();
				obj.country = ConstData.answers[i];
				obj.total = total;
//				trace("getKeyVoteData",getKeyVoteData(String(i)))
				if(getKeyVoteData(String(i)).length ==0)
				{
					
				}else {
					obj.share = getKeyVoteData(String(i)).length;
					obj.peoples =  getKeyUser(getKeyVoteData(String(i)));
					ConstData.voteResults.push(obj);
				}
			}
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},2000);
			/*var dataList:Array=[];
			var nameArray:Array=[];
			var promptList:Array=[];
			for (var j:int = 0; j < VoteResults.length; j++) 
			{
				dataList.push(VoteResults[j].share);
				nameArray.push(VoteResults[j].country);
				promptList.push(VoteResults[j].peoples);
			}
			
			/*var promptList:Array=["xiangzi66; xiangzi62; xiangzi88; xiangzi43; \n ; xiangzi3; xiangzi17; ", "xiangzi63336; xiangzi62; xiangzi8228; xiangzi4113;  \n ; xiangzi3; xiangzi17; ",
			"xiangzi66; xiangzi6332; xiangzi88; xiangzi422; \n ; xiangzi3; xiangzi15; ", "xiangzi66; xiangzi62; xiangzi88; xiangzi45453; \n ; xiangzi663; xiangzi1777; "];*/
			
			/*var colorList:Array=[0xFF0F00,0xFCD202,0xB0DE09,0x0D8ECF];
			var pieGraph:DrawPieGraph = new DrawPieGraph(200,200,600,360,15,dataList,[0xFF0F00,0xFCD202,0xB0DE09,0x0D8ECF],nameArray,promptList,.7);
			pieGraph.x = pieGraph.width;
			pieGraph.y = 500;
			pieGraph.x = (pieGraph.width * 0.5);
			pieGraph.y = (pieGraph.height * 0.5);
			this.addChild(pieGraph);
			
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"数据统计完成，双击查看投票结果");
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},2000);*/
			/*var total:int = ConstData.votes.length;
			var xml:XML = <data></data>;
			if(int(_voteTitleType) == 0)
			{//abcd型
				var keyas:Vector.<UserVO> = getKeyVoteData("0");
				var keybs:Vector.<UserVO> = getKeyVoteData("1");
				var keycs:Vector.<UserVO> = getKeyVoteData("2");
				var keyds:Vector.<UserVO> = getKeyVoteData("3");
				
				var keyaUserStr:String = getKeyUser(keyas);
				var keybUserStr:String = getKeyUser(keybs);
				var keycUserStr:String = getKeyUser(keycs);
				var keydUserStr:String = getKeyUser(keyds);
				
				var itema:XML= <item/>;
				itema.@title = "A";
				itema.@total = total;
				itema.@share = keyas.length;
				itema.@peoples = keyaUserStr;
				xml.appendChild(itema);
				
				var itemb:XML= <item/>;
				itemb.@title = "B";
				itemb.@total = total;
				itemb.@share = keybs.length;
				itemb.@peoples = keybUserStr;
				xml.appendChild(itemb);
				
				var itemc:XML= <item/>;
				itemc.@title = "C";
				itemc.@total = total;
				itemc.@share = keycs.length;
				itemc.@peoples = keycUserStr;
				xml.appendChild(itemc);
				
				var itemd:XML= <item/>;
				itemd.@title = "D";
				itemd.@total = total;
				itemd.@share = keyds.length;
				itemd.@peoples = keydUserStr;
				xml.appendChild(itemd);
				
			} else
			{//是否型
				var keyYess:Vector.<UserVO> = getKeyVoteData("0");
				var keyNos:Vector.<UserVO> = getKeyVoteData("1");
				
				var keyYesUserStr:String = getKeyUser(keyYess);
				var keyNoUserStr:String = getKeyUser(keyNos);
				
				var itemyes:XML= <item/>;
				if(int(_voteTitleType) == 1){
					itemyes.@title = "是";
				} else{
					itemyes.@title = "对";
				}
				
				itemyes.@total = total;
				itemyes.@share = keyYess.length;
				itemyes.@peoples = keyYesUserStr;
				xml.appendChild(itemyes);
				
				var itemno:XML= <item/>;
				if(int(_voteTitleType) == 1){
					itemyes.@title = "否";
				} else{
					itemyes.@title = "错";
				}
				itemno.@total = total;
				itemno.@share = keyNos.length;
				itemno.@peoples = keyNoUserStr;
				xml.appendChild(itemno);
			} 
			
			saveUTFString(xml.toString(), ApplicationData.getInstance().appPath + "assets/VoteResult.xml");*/
		}
		
		/**
		 * xml写入  
		 * @param fileName
		 * @return 
		 */	
		private function saveUTFString(str:String, fileName:String):void
		{
//			trace("数据处理完成",fileName)
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
			
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"数据统计完成，双击查看投票结果");
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},2000);
		}
		
		private function getKeyUser(keys:Vector.<UserVO>):String
		{
			var userStr:String = "";
			for (var i:int = 0; i < keys.length; i++) 
			{
				if((i%2) == 0 && i > 0)
				{
					userStr += "\n " + keys[i].userName + "; ";
				} else {
					userStr +=  keys[i].userName + "; ";
				}
			}
			return userStr;
		}
		
		private function getKeyVoteData(key:String):Vector.<UserVO>
		{
			var keyVotedatas:Vector.<UserVO> = new Vector.<UserVO>;
			for (var i:int = 0; i < ConstData.votes.length; i++) 
			{
				if(ConstData.votes[i].answer == key)
				{
					keyVotedatas.push(ConstData.votes[i]);
				}
			}
			return keyVotedatas; 
		}
		
		/*private function handleStatus(event:NetStatusEvent):void
		{
//			trace("handleStatus");
		}
		
		private function handleSyncError(event:AsyncErrorEvent):void
		{
//			trace("handleSyncError");
		}*/
		
		/*private function handleSync( event:SyncEvent):void
		{
			Tool.log("handleSync");
			var msg:Object = _whiteBoardRemoteSO.data.BA;
			if(msg==null)return;
			//_whiteBoardRemoteSO.data.BA.position = 0;
		//	Tool.log("改变了"+ApplicationData.getInstance().isOpp);
		//	Tool.log("改变了1"+msg.type);
		//	Tool.log("msgNum"+msg.msgNum+"   ApplicationData"+ApplicationData.getInstance().msgNum);
		//	Tool.log("positionID"+msg.positionID+"   ApplicationData"+ApplicationData.getInstance().positionID);
		//	Tool.log("clientType"+ApplicationData.getInstance().clientType);
			Tool.log("Himi"+msg.thumb+msg.isHimi+msg.himiLink);
			if(ApplicationData.getInstance().clientType == ClientType.TEACHER)
			{
				Tool.log("正在匹配双脑信息  "+ "   msg.isHimi     " + msg.isHimi);
				Tool.log("双脑信息  " + msg.msgNum + "   "+ApplicationData.getInstance().msgNum + "   " + msg.positionID + "   " + ApplicationData.getInstance().positionID);
				if(msg.msgNum == ApplicationData.getInstance().msgNum )
//				if(msg.msgNum == ApplicationData.getInstance().msgNum &&ApplicationData.getInstance().positionID == msg.positionID)
				{
					Tool.log("双脑成功了，正在加载图片    "+ msg.type + "msg.isHimi     " + msg.isHimi);
					if(msg.isHimi == false)
					{
						var stagePoint:Point = new Point(1920*0.5,1080*0.5);
						if(msg.type == "jpg")
						{
							msg.byteArray.position = 0;
							Tool.log("加载图片"+msg.stagePoint.x+"stagePoint");
							Tool.log("stagePoint"+msg.stagePoint.x);
							Tool.log("msg.byteArray  "+msg.byteArray.length);
							var obj:MediaVO = new MediaVO();
							obj.isFull = true;
							obj.type = ".jpg";
							obj.isBmpd = true;
							obj.globalP = stagePoint;
							obj.globaX = stagePoint.x;
							obj.globaY = stagePoint.y;
							obj.btyeArray = msg.byteArray;
							obj.isServer = true;
							obj.formatString("1.jpg");
							NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);
						}else if(msg.type == "flv"){
							var obj1:MediaVO = new MediaVO();
							obj1.isFull = true;
							obj1.type = ".flv";
							obj1.isServer = true;
							obj1.globalP = stagePoint;
							obj1.globaX = stagePoint.x;
							obj1.globaY = stagePoint.y;
							obj1.ipAddress  = msg.ipAddress;
							obj1.thumb = msg.thumb;
							obj1.formatString(msg.path+".flv");
							NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj1);
						}
					} else {
//						trace("双脑素材关联成功了    "+msg.type);
						if(_himiLinkCon == null)
						{
							_himiLinkCon = new HimiLinkContent();
							_spCon.addPanelSprite(_himiLinkCon);
						}
						
						_himiLinkCon.gotoPlay(msg.thumb,msg.himiLink);
					}
				} else {
					if(msg.msgNum != ApplicationData.getInstance().msgNum&&msg.positionID == ApplicationData.getInstance().positionID)
					{
						var stagePoint:Point = new Point(1920*0.5,1080*0.5);
						if(msg.type == "jpg")
						{
							msg.byteArray.position = 0;
							Tool.log("加载图片"+msg.stagePoint.x+"stagePoint");
							Tool.log("stagePoint"+msg.stagePoint.x);
							var obj:MediaVO = new MediaVO();
							obj.isFull = true;
							obj.type = ".jpg";
							obj.isBmpd = true;
							obj.globalP = stagePoint;
							obj.globaX = stagePoint.x;
							obj.globaY = stagePoint.y;
							obj.btyeArray = msg.byteArray;
							obj.isServer = true;
							obj.formatString("1.jpg");
							setTimeout(function ():void{
								NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj);
							},10);
						}else if(msg.type == "flv"){
							var obj1:MediaVO = new MediaVO();
							obj1.isFull = true;
							obj1.type = ".flv";
							obj1.isServer = true;
							obj1.globalP = stagePoint;
							obj1.globaX = stagePoint.x;
							obj1.globaY = stagePoint.y;
							obj1.ipAddress  = msg.ipAddress;
							obj1.thumb = msg.thumb;
							obj1.formatString(msg.path+".flv");
							NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,obj1);
						}
					}
				}
			}
		}*/
		
		private function onChuangLianBtnDown(e:MouseEvent):void
		{
			_dowmY = mouseY;
			_tempY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			_chuanLianBtn.y+=mouseY-_dowmY;
			_dowmY = mouseY;
		}
		
		/**
		 * 
		 * 背景切换
		 * */
		private function onUp(e:MouseEvent):void
		{
			if(Math.abs(_tempY-mouseY)>10)
			{
				_bgID++;
				if(_bgID > 5)
//				if(_bgID>ApplicationData.getInstance().bgs.length-1)
				{
					_bgID=0;
				}
				_blackBoardContainer.setBlackBoardBG(_bgID);
				_boardThumb.setThumbBG(_bgID);
			}
			Tweener.addTween(_chuanLianBtn,{y:-912,time:0.5});
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		public function getLogicName():String
		{
			return NAME;
		}
		
		public function handleNotification(notification:SimpleNotification):void
		{
			switch(notification.getId())
			{
				case NotificationIDs.OPEN_FILE:
				{
					if(!mainApp.closed){
						mainApp.visible = false;
					}
					onSmallBoardClose();
					_smallWindowns.showShotScreenBtn();
					_smallWindowns.configListeners();
					_smallWindowns.showLog("正在打开文件，请稍候...");
					
					setTimeout(function ():void
					{
						_smallWindowns.hideLog();
					},3000);
					
					if(notification.getBody() == 0)
					{
						_smallWindowns.openPPT();
					}
					break;
				}
				
				case NotificationIDs.ADD_GHONEMEDIA:
				{
					var vo:MediaVO = notification.getBody() as MediaVO;
					//					trace(vo.type,"vo.type");
					if(vo.type == MediaVO.SWF)
					{
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"文件已损坏");
						
						setTimeout(function ():void
						{
							NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
						},2000);
						return;
					}
					if(_receiveFileList == null)
					{
						_receiveFileList = new ReceiveFileList();
						_receiveFileList.x = 0;
						_receiveFileList.y = -100;
						this.addChild(_receiveFileList);
						_receiveFileList.visible = false;
					}
					_receiveFileList.addMedia(vo);
					TweenLite.to(_receiveFileList, 0.3, {y:0, visible:true});
					break;
				}
				
				case NotificationIDs.CLEAR_SYSTEMMEMORY:
				{
					_blackBoardContainer.clearSystemMemory();
					break;
				}
				
				case NotificationIDs.ADD_BOARD:
				{
					_boardThumb.addBoard();
					_blackBoardContainer.addBackgroundPage();
					_tools.addPageBtn();
					_phoneTools1.addPageBtn();
					setCheXiaoChongZuo();
					break;
				}
					
				case NotificationIDs.CHANGE_BOARD:
				{
					_blackBoardContainer.reset();
					_tools.reset();
					ApplicationData.getInstance().nowBoardID = int(notification.getBody());
					_blackBoardContainer.setBlackBoardWeiZhi(int(notification.getBody()));
					_tools.setPageBtn(int(notification.getBody()));
					_boardThumb.setBtnStatus(int(notification.getBody()));
					setCheXiaoChongZuo();
					break;
				}
					
				case NotificationIDs.REMOVE_BOARD:
				{
					_blackBoardContainer.removeBackgroundPage(int(notification.getBody()));
					_tools.removePageBtn(int(notification.getBody()));
					
					if(ApplicationData.getInstance().nowBoardID>ApplicationData.getInstance().blachBoardLength-1){
						ApplicationData.getInstance().nowBoardID = ApplicationData.getInstance().blachBoardLength-1;
					}
					_blackBoardContainer.setBlackBoardWeiZhi(ApplicationData.getInstance().nowBoardID);
					_tools.setPageBtn(ApplicationData.getInstance().nowBoardID);
					break;
				}
				case NotificationIDs.CLEAR_ALL:
				{
					_blackBoardContainer.clearAll();
					_tools.gotoStop(true,0,2);
					_phoneTools1.gotoStop(true,0,2);
					_boardThumb.clearBoard();
					break;
				}
				
				case NotificationIDs.SHOW_WENLI:
				{
					_blackBoardContainer.setGeZiShow((notification.getBody()) as Object);
					break;
				}
					
				case NotificationIDs.HIDE_SHOW_MENU:
				{
					if(notification.getBody()==2){
						hideContent();
						_tools.setHideShowBtn(2);
						_tools.hidePanel();
						_tools.hideGongSiPanel(true);
						_phoneTools1.hidePanel();
						_phoneTools2.hidePanel();
						_phoneTools2.gotoHideShowBtnStop(2);
						_phoneTools2.hideGongSiPanel(true);
					}else if(notification.getBody()==1){
						showContent();
						_tools.setHideShowBtn(1);
						_phoneTools2.gotoHideShowBtnStop(1);
					}else{//当点击桌面整理时  影藏浮在上面的内容
						hideContent();
						_tools.setHideShowBtn(2);
						_tools.hidePanel();
						_phoneTools1.hidePanel();
						_phoneTools2.hidePanel();
					}
					break;
				}
					
				case NotificationIDs.PHOTO_GRAPH:
				{
					ToolKit.log("PHOTO_GRAPH");
//					_loadingBar.visible =true;
					_tools.visible = false;
					_phoneTools1.visible = false;
					_phoneTools2.visible = false;
					_desBtn.visible = false;
					_spCon.setPanelVisible(false);
//					_smallBoard.visible = false;
					_smallBoardCon.visible = false;
					_yingGuangBi.hideTools();
					_blackBoardContainer.hideRes();
					if(_userNumRes)
					{
						_userNumRes.visible = false;
					}
					try
					{
						if(stage==null)
						{
//							Tool.log("nulllllll")
							addEventListener(Event.ADDED_TO_STAGE,onBmpdStage);
						}else{
//							Tool.log("PHOTO_GRAPH1111"+ApplicationData.getInstance().screenX+ApplicationData.getInstance().screenY);
							try
							{
//								_stageBmpd = new BitmapData(ConstData.stageWidth, ConstData.stageHeight, true);
								_stageBmpd = new BitmapData(ConstData.stageWidth, ConstData.stageHeight, true);
								_stageBmpd.draw(stage);
								CameraPhoto.setBitMapData(_stageBmpd,0);
								
								_desBtn.visible = true;
								
								_smallBoardCon.visible = true;
								_tools.visible = true;
								_spCon.setPanelVisible(true);
								_phoneTools1.visible = true;
								_phoneTools2.visible = true;
								_yingGuangBi.showTools();
								_desBtn.visible = true;
								if(_userNumRes)
								{
									_userNumRes.visible = true;
								}
								_blackBoardContainer.showRes();
							} 
							catch(error:Error) 
							{
								ToolKit.log("无法完成绘图 "+error.message);
								NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"无法完成绘图,请与管理员联系");
								setTimeout(function ():void{
									NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
								},2000);
								_desBtn.visible = true;
								//Tool.log("无法完成绘图 ");
								_smallBoardCon.visible = true;
								_tools.visible = true;
								_spCon.setPanelVisible(true);
								_phoneTools1.visible = true;
								_phoneTools2.visible = true;
								_yingGuangBi.showTools();
								_desBtn.visible = true;
								_blackBoardContainer.showRes();
								if(_userNumRes)
								{
									_userNumRes.visible = true;
								}
							}
						}
					} 
					catch(error:Error) 
					{
						return;
					}
					break;
				}
					
				case NotificationIDs.COMPLETE_MEDIA:
				{
//					_loadingBar.visible =false;
//					_smallBoard.visible = true;
					_smallBoardCon.visible = true;
					_tools.visible = true;
					_spCon.setPanelVisible(true);
					_phoneTools1.visible = true;
					_phoneTools2.visible = true;
					_yingGuangBi.showTools();
					if(_phoneTools1.y == 921.65)
					{
						_desBtn.visible = true;
					}
				}
				case NotificationIDs.TUYA_BEGIN:
				{
					_tools.hidePanel();
					_tools.hideGongSiPanel(false);
					_phoneTools1.hidePanel();
					_phoneTools2.hidePanel();
					_phoneTools2.hideGongSiPanel(false);
					if(_phoneUserCon)
					{
						_phoneUserCon.visible = false;
					}
					
					if(_receiveFileList)
					{
						TweenLite.to(_receiveFileList, 0.3, {y:-100, visible:false});
						setTimeout(function ():void{
							_receiveFileList.visible = false;
						},300);
						
						if(_receiveFileList.getMediaNum() > 0)
						{
							_fileTiShi.visible = true;
							_fileTiShi.gotoAndPlay(1);
						}
					}
					break;
				}
				case NotificationIDs.TUYA_END:
				{
					setCheXiaoChongZuo();
					if(notification.getBody() == null)return;
					_boardThumb.addBmpd(notification.getBody() as BitmapData);
					_blackBoardContainer.addYuLanTuYa();
					break;
				}
				case NotificationIDs.FANGDAJING:
				{
					_blackBoardContainer.openFangDaJing(int(notification.getBody()));
					break;
				}
					
				case NotificationIDs.UDISK_FILE:
				{
					_loginPlugin.hideShowAgainBtn(false);
					_loginPlugin.isLocalModel = false;
					_loginPlugin.setLessonParams(ApplicationData.getInstance().userXML);
					_loginPlugin.visible = true;
					break;
				}
					
				case NotificationIDs.LOCAL_FILE:
				{
					_loginPlugin.hideShowAgainBtn(true);
					_loginPlugin.setHuiFu();
					_loginPlugin.visible = true;
					_loginPlugin.loginComplete();
					break;
				}
					
				case NotificationIDs.SELECT_LESSON_CLASS:
				{
					_loginPlugin.visible = false;
//					_smallBoard.changeUseXml();
					break;
				}
					
				case NotificationIDs.CHONEZUO:
				{
					_blackBoardContainer.chongZuo();
					break;
				}
					
				case NotificationIDs.CHEXIAO:
				{
					_blackBoardContainer.cheXiao();
					break;
				}
				case NotificationIDs.COPY_BLACKBOARD:
				{
					_boardThumb.addBoard(true, ApplicationData.getInstance().nowBoardID,_blackBoardContainer.getBmpd());
					_blackBoardContainer.addBackgroundPage(true);
					_tools.addPageBtn();
					break;
				}
				case NotificationIDs.MIN_DIS_THUMB:
				{
					//if(notification.getBody()[1]){//已经有隐藏图标
						//_boardThumb.miniDisplayThumb(notification.getBody()[0] as OppMedia);
				//	}else{
						_boardThumb.addDisThumb(notification.getBody()[0] as OppMedia);
				//	}
					break;
				}
					
				case NotificationIDs.OPEN_JISUANQI:
				{
					if(_cator==null){
						_cator = new CatorContainer();
						_cator.x = (1920-_cator.width)*0.5;
						_cator.y = (1080-_cator.height)*0.5;
						_spCon.addPanelSprite(_cator);
						_cator.visible = true;
					}else{
						_cator.reset();
						_cator.alpha = 1;
						_cator.x = (1920-_cator.width)*0.5;
						_cator.y = (1080-_cator.height)*0.5;
						_spCon.addPanelSprite(_cator);
						if(_cator.visible==true)
						{
							_cator.visible = false;
						}else{
							_cator.visible = true;
						}
					}
					break;
				}
				case NotificationIDs.OPEN_GONGJULAN:
				{
					_tools.gongJuLanPanle();
					break;
				}
				case NotificationIDs.PIANHAO_SETTING:
				{
//					trace("设定偏好设置");
					_tools.pianHaoSet(notification.getBody() as StyleVO);
				//	_blackBoardContainer.setBlackBoardBG(ApplicationData.getInstance().blackID);
				//	_boardThumb.setThumbBG(ApplicationData.getInstance().blackID);
					break;
				}
				case NotificationIDs.DRAW_SHAPE_END:
				{
					setCheXiaoChongZuo();
					/*_blackBoardContainer.setArrID();
//					trace(ApplicationData.getInstance().jiLuArr.length,ApplicationData.getInstance().stepID,"+++++++++")
					if(ApplicationData.getInstance().jiLuArr.length>0){
						if(ApplicationData.getInstance().stepID==ApplicationData.getInstance().jiLuArr.length-1)
						{//在没有撤销的时候  重做按钮不能点击
							_tools.gotoStop(false,1,2);
							_tools.gotoStop(false,0,1);
							_phoneTools1.gotoStop(false,1,2);
							_phoneTools1.gotoStop(false,0,1);
						}else if(ApplicationData.getInstance().stepID==-1){
							_tools.gotoStop(false,0,2);
							_tools.gotoStop(false,1,1);
							_phoneTools1.gotoStop(false,0,2);
							_phoneTools1.gotoStop(false,1,1);
						}else{
							_tools.gotoStop(true,0,1);
							_phoneTools1.gotoStop(true,0,1);
						}
					}else{
						if(ApplicationData.getInstance().jiLuArr.length==0)
						{
							_tools.gotoStop(true,0,2);
							_phoneTools1.gotoStop(true,0,2);
						}
					}*/
					break;
				}
				case NotificationIDs.DRAW_SHAPE:
				{
					_blackBoardContainer.openDrawShape(notification.getBody() as TuXingVO);
					break;
				}
				case NotificationIDs.SHUXUE_GONGJU:
				{if(notification.getBody()==1)
				{
					if(	_liangJiaoQi==null)
					{
						_liangJiaoQi = new LiangJiaoQi(); 
						_spCon.addPanelSprite(_liangJiaoQi);
						_liangJiaoQi.visible = false;
						_liangJiaoQi.addEventListener(Event.CLOSE,onDengBianClose);
					}
//					trace(_liangJiaoQi,_liangJiaoQi.visible,"_liangJiaoQi");
					if(_liangJiaoQi.visible)
					{
						_liangJiaoQi.visible = false;
					}else{
						_liangJiaoQi.x = 1492.65;
						_liangJiaoQi.y = 435.9;
						_liangJiaoQi.visible = true;
					}
				}else if(notification.getBody()==2){
					if(_zhiJoapSanJiao==null)
					{
						_zhiJoapSanJiao = new ZhiJiaoSanJiao();
						_spCon.addPanelSprite(_zhiJoapSanJiao);
						_zhiJoapSanJiao.visible = false;
						_zhiJoapSanJiao.addEventListener(Event.CLOSE,onDengBianClose);
					}
					if(_zhiJoapSanJiao.visible)
					{
						_zhiJoapSanJiao.visible = false;
					}else{
						_zhiJoapSanJiao.x = 119.9;
						_zhiJoapSanJiao.y = 200.05;
						_zhiJoapSanJiao.visible = true;
					}
				}else if(notification.getBody()==3){
					if(_dengBianSanJiao==null)
					{
						_dengBianSanJiao = new DengBianSanJiao();
						_spCon.addPanelSprite(_dengBianSanJiao);
						_dengBianSanJiao.visible = false;
						_dengBianSanJiao.addEventListener(Event.CLOSE,onDengBianClose);
					}
					
					if(_dengBianSanJiao.visible)
					{
						_dengBianSanJiao.visible = false;
					}else{
						_dengBianSanJiao.visible = true;
						_dengBianSanJiao.x = 1254.1;
						_dengBianSanJiao.y = 543.55
					}
				}else if(notification.getBody()==4){
					if(_zhiChi==null)
					{
						_zhiChi = new ZhiChi();
						_spCon.addPanelSprite(_zhiChi);
						_zhiChi.visible = false;
						_zhiChi.addEventListener(Event.CLOSE,onDengBianClose);
					}
					
					if(_zhiChi.visible)
					{
						_zhiChi.visible = false;
					}else{
						_zhiChi.visible = true;
						_zhiChi.x = 110.45;
						_zhiChi.y = 836.6;
					}
				}else if(notification.getBody()==0){
					if(_yuanGui2==null)
					{
						_yuanGui2 = new YuanGui2();
						_spCon.addPanelSprite(_yuanGui2);
						_yuanGui2.visible = false;
						_yuanGui2.addEventListener(Event.CLOSE,onDengBianClose);
					}
					
					if(_yuanGui2.visible)
					{
						_yuanGui2.visible = false;
					}else{
						_yuanGui2.visible = true;
						_yuanGui2.x = 937.45;
						_yuanGui2.y = 818.45;
					}
				}
					break;
				}
				case NotificationIDs.SHUXUE_GONGJU_END:
				{
					_blackBoardContainer.addShuXueShape(notification.getBody() as DisplayObject);
					break;
				}
				case NotificationIDs.CHANGE_PHONE_MODEL:
				{
					_boardThumb.scaleX = _boardThumb.scaleY = 1.5;
					_boardThumb.x = 1800;
					_boardThumb.y = 850;
					Tweener.addTween(_phoneTools1,{y:921.65,visible:true,time:0.5});
					Tweener.addTween(_phoneTools2,{y:-2,visible:true,time:0.5});
					Tweener.addTween(_tools,{y:1080,visible:true,time:0.5});
//					_desBtn.visible = true;
					_yingGuangBi.changeToosScale(2);
					break;
				}
					
				case NotificationIDs.CHANGE_IPTID_MODEL:
				{
//					_desBtn.visible = false;
					_boardThumb.x = 1830;//1853
					_boardThumb.y = 965;
//					_boardThumb.scaleX = _boardThumb.scaleY = 1;
					Tweener.addTween(_phoneTools1,{y:1080,visible:true,time:0.5});
					Tweener.addTween(_phoneTools2,{y:-150,visible:true,time:0.5});
					Tweener.addTween(_tools,{y:1080-_tools.height,visible:true,time:0.5});
					_yingGuangBi.changeToosScale(1);
					break;
				}
				case NotificationIDs.CHANGE_SMALLBOARD:
				{
//					_smallBoard.reset();
					onSmallBoardClose(null);
//					_smallBoard.changeWenTi();
					_smallBoardCon.changeWenTi();
					break;
				}
				case NotificationIDs.CHANGE_PHONE_MODEL:
				{
					_desBtn.visible= true;
					break;
				}
					
				case NotificationIDs.CHANGE_IPTID_MODEL:
				{
					_desBtn.visible= false;
					break;
				}
				case NotificationIDs.MINI_WINDOWN:
				{
					if(!mainApp.closed){
						mainApp.visible = false;
					}
					onSmallBoardClose();
					_smallWindowns.showShotScreenBtn();
					_smallWindowns.configListeners();
					break;
				}
					
				case NotificationIDs.MAX_WINDOW:
				{
					mainApp.visible = true;
					mainApp.alwaysInFront = true;
					_smallBoardCon.visible= true;
//					_smallBoard.visible= true;
					_smallWindowns.showWindows();
					_smallWindowns.hideShotScreenBtn();
					_smallWindowns.removeConfigListeners();
					break;
				}
				case NotificationIDs.TONGBU_BTN:
				{
					_tools.gotoSuoDingBtn(int(notification.getBody()));
					_phoneTools2.gotoStop(int(notification.getBody()));
					break;
				}
				case NotificationIDs.RE_LOGIN:
				{
					_uDiskMod.openStorage();
					break;
				}
				case NotificationIDs.START_SHOTSCREEN:
				{
					_smallBoardCon.x = -(_smallBoardCon.width-20);
					_smallBoardCon.y = (ConstData.stageHeight-64-_smallBoardCon.height)*0.5;
					if(notification.getBody()==0)
					{
						_smallBoardCon.visible= false;
					}else if(notification.getBody()==1){
						_smallWindowns.stage.addChild(_smallBoardCon);
						_smallBoardCon.visible= true;
					}else if(notification.getBody()==2){
						_smallBoardCon.visible= false;
					}
					break;
				}
					
				case NotificationIDs.COPY_DATA:
				{
					if(_copyData==null)
					{
						_copyData = new CopyLesson();
					}
					_copyData.setPath(String(notification.getBody()));
					break;
				}
				case NotificationIDs.SHOW_LOADING:
				{
//					trace("SHOW_LOADING");
					stage.addChild(_loadingPage);
					_loadingPage.setTT(String(notification.getBody()));
					_loadingPage.visible = true;
					break;
				}
				case NotificationIDs.HIDE_LOADING:
				{
//					trace("HIDE_LOADING");
					_loadingPage.visible = false;
					break;
				}
				case NotificationIDs.OPEN_TANZHAODENG:
				{
//					stage.addChild(_tanZhangDeng);
					/*_tanZhangDeng.visible = true;
					_tanZhangDeng.setDisObj(stage);*/
					_tanZhangDeng.visible = true;
					_tanZhangDeng.openTanZhaoDeng();
					break;
				}
					
				case NotificationIDs.SAVE_ALL:
				{
					saveOppMedia();
					
					stage.addChild(_loadingPage);
					_loadingPage.setTT("正在整理会议记录");
					_loadingPage.visible = true;
					break;
				}
					
				case NotificationIDs.OPEN_YINGGUANGBI:
				{
					_tools.visible = false;
					_phoneTools1.visible = false;
					_phoneTools2.visible = false;
					_spCon.setPanelVisible(false);
					_smallBoardCon.visible = false;
					break;
				}
					
				case NotificationIDs.CLOSE_YINGGUANGBI:
				{
					_smallBoardCon.visible = true;
					_tools.visible = true;
					_spCon.setPanelVisible(true);
					_phoneTools1.visible = true;
					_phoneTools2.visible = true;
					break;
				}
				
				case NotificationIDs.REMOVE_PHONEUSER:
				{
					//trace("remove",notification.getBody());
//					_phoneUserCon.removePhoneUser(String(notification.getBody()));
					setTimeout(function ():void
					{
						for (var i:int = 0; i < ApplicationData.getInstance().users.length; i++) 
						{
							if(ApplicationData.getInstance().users[i].userIP == notification.getBody())
							{//trace("removeing")
								ApplicationData.getInstance().users.splice(i,1);
							}
						}
						/*if(_phoneUserCon)
						{
							_phoneUserCon.addAllPhoneUser();
						}*/
						for (var j:int = 0; j < ConstData.ips.length; j++) 
						{
							if(ConstData.ips[j] == notification.getBody())
							{
								ConstData.ips.splice(j,1);
							}
						}
						//trace("userVO.userName" ,userVO.userName , "userVO.userIP", userVO.userIP);
						if(_userNumRes)
						{
							_userNumRes.numTitle.text = String(ApplicationData.getInstance().users.length);
						}
						
						if(ApplicationData.getInstance().users.length == 0)
						{
//							TweenLite.to(_phoneUserCon,0.5,{visible:false,alpha:0});
//							Tweener.addTween(_phoneUserCon,{time:0.5,visible:false,alpha:0});
						}
					},100);
					break;
				}
					
				case NotificationIDs.SETTINGENVIR_COMPLETE:
				{
					_loadingPage.setTT("环境配置成功");
					_wangLuoTiShi.tt.text = "环境配置成功";
//					_tools.setTT(false);
					setTimeout(function():void
					{
						_loadingPage.visible = false;
					},2000);
					
					if(ConstData.socket.isNetSuccess)
					{
						_wangLuoTiShi.visible = false;
					}
					break;
				}
					
				case NotificationIDs.SOCKET_SHIBAI:
				{
//					_tools.setTT(true);
					break;
				}
					
				case NotificationIDs.HUANDENGMODEL:
				{
					_tools.setHuanDengModel();
					break;
				}
					
				case NotificationIDs.SETTING_APP:
				{
					setNativeProcess();
					break;
				}
				
				case NotificationIDs.VOTE_END:
				{
					NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在分析数据，请稍候...");
					generateVoteData();
					break;
				}
					
				case NotificationIDs.SETTING_ENVIR:
				{
					if(_settingEnvironment == null)
					{
						_settingEnvironment = new SettingEnvironment();
						_settingEnvironment.x = 0;
						_settingEnvironment.y = 0;
					}
					_settingEnvironment.reset();
					_settingEnvironment.addIps();
					_settingEnvironment.visible = true;
//					stage.addChild(_settingEnvironment);
					ConstData.setEnv = _settingEnvironment;
					break;
				}
					
				case NotificationIDs.HUANDENGMODEL_CLOSELUCK:
				{
					_tools.closeLuck();
					break;
				}
					
			}
		}
		
		public function saveOppMedia():void
		{
			ConstData.historyDate = ApplicationData.getInstance().appPath + "历史记录/" + GetDateName.getDateHMName()+"/";
			_isSaveOpp = true;
			_saveID = 0;
			
			_saveArrs.length = 0;
			_boards.length = 0;
			
			for (var i:int = 0; i < _spCon.mediaSprite.numChildren&&i<57; i++) 
			{
				if(_spCon.mediaSprite.getChildAt(i).name =="oppMedia"||_spCon.mediaSprite.getChildAt(i).name =="Opp")
				{
					var tempOpp:OppMedia = _spCon.mediaSprite.getChildAt(i) as OppMedia;
					_saveArrs.push(tempOpp);
				}
			}	
			
			for (var i:int = 0; i < ApplicationData.getInstance().oppArr.length; i++) 
			{
				if(!ApplicationData.getInstance().oppArr[i].isSave)
				{
					_saveArrs.push(ApplicationData.getInstance().oppArr[i]);
				}
			}
			
			for (var k:int = 0; k < ApplicationData.getInstance().oppArr.length; k++) 
			{
				ApplicationData.getInstance().oppArr[k].isSave = false;
				ApplicationData.getInstance().oppArr[k].indexID = ApplicationData.getInstance().oppArr.length + k;
				_saveArrs.push(ApplicationData.getInstance().oppArr[k]);
			}
			
			for (var j:int = 0; j < _blackBoardContainer.getBloakBoardNum(); j++) 
			{
				ToolKit.log(_blackBoardContainer.getBlackBoard(j).isSave + " isSave");
				if(_blackBoardContainer.getBlackBoard(j).isSave == false)
				{
					ToolKit.log("板书编号："+_boardThumb.getTitle(j));
					_blackBoardContainer.getBlackBoard(j).tt = _boardThumb.getTitle(j);
					_boards.push(_blackBoardContainer.getBlackBoard(j));
				}
			}
			_saveNum = _saveArrs.length;
			ToolKit.log(_saveArrs.length + " 保存卡片的个数")
			ToolKit.log(_boards.length + "保存板书的个数")
			if(_isSaveOpp)
			{
				//				_saveNum = _spCon.mediaSprite.numChildren;
				//				_saveNum = ApplicationData.getInstance().mediaArr.length;
				_saveNum = _saveArrs.length;
				if(_saveNum == 0)
				{
					//					_saveNum = _blackBoardContainer.getBloakBoardNum();
					_saveNum = _boards.length;
					_isSaveOpp = false;
				}
			} else {
				//				_saveNum = _blackBoardContainer.getBloakBoardNum();
				_saveNum = _boards.length;
				if(_saveNum ==0)
				{
					_isSaveOpp = true;
					_saveID = 0;
					
					_saveTimer.reset();
					_saveTimer.stop();
					
					_loadingPage.visible = false;
				}
			}
			
			_saveTimer.reset();
			_saveTimer.start();
		}
		
		private function onSaveTimer(event:TimerEvent):void
		{
			//			trace(_saveID,"_saveID ", _isSaveOpp);
			if(_isSaveOpp)
			{
				if(_saveNum < 1)return;
				if(_saveArrs[_saveID] is OppMedia)
				{
					_tempOpp = _saveArrs[_saveID];
					if(!_tempOpp.isSave) 
					{
						var date:Date = new Date();
						_filePath = ConstData.historyDate + "媒体卡片/"  + date.time +".jpg";
						_tempOpp.isSave = true;
						
						ToolKit.saveLocalFile(_saveArrs[_saveID].getBmpd(), _filePath);
					}
					if(!_isNew)
					{
						_loadingPage.setTT("正在保存媒体卡片"+int(_saveID/_saveNum*100)+"%");
					} else {
						_loadingPage.setTT("正在清理上次会议内容"+int(_saveID/_saveNum*100/2)+"%");
					}
				}
			} else {
				if(_saveNum < 1)
				{
					_isSaveOpp = true;
					_saveID = 0;
					_saveTimer.reset();
					_saveTimer.stop();
					_loadingPage.visible = false;
					_saveArrs.length = 0;
					_boards.length = 0;
				/*	if(_isNew)
					{
						clearMeetingAll();
					}*/
					
					return;
				}	
				//				_filePath = ConstData.historyDate + "黑板板书/" +"板书_" + _saveID +".jpg";
				_filePath = ConstData.historyDate + "黑板板书/" +"板书_" + _boards[_saveID].tt +".jpg";
				//								trace(_filePath,"_filePath 黑板板书");
				if(!_isNew)
				{
					_loadingPage.setTT("正在保存黑板板书"+int(_saveID/_saveNum*100)+"%");
				} else {
					_loadingPage.setTT("正在清理上次会议内容"+int(_saveID/_saveNum*100/2+50)+"%");
				}
				//				_blackBoardContainer.getBlackBoard(_saveID).isSave = true;
				_boards[_saveID].isSave = true;
				ToolKit.saveLocalFile(_boards[_saveID].saveBitmapData(), _filePath);
				//				ConstData.saveLocalFile.saveBmpd(_blackBoardContainer.getBitmapData(_saveID),_filePath,false);
//				ConstData.saveLocalFile.saveBmpd(_boards[_saveID].saveBitmapData(),_filePath,false);
			}
			
			if(_saveID < _saveNum - 1)
			{
				_saveID++;
			} else {
				if(_isSaveOpp)
				{
					ToolKit.log("卡片缓存结束");
					_isSaveOpp = false;
					_saveID = 0;
					//					_saveNum = _blackBoardContainer.getBloakBoardNum();
					_saveNum = _boards.length;
				} else {
					ToolKit.log("缓存结束");
					_isSaveOpp = true;
					_saveID = 0;
					_saveTimer.reset();
					_saveTimer.stop();
					_loadingPage.visible = false;
					_saveArrs.length = 0;
				}
			}
		}
		
		private function onBmpdStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onBmpdStage);
			try
			{
				_stageBmpd = new BitmapData(ApplicationData.getInstance().screenX,ApplicationData.getInstance().screenY,true);
				_stageBmpd.draw(stage);
				CameraPhoto.setBitMapData(_stageBmpd,0);
				
				_desBtn.visible = true;
//				Tool.log("无法完成绘图 ");
				_smallBoardCon.visible = true;
				_tools.visible = true;
				_spCon.setPanelVisible(true);
				_phoneTools1.visible = true;
				_phoneTools2.visible = true;
				_yingGuangBi.showTools();
				_desBtn.visible = true;
			} 
			catch(error:Error) 
			{
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"保存图片失败，请再次保存");
				setTimeout(function ():void{
					NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
				},2000);
				_desBtn.visible = true;
				//Tool.log("无法完成绘图 ");
				_smallBoardCon.visible = true;
				_tools.visible = true;
				_spCon.setPanelVisible(true);
				_phoneTools1.visible = true;
				_phoneTools2.visible = true;
				_yingGuangBi.showTools();
				_desBtn.visible = true;
			}
		}
		
		private function onDengBianClose(event:Event):void
		{
			event.target.removeEventListener(Event.CLOSE,onDengBianClose);
			if(event.target is ZhiChi)
			{
//				_spCon.addPanelSprite(_liangJiaoQi);
				_zhiChi.parent.removeChild(_zhiChi);
				_zhiChi.reset();
				_zhiChi =null;
			}else if(event.target is DengBianSanJiao)
			{
				_dengBianSanJiao.parent.removeChild(_dengBianSanJiao);
				_dengBianSanJiao.reset();
				_dengBianSanJiao=null;
			}else if(event.target is ZhiJiaoSanJiao)
			{
				_zhiJoapSanJiao.parent.removeChild(_zhiJoapSanJiao);
				_zhiJoapSanJiao.reset();
				_zhiJoapSanJiao=null;
			}else if(event.target is LiangJiaoQi){
				_liangJiaoQi.parent.removeChild(_liangJiaoQi);
				_liangJiaoQi.reset();
				_liangJiaoQi=null;
			}else if(event.target is YuanGui2){
				_yuanGui2.parent.removeChild(_yuanGui2);				
				_yuanGui2.reset();
				_yuanGui2=null;
			}
		}
		
		private function hideContent():void
		{ 
			if(_cator)
			{
				_cator.visible = false;
			}
			_smallBoardCon.visible = false;
			_chuanLianBtn.visible = false;
			_boardThumb.visible = false;
			_yingGuangBi.visible = false;
		}
		
		private function showContent():void
		{
			
			_smallBoardCon.visible = true;
			_chuanLianBtn.visible = true;
			_boardThumb.visible = true;
			_yingGuangBi.visible = true;
			if(_cator)
			{
				_cator.visible = true;
			}
		}
		
		private function onDesBtnClick(e:MouseEvent):void
		{
			/*if(_phoneTools1.visible == true)
			{
				if(_phoneTools1.y!=921.65)
				{
					Tweener.addTween(_phoneTools1,{y:921.65,visible:true,time:0.5});
					Tweener.addTween(_phoneTools2,{y:-2,visible:true,time:0.5});
				}else{
					Tweener.addTween(_phoneTools1,{y:1080,visible:true,time:0.5});
					Tweener.addTween(_phoneTools2,{y:-150,visible:true,time:0.5});
				}
			}*/
			
			/*if(_hemiCon.visible == false)
			{
				_hemiCon.visible = true;
				_hemiCon.outIn();
			}else{
				Tweener.addTween(_hemiCon,{time:0.1,visible:false});
				_hemiCon.reset();
			}*/
		}
		
		private function onSmallBoardClose(e:Event=null):void
		{
			_smallBoardCon.x = -(_smallBoardCon.width-20);
			_smallBoardCon.y = (ConstData.stageHeight-64-_smallBoardCon.height)*0.5;
			_smallBoardCon.isXiFu = true;
		}
		
		private function onTanZhaoDengClose(e:Event):void
		{
			_tanZhangDeng.visible = false;
		}
		
		/**
		 * 
		 * @param e
		 * 确定U盘模式登录
		 */		
		private function onUDiskModeChange(e:Event):void
		{
			_tools.showUDiskButton();
			
			/*_hemiCon.initData(null);
			_hemiCon.visible = true;
			_hemiCon.outIn();*/
		}
		
		private function onUDiskModeClose(e:Event):void
		{
			_loginPlugin.visible = false;
			_tools.hideUDiskButton();
			
			/*_hemiCon.inOut();*/
		}
		
		private function onLoginPluginClose(event:Event):void
		{
			_loginPlugin.visible = false;
		}
		
		private function setCheXiaoChongZuo():void
		{
//			_blackBoardContainer.setArrID();
			var jlNum:int = _blackBoardContainer.setArrID();
			//			trace(_blackBoardContainer.jlArr.length,_blackBoardContainer.stepID,"+++++++++")
			if(jlNum>0){
				if(_blackBoardContainer.stepID==jlNum-1)
				{//在没有撤销的时候  重做按钮不能点击
					_tools.gotoStop(false,1,2);
					_tools.gotoStop(false,0,1);
					_phoneTools1.gotoStop(false,1,2);
					_phoneTools1.gotoStop(false,0,1);
				}else if(_blackBoardContainer.stepID==-1){
					_tools.gotoStop(false,0,2);
					_tools.gotoStop(false,1,1);
					_phoneTools1.gotoStop(false,0,2);
					_phoneTools1.gotoStop(false,1,1);
				}else{
					_tools.gotoStop(true,0,1);
					_phoneTools1.gotoStop(true,0,1);
				}
			}else{
				if(jlNum==0)
				{
					_tools.gotoStop(true,0,2);
					_phoneTools1.gotoStop(true,0,2);
				}
			}
		}
		
		private function onLogin(e:LoginEvent):void
		{
			_tools.gotoLocalBtnGotoStop(2);
		}
		
		private function onAgainLogin(e:LoginEvent):void
		{
			_tools.gotoLocalBtnGotoStop(1);
		}
		
		public function listNotificationInterests():Array
		{
			return [NotificationIDs.ADD_BOARD,NotificationIDs.CHANGE_BOARD,NotificationIDs.REMOVE_BOARD,NotificationIDs.CLEAR_ALL,NotificationIDs.SHOW_WENLI,
				NotificationIDs.HIDE_SHOW_MENU,NotificationIDs.PHOTO_GRAPH,NotificationIDs.COMPLETE_MEDIA,NotificationIDs.TUYA_BEGIN,NotificationIDs.FANGDAJING,
				NotificationIDs.UDISK_FILE,NotificationIDs.LOCAL_FILE,NotificationIDs.SELECT_LESSON_CLASS,NotificationIDs.CHEXIAO,NotificationIDs.CHONEZUO,
				NotificationIDs.TUYA_END,NotificationIDs.COPY_BLACKBOARD,NotificationIDs.MIN_DIS_THUMB,NotificationIDs.OPEN_JISUANQI,NotificationIDs.OPEN_GONGJULAN,
				NotificationIDs.PIANHAO_SETTING,NotificationIDs.DRAW_SHAPE_END,NotificationIDs.DRAW_SHAPE,NotificationIDs.SHUXUE_GONGJU,NotificationIDs.SHUXUE_GONGJU_END,
				NotificationIDs.CHANGE_PHONE_MODEL,NotificationIDs.CHANGE_IPTID_MODEL,NotificationIDs.CHANGE_SMALLBOARD,NotificationIDs.MINI_WINDOWN,NotificationIDs.MAX_WINDOW,
				NotificationIDs.TONGBU_BTN,NotificationIDs.RE_LOGIN,NotificationIDs.START_SHOTSCREEN,NotificationIDs.COPY_DATA,NotificationIDs.HIDE_LOADING,NotificationIDs.OPEN_FILE,
				NotificationIDs.SHOW_LOADING,NotificationIDs.OPEN_TANZHAODENG,NotificationIDs.CLOSE_TANZHAODENG,NotificationIDs.OPEN_YINGGUANGBI,NotificationIDs.CLOSE_YINGGUANGBI,
				NotificationIDs.REMOVE_PHONEUSER,NotificationIDs.SAVE_ALL,NotificationIDs.SETTING_APP,NotificationIDs.SETTING_ENVIR,NotificationIDs.SETTINGENVIR_COMPLETE,
				NotificationIDs.SOCKET_SHIBAI,NotificationIDs.HUANDENGMODEL,NotificationIDs.CLEAR_SYSTEMMEMORY,NotificationIDs.HUANDENGMODEL_CLOSELUCK,NotificationIDs.ADD_GHONEMEDIA,
				NotificationIDs.VOTE_END
			];
		}
		
		public function onRegister():void
		{
			
		}
		
		public function onRemove():void
		{
			
		}
		
	}
}