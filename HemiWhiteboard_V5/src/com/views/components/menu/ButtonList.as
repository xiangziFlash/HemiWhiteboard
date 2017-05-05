package com.views.components.menu
{
	import com.controls.ToolKit;
	import com.events.MeetsEvent;
	import com.events.MenuListEvent;
	import com.models.ApplicationData;
	import com.models.vo.FullShowAppVO;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.components.OpenLocalFile;
	import com.windows.FullAppWindow;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	public class ButtonList extends Sprite
	{
		private var _oneBtn:OneButton;
		private var _urlLdr:URLLoader;
		private var _firstLdr:URLLoader;
		private var _vo:MediaVO;
		private var _spSec:Sprite;
		private var _stageHeight:Number=0;
		private var _tempH:Number=0;
		private var _mask:Shape;
		private var _tempBtn:SecondButton;
		private var _xml:XML;
		private var _mediaArr:Array=[];
		private var _listID:int;
		private var fullWin:FullAppWindow;
		private var _menuXML:XML;
		private var _matID:int;
		private var _openLocalFile:OpenLocalFile;
		private var _hisLdr:URLLoader;
		private var _hisArr:Array=[];
		private var _firstArr:Array=[];
		
		public function ButtonList()
		{
			_spSec = new Sprite();
			_spSec.x = 19;
			
			_spSec.visible =false;
			
			_mask = new Shape();
			_mask.x = 19;
			this.addChild(_mask);
			this.addChild(_spSec);
			_spSec.mask = _mask;
			_spSec.addEventListener(MouseEvent.CLICK,onSpSecClick);
			
			_openLocalFile = new OpenLocalFile();
			_openLocalFile.addEventListener(Event.SELECT,onFileSelect);
			
			_hisLdr = new URLLoader();
			_hisLdr.addEventListener(Event.COMPLETE,onHisXmlEnd);
		}
		
		public function setVO(vo:MediaVO):void
		{
			_vo = vo;
			if(_oneBtn==null)
			{
				_oneBtn = new OneButton();
				_oneBtn.addEventListener(MouseEvent.CLICK,onOneBtnClick);
				this.addChild(_oneBtn);
			}
			_stageHeight = 26;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFFFFFF,0.5);
			_mask.graphics.drawRect(0,0,_oneBtn.width,_stageHeight);
			_mask.graphics.endFill();
			_oneBtn.setVO(vo);
		}

		private function onOneBtnClick(e:MouseEvent):void
		{
//			trace("+++++++++++++++++",_vo.type)
			if(ApplicationData.getInstance().xiangCeVO.isVisible)
			{
				ApplicationData.getInstance().xiangCeVO.isVisible = false;
				ApplicationData.getInstance().xiangCeVO.isTimer = false;
				ApplicationData.getInstance().xiangCeVO.isModel = false;
				ApplicationData.getInstance().xiangCeVO.isHemi = false;
				NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
				ApplicationData.getInstance().xiangCeVO.isClear = false;
			}
			if(_vo.type=="second")
			{
				if(e.target.oneBtnRes.currentFrame==1)
				{
					e.target.oneBtnRes.gotoAndStop(2);
					if(_urlLdr==null)
					{
						_urlLdr = new URLLoader();
						_urlLdr.addEventListener(Event.COMPLETE,onXmlEnd);
						_urlLdr.addEventListener(IOErrorEvent.IO_ERROR,onXmlError);
					}
					if(ApplicationData.getInstance().UDiskModel){
//						trace(ApplicationData.getInstance().UDiskPath+_vo.path,"path")
						_urlLdr.load(new URLRequest(ApplicationData.getInstance().UDiskPath+_vo.path));
					}else{
//						trace(ApplicationData.getInstance().assetsPath+_vo.path,"path")
						_urlLdr.load(new URLRequest(ApplicationData.getInstance().assetsPath+_vo.path));
					}
				}else{
					_stageHeight = 26;
					e.target.oneBtnRes.gotoAndStop(1);
					Tweener.addTween(_spSec,{y:-_spSec.height,time:0.5,visible:false});
					_mask.graphics.clear();
					_mask.graphics.beginFill(0xFFFFFF,0.5);
					_mask.graphics.drawRect(0,0,_oneBtn.width,_stageHeight);
					_mask.graphics.endFill();
					this.dispatchEvent(new Event(Event.CHANGE));
				}
			}else if(_vo.type=="exe_app"||_vo.type=="html_app"){
				var vo:FullShowAppVO = new FullShowAppVO();
				if(_vo.type=="exe_app")
				{
					vo.appType = FullShowAppVO.EXE_APP;
					vo.appUrl = _vo.path;
				}else{
					vo.appType = FullShowAppVO.HTML_APP;
					vo.appUrl = ApplicationData.getInstance().assetsPath+_vo.path;
				}
				
				openEXE(vo);
			}else if(_vo.type=="material"){
			//	trace(this.name,"name");
				_matID = this.name.split("_")[1];
				_menuXML = ApplicationData.getInstance().menuXML;
				clearContainer(_spSec);
				_tempH=0;
				
				for (var i:int = 0; i < _menuXML.item[1].item[_matID].item.length(); i++) 
				{
					var vo1:MediaVO = new MediaVO();
					vo1.title = _menuXML.item[1].item[_matID].item[i].@cname;
					vo1.path = _menuXML.item[1].item[_matID].item[i].@path;
					vo1.type = _menuXML.item[1].item[_matID].item[i].@type;
					var secBtn:SecondButton = new SecondButton();
					secBtn.name = "material_"+i;
					secBtn.y = _tempH;
					_tempH += secBtn.height+8;
					secBtn.setVO(vo1);
					_spSec.addChild(secBtn);
				}
				_spSec.graphics.clear();
				Tweener.addTween(_spSec,{y:34,time:0.5,visible:true,transition:"easeOutSine"});
				_stageHeight = _oneBtn.height+34+_spSec.height;
				_mask.graphics.clear();
				_mask.graphics.beginFill(0xFFFFFF,0.5);
				_mask.graphics.drawRect(0,0,_oneBtn.width,_stageHeight);
				_mask.graphics.endFill();
				this.dispatchEvent(new Event(Event.CHANGE));
			}else if(_vo.type=="local")
			{
				if(_openLocalFile){
					_openLocalFile.browseForOpen();	
				}
			}else if(_vo.type=="history")
			{
				//_hisLdr.load(new URLRequest(ApplicationData.getInstance().assetsPath+"photo/用户/历史记录.xml"));
			}else if(_vo.type=="first"){
				if(_firstLdr==null)
				{
					_firstLdr = new URLLoader();
					_firstLdr.addEventListener(Event.COMPLETE,onFirstXmlEnd);
					_firstLdr.addEventListener(ErrorEvent.ERROR,onFirstXmlError);
				}
				if(ApplicationData.getInstance().UDiskModel){
					_firstLdr.load(new URLRequest(ApplicationData.getInstance().UDiskPath+_vo.path));
				}else{
					_firstLdr.load(new URLRequest(ApplicationData.getInstance().assetsPath+_vo.path));
				}
			}else if(_vo.type=="website_app")
			{
				navigateToURL(new URLRequest(_vo.path),"_top");
			}
		}
		
		private function onFirstXmlError(event:Event):void
		{
			trace("First数据加载完出错");
		}
		
		private function onXmlError(event:IOErrorEvent):void
		{
			trace("数据加载完出错");	
		}
		
		private function onHisXmlEnd(e:Event):void
		{
			var xml:XML = new XML(e.target.data);
			_hisArr=[];
			for (var i:int = 0; i < xml.img.length(); i++) 
			{
				var vo:MediaVO = new MediaVO();
				vo.type = xml.img[i].@type;
				vo.thumb = ApplicationData.getInstance().assetsPath + xml.img[i].@thumb;
				vo.path = ApplicationData.getInstance().assetsPath + xml.img[i];
				vo.globalP = new Point(1920*0.5,1080*0.5);
				_hisArr.push(vo);
			}
			if(_hisArr.length>0)
			{
				var eve:MeetsEvent = new MeetsEvent(MeetsEvent.OPEN_MEDIAS);
				eve.arr = _hisArr;
				this.dispatchEvent(eve);
			}
			
			var eve:MeetsEvent = new MeetsEvent(MeetsEvent.OPEN_MEDIAS);
			eve.arr = _hisArr;
			this.dispatchEvent(eve);
		}
		
		private function onXmlEnd(e:Event):void
		{
			//trace("加载完成")
			_xml = new XML(e.target.data);
			//trace(_xml);
			ApplicationData.getInstance().currLessonXML = _xml;
			clearContainer(_spSec);
			if(_xml.others.other.length()>0)
			{
				_tempH=0;
				for (var i:int = 0; i < _xml.others.other.length(); i++) 
				{
					var vo:MediaVO = new MediaVO();
					vo.title = _xml.others.other[i].@title;
					var secBtn:SecondButton = new SecondButton();
					secBtn.mouseChildren = false;
					secBtn.name = "secBtn_"+i;
					secBtn.y = _tempH;
					_tempH += secBtn.height+8;
					secBtn.setVO(vo);
					_spSec.addChild(secBtn);
				}
				
				_spSec.graphics.clear();
				Tweener.addTween(_spSec,{y:34,time:0.5,visible:true,transition:"easeOutSine"});
				_stageHeight = _oneBtn.height+34+_spSec.height;
				_mask.graphics.clear();
				_mask.graphics.beginFill(0xFFFFFF,0.5);
				_mask.graphics.drawRect(0,0,_oneBtn.width,_stageHeight);
				_mask.graphics.endFill();
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			ApplicationData.getInstance().smallBoardArr.length=0;
		//	trace(_xml.smallBoards.samllBoard.length(),"小黑板的长度");
			if(_xml.smallBoards.samllBoard.length()>0)
			{
				for (var j:int = 0; j < _xml.smallBoards.samllBoard.length(); j++) 
				{
					if(ApplicationData.getInstance().UDiskModel){trace("小黑板已经添加0");
						ApplicationData.getInstance().smallBoardArr.push(ApplicationData.getInstance().UDiskPath+_xml.smallBoards.samllBoard[j].@path);
					}else{trace("小黑板已经添加1");
						ApplicationData.getInstance().smallBoardArr.push(ApplicationData.getInstance().assetsPath+_xml.smallBoards.samllBoard[j].@path);
					}
				}
			}
			NotificationFactory.sendNotification(NotificationIDs.CHANGE_SMALLBOARD);
		}
		/**
		 * 
		 * @param e
		 * 智能和个人素材库 数据处理
		 */		
		private function onFirstXmlEnd(e:Event):void
		{
			var xml:XML = new XML(e.target.data);
			_firstArr=[];
			for (var i:int = 0; i < xml.resource.length(); i++) 
			{
				var vo:MediaVO = new MediaVO();
				vo.type = xml.resource[i].@type;
				vo.title = xml.resource[i].@title;
				if(ApplicationData.getInstance().UDiskModel){
					vo.thumb = ApplicationData.getInstance().UDiskPath + xml.resource[i].@thumb;
					vo.path = ApplicationData.getInstance().UDiskPath + xml.resource[i].@path;
				}else{
					vo.thumb = ApplicationData.getInstance().assetsPath + xml.resource[i].@thumb;
					vo.path = ApplicationData.getInstance().assetsPath + xml.resource[i].@path;
				}
				_firstArr.push(vo);
			}
			var eve:MeetsEvent = new MeetsEvent(MeetsEvent.OPEN_MEDIAS);
			eve.arr = _firstArr;
			this.dispatchEvent(eve);
		}
		
		private function onSpSecClick(e:MouseEvent):void
		{
			trace(ApplicationData.getInstance().xiangCeVO.isVisible, "ApplicationData.getInstance().xiangCeVO.isVisible");
			if(ApplicationData.getInstance().xiangCeVO.isVisible)
			{
				ApplicationData.getInstance().xiangCeVO.isVisible = false;
				ApplicationData.getInstance().xiangCeVO.isTimer = false;
				ApplicationData.getInstance().xiangCeVO.isModel = false;
				ApplicationData.getInstance().xiangCeVO.isHemi = false;
				NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
				ApplicationData.getInstance().xiangCeVO.isClear = false;
			}
			
			if(e.target.name.split("_")[0]=="secBtn")
			{
				if(_tempBtn)
				{
					_tempBtn.secondBtn.gotoAndStop(1);
				}
				_tempBtn = e.target as SecondButton;
				_tempBtn.secondBtn.gotoAndStop(2);
//				trace(_listID,"_listID");
				_listID = e.target.name.split("_")[1];
				fengXiData();
			}else if(e.target.name.split("_")[0]=="material"){
				_mediaArr=[];
				var id:int = e.target.name.split("_")[1];
				for (var i:int = 0; i < _menuXML.item[1].item[_matID].item[id].item.length(); i++) 
				{
					var vo:MediaVO = new MediaVO();
					vo.path = ApplicationData.getInstance().assetsPath+ _menuXML.item[1].item[_matID].item[id].item[i].@path;
					vo.type = _menuXML.item[1].item[_matID].item[id].item[i].@type;
					vo.thumb =ApplicationData.getInstance().assetsPath + _menuXML.item[1].item[_matID].item[id].item[i].@thumb;
					vo.title = _menuXML.item[1].item[_matID].item[id].item[i].@cname;
					_mediaArr.push(vo);
				}
				var eve:MeetsEvent = new MeetsEvent(MeetsEvent.OPEN_MEDIAS);
				eve.arr = _mediaArr;
				this.dispatchEvent(eve);
			}
		}
		
		private function fengXiData():void
		{
			_mediaArr=[];
			//trace(_xml.others.other[_listID]);
			for (var i:int = 0; i < _xml.others.other[_listID].resource.length(); i++) 
			{
				var vo:MediaVO = new MediaVO();
				if(ApplicationData.getInstance().UDiskModel){
					vo.path = ApplicationData.getInstance().UDiskPath+ _xml.others.other[_listID].resource[i].@path;
					vo.thumb =ApplicationData.getInstance().UDiskPath + _xml.others.other[_listID].resource[i].@thumb;
				}else{
					vo.path = ApplicationData.getInstance().assetsPath+ _xml.others.other[_listID].resource[i].@path;
					vo.thumb =ApplicationData.getInstance().assetsPath + _xml.others.other[_listID].resource[i].@thumb;
				}
				ToolKit.log(_xml.others.other[_listID].resource[i].@link + "    link");
				if(_xml.others.other[_listID].resource[i].@link == undefined)
				{//trace("+++")
					vo.isHimi = false;
					vo.himiLink = "";
				} else {//trace("+++1111")
					vo.isHimi = true;
					vo.himiLink = _xml.others.other[_listID].resource[i].@link;
				}
				
				vo.type = _xml.others.other[_listID].resource[i].@type;
				vo.title = _xml.others.other[_listID].resource[i].@title;
				vo.con = _xml.others.other[_listID].resource[i];
				_mediaArr.push(vo);
			}
		//	trace("jjjjjjjjjjjjjjjjjjjjj")
			//NotificationFactory.sendNotification(NotificationIDs.OPEN_MEDIA,_mediaArr);
			var eve:MeetsEvent = new MeetsEvent(MeetsEvent.OPEN_MEDIAS);
			eve.arr = _mediaArr;
			this.dispatchEvent(eve);
		}
		
		private function openEXE(vo:FullShowAppVO):void
		{
			if(!fullWin){
				fullWin=new FullAppWindow();
			}
			
			if(fullWin.closed){
				fullWin = new FullAppWindow();
			}
			fullWin.openApp(vo);
		}
		
		/**
		 * 选择文件完成后 用系统默认程序打开该文件
		 * */
		private function onFileSelect(event:Event):void
		{//trace("执行了这里")
			//this.dispatchEvent(new ImageDargEvent(ImageDargEvent.SHOT_SCREEN));
		}
		
		public function closeBtn():void
		{
			_stageHeight = 26;
			_oneBtn.oneBtnRes.gotoAndStop(1);
			Tweener.addTween(_spSec,{y:-_spSec.height,time:0.5,visible:false});
			_mask.graphics.clear();
			_mask.graphics.beginFill(0xFFFFFF,0.5);
			_mask.graphics.drawRect(0,0,_oneBtn.width,_stageHeight);
			_mask.graphics.endFill();
		}
		
		private function clearContainer(sp:Sprite):void
		{
			while(sp.numChildren>0)
			{
				sp.removeChildAt(0);
			}
			_spSec.visible = false;
			_spSec.y = 0;
		}
		

		public function get stageHeight():Number
		{
			return _stageHeight;
		}

	}
}