package com.views.components
{
	import com.controls.Chinese;
	import com.controls.ToolKit;
	import com.lylib.touch.OSMultiTouch;
	import com.lylib.touch.events.TapEvent;
	import com.lylib.touch.gestures.TapGesture;
	import com.lylib.utils.MathUtil;
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.models.vo.XiangCeVO;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.OppMedia;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.media.MediaType;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import org.osmf.events.TimeEvent;
	
	public class HuanDengModel extends Sprite
	{
//		private var _oppArr:Vector.<OppMedia>= new Vector.<OppMedia>;
		private var _oppArr:Array=[];
		private var _mask:Shape;
		private var _spCon:Sprite;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _isOppMedia:Boolean;
		private var _tempOppMedia:OppMedia;
		private var _oppID:int;
		private var _disX:Number=0;
		private var _disY:Number=0;
		private var _tempID:int;
		private var _tempOppX:Number=0;
		private var _tempOppY:Number=0;
		private var _isPaiLie:Boolean = true;//是否是排列模式
		private var _isFull:Boolean;//是否是全屏模式
		private var _isLock:Boolean;//是否是全屏模式
		private var _timer:Timer;
		private var _lunBoTime:Number=0;
		private var _pageID:int;
		private var _pageNum:int;
		private var _pageSum:int=12;
		private var _albumID:int;
		private var _albumNum:int;
		private var _moveWidth:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _isXunHuan:Boolean;//自动轮播是否循环
		private var _isTimer:Boolean;//是否开启了自动轮播
		private var _isHuanYe:Boolean;//在排列模式下  左右拖动
		private var _bmpd:BitmapData;
		private var _bmp:Bitmap;
		
		private var _fangShiID:int=0;
		private var _pWidth:Number=0;
		private var _pHeight:Number=0;
		private var _xNum:int =0;
		private var _yNum:int =0;
		private var _pScale:Number =0;
		private var _wID:int;
		
		private var _pxNum:Number=0;
		private var _pyNum:Number=0;
		private var _sp:DisplaySprite;
		private var _bian:Sprite;
		private var _bianDownY:Number=0;
		private var _modelID:int;
//		private var _huanDengSprite:HuanDengMoveSprite;
//		private var _huanDengSprite:ImageTrunComponent;
		private var _oldObj:OppMedia;
		private var _nowObj:OppMedia;
		private var _prevID:int;
		private var _isMoveEnd:Boolean=true;
		private var _isDoubleClick:Boolean;
//		private var _upRes:UpRes;
		
		public function HuanDengModel()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_sp = NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			_mask = new Shape();
			//_mask.graphics.beginFill(0,0);
		//	_mask.graphics.drawRect(0,0,1522,720);
			//_mask.graphics.endFill();
			this.addChild(_mask);
			
			_spCon = new Sprite();
			_spCon.name = "spCon";
			this.addChild(_spCon);
			
	/*		_huanDengSprite = new ImageTrunComponent();
			_huanDengSprite.addEventListener(Event.CHANGE,onHuanDengChange);
//			_huanDengSprite = new HuanDengMoveSprite();
			this.addChild(_huanDengSprite);*/
			
			_bian = new Sprite();
			_bian.graphics.beginFill(0x000000,0);
			_bian.graphics.drawRect(0,0,1920,60);
			_bian.graphics.endFill();
			this.addChild(_bian);
			_bian.visible = false;
			_bian.y = 1020;
			//			_spCon.mask = _mask;
			
//			_upRes = new UpRes();
//			_upRes.x= 1920-_upRes.width-50;
//			_upRes.y= 1080-50;
//			this.addChild(_upRes);
//			_upRes.visible = false;
//			_upRes.gotoAndStop(1);
			
			_spCon.addEventListener(MouseEvent.MOUSE_DOWN,onSpConDown);
			_bian.addEventListener(MouseEvent.MOUSE_DOWN,onBianDown);
			_spCon.doubleClickEnabled = true;
			_spCon.addEventListener(MouseEvent.DOUBLE_CLICK,onSpConDoubleClick);
//			OSMultiTouch.getInstance().enableGesture(_spCon);
//			OSMultiTouch.getInstance().enableGesture(_spCon, new TapGesture(1,2), onTapHandler);
			_lunBoTime = ApplicationData.getInstance().xiangCeLunBoTime;
			_timer = new Timer(_lunBoTime*1000);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
		
		//	fengXiMedia();
		}
		
		/**
		 * 
		 * 将所有的弹出来的图片全部放在一个数组中
		 */		
		public function fengXiMedia():void
		{
			ToolKit.log("fengXiMedia");
//			_oppArr.length=0;
//			_oppArr = null;
//			_oppArr = new Vector.<OppMedia>;
			for (var i:int = 0; i < _sp.mediaSprite.numChildren&&i<57; i++) 
			{
				if(_sp.mediaSprite.getChildAt(i).name =="oppMedia"||_sp.mediaSprite.getChildAt(i).name =="Opp")
				{
					var tempOpp:OppMedia = _sp.mediaSprite.getChildAt(i) as OppMedia;
					_oppArr.push(tempOpp);
				}
			}	
			
			for (var j:int = 0; j < _oppArr.length; j++) 
			{
				if(_oppArr[j] == null)
				{
					_oppArr.splice(j,1);
				} else {
					_spCon.addChild(_oppArr[j]);
				}
			}
			
			if(ApplicationData.getInstance().oppArr != _oppArr)
			{
				sortFunction();
				ApplicationData.getInstance().oppArr == _oppArr;
			}
			_spCon.doubleClickEnabled = true;
//			_oppArr = ApplicationData.getInstance().mediaArr;\
//			trace(_oppArr.length,"_oppArr.length");
			_pageNum = _oppArr.length;
			ToolKit.log("_pageNum   " + _pageNum);
			if(_pageNum<=20)
			{
				_fangShiID = 1;
				_pWidth = (1720/5)+10;
				_pHeight = (850/4);
				_xNum = 5;
				_yNum = 4;
				_pScale = 1/5-0.028;
			}else if(_pageNum>20&&_pageNum<=30)
			{
				_fangShiID = 2;
				_pWidth = (1720/6)+5;
				_pHeight = (850/5);
				_xNum = 6;
				_yNum = 5;
				_pScale = 1/6-0.02;
			}else if(_pageNum>30&&_pageNum<=42)
			{
				_fangShiID = 3;
				_pWidth = (1720/7)+2;
				_pHeight = (850/6);
				_xNum = 7;
				_yNum = 6;
				_pScale = 1/8-0.012;
			}else if(_pageNum>42){
//			}else if(_pageNum>42&&_pageNum<=56){
				_fangShiID = 4;
				_pWidth = (1720/8)-1;
				_pHeight = (850/7);
				_xNum = 8;
				_yNum = 7;
				_pScale = 1/9-0.008;
			}
			ApplicationData.getInstance().oppArr = _oppArr;
		}
		
		private function sortFunction():void
		{
			var re:RegExp = /\d+/;
			var str:String;
			var strLen:int;
			for (var i:int = 0; i < _oppArr.length; i++) 
			{
				str=_oppArr[i].mediaVO.title;
				
				//trace("---",str.match(re));
				if(str.match(re)==null){
					strLen=str.length;
					_oppArr[i].numName="";//将name解析出数字
				}else{
					strLen=str.indexOf(str.match(re)[0]);
					_oppArr[i].numName=str.match(re)[0];//将name解析出数字
				}
				
				_oppArr[i].strName=Chinese.convertString(str.substr(0,strLen));//将name解析出字母
				
			}
			_oppArr.sortOn(["strName","numName"],[null,Array.NUMERIC]);
		}
		
		public function setMediaHunPai():void
		{
//			trace("setMediaHunPai")
			if(_oppArr==null)return; 
			if(_oppArr.length==0)return; 
			_isMoveEnd = true;
//			trace("混排模式");
			clearContainer();
			_bian.visible = false;
			_isPaiLie =false;
			_isFull = false;
			_modelID = 3;
			_mask.x = 0;
			_mask.y = 0;
			_mask.graphics.clear();
			_spCon.mask = null;
			_spCon.graphics.clear();
			for (var j:int = 0; j < _oppArr.length; j++) 
			{
				Tweener.removeTweens((_oppArr[j] as OppMedia));
				(_oppArr[j] as OppMedia).name = "oppMedia";
				(_oppArr[j] as OppMedia).resetXY();
				(_oppArr[j] as OppMedia).scaleX = Math.min(600/1920,358/1080);
				(_oppArr[j] as OppMedia).scaleY = Math.min(600/1920,358/1080);
				(_oppArr[j] as OppMedia).x = MathUtil.random(200,1600);
				(_oppArr[j] as OppMedia).y = MathUtil.random(200,800);
				(_oppArr[j] as OppMedia).indexID = j;
				(_oppArr[j] as OppMedia).rotation = MathUtil.random(-180,180);
				(_oppArr[j] as OppMedia).showTools();
				(_oppArr[j] as OppMedia).zanTingMedia();
				(_oppArr[j] as OppMedia).isRemoveDown = false;
				(_oppArr[j] as OppMedia).closeLock();
				(_oppArr[j] as OppMedia).openDuoDian();
				(_oppArr[j] as OppMedia).setInertia(true);
//				(_oppArr[j] as OppMedia).doubleClickEnabled = true;
				(_oppArr[j] as OppMedia).isHuanDengModel = false;
				_sp.mediaSprite.addChild(_oppArr[j]);
			}
			//clearContainer();
			_oppArr=[];
			ApplicationData.getInstance().oppArr=[];
		}
		
		public function setMediaFull():void
		{
			if(_oppArr.length==0)return;
//			trace("全屏模式");
			clearContainer();
			_bian.visible = true;
			_isMoveEnd = true;
//			Tweener.addTween(_spCon,{x:-_pageID*1920,y:0,time:1.5});
			_isPaiLie =false;
			_isFull = true;
			_modelID = 2;
			_mask.x = 0;
			_mask.y = 0;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0);
			_mask.graphics.drawRect(0,0,1920,1080);
			_mask.graphics.endFill();
			_spCon.mask = _mask;
			
			_spCon.graphics.clear();
			_spCon.graphics.beginFill(0);
			_spCon.graphics.drawRect(0,0,1920,1080);
			_spCon.graphics.endFill();
			_spCon.x = _spCon.y = 0;
			
			_nowObj = _oppArr[_pageID];
			_nowObj.resetXY();
			_nowObj.scaleX = _nowObj.scaleY = 1;
			_nowObj.x = 0;
			_nowObj.y = 0;
			_nowObj.indexID = _pageID;
			_nowObj.rotation = 0;
			_nowObj.hideTools();
			_nowObj.zanTingMedia();
			_nowObj.isRemoveDown = true;
			_nowObj.closeLock();
			_nowObj.closeDuoDian();
			_nowObj.setInertia(false);
			_nowObj.doubleClickEnabled = false;
			_nowObj.mouseChildren = true;
			_nowObj.isHuanDengModel = true;
			_spCon.addChild(_nowObj);
			Tweener.addTween(_nowObj,{alpha:1, visible:true,time:1,transition:"easeInOutQuad"});
			
			setTimeout(function():void
			{
				_spCon.x = 0;
				_spCon.y = 0;
				_mask.x = 0;
				_mask.y = 0;
				_nowObj.x = 0;
				_nowObj.y = 0;
			},10);
			
//			Tool.log("isHemi"+ApplicationData.getInstance().xiangCeVO.isHemi);
			if(ApplicationData.getInstance().xiangCeVO.isHemi==true)
			{
				_pageID = _pageNum-1;
				_nowObj = _oppArr[_pageID];
				ToolKit.log("_nowObj.mediaVO.type    "+_nowObj.mediaVO.type);
				if(_nowObj.mediaVO.type==".flv"||_nowObj.mediaVO.type == MediaType.VIDEO)
				{
					ToolKit.log("playVideo");
//					_nowObj.playVideo();
				}
				leftMove();
			}
			
			if(_isTimer)
			{
				_timer.reset();
				_timer.start();
			}
		}
		
		public function setMediaHuaDeng():void
		{
			if(_oppArr.length==0)return;
//			trace("半预览模式")
			_isMoveEnd = true;
			clearContainer();
			_bian.visible = false;
			_modelID = 1;
			_isPaiLie =false;
			_isFull = false;
			_mask.x = 199;
			_mask.y = 70;
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0.3);
			_mask.graphics.drawRect(0,0,1522,856);
			_mask.graphics.endFill();
			
			_spCon.graphics.clear();
			_spCon.graphics.beginFill(0);
			_spCon.graphics.drawRect(0,0,1522,856);
			_spCon.graphics.endFill();
			_spCon.mask = _mask;

			_spCon.x = 199;
			_spCon.y = 70;
			_nowObj = _oppArr[_pageID];
			_nowObj.resetXY();
			_nowObj.scaleX = _nowObj.scaleY = 0.793;
			_nowObj.x = 0;
			_nowObj.y = 0;
			_nowObj.indexID = _pageID;
			_nowObj.rotation = 0;
			_nowObj.hideTools();
			_nowObj.zanTingMedia();
			_nowObj.setInertia(false);
			_nowObj.isRemoveDown = true;
			_nowObj.closeLock();
			_nowObj.closeDuoDian();
			_nowObj.doubleClickEnabled = true;
			_nowObj.mouseChildren = true;
			_nowObj.isHuanDengModel = true;
			_spCon.addChild(_nowObj);
			Tweener.addTween(_nowObj,{alpha:1, visible:true, time:1, transition:"easeInOutQuad"});
			
			setTimeout(function():void
			{
				_spCon.x = 199;
				_spCon.y = 70;
				_mask.x = 199;
				_mask.y = 70;
				_nowObj.x = 0;
				_nowObj.y = 0;
			},100);
			
			if(_isTimer)
			{
				_timer.reset();
				_timer.start();
			}
		}
		
		public function setMediaPaiLie():void
		{
			if(_oppArr.length==0)return;
			_isMoveEnd = true;
			_pageID=0;
			_modelID = 0;
			_bian.visible = false;
			_timer.stop();
			Tweener.addTween(_spCon,{x:105,y:70,time:0.5,onComplete:moveEnd});
		
			function moveEnd():void
			{
				Tweener.removeTweens(_spCon);
			}
			_spCon.graphics.clear();
			_isPaiLie = true;
			_isFull = false;
			_mask.graphics.clear();
			_spCon.mask = null;
			_spCon.x =105 ;
			_spCon.y =70 ;
			_albumNum = Math.ceil(_oppArr.length/_pageSum);
			//Tweener.removeAllTweens();
//			trace(_oppArr.length,"_oppArr.length");
			for (var j:int = 0; j < _oppArr.length; j++)
			{
				if(_oppArr[j] != null)
				{
					Tweener.removeTweens((_oppArr[j] as OppMedia));
					//				(_oppArr[j] as OppMedia).resetVote();
					(_oppArr[j] as OppMedia).clearPoint();
					(_oppArr[j] as OppMedia).resetXY();
					(_oppArr[j] as OppMedia).x = 0;
					(_oppArr[j] as OppMedia).y = 0;
					(_oppArr[j] as OppMedia).alpha = 1;
					(_oppArr[j] as OppMedia).rotation = 0;
					(_oppArr[j] as OppMedia).hideTools();
					(_oppArr[j] as OppMedia).isRemoveDown = true;
					(_oppArr[j] as OppMedia).closeLock();
					(_oppArr[j] as OppMedia).zanTingMedia();
					(_oppArr[j] as OppMedia).indexID = j;
					(_oppArr[j] as OppMedia).setInertia(false);
					(_oppArr[j] as OppMedia).name = "oppMedia_"+j;
					(_oppArr[j] as OppMedia).doubleClickEnabled = true;
					(_oppArr[j] as OppMedia).mouseChildren = false;
					(_oppArr[j] as OppMedia).isHuanDengModel = true;
					//				(_oppArr[j] as OppMedia).chongZhi();
					(_oppArr[j] as OppMedia).scaleX = (_oppArr[j] as OppMedia).scaleY = _pScale;
					if(!(_oppArr[j] as OppMedia).hasEventListener(OppMedia.TouchBeginEvent))
					{
						(_oppArr[j] as OppMedia).addEventListener(OppMedia.TouchBeginEvent,touchBegin);
						(_oppArr[j] as OppMedia).addEventListener(OppMedia.TouchEndEvent,touchEnd);
						(_oppArr[j] as OppMedia).addEventListener(OppMedia.TouchMoveEvent,touchMove);
					}
					_oppArr[j].x = int(j%_xNum)*_pWidth;
					_oppArr[j].y = int(j/_xNum)*_pHeight;
					_spCon.addChildAt(_oppArr[j],0);
				} else {
					_oppArr.splice(j,1);
				}
			}
		}
		
		private function onTapHandler(e:TapEvent):void
		{
			trace("tap");
		}
		
		private function onSpConDown(e:MouseEvent):void
		{
//			trace("_isPaiLie down");
			if(_isPaiLie)
			{//图片整齐排列模式
					return;
			}
			if(_isDoubleClick)return;
//			trace("onSpConDown");
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseX;
			_tempY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onSpConMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onSpConUp);
			stopLunBo();
		}
		
		private function onSpConMove(event:MouseEvent):void
		{
			if(_isPaiLie)
			{return;
			}
			if(!_isLock){
				if(_isFull){//相册全屏播放
					_moveWidth = 1920;
				}else{//相册幻灯播放
					_moveWidth = 1522;
				}
//				_spCon.x += mouseX-_downX; 
				_downX = mouseX;
				_downY = mouseY;
			}
			
		}
		
		private function onSpConUp(event:MouseEvent):void
		{
//			trace(_isPaiLie,_isFull,"_isPaiLie")
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSpConMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onSpConUp);
			if(_isPaiLie)return;
