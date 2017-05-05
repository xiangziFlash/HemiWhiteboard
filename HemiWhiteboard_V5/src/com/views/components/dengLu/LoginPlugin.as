package  com.views.components.dengLu
{
	import com.cndragon.baby.plugs.Login.LoginBeiJing;
	import com.cndragon.baby.plugs.Login.LoginCloseBtn;
	import com.events.LoginEvent;
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	public class LoginPlugin extends Sprite
	{
		private var _loginboard:LoginKeyBoard;
		private var _loginBj:LoginBeiJing;
		private var _pianHaoSet:PianHaoSetting;
		private var _loginLesson:LoginLesson;
		private var _landconf:XML;
		private var _closeBtn:LoginCloseBtn;
		private var _isLogin:Boolean;
		private var _isLocalModel:Boolean;
		
		public function LoginPlugin() 
		{
			this.graphics.beginFill(0,.5)
			this.graphics.drawRect(0,0,1920,1080);
			this.graphics.endFill();
			initContent();
			initListener();
		}		
		
		private function initContent():void
		{ 
			_landconf = ApplicationData.getInstance().configXML;
			_loginBj = new LoginBeiJing();
			_loginBj.x = (1920-942)*0.5;
			_loginBj.y = (1080-373)*0.5;
			
			_loginboard = new LoginKeyBoard();				
			_loginboard.initialize();
			_loginboard.x =_loginBj.x + 242.05;
			_loginboard.y = _loginBj.y + 47;
			
			_loginLesson = new LoginLesson();			
			_loginLesson.visible = false;
			_loginLesson.x = _loginBj.x +  244;
			_loginLesson.y = _loginBj.y + 47;
			
			_pianHaoSet = new PianHaoSetting();
			_pianHaoSet.x = _loginBj.x;
			_pianHaoSet.y = _loginBj.y;
			
			this.addChild(_loginBj);
			this.addChild(_loginboard);
			this.addChild(_loginLesson);
			this.addChild(_pianHaoSet);
			_pianHaoSet.visible = false;
		}		
		
		private function initListener():void
		{
			_loginLesson.addEventListener(LoginEvent.AGAINLOGIN,onagainLogin);
			_loginLesson.addEventListener(LoginEvent.DETER,onDeter);
			_loginboard.addEventListener(LoginEvent.LOGIN,onlogin);
//			_loginboard.addEventListener(LoginEvent.PIANHAO,onPianHaoSet);
			_loginBj.closeBtn.addEventListener(MouseEvent.CLICK,oncloseClick);
			_loginBj.suoPingBtn.addEventListener(MouseEvent.CLICK,onSuoPingClick);
			_loginBj.changBtn.addEventListener(MouseEvent.CLICK,onChangeUseClick);
			_loginBj.pianHaoBtn.addEventListener(MouseEvent.CLICK,onPianHaoBtnClick);
			
			_pianHaoSet.addEventListener(Event.CLOSE,onPianHaoSetClose);
		}
		
		private function onPianHaoSetClose(event:Event):void
		{
			_pianHaoSet.visible = false;
		}
		
		private function onPianHaoBtnClick(event:MouseEvent):void
		{
			_pianHaoSet.visible = true;
		}
		
		private function onSuoPingClick(e:MouseEvent):void
		{
			_loginBj.closeBtn.visible = false;
			setHuiFu();
		}

		private function onChangeUseClick(e:MouseEvent):void
		{
			this.dispatchEvent(new LoginEvent(LoginEvent.AGAINLOGIN));
//			_loginBj.closeBtn.visible = false;
			_loginBj.thumb.gotoAndStop(1);
			ApplicationData.getInstance().userXML = null;
			ApplicationData.getInstance().userName = "";
			ApplicationData.getInstance().localLessonLogin = false;
			setHuiFu();
		}
		
		
		private function onlogin(event:LoginEvent):void
		{
			//trace("登录成功");
			_isLocalModel = true;
			_loginBj.closeBtn.visible = true;
			_loginboard.visible =false;
			_loginLesson.reset();
			_loginLesson.visible = true;
			_loginLesson.dispose(event.xml);	
			_loginBj.thumb.gotoAndStop(2);
			_loginBj.suoPingBtn.gotoAndStop(1);
			ApplicationData.getInstance().UDiskModel = false;
			ApplicationData.getInstance().nowLessonXML=null;
			_loginLesson.setParams(event.xml);
//			ApplicationData.getInstance().userXML = event.xml;
//			ApplicationData.getInstance().userName = event.xml.username;
//			ApplicationData.getInstance().userName = "123";
			/*var tempColor:int = event.xml.pianHao.color;
			var tempBg:int = event.xml.pianHao.backGround;
			var tempThickness:int = event.xml.pianHao.thickness;
			var tempLineStyle:int = event.xml.pianHao.lineStyle;*/
			//ApplicationData.getInstance().styleVO.lcolor = tempColor;
		/*	ApplicationData.getInstance().styleVO.blackID = tempBg;
			ApplicationData.getInstance().blackID = tempBg;*/
		//	ApplicationData.getInstance().styleVO.lineThickness = tempThickness;
		//	ApplicationData.getInstance().styleVO.lineStyle = tempLineStyle;
			this.dispatchEvent(new LoginEvent(LoginEvent.LOGIN));
//			NotificationFactory.sendNotification(NotificationIDs.PIANHAO_SETTING,ApplicationData.getInstance().styleVO);
		}
		
		public function loginComplete():void
		{
//			trace(ApplicationData.getInstance().localLessonLogin,"ApplicationData.getInstance().localLessonLogin",ApplicationData.getInstance().UDiskModel);
			//||!ApplicationData.getInstance().UDiskModel
			if(!ApplicationData.getInstance().localLessonLogin)return;//trace("+++++++++++++++++")
			_loginboard.visible =false;
			_loginLesson.visible = true;
			_loginLesson.dispose(ApplicationData.getInstance().userXML);	
			//_loginBj.biaoTi.gotoAndStop(2);
			//trace(event.xml);
			ApplicationData.getInstance().UDiskModel = false;
			//ApplicationData.getInstance().nowLessonXML="";
			_loginLesson.setParams(ApplicationData.getInstance().userXML);
			ApplicationData.getInstance().userName = ApplicationData.getInstance().userXML.username;
//			ApplicationData.getInstance().userName = "123";
		}
		
		public function setLessonParams(xml:XML):void
		{
			_loginboard.visible =false;
			_loginLesson.visible = true;
			//_loginBj.biaoTi.gotoAndStop(2);
			_loginLesson.dispose(xml);	
			_loginLesson.setParams(xml);
			ApplicationData.getInstance().userName = xml.username;
//			ApplicationData.getInstance().userName = "123";
		}
		
		private function onDeter(event:LoginEvent):void
		{
			trace("确定事件已接收");
			if(_isLogin){
				ApplicationData.getInstance().UDiskModel = false;
			}
			_isLogin = false;
			this.dispatchEvent(new LoginEvent(LoginEvent.DETER));
		}
		
		public function hideShowAgainBtn(boo:Boolean):void
		{
			_loginLesson.hideShowAgainBtn(boo);
		}
		
		private function onagainLogin(event:LoginEvent):void
		{
//			trace("重新登录");			
			this.dispatchEvent(new LoginEvent(LoginEvent.AGAINLOGIN));
			_isLocalModel=false;
			_loginBj.thumb.gotoAndStop(1);
			setHuiFu();
		}
		
		public function setHuiFu():void
		{
//			if(_isLocalModel==true)return;
			_loginLesson.visible =false;
			_loginboard.visible = true;
			_loginboard.huiFu();
			_isLogin = true;
		}
		
		private function oncloseClick(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(Event.CLOSE));
		}

		public function get isLocalModel():Boolean
		{
			return _isLocalModel;
		}

		public function set isLocalModel(value:Boolean):void
		{
			_isLocalModel = value;
		}

	}
}