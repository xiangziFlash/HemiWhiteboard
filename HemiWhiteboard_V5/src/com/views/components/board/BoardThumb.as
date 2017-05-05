package com.views.components.board
{
	import com.events.ChangeEvent;
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.OppMedia;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class BoardThumb extends Sprite
	{
		private var _boardBtn:BoardThumbMC;
		private var _minBtn:MinBoradRes;//软件最小化窗口按钮
		private var _spCon:Sprite;
		private var _btnArr:Array=[];
		private var _index:int = 0;
		private var _spDis:Sprite;
		private var _disThumbArr:Array=[];
		private var _copyID:int=0;
		private var _tempBtn:BoardThumbMC;
		private var _nowBGID:int;//当前黑板的背景颜色
		
		public function BoardThumb()
		{
			_minBtn = new MinBoradRes();
			
			_spCon = new Sprite();
			_spCon.y = -40;
			
			_spDis = new Sprite();
			
			this.addChild(_spCon);
			this.addChild(_spDis);
			this.addChild(_minBtn);
			_minBtn.addEventListener(MouseEvent.CLICK,onMiniBtnClick);
			
			addBoard();
			
		}
		/**
		 * 
		 * @param boo 是不是复制白板
		 * @param id  复制的是那块白板 
		 * 
		 */		
		public function addBoard(boo:Boolean=false,id:int=0,bmpd:BitmapData=null):void
		{
			if(_btnArr.length>ApplicationData.getInstance().maxBoard)return;//白板的个数限制
			_boardBtn = new BoardThumbMC();
//			_boardBtn.scaleX = _boardBtn.scaleY = 0.8;
			_spCon.addChild(_boardBtn);
			if(boo==true){
				_copyID++;
				_boardBtn.setCon(String(huoQuMC(ApplicationData.getInstance().nowBoardID)+"_"+_copyID),_spCon.numChildren);
				_boardBtn.addYuLan(bmpd);
				_boardBtn.gotoStop((_spCon.getChildByName("board_"+ApplicationData.getInstance().nowBoardID)as BoardThumbMC).blackID);
				_btnArr.splice(ApplicationData.getInstance().nowBoardID+1,0,_boardBtn);
//				ApplicationData.getInstance().nowBoardID = ApplicationData.getInstance().nowBoardID + 1;
			}else{
				_index++;
				_btnArr.push(_boardBtn);
				_boardBtn.setCon(String(_index),_spCon.numChildren);
				_boardBtn.gotoStop(ApplicationData.getInstance().blackID);
			}
			if(_tempBtn)
			{
				_tempBtn.setStatus(false);
			}
			
			_tempBtn = _boardBtn;
			_tempBtn.setStatus(true);
			ApplicationData.getInstance().boardArr = _btnArr;
//			_boardBtn.addEventListener(MouseEvent.CLICK,onCloseBtnClick);
			_boardBtn.addEventListener(ChangeEvent.BOARD_CLOSE,onCloseBtnClick);
			setWeiZhi();
		}
		
		private function huoQuMC(id:int):String
		{
			var tt:String="";
			for (var i:int = 0; i < _spCon.numChildren-1; i++) 
			{
				if((_spCon.getChildAt(i) as BoardThumbMC).index == id)
				{
					var tempMC:BoardThumbMC = (_spCon.getChildAt(i) as BoardThumbMC);
					tt = tempMC.huoQuTT();
//					trace("tt1111",tt);
				}
			}
			return tt
		}
		
		public function addDisThumb(pad:OppMedia):void
		{
			_boardBtn = new BoardThumbMC();
			//trace(_disThumbArr.length,"_disThumbArr.length")
			_boardBtn.name ="disThumb_"+_disThumbArr.length;
			_boardBtn.isThumb = true;
			_boardBtn.index = _disThumbArr.length;
			pad.hideID = _disThumbArr.length;
			_spDis.addChild(_boardBtn);
			
			var dic:Dictionary = pad.showDic;
			dic.x = pad.x ;
			dic.y = pad.y ;
			dic.scaleX = pad.scaleX ;
			dic.scaleY = pad.scaleY ;
			dic.rotation = pad.rotation ;
			_boardBtn.y = -(_disThumbArr.length)*40;
			
			_disThumbArr.push(_boardBtn);
//			_boardBtn.addEventListener(MouseEvent.CLICK,onSpDisClick);
			_boardBtn.addEventListener(ChangeEvent.BOARD_CLOSE,onSpDisClick);
			var gloabP:Point = _boardBtn.localToGlobal(new Point());
			Tweener.addTween(pad,{	rotation:0,
				width:_boardBtn.width,
				height:_boardBtn.height,
				x:gloabP.x,
				y:gloabP.y,
				alpha:0,
				visible:false,
				time:0.5,
				onComplete:function():void{//trace("添加舞台展示文件图标",pad.dataVO.bmp.width);
					_boardBtn.addBitMap(pad.mediaVO.btyeArray,null,pad);
					_spDis.y = _spCon.y-_spCon.height-5;
					var dic:Dictionary = pad.hideDic;
					dic.x = gloabP.x ;
					dic.y = gloabP.y ;
					dic.width = pad.width ;
					dic.height = pad.height ;
				}
			});
		}
		
		/**
		 * 缩小舞台展示图标(已有图标)
		 * */
		public function miniDisplayThumb(pad:OppMedia):void
		{
			var dic1:Dictionary = pad.showDic;
			dic1.x = pad.x ;
			dic1.y = pad.y ;
			dic1.scaleX = pad.scaleX ;
			dic1.scaleY = pad.scaleY ;
			dic1.rotation = pad.rotation ;
			
			var dic:Dictionary = pad.hideDic;
			Tweener.addTween(pad,{	rotation:dic.rotation,
				width:dic.width,
				height:dic.height,
				x:dic.x,
				y:dic.y,
				alpha:0,
				visible:false,
				time:0.5,
				onComplete:function():void{
					
				}
			});
		}
		
		private function onSpDisClick(e:ChangeEvent):void
		{
//			(e.currentTarget,e.currentTarget.name,e.target.name,"+++++")
			var thumb:BoardThumbMC = e.currTarget as BoardThumbMC;
			var pad:OppMedia = thumb.pad;
			var dic:Dictionary = pad.showDic;
			var n:int;
			
			if(e.targetName == "closeBtn"){
				n = thumb.index;
				NotificationFactory.sendNotification(NotificationIDs.REMOVE_DISPLAY,pad);//删除pad
			}else{
				n = thumb.index;
				pad.parent.setChildIndex(pad,pad.parent.numChildren-1);
				Tweener.addTween(pad,{rotation:dic.rotation,scaleX:dic.scaleX,scaleY:dic.scaleY,x:dic.x,y:dic.y,alpha:1,visible:true,time:0.5});
				removeDisplayThumb(pad);
			}
		}
		
		public function clearBoard():void
		{
			(_spCon.getChildByName("board_"+ApplicationData.getInstance().nowBoardID)as BoardThumbMC).clearBmpd();
		}
		
		private function onCloseBtnClick(e:ChangeEvent):void
		{
			if(e.targetName=="closeBtn")
			{
				if(_spCon.numChildren<2)return;
				var id:int = (e.currTarget as BoardThumbMC).index;
				removeBackgroundThumb(id);
				NotificationFactory.sendNotification(NotificationIDs.REMOVE_BOARD,id);
			}else{
//				trace((e.currTarget as BoardThumbMC).huoQuTT(),"tttt");
				if(e.currTarget.name.split("_")[0]=="board")
				{
					var index:int = (e.currTarget as BoardThumbMC).index;
					_nowBGID = (e.currTarget as BoardThumbMC).blackID;
//					trace(index,"index",(e.currTarget as BoardThumbMC).blackID);
					if(_tempBtn)
					{
						_tempBtn.setStatus(false);
					}
					
					_tempBtn = e.currTarget as BoardThumbMC;
					_tempBtn.setStatus(true);
					NotificationFactory.sendNotification(NotificationIDs.CHANGE_BOARD,index);
				}
			}
		}
		
		private function setWeiZhi():void
		{
			for (var i:int = 0; i < _btnArr.length; i++) 
			{
				(_btnArr[i] as BoardThumbMC).name = "board_"+(i);
				(_btnArr[i] as BoardThumbMC).y = -(i)*38;
				(_btnArr[i] as BoardThumbMC).index = i;
			}
			
			_spDis.y = _spCon.y-_spCon.height-5;
		}
		
		public function removeBackgroundThumb(index:int):void
		{
			_btnArr[index].removeEventListener(MouseEvent.CLICK,onCloseBtnClick);
			_spCon.removeChild(_btnArr[index]);
			_btnArr.splice(index,1);
			for (var i:int = 0; i < _btnArr.length; i++) 
			{
				(_btnArr[i] as BoardThumbMC).name = "board_"+(i);
				(_btnArr[i] as BoardThumbMC).y = -(i)*40;
				(_btnArr[i] as BoardThumbMC).index = i;
			}
			_spDis.y = _spCon.y-_spCon.height-5;
			ApplicationData.getInstance().boardArr = _btnArr;
		}
		
		public function getTitle(id:int):String
		{
			return (_btnArr[id] as BoardThumbMC).getTitle();
		}
		
		public function setBtnStatus(id:int):void
		{
			if(_tempBtn)
			{
				_tempBtn.setStatus(false);
			}
			
			_tempBtn = _btnArr[id] as BoardThumbMC;
			_tempBtn.setStatus(true);
		}
		
		public function removeDisplayThumb(pad:OppMedia):void
		{
			var id:int = pad.hideID;
			_disThumbArr[id].disposeDisplayThumb();
			_spDis.removeChild(_disThumbArr[id]);
			_disThumbArr.splice(id,1);
			for (var i:int = 0; i < _disThumbArr.length; i++) 
			{
				(_disThumbArr[i] as BoardThumbMC).name = "disThumb_"+(i);
				(_disThumbArr[i] as BoardThumbMC).y = -(i)*40;
				(_disThumbArr[i] as BoardThumbMC).index = i;
			}
			
			for(var j:int = 0;j<_disThumbArr.length;j++){
				var thumb:BoardThumbMC = _disThumbArr[j] as BoardThumbMC;
				var gloabP:Point = pad.localToGlobal(new Point());
				var dic:Dictionary = pad.hideDic;
				dic.x = gloabP.x ;
				dic.y = gloabP.y ;
				dic.width = thumb.width ;
				dic.height = thumb.height ;
				thumb.pad.hideID = j;
			}
		}
		
		public function setThumbBG(id:int):void
		{
			(_spCon.getChildByName("board_"+ApplicationData.getInstance().nowBoardID)as BoardThumbMC).gotoStop(id);
		}
		/**
		 * 
		 * 为白板图标添加涂鸦
		 * */
		public function addBmpd(bmpd:BitmapData):void
		{
			(_spCon.getChildByName("board_"+ApplicationData.getInstance().nowBoardID)as BoardThumbMC).addYuLan(bmpd);
		}
		
		private function onMiniBtnClick(e:MouseEvent):void
		{
			if(e.target.name=="fuzhiBtn")
			{
				NotificationFactory.sendNotification(NotificationIDs.COPY_BLACKBOARD);
			}else if(e.target.name=="addBtn"){
				NotificationFactory.sendNotification(NotificationIDs.ADD_BOARD);
			}
		}
	}
}