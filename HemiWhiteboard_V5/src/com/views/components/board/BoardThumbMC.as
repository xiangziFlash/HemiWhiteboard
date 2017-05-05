package com.views.components.board
{
	import com.events.ChangeEvent;
	import com.greensock.TweenLite;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.OppMedia;
	import com.tweener.transitions.Tweener;
	
	import fl.motion.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filters.DropShadowFilter;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class BoardThumbMC extends Sprite
	{
		private var _index:int;
		private var _bmp:Bitmap;
		private var _bmp1:Bitmap;
		
		private var _sp:Sprite;
		private var _vo:MediaVO;
		public var pad:OppMedia;
		private var _downX:Number;
		private var _downY:Number;
		
		private var _tempX:Number=0;
		private var _isThumb:Boolean =false;//这里记录下  这个小图标是不是弹出媒体的最小化状态  
		private var _blackID:int = 0;
		private var _ldr:Loader;
		
		private  var _bgLdr:Loader;
//		private var _bgArr:Array=["assets/backGround/thumb_0.png","assets/backGround/thumb_1.png","assets/backGround/thumb_2.png","assets/backGround/thumb_3.png","assets/backGround/thumb_4.png"];
		private var _tempBmpd:BitmapData;
		private var _tempBmp:Bitmap;
		private var _tt:TextField;
		private var _yuLanBmp:Bitmap;
		private var _res:ThumbBianRes;
		
		public function BoardThumbMC()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
			this.mouseChildren =false;
			_tt = new TextField();
			_tt.defaultTextFormat = new TextFormat("YaHei_font",15,0xD6D6D6);
			_tt.autoSize = "left";
			_sp = new Sprite();
			_res = new ThumbBianRes();
			
			_bgLdr = new Loader();
			_bgLdr.contentLoaderInfo.addEventListener(Event.COMPLETE,onBgLdrEnd);
			_bgLdr.load(new URLRequest(ApplicationData.getInstance().bgThumbs[0].nativePath));
		}
		
		private function onBgLdrEnd(event:Event):void
		{
			_tempBmpd = (_bgLdr.content as Bitmap).bitmapData.clone();
			_bgLdr.x = _bgLdr.y = 0;
			this.addChild(_bgLdr);
			/*if(_yuLanBmp)
			{
				this.addChild(_yuLanBmp);
			}*/
			
			this.addChild(_res);
			_tt.x = 2;
			_tt.y = 3;
			this.addChild(_tt);
			if(_tempBmp==null)return;
//			TweenLite.to(_tempBmp, 0.2, {visible:false, ease:Linear.easeNone});
//			TweenLite.to(_bgLdr,0.2,{visible:true, ease:Linear.easeNone});
			Tweener.addTween(_tempBmp, {time:0.2, visible:false});
			Tweener.addTween(_bgLdr,{time:0.2,visible:true});
			setTimeout(function ():void
			{
				_bgLdr.visible = true;
			},200);
		}
		/**
		 *切換塗鴉板背景 
		 */		
		public function gotoStop(index:int):void
		{//trace(index,"index");
			_blackID = index;
			if(_tempBmp==null)
			{
				_tempBmp = new Bitmap(_tempBmpd);
				this.addChild(_tempBmp);
				_tempBmp.visible = false;
			}else{
				_tempBmp.bitmapData = _tempBmpd;
			}
//			TweenLite.to(_tempBmp,0.5,{visible:true});
//			TweenLite.to(_bgLdr,0.5,{visible:false});
			Tweener.addTween(_tempBmp,{time:0.5,visible:true});
			Tweener.addTween(_bgLdr,{time:0.5,visible:false});
//			trace(ApplicationData.getInstance().bgThumbs.length,"+++++")
			
			try
			{
//				trace("thumb",ApplicationData.getInstance().bgThumbs[index].nativePath);
				_bgLdr.load(new URLRequest(ApplicationData.getInstance().bgThumbs[index].nativePath));
			} 
			catch(error:Error) 
			{
				
			}
			
			//trace("thumb",ApplicationData.getInstance().bgThumbs[index].nativePath);
		}
		
		private function onDown(event:MouseEvent):void
		{
			if(_isThumb)
			{
				
			}else{
				if(ApplicationData.getInstance().boardArr.length==1)return;
				this.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			}
			_downX = this.x;
			_downY = mouseY;
			_tempX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			this.x +=mouseX-_tempX;
			_tempX = mouseX;
		}
		
		private function onUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			if(Math.abs(this.x-_downX)>20){
				var eve:ChangeEvent = new ChangeEvent(ChangeEvent.BOARD_CLOSE);
				eve.targetName = "closeBtn"
				eve.index = _index;
				eve.currTarget = this;
				this.dispatchEvent(eve);
			}else{
				Tweener.addTween(this,{x:0,time:0.5});
				if(Math.abs(mouseX-_downX)<10||Math.abs(mouseY-_downY)<10)
				{//trace("执行了这里77")
					var eve1:ChangeEvent = new ChangeEvent(ChangeEvent.BOARD_CLOSE);
					eve1.targetName = "board_"+_index;
					eve1.index = _index;
					eve1.currTarget = this;
					this.dispatchEvent(eve1);
				}
			}
		}
		
		private function onAddStage(event:Event):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		/**
		 * 
		 * @param tt 文本框内容
		 * @param index mc的深度
		 * 
		 */		
		public function setCon(tt:String,index:int):void
		{
			_index = index;
			_tt.text = tt;
			_tt.mouseEnabled = false;
		}

		public function huoQuTT():String
		{
			var tt:String="";
			var myRegExp:RegExp = new RegExp("_","g");
			if(_tt.text.match(myRegExp)[0]=="_")
			{
//				trace(_boardBtn.TT.text,"中包含了_");
				tt = _tt.text.split("_")[0];
			}else{
//				trace(_boardBtn.TT.text,"中不包含了_");
				tt = _tt.text;
			}
//			trace(tt,"bianhao")
			return tt;
		}
		
