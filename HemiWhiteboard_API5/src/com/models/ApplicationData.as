package com.models
{
	import com.models.vo.StyleVO;
	import com.models.vo.UserVO;
	import com.models.vo.XiangCeVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.GetDateName;
	import com.scxlib.OppMedia;
	import com.views.components.SocketComponents;
	import com.windows.MinAppWindow;
	
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.NetConnection;
	import flash.net.SharedObject;
	import flash.net.Socket;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Capabilities;
	import flash.text.Font;
	import flash.text.TextField;

	/**
	 * ...
	 * @author LiuY
	 */
	public class ApplicationData extends EventDispatcher
	{
		static private var _instance:ApplicationData;
		
		private var _loaded:Boolean = false;
		private var _funArr:Array;
		private var _funCount:int;
		private var _configXML:XML;
		private var _conXml:XML;
		private var _appPath:String;
		private var _assetsPath:String;
		public var userName:String="";
		private var _closePassword:String;
		public var nowObj:MovieClip;
		public var closeBtn:Sprite;
		public var menuXML:XML;
		public var userXML:XML=null;
		public var shuangNaoXML:XML=null;
		public var UDiskXML:XML;
		public var nowLessonXML:XML;//当前课的xml
		public var nowLesson:String;//当前课的xml
		public var currLessonXML:XML;//当前课堂数据
		
		public var blachBoardLength:int;//黑板的个数
		public var nowBoardID:int;//当前黑板的id
		public var styleVO:StyleVO = new StyleVO();
		public var xiangCeVO:XiangCeVO = new XiangCeVO();
		
		public var UDiskModel:Boolean;
		public var UDiskPath:String;
		public var isLock:Boolean= false;
		public var UDiskJieRu:Boolean =false;
		public var isTuYaBan:Boolean;//是否在涂鸦板模式下
		public var isOpp:Boolean;//是否在涂鸦板模式下
		public var maxBoard:int=15;//限制黑板的个数
		public var localLessonLogin:Boolean;//本地课件已登录
		public var jiLuArr:Array=[];
		public var stepID:int;
		public var oppArr:Array=[];
//		public var oppArr:Vector.<OppMedia> = new Vector.<OppMedia>;
		public var xiangCeLunBoTime:Number=5;
		public var boardArr:Array=[];
		public var bgs:Array=[];
		public var bgThumbs:Array=[];
		
		public var menuX:Number=0;//全局记录菜单所在的位置
		public var blackID:int = 0;//默认的背景颜色
		public var port:int =0;//默认的背景颜色
		public var pianHaoObj:StyleVO;//默认的喜好值
		public var smallBoardArr:Vector.<String> = new Vector.<String>;
		public var screenX:Number=0;
		public var screenY:Number=0;
		public var msgNum:Number=Math.random()*10000000000000000;
		public var hitSp:Sprite;
//		public var videoWin:MinAppWindow=null;
//		public var whiteBoardObject:SharedObject;
		public var serverAddress:String;
		public var socketServer:String;
		public var pptAddress:String;
		public var httpAssets:String;
		public var httpAddress:String;
		public var netConnect:NetConnection;
		public var users:Vector.<UserVO> = new Vector.<UserVO>;
		public var clientType:int=0;
		public var positionID:int;//机器位置编号
		public var model:int;//机器位置编号
		public var classroom:String;//机器位置编号
		
		public function ApplicationData(s:S) 
		{
//			var obj:Object = new Object();
//			obj.brushID = 2;
//			obj.colorID = 4;
//			obj.blackID = 0;
//			obj.thincessID = 5;
//			pianHaoObj = obj;
			screenX = 1920;
			screenY = 1080;
			
			var file1:File=File.applicationDirectory;   
			var appPath:String = file1.nativePath+"/";
			var pattern:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
			_appPath = appPath.replace(pattern, "/");
			
			var pianHaoVO:StyleVO = new StyleVO();
			pianHaoVO.blackID = 1;
			pianHaoVO.lcolor  = 4;
			pianHaoVO.lineStyle = 1;
			pianHaoVO.lineThickness = 5;
			pianHaoObj = pianHaoVO;
			
			var bgFiles:File = new File(_appPath+ "assets/backGround/backbround");
			var files:Array = bgFiles.getDirectoryListing();
			var temps:Array = [];
			for (var j:int = 0; j < files.length; j++) 
			{
				var obj:Object = new Object();
				obj.name = files[j].name.split(".")[0];
				obj.file = files[j];
				temps.push(obj);
			}
			
			var bgFiles1:File = new File(_appPath+ "assets/backGround/thumb");
			var files1:Array = bgFiles1.getDirectoryListing();
			var temps1:Array = [];
			for (var j1:int = 0; j1 < files1.length; j1++) 
			{
				var obj1:Object = new Object();
				obj1.name = files1[j1].name.split(".")[0];
				obj1.file = files1[j1];
				temps1.push(obj1);
			}
			
			bgs=[];
			bgThumbs=[];
			
			temps.sortOn(["name"],[Array.NUMERIC]);
			for (var i:int = 0; i < temps.length; i++) 
			{
				bgs.push(temps[i].file);
			}
			
			temps1.sortOn(["name"],[Array.NUMERIC]);
			for (var i1:int = 0; i1 < temps1.length; i1++) 
			{
				bgThumbs.push(temps1[i1].file);
			}
		}
		static public function getInstance():ApplicationData
		{
			if (_instance == null)
			{
				_instance = new ApplicationData(new S());
			}
			return _instance;
		}
		
		/**
		 * 初始化数据
		 */
		public function initAppData():void
		{
			if (_loaded) return;
			_funArr = [loadYaHeiFont,loadSongTiFont,loadConfig,loadMenuXML];
			_funCount = 0;
			_funArr[0]();
		}
		
		private function funEnd():void
		{
			//累加器
			_funCount++;
			if(_funCount == _funArr.length)
			{
				// trace("加载完成")
				_loaded = true;
				dispatchEvent(new Event(Event.COMPLETE));
				NotificationFactory.sendNotification(NotificationIDs.APP_DATA_LOADED);
			}else{
				_funArr[_funCount]();
			}
		}
		
		/**
		 * 加载配置xml文件
		 * */
		private function loadConfig():void
		{
			var ldr:URLLoader=new URLLoader();
			ldr.load(new URLRequest("config/config.xml"));
			ldr.addEventListener(Event.COMPLETE,configEnd);
			NotificationFactory.sendNotification(NotificationIDs.APP_DATA_LOADING,"正在加载config.xml...");
		}
		
		protected function configEnd(event:Event):void
		{
			_configXML=XML(event.target.data);
			
			if(_configXML.local=="")
			{
//				_assetsPath=_configXML.local;
				var file1:File=File.applicationDirectory;   
				_assetsPath=file1.nativePath+"/";
				var pattern:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
				_assetsPath = _assetsPath.replace(pattern, "/")+"DIGITALBOARD/";
			}else{
				_assetsPath=_configXML.local;
			}
			socketServer = _configXML.socketServer;
			_closePassword=_configXML.closePassword;
			model = _configXML.model;
			port = _configXML.port;
			_closePassword=_configXML.closePassword;
			serverAddress=_configXML.serverAddress;
			pptAddress=_configXML.pptAddress;
			httpAssets=_configXML.httpAssets;
			httpAddress=_configXML.httpAddress;
			clientType = 0;
			classroom=_configXML.classroom;
			positionID=_configXML.positionID;
			funEnd();
		}
		
		private function loadMenuXML():void 
		{
			var ldr:URLLoader=new URLLoader();
			ldr.load(new URLRequest("config/menu.xml"));
			ldr.addEventListener(Event.COMPLETE,newsXmlEnd);
			NotificationFactory.sendNotification(NotificationIDs.APP_DATA_LOADING,"正在加载menu.xml...");
		}
		
		private function newsXmlEnd(e:Event):void 
		{
			menuXML=XML(e.target.data);
			funEnd();
		}
		
		private function loadTLFYaHeiFont():void {
			//读取雅黑字体
			var fontLoader:Loader = new Loader();
			fontLoader.load(new URLRequest("fonts/YaHei_font.swf"));
			fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onTLFYaHeiLoaded);
			NotificationFactory.sendNotification(NotificationIDs.APP_DATA_LOADING,"正在初始化雅黑字体...");
		}
		
		private function onTLFYaHeiLoaded(e:Event):void 
		{
			funEnd();
		}

		private function loadRollTextXml():void 
		{
			var ldr:URLLoader=new URLLoader();
			ldr.load(new URLRequest(_assetsPath+"rolltxt.xml"));
			ldr.addEventListener(Event.COMPLETE,rollTextXmlEnd);
		}
		
		private function rollTextXmlEnd(e:Event):void 
		{
			//rollTextXML=XML(e.target.data);
			funEnd();
		}
		
		private function loadYaHeiFont():void {
			//读取雅黑字体
			var fontLoader:Loader = new Loader();
			fontLoader.load(new URLRequest("fonts/YaHei_font.swf"));
			fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onYaHeiLoaded);
			NotificationFactory.sendNotification(NotificationIDs.APP_DATA_LOADING,"正在初始化雅黑字体...");
		}
		
		private function onYaHeiLoaded(e:Event):void 
		{
			funEnd();
		}
		
		private function loadSongTiFont():void {
			//读取宋体
			var fontLoader:Loader = new Loader();
			fontLoader.load(new URLRequest("fonts/SongTi_font.swf"));
			fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onSongTiLoaded);
			NotificationFactory.sendNotification(NotificationIDs.APP_DATA_LOADING,"正在初始化宋体字体...");
		}
		
		private function onSongTiLoaded(e:Event):void 
		{
			funEnd();
		}
		
		private function loadHeiTi():void {
			//读取黑体
			var fontLoader:Loader = new Loader();
			fontLoader.load(new URLRequest("fonts/HeiTi_font.swf"));
			fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onHeiTiLoaded);
			NotificationFactory.sendNotification(NotificationIDs.APP_DATA_LOADING,"正在初始化黑体字体...");
		}
		
		private function onHeiTiLoaded(e:Event):void 
		{
			funEnd();
		}
		/**
		 * 软件配置xml
		 * */
		public function get configXML():XML
		{
			return _configXML;
		}
		/**
		 * 软件资源绝对路径
		 * */
		public function get assetsPath():String
		{
			return _assetsPath;
		}
		/**
		 * 软件根目录
		 * */
		public function get appPath():String
		{
			return _appPath;
		}
		/**
		 * 软件关闭密码
		 * */
		public function get closePassword():String
		{
			return _closePassword;
		}

		public function get conXml():XML
		{
			return _conXml;
		}

		
	}
}

class S{}