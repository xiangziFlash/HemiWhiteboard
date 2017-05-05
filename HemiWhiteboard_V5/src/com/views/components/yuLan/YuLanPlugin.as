package com.views.components.yuLan
{
	import com.lylib.layout.LayoutManager;
	import com.lylib.utils.MathUtil;
	import com.models.ApplicationData;
	import com.models.vo.DataVO;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.GongZhuLan;
	import com.views.components.pageMoveMedia.PageMoveMediaPlayer;
	
	import flash.desktop.NativeApplication;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.NativeWindow;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.sendToURL;
	import flash.system.Capabilities;
	
	public class YuLanPlugin extends Sprite
	{
		private var _xml:XML;
		private var _arr:Array = [];
		private var _soundArr:Array=[];
		private var _mediaContainer:MediaContainer;
		
		private var mainApp:NativeWindow;
		private var _isFull:Boolean;
		private var _isTuYa:Boolean;
		private var _toolBar:GongZhuLan;
		private var _soundBar:SoundBar;
		private var _len:int;
		private var _ldr:URLLoader;
		private var stageP:Point;
		private var _initW:Number = 1920*0.5;
		private var _initH:Number = 1080*0.5;
		private var _standbyContainer:StandbyContainer;
		private var _maskShape:Shape;
		
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		
		public function YuLanPlugin()
		{
			initContent();
			initListener();
		}

		public function setTuYaStr(str:String):void
		{
			_ldr.load(new URLRequest(str));
		}
		
		public function setXML(vo:DataVO):void
		{
			var xml:XML = vo.xml;
			var id:int = vo.id;
			//trace(id,"+++++++++++++++++++++++++++++++++++++")
			var arr:Array=[];
			for (var i:int = 0; i < xml.resource.length(); i++) 
			{
				var vo1:MediaVO = new MediaVO();
				vo1.formatXML(XML(xml.resource[i]));
				vo1.soundPathArr=[];
				vo1.soundNameArr=[];
				arr.push(vo1);
			}
			_arr = arr;
			_mediaContainer.setContent(_arr, id);
//			_mediaContainer.showSelectPage(id);
		}
		
		public function setArr(arr:Array,id:int):void
		{
			_arr =arr; 
			_mediaContainer.setContent(arr,id);
			
		}
		
		private function initContent():void 
		{
			_arr = [];
			_mediaContainer = new MediaContainer();
			_toolBar = new GongZhuLan();
			_soundBar = new SoundBar();
			
			LayoutManager.sizeToFit(_toolBar,_initW,_initH);
			setPosition(_mediaContainer,(1920-_initW)*0.5,(1080-_initH)*0.5);
			setPosition(_toolBar,_mediaContainer.x,_mediaContainer.y+_initH);
			setPosition(_soundBar,40,0);
			
			_toolBar.addChild(_soundBar);
			this.addChild(_mediaContainer);
			this.addChild(_toolBar);
			_ldr = new URLLoader();
			_ldr.addEventListener(Event.COMPLETE, onXmlEnd);
			
			this.filters = [new DropShadowFilter(0,0,0,1,9,9)];
		}
		
		private function setPosition(container:DisplayObject,_x:Number=0,_y:Number=0,isTween:Boolean=false):void
		{
			if(isTween){
				Tweener.addTween(container,{x:_x,y:_y,time:0.5});
			}else{
				container.x = _x;
				container.y = _y;
			}
			
		}
		
		private function onXmlEnd(e:Event):void 
		{
			_xml = new XML(e.target.data);
			_arr = [];
			_len = _xml.kecheng.resource.length();
			if(_len==0){
				this.dispatchEvent(new Event(Event.CLOSE));
				return;
			}
			for (var i:int = 0; i < _xml.kecheng.resource.length(); i++) 
			{
				var mvo:MediaVO = new MediaVO();
				if (_xml.kecheng.resource[i].@type == ".JPG"||_xml.kecheng.resource[i].@type ==".jpg") {
					mvo.type=MediaVO.IMAGE;
					for(var j:int=0;j<_xml.others.other.length();j++){
						for(var k:int=0;k<_xml.others.other[j].resource.length();k++){
							if(_xml.kecheng.resource[i].@thumb == _xml.others.other[j].resource[k].@thumb){
								if(_xml.others.other[j].resource[k].union.length()!=0){
									for(var m:int=0;m<_xml.others.other[j].resource[k].union.length();m++){
										
										var str:String = _xml.others.other[j].resource[k].union[m].@path;
										mvo.soundPathArr.push(str);
										str = str.substr(str.lastIndexOf("/")+1,str.length-4);
										mvo.soundNameArr.push(str);
										//trace(mvo.soundNameArr[m],mvo.soundPathArr[m]);
									}
								}
								
							}
						}
					}
				}else if(_xml.kecheng.resource[i].@type == ".swf"||_xml.kecheng.resource[i].@type ==".SWF"){
					mvo.type=MediaVO.SWF;
				}else if(_xml.kecheng.resource[i].@type == ".flv"||_xml.kecheng.resource[i].@type ==".FLV"){
					mvo.type = MediaVO.VIDEO;
				}else if(_xml.kecheng.resource[i].@type == ".mp3"||_xml.kecheng.resource[i].@type ==".MP3"){
					mvo.type = MediaVO.MP3;
				}else if(_xml.kecheng.resource[i].@type == ".ppt"||_xml.kecheng.resource[i].@type ==".PPT"){
					mvo.type = MediaVO.PPT;
					
				}
				
				mvo.mediaID = i;
				mvo.formatXML(XML(_xml.kecheng.resource[i]));
				_arr.push(mvo);
			}
			_mediaContainer.setContent(_arr, 0);
			
		}
		
		public function showSelectPage(id:int):void
		{
			_mediaContainer.showSelectPage(id);
		}
		
		
		private function initListener():void
		{
			//_toolBar.lock_btn.addEventListener(MouseEvent.CLICK,onLockBtnClick);
			//_toolBar.fullScreen_btn.addEventListener(MouseEvent.CLICK,onFullBtnClick);
			//_toolBar.clear_btn.addEventListener(MouseEvent.CLICK,onClearBtnClick);
			//_toolBar.close_btn.addEventListener(MouseEvent.CLICK,onCloseBtnClick);
			//_toolBar.mini_btn.addEventListener(MouseEvent.CLICK,onMiniBtnClick);
		//	_toolBar.pop_btn.addEventListener(MouseEvent.CLICK,onPopBtnClick);
			//_toolBar.daiji_btn.addEventListener(MouseEvent.CLICK,onDaijiBtnClick);
			_toolBar.addEventListener(MouseEvent.MOUSE_DOWN,onToolBarDown);
			_mediaContainer.addEventListener(Event.CHANGE,onNextComplete);//下一个对象加载完成
			
		}
		
		private function onNextComplete(e:Event):void
		{
			try
			{
				_soundBar.dispose();
				_soundArr = [];
				
				for(var i:int;i<_arr[_mediaContainer.pageID].soundPathArr.length;i++){
					var vo:MediaVO = new MediaVO();
					vo.title = _arr[_mediaContainer.pageID].soundNameArr[i];
					
					/*********************************************vo.path = PATH.uPanStr+_arr[_mediaContainer.pageID].soundPathArr[i];***********************************/
					vo.path = _arr[_mediaContainer.pageID].soundPathArr[i];
					_soundArr.push(vo);
				}
				_soundBar.setSoundInfo(_soundArr);
			} 
			catch(error:Error) 
			{
				trace("抛出异常")
			}
			
		}
		private function onDaijiBtnClick(e:MouseEvent):void
		{
			if(!_standbyContainer){
				_standbyContainer = new StandbyContainer();
				_standbyContainer.doubleClickEnabled = true;
				stage.addChild(_standbyContainer);
				_standbyContainer.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleStandby);
				_standbyContainer.load(ApplicationData.getInstance().assetsPath + "待机动画/image.xml");
			}else{
				_standbyContainer.play();
			}
			stage.addChild(_standbyContainer);
			
		}
		private function onDoubleStandby(e:MouseEvent):void
		{
			_standbyContainer.reset();
			stage.removeChild(_standbyContainer);
		}
		private function onLockBtnClick(event:MouseEvent):void
		{
			if((_toolBar.lock_btn as MovieClip).currentFrame==1){
				_mediaContainer.isLock = true;
				_toolBar.lock_btn.gotoAndStop(2);
			}else{
				_mediaContainer.isLock = false;
				_toolBar.lock_btn.gotoAndStop(1);
			}
		}
		
		private function onFullBtnClick(event:MouseEvent):void
		{
			if(!_isFull){
				_isFull= true;
				this.x = this.y = 0;
				_mediaContainer.x = 0;
				_mediaContainer.y = 0;
				
				_mediaContainer.scaleX = 1920/_initW;
				_mediaContainer.scaleY = _mediaContainer.scaleX;
				
				LayoutManager.sizeToFit(_toolBar,1920,1080);
				_toolBar.x = _mediaContainer.x;
				_toolBar.y =1080-_toolBar.height;
//				_mediaContainer.height -=20*_toolBar.scaleY;
				_mediaContainer.setPlayerBarFull(_toolBar.height/_mediaContainer.scaleY);
				//_toolBar.removeEventListener(MouseEvent.MOUSE_DOWN,onToolBarDown);
			}else{
				_isFull= false;
			//	this.x = (1920-_initW)*0.5;
			//	this.y = (1080-_initH)*0.5;
				_mediaContainer.x = (1920-_initW)*0.5;
				_mediaContainer.y = (1080-_initH)*0.5;
				_mediaContainer.scaleX = 1;
				_mediaContainer.scaleY = 1;
				LayoutManager.sizeToFit(_toolBar,_initW,_initH);
				_toolBar.x = _mediaContainer.x;
				_toolBar.y =_mediaContainer.y+_initH;
				_mediaContainer.setPlayerBarFull(0);
				//_toolBar.addEventListener(MouseEvent.MOUSE_DOWN,onToolBarDown);
			}
			NotificationFactory.sendNotification(NotificationIDs.IS_FULL,_isFull);
		}
		
		private function onClearBtnClick(event:MouseEvent):void
		{
			_mediaContainer.clearGraffiti();
		}
		
		private function onCloseBtnClick(event:MouseEvent):void
		{
			//NotificationFactory.getInstance().sendNotification(NotificationIDs.CLOSE_YULAN);
			_mediaContainer.clearContent();
			_soundBar.dispose();
			_isFull= false;
			_mediaContainer.x = (1920-_initW)*0.5;
			_mediaContainer.y = (1080-_initH)*0.5;
			_mediaContainer.scaleX = 1;
			_mediaContainer.scaleY = 1;
			LayoutManager.sizeToFit(_toolBar,_initW,_initH);
			_toolBar.x = _mediaContainer.x;
			_toolBar.y =_mediaContainer.y+_initH;
			_mediaContainer.setPlayerBarFull(0);
			this.dispatchEvent(new Event(Event.CLOSE));
			NotificationFactory.sendNotification(NotificationIDs.IS_FULL,false);
		}
		
		private function onMiniBtnClick(event:MouseEvent):void
		{
			var bmpd:BitmapData = new BitmapData(140,140/_initW*_initH,true,0);
			var matrix:Matrix = new Matrix();
			matrix.a = 140/_initW;
			matrix.d = matrix.a;
			bmpd.draw(_mediaContainer,matrix);
			//var newBpd:BitmapData = BitMapCompress.conpressBitMap(bmpd,140,140,false);
			var bmp:Bitmap = new Bitmap(bmpd);
			stageP= new Point(1230,540);
			var vo:DataVO = new DataVO();
			if(_arr[_mediaContainer.pageID].type==MediaVO.IMAGE){
				vo.type = ".jpg";
			}else if(_arr[_mediaContainer.pageID].type==MediaVO.SWF){
				vo.type = ".swf";
			}else if(_arr[_mediaContainer.pageID].type==MediaVO.VIDEO){
				vo.type = ".flv";
			}else if(_arr[_mediaContainer.pageID].type==MediaVO.MP3||_arr[_mediaContainer.pageID].type==MediaVO.PPT){
				
				return;
			}
			vo.name = "图片";
			if(ApplicationData.getInstance().UDiskModel){
				vo.url =ApplicationData.getInstance().UDiskPath+_arr[_mediaContainer.pageID].path;		
			}else{
				vo.url = ApplicationData.getInstance().assetsPath+_arr[_mediaContainer.pageID].path;		
			}
			vo.ico = _arr[_mediaContainer.pageID].thumb;			
			vo.globalP = stageP;
			
			
			vo.bmp = bmp;
			
			NotificationFactory.sendNotification(NotificationIDs.DISPLAY_POP,vo);
		}
		
		private function onPopBtnClick(event:MouseEvent):void
		{
			var bmpd:BitmapData = new BitmapData(40,40/_initW*_initH,true,0);
			var matrix:Matrix = new Matrix();
			matrix.a = 40/_initW;
			matrix.d = matrix.a;
			
			bmpd.draw(_mediaContainer,matrix);
			var bmp:Bitmap = new Bitmap(bmpd);
			var vo:MediaVO = new MediaVO();
			if(_arr[_mediaContainer.pageID].type==MediaVO.IMAGE){
				vo.type = ".jpg";
			}else if(_arr[_mediaContainer.pageID].type==MediaVO.SWF){
				vo.type = ".swf";
			}else if(_arr[_mediaContainer.pageID].type==MediaVO.VIDEO){
				vo.type = ".flv";
			}else if(_arr[_mediaContainer.pageID].type==MediaVO.MP3){
				return;
			}else if(_arr[_mediaContainer.pageID].type==MediaVO.PPT){
				return;
			}
			vo.thumb = _arr[_mediaContainer.pageID].thumb;
			vo.isHimi = _arr[_mediaContainer.pageID].isHimi; 
			vo.himiLink = _arr[_mediaContainer.pageID].himiLink; 
			vo.globalP = stage.globalToLocal(_toolBar.pop_btn.localToGlobal(new Point()));
			vo.path = _arr[_mediaContainer.pageID].path;
			vo.formatString(_arr[_mediaContainer.pageID].path);
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,vo);
		}
		private function onPopAllBtnClick(event:MouseEvent):void
		{
			/*var bmpd:BitmapData = new BitmapData(40,40/_initW*_initH,true,0);
			var matrix:Matrix = new Matrix();
			matrix.a = 40/_initW;
			matrix.d = matrix.a;
			
			bmpd.draw(_mediaContainer,matrix);
			var bmp:Bitmap = new Bitmap(bmpd);*/
			
			for (var i:int = 0; i < _arr.length; i++) 
			{
				var vo:MediaVO = new MediaVO();
				if(_arr[i].type==MediaVO.IMAGE){
					vo.type = ".jpg";
				}else if(_arr[i].type==MediaVO.SWF){
					vo.type = ".swf";
				}else if(_arr[i].type==MediaVO.VIDEO){
					vo.type = ".flv";
				}else if(_arr[i].type==MediaVO.MP3){
					continue;
				}else if(_arr[i].type==MediaVO.PPT){
					continue;
				}
				vo.globalP = stage.globalToLocal(_toolBar.pop_btn.localToGlobal(new Point()));
				vo.path = _arr[i].path;
				NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,vo);
			}
			
			
		}
		private function onToolBarDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseX;
			_tempY = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onToolBarMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onToolBarUp);
		}
		
		private function onToolBarMove(e:MouseEvent):void
		{
			if(_isFull==false){
				this.x += mouseX-_downX;
				this.y += mouseY-_downY;
				_downX = mouseX;
				_downY = mouseY;
			}
		}
		
		private function onToolBarUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onToolBarMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onToolBarUp);
			if(Math.abs(_tempX-mouseX)<5||Math.abs(_tempY-mouseY)<5)
			{
			//	trace("预览工具栏点击了",e.target.name	);
				switch(e.target.name)
				{
					case "lock_btn":
					{
						onLockBtnClick(null);
						break;
					}
					case "fullScreen_btn":
					{
						onFullBtnClick(null);
						break;
					}
					case "clear_btn":
					{
						onClearBtnClick(null);
						break;
					}
					case "close_btn":
					{
						onCloseBtnClick(null);	
						break;
					}
					case "pop_btn":
					{
						onPopBtnClick(null);	
						break;
					}
					case "popAll_btn":
					{
						onPopAllBtnClick(null);	
						break;
					}
				}
			}
		}
		
		public function reset():void
		{
			
		}
		private function ClearContainer(sp:Sprite):void
		{

			while(sp.numChildren>0){
				sp.removeChildAt(0);
			}
		}
		
	}
}