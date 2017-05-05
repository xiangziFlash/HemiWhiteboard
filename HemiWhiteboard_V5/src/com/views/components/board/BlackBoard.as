package com.views.components.board
{
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.models.vo.StyleVO;
	import com.models.vo.TuXingVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.GraffitiBoardTouch;
	import com.scxlib.GraphObject;
	import com.views.components.DrawShapeFill;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 白板的涂鸦板
	 * */
	public class BlackBoard extends Sprite
	{
		private var styleVO:StyleVO;
		private var _botSprite:Sprite;
		private var _topSprite:Sprite;
		
//		private var _tuYaBG:TuYaBGRes;//黑板的背景
		private var _tuYaBG:BoardBackGround;//黑板的背景
		private var _tuYa:GraffitiBoardTouch;//涂鸦
//		private var _drawShape:DrawShapeFill;//绘制图形 
		private var _stageW:Number;
		private var _stageH:Number;
//		private var _bmpd:BitmapData;
		public var isFangDa:Boolean;
//		public var jlArr:Vector.<ByteArray> = new Vector.<ByteArray>;
//		public var jlArr:Array=[];
		public var stepID:int;
		private var _ldrByte:Loader;
		private var _tempGeZi:MovieClip;
		private var _bgID:int =1;
		private var _fileBmpd:BitmapData;
		private var _spBmp:Sprite;

		private var _tempBmp:Bitmap;
		private var _isFangDa:Boolean;
		
		private var _yuLanX:Number=0;
		private var _yuLanY:Number=0;
		private var _downX:Number;
		private var _downY:Number;
		private var _tempX:Number;
		private var _tempY:Number;
		private var _mask:Shape;
		private var _isQieHuan:Boolean;//切換模式
		
		private var _shuangJiTiShi:ShuangJitiShiRes;
		private var _blackBoardYuLan:BlackBoardYuLanRes;

		private var _bmpd2:BitmapData;

		private var _bmp2:Bitmap;

		private var _bmp:Bitmap;
		private var _isManYou:Boolean;
		private var _geZiObj:Object;
		private var _isSave:Boolean;
		public var tt:String = "";
		
		public function BlackBoard()
		{
			_botSprite = new Sprite();
			this.addChild(_botSprite);
			
			_topSprite = new Sprite();
			this.addChild(_topSprite);
			_spBmp = new Sprite();
			
			_tempBmp = new Bitmap(null);
			/*_tuYaBG = new TuYaBGRes();
			_botSprite.addChild(_tuYaBG);*/
			
			_tuYaBG = new BoardBackGround();
			_botSprite.addChild(_tuYaBG);
			
			styleVO = new StyleVO();
			_tuYa = new GraffitiBoardTouch();
			_tuYa.touchBegin = tuYaTouchBegin;
			_topSprite.addChild(_tuYa);
			_tuYa.styleVO = styleVO;
//			_bmpd = new BitmapData(1920,990,true,0);
//			_fileBmpd = new BitmapData(1920,990,true,0);
//			_drawShape = new DrawShapeFill();
//			_drawShape.mouseEnabled = false;
//			_topSprite.addChild(_drawShape);
			
			hideAllGeZi();
			//_tuYa.addListener();
		//	_tuYa.addEventListener(Event.CHANGE,onTuYaChange);
			
			_tuYaBG.doubleClickEnabled = true;
			_tuYa.doubleClickEnabled = true;
			
			/*_blackBoardYuLan = new BlackBoardYuLanRes();
			_blackBoardYuLan.x = 1695;
			_blackBoardYuLan.y = 114;
			this.addChild(_blackBoardYuLan);
			_blackBoardYuLan.visible =false;
			
			_shuangJiTiShi = new ShuangJitiShiRes();
			_shuangJiTiShi.scaleX = _shuangJiTiShi.scaleY = 0.5;
			_shuangJiTiShi.x = 1695 - _shuangJiTiShi.width -50;
			_shuangJiTiShi.y = 114;
			this.addChild(_shuangJiTiShi);*/
			
			_mask = new Shape();
			_mask.graphics.beginFill(0x000000,0);
			_mask.graphics.drawRect(0,0,1920,1080);
			_mask.graphics.endFill();
			this.addChild(_mask);
			this.mask = _mask;
			
		/*	_shuangJiTiShi.visible = false;
			_shuangJiTiShi.gotoAndStop(1);
			_shuangJiTiShi.mouseEnabled = false;
			
			_shuangJiTiShi.tt.tt.embedFonts = true;
			_shuangJiTiShi.tt.tt.defaultTextFormat = new TextFormat("YaHei_font",20,0x000000);
			_shuangJiTiShi.tt.tt.wordWrap = true;
			_shuangJiTiShi.tt.tt.autoSize = "left";
			_shuangJiTiShi.tt.tt.text ="双击拖拽";*/
			_tuYaBG.doubleClickEnabled = true;
			_tuYa.doubleClickEnabled = true;
			
			/*_blackBoardYuLan.cacheAsBitmap  = true;
			_shuangJiTiShi.cacheAsBitmap  = true;*/
			_tuYaBG.cacheAsBitmap  = true;
			
			new BgGeZi_0();
			new BgGeZi_1();
			new BgGeZi_2();
			new BgGeZi_3();
			
			initListener();
		}
		
		private function initListener():void
		{
			_tuYa.addListener();
			_tuYa.addEventListener(Event.CHANGE,onTuYaChange);
			_tuYa.addEventListener(Event.COMPLETE,onTuYaEnd);
			/*_blackBoardYuLan.addEventListener(MouseEvent.CLICK,onMenuClick);
			_blackBoardYuLan.bar.addEventListener(MouseEvent.MOUSE_DOWN,onBlackBarDown);
			_blackBoardYuLan.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);*/
			//			_drawShape.addEventListener(Event.CLOSE,onDrawShapeClose);
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onBackBoardDoubleClick);
		}
		
		private function removeListener():void
		{
//			trace("removeListener");
			_tuYa.removeListener();
			_tuYa.removeEventListener(Event.CHANGE,onTuYaChange);
			_tuYa.removeEventListener(Event.COMPLETE,onTuYaEnd);
			/*_blackBoardYuLan.removeEventListener(MouseEvent.CLICK,onMenuClick);
			_blackBoardYuLan.bar.removeEventListener(MouseEvent.MOUSE_DOWN,onBlackBarDown);
			_blackBoardYuLan.removeEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);*/
			this.removeEventListener(MouseEvent.DOUBLE_CLICK,onBackBoardDoubleClick);
		}
		
		public function showRes():void
		{
			if(!_isFangDa)return;
			if(_blackBoardYuLan)
			{
				_blackBoardYuLan.visible = true;
			}
			
			if(_shuangJiTiShi)
			{
				_shuangJiTiShi.visible = true;
			}
		}
		
		public function hideRes():void
		{
			if(_blackBoardYuLan)
			{
				_blackBoardYuLan.visible = false;
			}
			
			if(_shuangJiTiShi)
			{
				_shuangJiTiShi.visible = false;
			}
		}
		
		private function tuYaTouchBegin():void
		{
			//			trace("tuYaTouchBegin");
			isSave = false;
		}
		
		public function addShuXueShape(shape:DisplayObject):void
		{
			_tuYa.addShuXueShape(shape);
		}
		
		private function onBackBoardDoubleClick(e:MouseEvent):void
		{
						trace("推出放大镜",e.target)
			e.stopPropagation();
			if(_isFangDa)
			{
				_shuangJiTiShi.visible = true;
				_shuangJiTiShi.play();
				if(_isQieHuan==false){//trace("双击释放可以涂鸦")
					_shuangJiTiShi.tt.tt.text = "双击拖拽";
					_isQieHuan = true;
					touchPathStart();
					this.removeEventListener(MouseEvent.MOUSE_DOWN,onTempBlackBoardDown);
				}else{//trace("双击锁定不能涂鸦")
					_shuangJiTiShi.tt.tt.text = "双击涂鸦";
					_isQieHuan = false;
					touchPathStop();
					this.addEventListener(MouseEvent.MOUSE_DOWN,onTempBlackBoardDown);
				}
			}else{
				if(e.target is GraphObject)return;
				if(ApplicationData.getInstance().isLock==true)return;
				//				if(ApplicationData.getInstance().isTuYaBan==true)return;
				NotificationFactory.sendNotification(NotificationIDs.STAGE_DOUBLE_CLICK,e);
			}
		}
		
		private function onTouchBegin(event:TouchEvent):void
		{
			event.stopPropagation();
			stage.addEventListener(TouchEvent.TOUCH_END,onTouchEnd);
		}
		
		private function onTouchEnd(event:TouchEvent):void
		{
			event.stopPropagation();
			stage.removeEventListener(TouchEvent.TOUCH_END,onTouchEnd);
		}
		
		private function onMenuClick(e:MouseEvent):void
		{
			if(e.target.name == "menuBtn")
			{
				NotificationFactory.sendNotification(NotificationIDs.STAGE_DOUBLE_CLICK,e);
			}else if(e.target.name == "saveBtn")
			{
				try
				{
					var vo:MediaVO = new MediaVO();
					vo.type = ".jpg";
					vo.isBmpd = true;
					vo.isZiDong = true;
					vo.globalP = new Point(1920*0.5, 1080*0.5);
					vo.bmpd = _tuYa.bmpd.clone();
					NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA, vo);
				} 
				catch(error:Error) 
				{
					NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
				}
				
//				NotificationFactory.sendNotification(NotificationIDs.OPP_CAMERA,_tuYa.bmpd.clone());
				//由于保存成图片很卡  所以暂时取消20140409
				//saveJPG();
			}else{
				if(e.target.name.split("_")[0]=="wz")
				{
					_blackBoardYuLan.bar.x = e.target.x;
					_blackBoardYuLan.bar.y = e.target.y;
					
					var moveX:Number = _blackBoardYuLan.width/(_tuYa.width);
					var moveY:Number = _blackBoardYuLan.height/(_tuYa.height);
					_tuYa.x = -(_blackBoardYuLan.bar.x/moveX);
					_tuYa.y = -(_blackBoardYuLan.bar.y/moveY);
				}
			}
		}
		
		private function onBlackBarDown(e:MouseEvent):void
		{
			_yuLanX = mouseX;
			_yuLanY = mouseY;
			_blackBoardYuLan.addEventListener(MouseEvent.MOUSE_MOVE,onBlackBoardYuLanMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBlackBoardYuLanUp);
		}
		
		private function onBlackBoardYuLanMove(event:MouseEvent):void
		{
			_blackBoardYuLan.bar.x +=mouseX-_yuLanX;
			_blackBoardYuLan.bar.y +=mouseY-_yuLanY;			
			_yuLanX = mouseX;
			_yuLanY = mouseY;
			
			if(_blackBoardYuLan.bar.x<0)
			{
				_blackBoardYuLan.bar.x = 0;
			}
			
			if(_blackBoardYuLan.bar.y<0)
			{
				_blackBoardYuLan.bar.y = 0;
			}
			
			if(_blackBoardYuLan.bar.x>109)
			{
				_blackBoardYuLan.bar.x = 109;
			}
			
			if(_blackBoardYuLan.bar.y>62)
			{
				_blackBoardYuLan.bar.y = 62;
			}
			
			var moveX:Number = _blackBoardYuLan.width/(_tuYa.stageW);
			var moveY:Number = _blackBoardYuLan.height/(_tuYa.stageH);
			_tuYa.x = -(_blackBoardYuLan.bar.x/moveX);
			_tuYa.y = -(_blackBoardYuLan.bar.y/moveY);			
		}
		
		private function onBlackBoardYuLanUp(event:MouseEvent):void
		{
			_blackBoardYuLan.removeEventListener(MouseEvent.MOUSE_MOVE,onBlackBoardYuLanMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBlackBoardYuLanUp);
		}
		
		private function onTuYaChange(e:Event):void
		{
//			_bmpd = _tuYa.bmpd;
			/*try
			{
				NotificationFactory.sendNotification(NotificationIDs.TUYA_END,bmpd.clone());
			} 
			catch(error:Error) 
			{
				trace("error");
			}*/
		}
		
		public function saveBitmapData():BitmapData
		{
			try
			{
				if(_fileBmpd == null)
				{
					_fileBmpd = new BitmapData(1920,990,true,0);
				} 
				if(_isManYou)
				{
					_fileBmpd.draw(_tuYa);
				} else {
					_fileBmpd.draw(this);
				}
			} 
			catch(error:Error) 
			{
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
			}
			return _fileBmpd;
		}
		
		private function hideAllGeZi():void
		{
			/*_tuYaBG.geZi0.visible = false;
			_tuYaBG.geZi1.visible = false;
			_tuYaBG.geZi2.visible = false;
			_tuYaBG.geZi3.visible = false;
			
			_tuYaBG.geZi0.alpha =1;
			_tuYaBG.geZi1.alpha =1;
			_tuYaBG.geZi2.alpha =1;
			_tuYaBG.geZi3.alpha =1;*/
			
			if(_tempGeZi)
			{
				_tempGeZi.visible = false;
				_tempGeZi.alpha = 1;
				this.removeChild(_tempGeZi);
				_tempGeZi=null;
			}
		}
		
		public function setVO(vo:StyleVO):void
		{
			styleVO = vo;
		}
		
		public function setTuYaBG(id:int):void
		{
			/*_tuYaBG.gotoAndStop(id+1);*/
			_bgID = id;
			//			_tuYaBG.gotoAndStop(id);
			_tuYaBG.changeBoardBg(id);
		}
		
		public function clearSystemMemory():void
		{
			_tuYa.clearSystemMemory();
		}
		
		public function setWH(w:Number,h:Number):void
		{
			_stageW = w;
			_stageH = h;
			_tuYa.setWH(w,h);
		}
		
		public function clearAll():void
		{
			_tuYa.clear();
			if(_bmpd2)
			{
				_bmpd2.dispose();
			}
			
//			_drawShape.clearAll();
		}
		
		public function setGeZiShow(obj:Object):void
		{
			if(obj == null)return;
			_geZiObj = obj;
			
			/*hideAllGeZi();
			if(obj.id==4){
				
			}else{
				_tuYaBG["geZi"+obj.id].visible = true;
				if(obj.change==false)return;
				_tuYaBG["geZi"+obj.id].scaleX = _tuYaBG["geZi"+obj.id].scaleY = obj.scale;
				_tuYaBG["geZi"+obj.id].alpha = obj.alpha;
			}*/
			
			hideAllGeZi();
			if(obj.id==4){
				
			}else{
				/*_tuYaBG["geZi"+obj.id].visible = true;
				if(obj.change==false)return;
				_tuYaBG["geZi"+obj.id].scaleX = _tuYaBG["geZi"+obj.id].scaleY = obj.scale;
				_tuYaBG["geZi"+obj.id].alpha = obj.alpha;*/
				if(_tempGeZi)
				{
						this.removeChild(_tempGeZi);
						_tempGeZi = null;
				}
				var str:String = "BgGeZi_"+obj.id;
				var GeZiCls:Class = getClassByName(str);
				var gezi:* = new GeZiCls();
				gezi.scaleX = gezi.scaleY = 1;
				gezi.x = 960 ;
				gezi.y = 507.5 ;
				gezi.name = "gezi";
				this.addChild(gezi);
				_tempGeZi = gezi;
				if(obj.change==false)return;
				gezi.scaleX = gezi.scaleY = obj.scale;
				gezi.alpha = obj.alpha;
			}
		}
		
		/**
		 * 
		 * 開啟漫遊
		 */		
		public function openFangDaJing():void
		{
			if(_isFangDa)return;
			if(_blackBoardYuLan == null)
			{
				_blackBoardYuLan = new BlackBoardYuLanRes();
				_blackBoardYuLan.x = 1695;
				_blackBoardYuLan.y = 114;
				this.addChild(_blackBoardYuLan);
				_blackBoardYuLan.visible =false;
				_blackBoardYuLan.cacheAsBitmap  = true;
				
				_blackBoardYuLan.addEventListener(MouseEvent.CLICK,onMenuClick);
				_blackBoardYuLan.bar.addEventListener(MouseEvent.MOUSE_DOWN,onBlackBarDown);
				_blackBoardYuLan.addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
			}
			
			if(_shuangJiTiShi == null)
			{
				_shuangJiTiShi = new ShuangJitiShiRes();
				_shuangJiTiShi.scaleX = _shuangJiTiShi.scaleY = 0.5;
				_shuangJiTiShi.x = 1695 - _shuangJiTiShi.width -50;
				_shuangJiTiShi.y = 114;
				this.addChild(_shuangJiTiShi);
				_shuangJiTiShi.cacheAsBitmap  = true;
				_shuangJiTiShi.mouseChildren = false;
				_shuangJiTiShi.mouseEnabled = false;
				
				_shuangJiTiShi.visible = false;
				_shuangJiTiShi.gotoAndStop(1);
				_shuangJiTiShi.mouseEnabled = false;
				
				_shuangJiTiShi.tt.tt.embedFonts = true;
				_shuangJiTiShi.tt.tt.defaultTextFormat = new TextFormat("YaHei_font",20,0x000000);
				_shuangJiTiShi.tt.tt.wordWrap = true;
				_shuangJiTiShi.tt.tt.autoSize = "left";
			}
			
			//			_isFirst = true;
			touchPathStop();
			if(!_isManYou && !_isFangDa)
			{
				if(_fileBmpd == null)
				{
					_fileBmpd = new BitmapData(1920*3, 990*3, true, 0);
				}
				setWH(1920*3,990*3);
			}
			_isFangDa = true;
			_isManYou = true;
			_isFangDa = true;
			_tuYa.setManYou(_isManYou);
			_shuangJiTiShi.tt.tt.text ="双击涂鸦";
			_blackBoardYuLan.visible = true;
			_shuangJiTiShi.visible = true;
			_shuangJiTiShi.play();
			onTuYaEnd(null);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onTempBlackBoardDown);
		}
		
		/**
		 * 
		 * 關閉漫遊
		 */		
		public function closeFangDaJing():void
		{
			if(!_isFangDa)return;
			
			_isFangDa = false;
			touchPathStart();
			_blackBoardYuLan.visible = false;
			_shuangJiTiShi.visible = false;
			_shuangJiTiShi.gotoAndStop(1);
			this.mask = _mask;
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onTempBlackBoardDown);
		}
		
		private function onTempBlackBoardDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseX;
			_tempX = mouseY;
			this.addEventListener(MouseEvent.MOUSE_MOVE,onTempBackGroundMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
		}
		
		private function onTempBackGroundMove(e:MouseEvent):void
		{
			_tuYa.x += mouseX-_downX;
			_tuYa.y += mouseY-_downY;
			
			_downX = mouseX;
			_downY = mouseY;
			//trace(_tempBackGround.x,_tempBackGround.y);
			if(_tuYa.x>0*1920)
			{
				_tuYa.x = 0*1920;
			} else if(_tuYa.x<-_tuYa.stageW+(0+1)*1920)
			{
				_tuYa.x = -_tuYa.stageW+(0+1)*1920;
			}
			
			if(_tuYa.y>0)
			{
				_tuYa.y = 0;
			}else if(_tuYa.y<-_tuYa.stageH+990)
			{
				_tuYa.y = -_tuYa.stageH+990;
			}
			
			var moveX:Number = _blackBoardYuLan.width/(_tuYa.stageW);
			var moveY:Number = _blackBoardYuLan.height/(_tuYa.stageH);
			_blackBoardYuLan.bar.x = Math.abs(_tuYa.x)*moveX;
			_blackBoardYuLan.bar.y = Math.abs(_tuYa.y)*moveY;
			
			if(_blackBoardYuLan.bar.x<0)
			{
				_blackBoardYuLan.bar.x = 0;
			}
			
			if(_blackBoardYuLan.bar.y<0)
			{
				_blackBoardYuLan.bar.y = 0;
			}
			
			if(_blackBoardYuLan.bar.x>109)
			{
				_blackBoardYuLan.bar.x = 109;
			}
			
			if(_blackBoardYuLan.bar.y>62)
			{
				_blackBoardYuLan.bar.y = 62;
			}
		}
		
		private function onStageUp(e:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onTempBackGroundMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
		}
		
		/**
		 * 
		 * @param e
		 * 涂鸦结束  更新预览框 
		 */			
		public function onTuYaEnd(e:Event):void
		{
			if(!_isFangDa)return;
			while(_blackBoardYuLan.mc.numChildren>0)
			{
				if(_blackBoardYuLan.mc.getChildAt(0) is Bitmap)
				{
					(_blackBoardYuLan.mc.getChildAt(0) as Bitmap).bitmapData.dispose();
				}
				_blackBoardYuLan.mc.removeChildAt(0);
			}		 
			
			try
			{
//				var bmpd1:BitmapData = new BitmapData(_stageW, _stageH, true, 0);
				//trace("dd---");
				if(_bmp == null)
				{
					_bmp = new Bitmap(_tuYa.bmpd,"auto",true);
				}
				_bmp.bitmapData = _tuYa.bmpd;
				_bmp.scaleX = (55/1920);
				_bmp.scaleY = (31/990);
				var sp:Sprite = new Sprite();
				sp.mouseEnabled = false;
				sp.addChild(_bmp);
				if(_bmpd2)
				{
					_bmpd2.dispose();
					_bmpd2 = null;
				}
				_bmpd2 = new BitmapData(sp.width, sp.height, true, 0);
				_bmpd2.draw(sp);
				if(_bmp2 == null)
				{
					_bmp2 = new Bitmap(_bmpd2);
				}
				_bmp2.bitmapData = _bmpd2;
				_bmp2.name = "bmp2";
				_blackBoardYuLan.mc.addChild(_bmp2);
				sp.removeChild(_bmp);
			} 
			catch(error:Error) 
			{
				trace("漫游出错了  563");
			}
			
		}
		
		private function getClassByName(cname:String):Class  //cname即为元件的链接名称。
		{
			var mc:Class =  getDefinitionByName(cname) as Class;
			return mc;
		}
		
		public function copyBlackBoard(bmpd:BitmapData):void
		{
//			_bmpd = bmpd;
			_tuYa.drawBitmap(bmpd);
			/*var bmp:Bitmap = new Bitmap(bmpd);
			this.addChild(bmp);*/
		}
		
		public function touchPathStop():void
		{
//			_tuYa.removeListener();
			_tuYa.isSuoDing = true;
		}
		
		public function touchPathStart():void
		{
			if(isFangDa==true)return;
//			_tuYa.addListener();
			_tuYa.isSuoDing = false;
		}
		
		public function cheXiao():void
		{
			try
			{
				if(_tuYa.stepID>0){
					_tuYa.stepID--;
					_tuYa.jiLuArr[_tuYa.stepID].position = 0;
					var bmpd:BitmapData = new BitmapData(_stageW,_stageH,true,0);
					bmpd.setPixels(new Rectangle(0, 0, _stageW,_stageH), _tuYa.jiLuArr[_tuYa.stepID]);
					_tuYa.bmpd = bmpd;
					_tuYa.bmp.bitmapData=_tuYa.bmpd
				}else{
					if(_tuYa.jiLuArr.length > 9)
					{
						//					_tuYa.bmp.bitmapData = null;
					} else {
						_tuYa.bmp.bitmapData = _tuYa.tempBmpd;
					}
//					_tuYa.bmp.bitmapData = null
					_tuYa.stepID=-1;
				}	
				NotificationFactory.sendNotification(NotificationIDs.TUYA_END,_tuYa.bmpd);
			} 
			catch(error:Error) 
			{
				
			}
			
			/*trace("撤销",ApplicationData.getInstance().isTuYaBan);
			if(ApplicationData.getInstance().isTuYaBan==true)
			{
//				_drawShape.stepID = _drawShape.bmpdArr.length;
//				_drawShape.cheXiao();
			}else{
				if(_tuYa.stepID>0){
					_tuYa.stepID--;
					//trace("撤销",_tuYa.stepID,_tuYa.jiLuArr[_tuYa.stepID]);
					/*_tuYa.bmpd = _tuYa.jiLuArr[_tuYa.stepID].clone();
					_tuYa.bmp.bitmapData=_tuYa.bmpd;*/
			/*		if(_ldrByte ==null)
					{
						_ldrByte = new Loader();
						_ldrByte.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrByteEnd);
					}
					_ldrByte.loadBytes(_tuYa.jiLuArr[_tuYa.stepID]);
				}else{
					_tuYa.bmp.bitmapData = null
					_tuYa.stepID=-1;
				}
			}*/
		}
		
		public function chongZuo():void
		{
			try
			{
				if(_tuYa.stepID<_tuYa.jiLuArr.length-1){
					_tuYa.stepID++;
					_tuYa.jiLuArr[_tuYa.stepID].position = 0;
					var bmpd:BitmapData = new BitmapData(_stageW,_stageH,true,0);
					bmpd.setPixels(new Rectangle(0, 0, _stageW,_stageH), _tuYa.jiLuArr[_tuYa.stepID]);
					_tuYa.bmpd = bmpd;
					_tuYa.bmp.bitmapData=_tuYa.bmpd;
				}
				NotificationFactory.sendNotification(NotificationIDs.TUYA_END,_tuYa.bmpd);
			} 
			catch(error:Error) 
			{
				
			}
			
			/*if(ApplicationData.getInstance().isTuYaBan==true)
			{
//				_drawShape.chongZuo();
			}else{
				if(_tuYa.stepID<_tuYa.jiLuArr.length-1){
					_tuYa.stepID++;
					/*_tuYa.bmpd = _tuYa.jiLuArr[_tuYa.stepID].clone();
					_tuYa.bmp.bitmapData=_tuYa.bmpd;*/
			/*		if(_ldrByte ==null)
					{
						_ldrByte = new Loader();
						_ldrByte.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrByteEnd);
					}
					_ldrByte.loadBytes(_tuYa.jiLuArr[_tuYa.stepID]);
				}
			//	NotificationFactory.sendNotification(NotificationIDs.TUYA_END);
			}*/
		}
		/**
		 * 
		 *设置涂鸦记录的数组和撤销的步骤 
		 */				
		public function setARRID():void
		{
//			jlArr = _tuYa.jiLuArr;
			stepID = _tuYa.stepID;
		}
		
		private function onLdrByteEnd(e:Event):void
		{
//			(e.target.content as Bitmap).bitmapData.transparent = true;
			_tuYa.bmpd = (e.target.content as Bitmap).bitmapData;
			_tuYa.bmp.bitmapData= (e.target.content as Bitmap).bitmapData;
			NotificationFactory.sendNotification(NotificationIDs.TUYA_END);
		}
		
		public function openDrawShape(vo:TuXingVO):void
		{
//			_drawShape.mouseEnabled = vo.drawShape;
//			if(vo.drawShape)
//			{
//				_topSprite.addChild(_drawShape);
//			}else{
//				_topSprite.addChild(_tuYa);
//			}
//			_drawShape.onTuYa(vo);
			_tuYa.onDrawShape(vo);
		}
		
		public function addGongJuDraw(shape:Object):void
		{
//			_drawShape.addGongJuDraw(shape);
		}
		
		public function dispose():void
		{
			_tuYa.clear();
//			_drawShape.clearAll();
		}

		public function get tuYa():GraffitiBoardTouch
		{
			return _tuYa;
		}

		public function get isManYou():Boolean
		{
			return _isManYou;
		}

		public function get geZiObj():Object
		{
			return _geZiObj;
		}

		public function get bgID():int
		{
			return _bgID;
		}

		public function get isSave():Boolean
		{
			return _isSave;
		}

		public function set isSave(value:Boolean):void
		{
			_isSave = value;
		}


	}
}