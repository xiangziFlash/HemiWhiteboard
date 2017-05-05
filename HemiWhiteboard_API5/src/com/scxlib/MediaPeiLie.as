package com.scxlib
{
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	/**
	 * 
	 * @author 祥子
	 * 所有资源的菜单
	 */	
	public class MediaPeiLie extends Sprite
	{
		private var _spCon:Sprite;
		private var _mediaVoArr:Array=[];
		private var _spShu:Sprite;
		private var _mediaArr:Array=[];
		
		/**
		 *实现上下拖动 的一系列参数 
		 */		
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _isHeng:Boolean;
		private var _isOpp:Boolean;
		private var _isMove:Boolean;
		private var _pageID:int;
		private var _stageW:Number=0;
		private var _tempImage:LoaderImage;
		
		private var _speedX:Number;
		private var _speedY:Number;
		private var _moCaLi:Number = 1.2;
		private var _upX:Number=0;
		private var _upY:Number=0;
		private var _startX:Number=0;
		private var _startY:Number=0;
		private var _timer:Timer;
		
		private var _mask:Shape;
		private var _isRight:Boolean;
		private var _mediaVO:MediaVO;
		private var _ldrXML:URLLoader;
		
		public function MediaPeiLie()
		{
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_spCon = new Sprite();
			_spCon.name = "spCon_";
			this.addChild(_spCon);
			
			_mask = new Shape();
			this.addChild(_mask);
			_mask.graphics.clear();
			_mask.graphics.beginFill(0,0.5);
			_mask.graphics.drawRect(0,0,100,740);
			_mask.graphics.endFill();
			_spCon.mask = _mask;
			
			_timer = new Timer(110);
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			_timer.stop();
			
			_ldrXML = new URLLoader();
			_ldrXML.addEventListener(Event.COMPLETE,onXmlEnd);
		}
		/**
		 *  设置显示区域遮罩
		 * @param ww 遮罩 的宽度
		 * 
		 */		
		public function setMask(ww:Number,isRight:Boolean):void
		{
			_isRight = isRight;
			if(_isRight)
			{
				_mask.x = 0;
				_mask.graphics.clear();
				_mask.graphics.beginFill(0,0.3);
				_mask.graphics.drawRect(0,0,ww,740);
				_mask.graphics.endFill();
			}else{
				_mask.x = ww+122;
				_mask.graphics.clear();
				_mask.graphics.beginFill(0,0.3);
				_mask.graphics.drawRect(0,0,1630-ww,740);
				_mask.graphics.endFill();
			}
			
		}
		
		private function initListener():void
		{
			_spCon.addEventListener(MouseEvent.MOUSE_DOWN,onSpConDown);
		}
		
		/**
		 * 
		 * @param arr
		 * 
		 */		
		public function setArr(arr:Array):void
		{
			clearContainer();
			_mediaVoArr=[];
			_mediaArr=[];
			_mediaVoArr=arr;
			_spCon.x = 0;
			//trace(isRight,"isRight");
			for (var i:int = 0; i < _mediaVoArr.length; i++) 
			{
				var item:LoaderImage=new LoaderImage();
				item.setPath(_mediaVoArr[i] as MediaVO);
				item.setWH(223,125,true,false);
				if(i%4==0){
					_spShu=new Sprite();
					_spShu.name="spShu_"+int(i/4);
					if(_isRight)
					{
						_spShu.x=int(i/4)*280;	
					}else{
						_spShu.x=1630-int(i/4)*280-145;	
					}
					
					_mediaArr.push(_spShu);
					_spCon.addChild(_spShu);
				}	
				_stageW = _mediaArr.length*280;
				item.y=(i%4)*200;
				item.name="item_"+i;
				_spShu.addChild(item);
				_spShu.graphics.clear();
				_spShu.graphics.beginFill(0xFF0000,0);
				_spShu.graphics.drawRect(0,0,_spShu.width,_spShu.height);
				_spShu.graphics.endFill();	
				//trace(_spShu.height,"_spShu.height")
			}
			_spCon.graphics.clear();
			_spCon.graphics.beginFill(0xCCCCCC,0);
			_spCon.graphics.drawRect(0,0,_spCon.width,_spCon.height);
			_spCon.graphics.endFill();	
			
		}
		
		/****************************_spCon Down Move Up事件************************************startstartstartstart*********************/
		private function onSpConDown(event:MouseEvent):void
		{
			//trace(event.target.name,"name");
			_downX = mouseX;
			_downY = mouseY
			_tempX = mouseX;
			_tempY = mouseY;
			_isMove=true;
			_isHeng =false;	
			if(event.target.name.split("_")[0]=="spShu")
			{
				_pageID = event.target.name.split("_")[1];
			}else if(event.target.name.split("_")[0]=="item"){
				_pageID = event.target.parent.name.split("_")[1];
				_tempImage = event.target as LoaderImage;
				_startX = mouseX;
				_startY = mouseY;
				_isOpp = true;
				_mediaVO = (event.target as LoaderImage).mediaVO;
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onSpConMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onSpConUp);	
		}
		
		private function onSpConMove(event:MouseEvent):void
		{
			if(Math.abs(mouseX-_tempX)>20&&_isMove==true)
			{
				_isMove = false;
				_isHeng = true;
			}
			
			if(Math.abs(mouseY-_tempY)>20&&_isMove==true)
			{
				_isMove = false;
			}
			if(_isHeng)
			{
				if(_isOpp)return;//如果你向x轴移动   点击在了图片上  故不能移动
				_spCon.x += mouseX-_downX;
				_downX = mouseX;
				if(_isRight)
				{
					if (_spCon.x > 0) {
						Tweener.addTween(_spCon, { x:0, time:0.2 , transition:"easeOutCubic"} );
					}
					else{ 
						if(_spCon.width>_mask.width)
						{
							if (_spCon.x < -_spCon.width+_mask.width) {//trace("更新了吗",_tempStageX);					
								Tweener.addTween(_spCon, { x: -_spCon.width+_mask.width, time:0.2 , transition:"easeOutCubic"} );
							}
						}else{
							if (_spCon.x < -_spCon.width+230) {//trace("更新了吗",_tempStageX);					
								Tweener.addTween(_spCon, { x: -_spCon.width+230, time:0.2 , transition:"easeOutCubic"} );
							}
						}
					}
				}else{
					if(_stageW>_mask.width)
					{
						//						if (_spCon.x > _mask.x) {
						//							Tweener.addTween(_spCon, { x:_mask.x, time:0.2 , transition:"easeOutCubic"} );
						//						}
						//						
						//						if (_spCon.x < _stageW-_mask.x) {
						//							Tweener.addTween(_spCon, { x:_stageW-_mask.x, time:0.2 , transition:"easeOutCubic"} );
						//						}
					}else{
						
					}
				}
				
			}else{
				_mediaArr[_pageID].y += mouseY-_downY;
				_downY = mouseY;
				if (_mediaArr[_pageID].y > 600) {
					Tweener.addTween(_mediaArr[_pageID], { y:600, time:0.5 , transition:"easeOutCubic"} );
				}else if (_mediaArr[_pageID].y < -((_mediaArr[_pageID] as Sprite).height-135.35)) {
					Tweener.addTween(_mediaArr[_pageID], { y:-((_mediaArr[_pageID] as Sprite).height-135.35), time:0.5 , transition:"easeOutCubic"} );
				}
			}
		}
		
		private function onSpConUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onSpConMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onSpConUp);
			if(_isOpp)
			{
				_upX = mouseX;
				_upY = mouseY;
				if(Math.abs(mouseY -_tempY )>20)return;
				if(Math.abs(_upX-_startX)>10||Math.abs(_upY-_startY)>10)
				{
					if(_tempImage.mediaVO.type!="openMedia")return;
					_speedX = _upX-_startX;
					_speedY = _upY-_startY;
					this.addEventListener(Event.ENTER_FRAME,onObjFrame);
				}else if(Math.abs(_upX-_startX)<5||Math.abs(_upY-_startY)<5){
					trace("是点击",(event.target as LoaderImage).mediaVO.isHimi)
					if((event.target as LoaderImage).mediaVO.type=="openMedia")
					{
						var obj:Object = new Object();
						obj.arr = _mediaVoArr;
						obj.id = event.target.name.split("_")[1];
						NotificationFactory.sendNotification(NotificationIDs.MEDIA_PREVIEW,obj);
					}else if((event.target as LoaderImage).mediaVO.type=="txt"){
						NotificationFactory.sendNotification(NotificationIDs.READ_JIAOAN,(event.target as LoaderImage).mediaVO.con);
					}else{
						_ldrXML.load(new URLRequest((event.target as LoaderImage).mediaVO.path));
					}
					
				}
				_isOpp = false;
			}
		}
		/****************************_spCon Down Move Up事件**********************************endendendendend***********************/
		
		private function onXmlEnd(e:Event):void
		{
			var xml:XML = new XML(e.target.data);
//			trace(xml);
			_mediaVoArr=[];
			for (var i:int = 0; i < xml.item.length(); i++) 
			{
				var vo:MediaVO = new MediaVO();
				vo.title = xml.item[i].@name;
				vo.path = ApplicationData.getInstance().assetsPath + xml.item[i].@data;
//				trace(vo.path,"vo.path");
				vo.thumb = ApplicationData.getInstance().assetsPath + xml.item[i].@thumb;
				vo.type = xml.item[i].@type;
				_mediaVoArr.push(vo);
			}
			setArr(_mediaVoArr);
		}
		
		private function onTimer(e:TimerEvent):void
		{
			_startX = mouseX;
			_startY = mouseY;
		}
		
		private function onObjFrame(e:Event):void
		{
			_timer.stop();
			this.removeEventListener(Event.ENTER_FRAME,onObjFrame);
			NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,_mediaVO);
		}
		
		public function clearContainer():void
		{
			while(_spCon.numChildren>0){
				while((_spCon.getChildAt(0) as Sprite).numChildren){
					if((_spCon.getChildAt(0) as Sprite).getChildAt(0) is LoaderImage){
						((_spCon.getChildAt(0) as Sprite).getChildAt(0) as LoaderImage).dispose();
					}
					(_spCon.getChildAt(0) as Sprite).removeChildAt(0);
				}
				_spCon.removeChildAt(0);
			}
		}
	}
}