//			trace("------",Math.abs(_spCon.x-_tempX),Math.abs(_spCon.y-_tempY))
			if(Math.abs(_spCon.x-_tempX)<5&&Math.abs(_spCon.y-_tempY)<5)return;//trace("++++++",_isLock)
			if(!_isLock){//trace("++11")
				if(!_isMoveEnd)return;//trace("==22")
				
				if((_tempX-mouseX)>0)
				{
					//向左拖动
					_pageID++;//trace("00")
					if(_pageID>_pageNum-1)
					{//trace("向左拖动")
						_pageID = _pageNum-1;
					}
//					trace(_pageID,_prevID,"_prevID1",_pageNum);
					if(_prevID==_pageID)return;
					_isMoveEnd = false;
					leftMove();
				}else if((_tempX-mouseX)<0){
					//向右拖动
					_pageID--;//trace("11")
					if(_pageID<0){//trace("向右拖动")
						_pageID = 0;
					}
//					trace(_pageID,_prevID,"_prevID2",_pageNum);
					if(_prevID == _pageID)return;
					_isMoveEnd = false;
					rightMove();
				}
//				if(_isFull)
//				{
//					if((_tempX-mouseX)<5){
					//	NotificationFactory.sendNotification(NotificationIDs.OPEN_GONGJULAN);
//					}
				//	_spCon.x = -_pageID*_moveWidth;
					//Tweener.addTween(_spCon,{x:-_pageID*_moveWidth,time:1.5});
//				}else{
					//_spCon.x = -_pageID*_moveWidth+199;
					//Tweener.addTween(_spCon,{x:-_pageID*_moveWidth+199,time:1.5});
//				}
				
				/*_spCon.removeChild(_oldObj);
				Tweener.addTween(_oldObj,{alpha:0,time:1,transition:"easeInOutQuad"});
				
				_nowObj = _oppArr[_pageID];
				_nowObj.x = 
				_nowObj.y = 0;
				_spCon.addChild(_nowObj);
				Tweener.addTween(_nowObj,{alpha:1,time:1,transition:"easeInOutQuad"});
				_oldObj = _nowObj;*/
				
				for (var j:int = 0; j < _oppArr.length; j++) 
				{
					(_oppArr[j] as OppMedia).zanTingMedia();
				}
				if(_isTimer)
				{
					_timer.reset();
					_timer.start();
				}
			}
		}
		
		private function leftMove():void
		{
			_prevID = _pageID;
			_oldObj = _nowObj;
			Tweener.addTween(_oldObj,{x:-_moveWidth,time:1,transition:"easeInOutQuad",onComplete:moveEnd0});
			
			function moveEnd0():void
			{
				_spCon.removeChild(_oldObj);
			}
			_nowObj = _oppArr[_pageID];
			if(_nowObj == null)return;
			if(_isFull)
			{
				_nowObj.scaleX = _nowObj.scaleY = 1;
				_nowObj.resetXY();
				_nowObj.indexID = _pageID;
				_nowObj.rotation = 0;
				_nowObj.hideTools();
				_nowObj.zanTingMedia();
				_nowObj.isRemoveDown = true;
				_nowObj.closeLock();
				_nowObj.mediaVO.title = "oppMedia_"+_pageID;
				_nowObj.closeDuoDian();
				_nowObj.setInertia(false);
				_nowObj.doubleClickEnabled = false;
				_nowObj.mouseChildren = true;
				_nowObj.isHuanDengModel = true;
			} else {
				if(!_isPaiLie)
				{
					_nowObj.scaleX = _nowObj.scaleY = 0.793;
					_nowObj.indexID = _pageID;
					_nowObj.rotation = 0;
					_nowObj.hideTools();
					_nowObj.zanTingMedia();
					_nowObj.setInertia(false);
					_nowObj.isRemoveDown = true;
					_nowObj.closeLock();
					_nowObj.closeDuoDian();
					_nowObj.mediaVO.title = "oppMedia_"+_pageID;
					_nowObj.doubleClickEnabled = true;
					_nowObj.mouseChildren = true;
					_nowObj.isHuanDengModel = true;
				}
			}
			_nowObj.x = _moveWidth;
			_nowObj.y = 0;
			_spCon.addChild(_nowObj);
			Tweener.addTween(_nowObj,{x:0,time:1,transition:"easeInOutQuad",onComplete:moveEnd2});
			function moveEnd2():void
			{
				_isMoveEnd = true;
			}
		}
		
		private function rightMove():void
		{
			//_spCon.removeChild(_oldObj);
			_prevID = _pageID;
			_oldObj = _nowObj;
			Tweener.addTween(_oldObj,{x:_moveWidth,time:1,transition:"easeInOutQuad",onComplete:moveEnd0});
			function moveEnd0():void
			{
				_spCon.removeChild(_oldObj);
			}
			_nowObj = _oppArr[_pageID];
			if(_nowObj == null)return;
			if(_isFull)
			{
				_nowObj.scaleX = _nowObj.scaleY = 1;
				_nowObj.resetXY();
				_nowObj.indexID = _pageID;
				_nowObj.rotation = 0;
				_nowObj.hideTools();
				_nowObj.zanTingMedia();
				_nowObj.isRemoveDown = true;
				_nowObj.closeLock();
				_nowObj.mediaVO.title = "oppMedia_"+_pageID;
				_nowObj.closeDuoDian();
				_nowObj.setInertia(false);
				_nowObj.doubleClickEnabled = false;
				_nowObj.mouseChildren = true;
				_nowObj.isHuanDengModel = true;
			} else {
				if(!_isPaiLie)
				{
					_nowObj.scaleX = _nowObj.scaleY = 0.793;
					_nowObj.indexID = _pageID;
					_nowObj.rotation = 0;
					_nowObj.hideTools();
					_nowObj.zanTingMedia();
					_nowObj.setInertia(false);
					_nowObj.isRemoveDown = true;
					_nowObj.closeLock();
					_nowObj.closeDuoDian();
					_nowObj.mediaVO.title = "oppMedia_"+_pageID;
					_nowObj.doubleClickEnabled = true;
					_nowObj.mouseChildren = true;
					_nowObj.isHuanDengModel = true;
				}
			}
			_nowObj.x = -_moveWidth; 
			_nowObj.y = 0;
			_spCon.addChild(_nowObj);
			Tweener.addTween(_nowObj,{x:0,time:1,transition:"easeInOutQuad",onComplete:moveEnd2});
			function moveEnd2():void
			{
				_isMoveEnd = true;
			}
//			
		}
		
		private function onHuanDengChange(e:Event):void
		{
			//_pageID = _huanDengSprite.id;
		}
		
		private function onSpConDoubleClick(e:MouseEvent):void
		{
			if(_isDoubleClick)return;
			_isDoubleClick = true;
			_spCon.doubleClickEnabled = false;
			ToolKit.log("onSpConDoubleClick");
			if(_isPaiLie)
			{
				_isLock = false;
				_pageID = e.target.name.split("_")[1];
				if(e.target is OppMedia)
				{
					(e.target as OppMedia).closeDuoDian();
				}
				
				for (var j:int = 0; j < _oppArr.length; j++)
				{
					_oppArr[j].closeDuoDian();
				}
				
//				trace(_pageID,"_pageI/D", _pageNum, "   ",e.target.name);
				ApplicationData.getInstance().xiangCeVO.modelID = 1;
				_prevID = _pageID;
				setTimeout(function ():void
				{
					setMediaHuaDeng();
				}, 500);
				
				setTimeout(function ():void
				{
					_isDoubleClick = false;
					_spCon.doubleClickEnabled = true;
				}, 2000);
//				settingModel(ApplicationData.getInstance().xiangCeVO);
			}else{
				if(_tempOppMedia)
				{
					Tweener.removeTweens(_tempOppMedia);
				}
				_pageID=0;
				ApplicationData.getInstance().xiangCeVO.modelID = 0;
				setMediaPaiLie();
				
				setTimeout(function ():void
				{
					_isDoubleClick = false;
					_spCon.doubleClickEnabled = true;
				}, 1000);
			}
			NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL_CLOSELUCK);
			//NotificationFactory.sendNotification(NotificationIDs.HUANDENGMODEL,ApplicationData.getInstance().xiangCeVO);
		}
		
		private function onBianDown(e:MouseEvent):void
		{
			_bianDownY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBianMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBianUp);
		}
		
		private function onBianMove(event:MouseEvent):void
		{
			
		}
		
		private function onBianUp(event:MouseEvent):void
		{
			if(Math.abs(mouseY-_bianDownY)>10)
			{
//				_upRes.visible = false;
//				_upRes.gotoAndStop(1);
				NotificationFactory.sendNotification(NotificationIDs.OPEN_GONGJULAN);
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBianMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBianUp);
		}
		
		private function drawShape():void
		{
			_bmpd = new BitmapData(_tempOppMedia._oppToolBar.width,_tempOppMedia._mediaPlayer.height,true,0);
			_bmpd.draw(_tempOppMedia._mediaPlayer);
			_bmp = new Bitmap(_bmpd.clone());
			_tempOppMedia.mediaVO.bmp = _bmp;
		}
		
		public function showTiShi():void
		{//trace("77")
			if(_isFull)
			{//trace("++++")
//				_upRes.visible = true;
//				_upRes.play();
			}
		}
		
		/**
		 *清除涂鸦 
		 * 
		 */		
		public function clearTuYa():void
		{
//			_tempOppMedia=_spCon.getChildAt(_pageID) as OppMedia;
//			trace("_pageID",_pageID)
			try
			{
				_tempOppMedia = _oppArr[_pageID] as OppMedia;
				if(_tempOppMedia == null)return;
				_tempOppMedia.clearTuYa();
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		public function settingModel(vo:XiangCeVO):void
		{
			//trace("settingModel",vo.modelID,_oppArr.length);
			if(vo.modelID==0)return;
			if(_oppArr.length==0)
			{
				if(!vo.isTimer){//trace("start")
					_isTimer= false;
					stopLunBo();
				}
				return;
			}
				
			if(vo.modelID==1){
				_moveWidth = 1522;
			}else if(vo.modelID==2){
				_moveWidth = 1920;
			}
			if(vo.isLock){
				_isLock = true;
//				trace("islock",_isLock);
				(_oppArr[_pageID] as OppMedia).openLock();
				if(_isFull)
				{
//					_upRes.visible = true;
//					_upRes.play();
				}
			}else{
				_isLock = false;
//				trace("islock1",_isLock,_oppArr);
				(_oppArr[_pageID] as OppMedia).closeDuoDian();
			}
			
			if(vo.isXunHuan){
				_isXunHuan =true;
			}else{
				_isXunHuan =false;
			}
			
//			trace(vo.isTimer,"vo.isTimer");
			if(vo.isTimer){//trace("start")
				_isTimer= true;
				_timer.delay = vo.LunBoTime*1000;
				_timer.reset();
				_timer.stop();
				startLunBo();
			}else{
				_isTimer= false;
				stopLunBo();
			}
			if(vo.isClear){
				(_oppArr[_pageID] as OppMedia).onClearBtnClick(null);
			}
			
			_pageNum = _oppArr.length;
		}
		
		public function startLunBo():void
		{
			if(_isPaiLie||_isLock)return;
			_timer.reset();
			_timer.start();
		}
		
		public function stopLunBo():void
		{
			_timer.reset();
			_timer.stop();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			if(_isPaiLie||_isLock)return;
			
			if(_pageID<_pageNum-1)
			{
				_pageID++;
				leftMove();
			}else{
				if(_isXunHuan){
					_pageID=0;
					leftMove();
				}else{
					_timer.reset();
					_timer.stop();
				}
			}
		}
		
		private function touchBegin(e:Event):void
		{
			if(_isDoubleClick)return;
			if(_isPaiLie){//图片整齐排列模式
				if(e.currentTarget.name.split("_")[0]=="oppMedia")
				{
//					trace("begin")
					_tempOppMedia = e.currentTarget as OppMedia;
					_tempOppX = _tempOppMedia.x;
					_tempOppY = _tempOppMedia.y;
				}
			}
		}
		
		
		private function touchMove(e:Event):void
		{
			if(_isDoubleClick)return;
			if(!_isPaiLie)return;
//			_tempOppMedia = e.currentTarget as OppMedia;
			var rect:Rectangle = _tempOppMedia.transform.pixelBounds;
//			trace(rect.left,"rect.left",rect.right,"top",rect.top)
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<960&&rect.right>980)
			{
				if(rect.top>1000-rect.height*0.2){
					_tempOppMedia.alpha = 0.5;
					return;
				}					
			}
			_tempOppMedia.alpha = 1;
		}
		
		private function touchEnd(e:Event):void
		{
			if(!_isPaiLie)return;
			if(_isDoubleClick)return;
			var rect:Rectangle = _tempOppMedia.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(_tempOppMedia.alpha<1){
				Tweener.addTween(_tempOppMedia,{x:972,y:1056,scaleX:0.1,scaleY:0.1,alpha:0,time:0.5,onComplete:clearGraph});
			}else{
				if(Math.abs(_tempOppX-_tempOppMedia.x)>5||Math.abs(_tempOppY-_tempOppMedia.y)>5)
				{
					ToolKit.log("卡片移动距离大于5")
					for (var j:int = 0; j < _oppArr.length; j++) 
					{
						if(_oppArr[j] == null)
						{
							_oppArr.splice(j,1);
						} else {
							_spCon.addChild(_oppArr[j]);
						}
					}
					if((e.target as OppMedia)!=_tempOppMedia)
					{
//						trace("--------------");
						var obj:OppMedia = e.target as OppMedia;
						if((Math.round(obj.scaleX*1000)/1000)<(Math.round(_pScale*1000)/1000))
						{
							obj.hideTools();
							obj.closeLock();
							obj.isRemoveDown = true;
							_oppArr.push(obj);
							setMediaPaiLie();
						} else { 
							setMediaPaiLie();
						}
					} else {
						if(_tempOppMedia.name=="Opp")
						{
							ToolKit.log("--------------111");
							if((Math.round(_tempOppMedia.scaleX*1000)/1000)<(Math.round(_pScale*1000)/1000))
							{
								ToolKit.log("执行了")
								//_tempOppMedia.parent.removeChild(_tempOppMedia);
								_tempOppMedia.hideTools();
								_tempOppMedia.closeLock();
								_tempOppMedia.isRemoveDown = true;
								_oppArr.push(_tempOppMedia);
								setTimeout(function ():void
								{
									_tempOppMedia.hideTools();
								},50);
								setMediaPaiLie();
							} /*else { 
								Tool.log("--------------222");
								setMediaPaiLie();
							}*/
						}else{
							if((Math.round(_tempOppMedia.scaleX*1000)/1000)>(Math.round(_pScale*1000)/1000))
							{
								ToolKit.log("执行了2")
								Tweener.addTween(_tempOppMedia,{alpha:1,scaleX:Math.min(600/1920,358/1080),scaleY:Math.min(600/1920,358/1080),time:0.5,transition:"linear",onComplete:moveEnd});
								_tempOppMedia.mouseChildren = true;
								_sp.mediaSprite.addChild(_tempOppMedia);
								_tempOppMedia.showTools();
								_tempOppMedia.isRemoveDown = false;
								_tempOppMedia.isHuanDengModel = false;
								_oppArr.splice(_tempOppMedia.name.split("_")[1],1);
								_tempOppMedia.name ="Opp"
								if(_oppArr.length==0)
								{
									_spCon.graphics.clear();
									this.dispatchEvent(new Event(Event.CLOSE));
								}
								setMediaPaiLie();
								function moveEnd():void
								{
									
									_tempOppMedia.setInertia(true);
									_tempOppMedia.openDuoDian();
								}
							}else if((Math.round(_tempOppMedia.scaleX*1000)/1000)==(Math.round(_pScale*1000)/1000))
							{
								ToolKit.log("执行了弹起重新排序");
								var oppID1:int = _tempOppMedia.name.split("_")[1];
								_disX = Math.round(_tempOppMedia.x/_pWidth);
								_disY =  Math.round(_tempOppMedia.y/_pHeight);
								_oppID = (_disY)*_xNum+(_disX);
								_tempOppMedia.hideTools();
								//							trace("name:",_tempOppMedia.name,"oppID:",_oppID,"oppID1：",oppID1);
								_oppArr.splice(oppID1,1);
								_oppArr.splice(_oppID,0,_tempOppMedia);
								setMediaPaiLie();
							} else {
								ToolKit.log("执行了弹起重新排序2222222222222222222");
								setMediaPaiLie();
							}
						}
						ApplicationData.getInstance().oppArr = _oppArr;
					}
				}else{
					Tweener.removeTweens(_tempOppMedia);
				}
			}
			_pageNum = _oppArr.length;
		}
		
		public function gotoPage(str:String):void
		{
			switch(str)
			{
				case "down":
				{
					_pageID++;//trace("00")
					if(_pageID>_pageNum-1)
					{//trace("向左拖动")
						_pageID = _pageNum-1;
					}
					if(_prevID==_pageID)return;
					_isMoveEnd = false;
					leftMove();	
					break;
				}
				case "up":
				{
					_pageID--;//trace("11")
					if(_pageID<0){//trace("向右拖动")
						_pageID = 0;
					}
					if(_prevID==_pageID)return;
					_isMoveEnd = false;
					rightMove();
					break;
				}
				case "home":
				{
					_pageID = 0;
					if(_prevID==_pageID)return;
					_isMoveEnd = false;
					rightMove();
					break;
				}
				case "end":
				{
					_pageID = _pageNum-1;
					if(_prevID==_pageID)return;
					_isMoveEnd = false;
					leftMove();	
					break;
				}
			}
		}
		
		private function clearGraph():void
		{
			_tempOppMedia.drawShape();
			if(_tempOppMedia.name=="Opp")return;
			_oppArr.splice(_tempOppMedia.name.split("_")[1],1)
			if(_oppArr.length==0)
			{
				_spCon.graphics.clear();
			}
			
			setMediaPaiLie();
		}	
		
		public function reset():void
		{
			_pageID =0;
			_pageNum =0;
		}
		
		private function clearContainer():void
		{
			while(_spCon.numChildren>0)
			{
				_spCon.removeChildAt(0);
			}
		}
		
		/**
		 *清除所有 重置 
		 * 
		 */		
		public function clearAll():void
		{
			_pageID =0;
			_pageNum =0;
			for (var i:int = 0; i < _oppArr.length; i++) 
			{

				if((_oppArr[i] as OppMedia).parent)
				{
					(_oppArr[i] as OppMedia).parent.removeChild(_oppArr[i]);
				}
				(_oppArr[i] as OppMedia).reset();
			}
			_oppArr.length = 0;
			_spCon.graphics.clear();
			_bian.visible = false;
			NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"卡片已删除");
		}

		public function get modelID():int
		{
			return _modelID;
		}

		public function get isPaiLie():Boolean
		{
			return _isPaiLie;
		}

		public function get isFull():Boolean
		{
			return _isFull;
		}
	}
}