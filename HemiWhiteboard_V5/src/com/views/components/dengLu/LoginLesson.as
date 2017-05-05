package com.views.components.dengLu
{
	import com.cndragon.baby.plugs.Login.Btn;
	import com.cndragon.baby.plugs.Login.CBj;
	import com.cndragon.baby.plugs.Login.KcBj;
	import com.cndragon.baby.plugs.Login.KeChengBtn;
	import com.cndragon.baby.plugs.Login.SelectCourse;
	import com.events.LoginEvent;
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.setTimeout;
	

	public class LoginLesson extends Sprite
	{
		private var _selectcourse:SelectCourse;
		private var _xml:XML;
		private var _selectMask:Shape;
		private var _classMask:Shape;
		private var _tempY:Number;
		private var _downY:Number;
		private var _kcBj:KcBj;
		private var _cBj:CBj;
		private var _sp_class:Sprite;
		private var _sp_kh:Sprite;
		private var _kechengID:int;
		private var _tempclassY:Number;
		private var _downclassY:Number;
		private var _tempBtn:MovieClip;
		private var _tempKeshiBtn:MovieClip;
		private var _tempClassBtn:MovieClip;
		private var _classID:int;
		private var _userXML:XML;
		
		private var _meetingXML:XML;
		private var _meetingLdr:URLLoader;
	
		public function LoginLesson()
		{
			//initContent();
			//initListener();
		}
		
		public function dispose(xml:XML):void
		{
			if(_sp_class == null){
				
			}else{
				ClearContainer(_sp_class);
				ClearContainer(_sp_kh);
				_xml = xml;
			}
		}
		
		public function setParams(params:*):void
		{
			//模拟数据
			_xml = params;
		//	trace("模拟数据");
			initContent();
			initListener();
		}	
		
		private function initContent():void
		{	
			if(_selectcourse == null){
				_selectcourse = new SelectCourse();
			}			
//			_selectcourse.x = 695;
//			_selectcourse.y = 307;
			this.addChild(_selectcourse);
			
			if(_sp_class == null){
				_sp_class = new Sprite();
			}			
			_sp_class.x = 167;
			_sp_class.y = 145;
			this.addChildAt(_sp_class,0);
			if(_sp_kh == null){
				_sp_kh = new Sprite();
			}			
			_sp_kh.x = 5 ;
			_sp_kh.y = 145;
			this.addChild(_sp_kh);
			
			if(_kcBj == null){
				_kcBj = new KcBj();
			}			
			_kcBj.x = 5 ;
			_kcBj.y = 145;
			this.addChildAt(_kcBj,0);
			if(_cBj == null){
				_cBj = new CBj();
			}			
			_cBj.x = 167;
			_cBj.y = 145;
			this.addChildAt(_cBj,0);
			
			if(_selectMask == null)	{		
				_selectMask = new Shape();
			}			
//			_selectMask.x = 698;
//			_selectMask.y = 460;
			_selectMask.x = _sp_kh.x,
			_selectMask.y = _sp_kh.y,
			_selectMask.graphics.beginFill(0xFFF00F);
			_selectMask.graphics.drawRect(0,0,150,148);
			_selectMask.graphics.endFill();
			this.addChild(_selectMask);
			_sp_kh.mask = _selectMask;
			if(_classMask == null){			
				_classMask = new Shape();
			}			
			_classMask.x = _sp_class.x;
			_classMask.y = _sp_class.y;
			this.addChild(_classMask);
			
			_classMask.graphics.beginFill(0xFF0000);
			_classMask.graphics.drawRect(0,0,216,148);
			_classMask.graphics.endFill();			
			_sp_class.mask = _classMask;
			
			_meetingLdr = new URLLoader();
			_meetingLdr.addEventListener(Event.COMPLETE,onMeetingXmlEd);
			
//			_selectcourse.deterBtn.visible = false;
			addLesson();
			chuShi();
		}
		
		private function chuShi():void
		{
			_cBj.visible = true;
			_kcBj.visible = true;
			_sp_class.visible = true;
			_sp_kh.visible = true;
			if(ApplicationData.getInstance().UDiskModel){
//				_selectcourse.againBtn.visible = false;	
			}else{
//				_selectcourse.againBtn.visible = true;	
			}
		}
		
		private function initListener():void
		{
			_selectcourse.classBtn.gotoAndStop(1);
			_selectcourse.courseBtn.gotoAndStop(1);
			_sp_class.addEventListener(MouseEvent.MOUSE_DOWN,onClassDown);			
			_sp_kh.addEventListener(MouseEvent.MOUSE_DOWN,onKeChengDown);
			_selectcourse.deterBtn.buttonMode = true;
			_selectcourse.deterBtn.addEventListener(MouseEvent.CLICK,ondeterBtnClick);
//			_selectcourse.againBtn.addEventListener(MouseEvent.CLICK,onagainBtnClick);
			_selectcourse.courseBtn.addEventListener(MouseEvent.CLICK,oncourseBtnClick);
			_selectcourse.classBtn.addEventListener(MouseEvent.CLICK,onclassBtnClick);
			_selectcourse.courseBtn.title.mouseEnabled = false;
			_selectcourse.classBtn.title.mouseEnabled = false;
			_selectcourse.courseBtn.buttonMode =true;
			_selectcourse.classBtn.buttonMode =true;			
		}
		/**
		 * 课时选择
		 * */
		protected function onClassDown(event:MouseEvent):void
		{
			_tempclassY = _sp_class.mouseY;
			_downclassY = mouseY;
			_sp_class.addEventListener(MouseEvent.MOUSE_MOVE,onClassMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onclassUp);
		}
		
		public function hideShowAgainBtn(boo:Boolean):void
		{
		//	_selectcourse.againBtn.visible = boo;	
		}
		
		protected function onClassMove(event:MouseEvent):void
		{
			Tweener.addTween(_sp_class,{y:mouseY-_tempclassY,time:0.3});		
		}
		
		protected function onclassUp(event:MouseEvent):void
		{
			_sp_class.removeEventListener(MouseEvent.MOUSE_MOVE,onClassMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onclassUp);
			if(_tempKeshiBtn!=null){
				_tempKeshiBtn.gotoAndStop(1);
			}
			if(Math.abs(_downclassY-mouseY)>10){
				if(_sp_class.y >_cBj.y){//trace("up0");
				Tweener.addTween(_sp_class,{y:_cBj.y,time:0.5});
				}else if(_sp_class.y < (-_sp_class.height+ _cBj.height+_cBj.y)){//trace("up1");
					if(_sp_class.height<_cBj.height){
						Tweener.addTween(_sp_class,{y:_cBj.y,time:0.5});
					}else{
						Tweener.addTween(_sp_class,{y:(-_sp_class.height+ _cBj.height+_cBj.y-10),time:0.5});
					}
				}
			}else{
//				trace("点击class",event.target.name);
				if(event.target.name.split("_")[0] == "btn")
				{
					_classID = event.target.name.split("_")[1];
//					trace(classID,"classID");
//					if(event.target.name.substr(0,4)=="btn_"){
//						_tempKeshiBtn = event.target as MovieClip;
//						_tempKeshiBtn.gotoAndStop(2);
//					}
					if(_tempKeshiBtn)
					{
						_tempKeshiBtn.gotoAndStop(1);
					}
					_tempKeshiBtn = event.target as MovieClip;
					_tempKeshiBtn.gotoAndStop(2);
					
//					trace(_xml.type[0].item[_kechengID],"222222");
					if(_xml.type[0].item[_kechengID].list[_classID]!=undefined){
						_selectcourse.classBtn.title.text = _xml.type[0].item[_kechengID].list[_classID].@title;
					}
					if(_tempKeshiBtn.daoChuBtn!=null)
					{
						if(ApplicationData.getInstance().UDiskModel)
						{
							_tempKeshiBtn.daoChuBtn.gotoAndStop(1);
						}else{
							_tempKeshiBtn.daoChuBtn.gotoAndStop(2);
						}
					}
					
//					event.target.gotoAndStop(1);
				//	Tweener.addTween(event.target,{delay:0.01,onComplete:goto});
					/*function goto():void
					{
						
						_cBj.visible = false;
						_kcBj.visible = false;
						_sp_class.visible = false;
						_sp_kh.visible = false;
						_selectcourse.deterBtn.visible = true;
					}*/
				}else if(event.target.name=="daoChuBtn")			
				{
//					trace(ApplicationData.getInstance().UDiskModel,ApplicationData.getInstance().UDiskJieRu);
					if(ApplicationData.getInstance().UDiskModel==false)
					{
						if(ApplicationData.getInstance().UDiskJieRu==false)
						{
							NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"没有检测到U盘，无法进行拷贝，请检查...");
							Tweener.addTween(_tempKeshiBtn,{time:1,onComplete:changeEnd});
							
							function changeEnd():void
							{
								NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"没有检测到U盘，请检查...");
							}
							return;
						}
					}
					
					if(_tempKeshiBtn)
					{
						_tempKeshiBtn.gotoAndStop(2);
					}
					var path:String = "";
					if(_xml.type[0].item[_kechengID].list[_classID]!=undefined){
//						if(ApplicationData.getInstance().UDiskModel)
//						{
//							path = ApplicationData.getInstance().UDiskPath + _xml.type[0].item[_kechengID].list[_classID].@path;
//						}else{
//							path =  ApplicationData.getInstance().assetsPath + _xml.type[0].item[_kechengID].list[_classID].@path;
//						}
						path = _xml.type[0].item[_kechengID].list[_classID].@path;
						trace("将数据导入和导出",path);
					}
					if(path!="")
					{
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在導出文件请稍等...");
						NotificationFactory.sendNotification(NotificationIDs.COPY_DATA,path);
					}
					
				}
			}
		}
		
		private function addLesson():void
		{		
			if(_xml==null)return;
			for(var i:int =0;i<_xml.type[0].item.length();i++)
			{
				var _kcBtn:KeChengBtn = new KeChengBtn();
				_kcBtn.name = "keChengBtn_"+i;
				_kcBtn.title.text = _xml.type[0].item[i].@title;
				_kcBtn.title.mouseEnabled = false;
				_kcBtn.x = 2 ;
				_kcBtn.y = 10+i*35;
				_sp_kh.addChild(_kcBtn);
			}
//			trace(_xml,"---");
			_selectcourse.courseBtn.title.text = _xml.type[0].item[0].@title;			
			_selectcourse.welcome.text ="欢迎您，"+ _xml.username +"老师,你已登录成功，请选择课程及课时。";
			
			(_sp_kh.getChildByName("keChengBtn_0") as MovieClip).gotoAndStop(2);
			_sp_kh.graphics.clear();
			_sp_kh.graphics.beginFill(0x000000,0);
			_sp_kh.graphics.drawRect(0,10,_selectcourse.courseBtn.width,_sp_kh.height-5);
			_sp_kh.graphics.endFill();			
			addClass(0);
		}
		
		/**
		 * 课程
		 * */
		protected function onKeChengDown(event:MouseEvent):void
		{	
			_downY = mouseY;
			_tempY = _sp_kh.mouseY;
//			trace(_sp_kh.mouseY,mouseY);		
			_sp_kh.addEventListener(MouseEvent.MOUSE_MOVE,onkeChengMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onstageUp);			
		}
		
		protected function onstageUp(event:MouseEvent):void
		{
			_sp_kh.removeEventListener(MouseEvent.MOUSE_MOVE,onkeChengMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onstageUp);
			if(Math.abs(mouseY-_downY)>10){
				if(_sp_kh.y>_selectMask.y){
					Tweener.addTween(_sp_kh,{y:_selectMask.y,time:0.3});
				}else if(_sp_kh.y <- _sp_kh.height + _selectMask.height +_kcBj.y)
				{
					if(_sp_kh.height>_selectMask.height){
						Tweener.addTween(_sp_kh,{y:(-_sp_kh.height+ _kcBj.height+_kcBj.y-10),time:0.3});
					}else{
						Tweener.addTween(_sp_kh,{y:_kcBj.y,time:0.3});
					}
					
				}
			}else if(Math.abs(mouseY-_downY)<10){
				//trace("点击",event.target.name);
				huiFu();
				if(event.target.name.split("_")[0] == "keChengBtn"){
					ClearContainer(_sp_class);
					_kechengID = event.target.name.split("_")[1];
//					PATH.lessonID = _kechengID;
//					trace(_kechengID,"_kechengID");
					_selectcourse.deterBtn.visible = true;
					var str:String = _xml.type[0].item[_kechengID].@title;
					_selectcourse.courseBtn.title.text = str;
					_selectcourse.courseBtn.title.mouseEnabled = false;
					(_sp_kh.getChildByName("keChengBtn_0") as MovieClip).gotoAndStop(1);
					/*if(event.target.name.split("_")[0]!="keChengBtn"){
						return;
					}*/
					if(_tempBtn != null){
						_tempBtn.gotoAndStop(1);
					}			
					_tempBtn = event.target as MovieClip;
					_tempBtn.gotoAndStop(2);
					addClass(_kechengID);
				}				
			}
			
		}
		
		protected function onkeChengMove(e:MouseEvent):void
		{
			Tweener.addTween(_sp_kh,{y:mouseY-_tempY,time:0.3});
		}
		
		private function addClass(id:int):void
		{
			ClearContainer(_sp_class);
		//	trace(_xml,"kecehgn")
			if(_xml.type[0].item[id].list.length()==0)return;
			for(var i:int =0;i<_xml.type[0].item[id].list.length();i++)
			{
				var btn:Btn = new Btn();
				btn.name ="btn_"+i;
				btn.title.mouseEnabled =false;
				btn.title.text = _xml.type[0].item[id].list[i].@title;
				btn.y = 10+i*35;
				_sp_class.addChild(btn);
			}
			_selectcourse.classBtn.title.text = _xml.type[0].item[id].list[0].@title;
			_sp_class.graphics.clear();
			_sp_class.graphics.beginFill(0x000000,0);
			_sp_class.graphics.drawRect(0,14,_cBj.width,_sp_class.height);
			_sp_class.graphics.endFill();
		}
		
		private function oncourseBtnClick(e:MouseEvent):void
		{
			if(_sp_kh.visible == false){
				e.target.gotoAndStop(2);
				_sp_kh.visible = true;
				_kcBj.visible = true;
				_cBj.visible = true;
				_selectcourse.deterBtn.visible = false;
				_sp_class.visible = true;
			}else{		
				e.target.gotoAndStop(1);
				_sp_kh.visible = false;
				_kcBj.visible = false;
				_sp_class.visible = false;
				_cBj.visible = false;
				_selectcourse.deterBtn.visible = true;	
			}
		}
		
		private function onclassBtnClick(e:MouseEvent):void
		{
			if(_sp_class.visible == false){
				_sp_class.visible = true;
				_cBj.visible = true;
				_selectcourse.deterBtn.visible = false;
				e.target.gotoAndStop(2);
			}else{
				e.target.gotoAndStop(1);
				_sp_class.visible = false;
				_cBj.visible = false;
				_selectcourse.deterBtn.visible = true;				
			}
		}
		
		/**
		 *重新登录按钮点击
		 * */
		private function onagainBtnClick(e:MouseEvent):void
		{
			//_selectcourse.visible = false;
			//trace("发送消息重新登录");
			_selectcourse.welcome.text = "";
			_kcBj.visible = true;
			_cBj.visible = true;
			_selectcourse.deterBtn.visible = false;
			ApplicationData.getInstance().localLessonLogin =false;
			ApplicationData.getInstance().userXML =null;
			ApplicationData.getInstance().userName = "";
			ApplicationData.getInstance().nowLessonXML = null;
			var eve:LoginEvent = new LoginEvent(LoginEvent.AGAINLOGIN);
			this.dispatchEvent(eve);
		}
		/**
		 * 确定按钮点击
		 * 
		 * */
		protected function ondeterBtnClick(e:MouseEvent):void
		{
		//	_meetingLdr.load(new URLRequest(ApplicationData.getInstance().assetsPath+_xml.kecheng.item[_kechengID].list[_classID].@path));
//			ApplicationData.getInstance().blackID = ApplicationData.getInstance().userXML.pianHao.backGround;
			ApplicationData.getInstance().nowLessonXML = XML(_xml.type[0].item[_kechengID]);
			NotificationFactory.sendNotification(NotificationIDs.SELECT_LESSON_CLASS);
			var eve:MouseEvent=new MouseEvent(MouseEvent.DOUBLE_CLICK);
			//stage.mouseX = mouseX;
			//stage.mouseY=mouseY;
			NotificationFactory.sendNotification(NotificationIDs.STAGE_DOUBLE_CLICK,eve);
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.ZIDONG_CHANGELESSON);
			},10);
		}
		
		private function onMeetingXmlEd(e:Event):void
		{
			trace("数据加载w发送消息");
		}

		/**
		 * 清除容器
		 * */
		private function ClearContainer(sp:Sprite):void
		{
			while(sp.numChildren>0){
				sp.removeChildAt(0);
			}
		}
		
		private function huiFu():void
		{
			_sp_class.y =_cBj.y;
		}
		
		public function reset():void
		{
			_classID = 0;
			_kechengID = 0;
		}

		public function get kechengID():int
		{
			return _kechengID;
		}

		public function get classID():int
		{
			return _classID;
		}

	
	}
}