//		public function addBitMap(bmp:Bitmap,vo:MediaVO=null,opp:OppMedia=null):void
		public function addBitMap(ba:ByteArray,vo:MediaVO=null,opp:OppMedia=null):void
		{
			_vo = vo;
			pad = opp;
			
			if(_ldr==null)
			{
				_ldr = new Loader();
				_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrBaEnd);
				_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			_ldr.loadBytes(ba);
		}
		
		public function addYuLan(bmpd:BitmapData):void
		{
			try
			{
				if(_yuLanBmp == null)
				{
					_yuLanBmp = new Bitmap(null);
					_yuLanBmp.width = _res.width;
					_yuLanBmp.height = _res.height;
					_yuLanBmp.cacheAsBitmap = true;
					_res.addChild(_yuLanBmp);
				}
				_yuLanBmp.scaleX = _yuLanBmp.scaleY = Math.min(53/bmpd.width,30/bmpd.height);
				_yuLanBmp.bitmapData = bmpd;
			} 
			catch(error:Error) 
			{
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
			}
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			trace("加载图标出错了")
		}
		
		private function onLdrBaEnd(event:Event):void
		{
			_ldr.width = 53;
			_ldr.height = 30;
			_sp.addChild(_ldr);
			var bmpd:BitmapData = new BitmapData(_sp.width,_sp.height);
			bmpd.draw(_sp);
			_bmp1 = new Bitmap(bmpd);
			_bmp1.x = 0.5;
			_bmp1.y = 0.3;
			this.addChild(_bmp1);
			_sp.removeChild(_ldr);
			_ldr.unloadAndStop();
			_ldr = null;
		}
		
		public function getTitle():String
		{
			return _tt.text;;
		}
		
	/**	private function onCloseBtnClick(e:MouseEvent):void
		{
			if(e.target.name=="closeBtn")
			{
//				if(_spCon.numChildren<2)return;
//				var id:int = (e.target as MovieClip).parent.name.split("_")[1];
//				removeBackgroundThumb(id);
//				NotificationFactory.sendNotification(NotificationIDs.REMOVE_BOARD,index);
				var eve:ChangeEvent = new ChangeEvent(ChangeEvent.BOARD_CLOSE);
				eve.index = _index;
				this.dispatchEvent(eve);
			}else{
//				if(e.target.name.split("_")[0]=="board")
//				{
//					var index:int = e.target.name.split("_")[1];
//					NotificationFactory.sendNotification(NotificationIDs.CHANGE_BOARD,index);
//				}
			}
		}**/
		
		public function disposeDisplayThumb():void
		{
			if(_yuLanBmp)
			{
				if(_yuLanBmp.bitmapData)
				{
					_yuLanBmp.bitmapData.dispose();
					_yuLanBmp=null;
				}
			}
			
			if(_tempBmp)
			{
				if(_tempBmp.bitmapData)
				{
					_tempBmp.bitmapData.dispose();
					_tempBmp = null;
				}
			}
			
			if(_bgLdr)
			{
				this.removeChild(_bgLdr);
				_bgLdr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onBgLdrEnd);
				_bgLdr.load(new URLRequest(ApplicationData.getInstance().bgThumbs[0].nativePath));
				_bgLdr.unloadAndStop();
				_bgLdr =null;
			}
//			_bgArr=[];
			_bmp1.bitmapData.dispose();
			_bmp1.bitmapData = null;
			_bmp1 = null;
			if(_ldr!=null)
			{
				//				(_ldr.content as Bitmap).bitmapData.dispose();
				//				(_ldr.content as Bitmap).bitmapData= null;
				_ldr.unloadAndStop();
				_ldr = null;
			}
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
		}
		
		/**
		 * 清除涂鸦缩约图
		 */		
		public function clearBmpd():void
		{
			if(_yuLanBmp)
			{
				if(_yuLanBmp.bitmapData)
				{
					_yuLanBmp.bitmapData.dispose();
				}
			}
			
			if(_tempBmp)
			{
				if(_tempBmp.bitmapData)
				{
					_tempBmp.bitmapData.dispose();
				}
			}
		}
		
		/**
		 * 
		 * 设置白班图标的状态
		 */		
		public function setStatus(boo:Boolean):void
		{
			if(boo){
				this.filters  = [new DropShadowFilter(0,0,0xFFFFFF,1,9,9)];
			}else{
				this.filters  = [];
			}
		}

		public function get index():int
		{
			return _index;
		}

		public function set index(value:int):void
		{
			_index = value;
		}

		public function get vo():MediaVO
		{
			return _vo;
		}

		public function get isThumb():Boolean
		{
			return _isThumb;
		}

		public function set isThumb(value:Boolean):void
		{
			_isThumb = value;
		}

		public function get blackID():int
		{
			return _blackID;
		}

		public function set blackID(value:int):void
		{
			_blackID = value;
		}


	}
}