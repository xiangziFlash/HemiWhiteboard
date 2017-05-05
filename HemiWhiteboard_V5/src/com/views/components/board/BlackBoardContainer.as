package com.views.components.board
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.StyleVO;
	import com.models.vo.TuXingVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.components.board.BlackBoard;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class BlackBoardContainer extends Sprite
	{
		private var _blackBoardSprite:Sprite;//装载黑板的总容器
		private var _boardArr:Vector.<BlackBoard> = new Vector.<BlackBoard>;//装载黑板的数组
//		private var _boardArr:Array=[];//装载黑板的数组
		private var _pageID:int=0;//当前黑板的id
		
		private var _tempBlackBoard:BlackBoard;
		private var _downX:Number;
		private var _downY:Number;
		private var _tempX:Number;
		private var _tempY:Number;
		private var _isShiFang:Boolean;
//		private var _blackBoardYuLan:BlackBoardYuLanRes;
		
		private var _yuLanX:Number=0;
		private var _yuLanY:Number=0;
		
//		private var _jlArr:Array=[];
//		private var _jlArr:Vector.<ByteArray> = new Vector.<ByteArray>;
		private var _stepID:int;
		private var _saveBoardTimer:Timer;
		private var _fileID:int = -1;
		private var _filePath:String;
		
		public function BlackBoardContainer()
		{
			this.addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		private function onAddStage(e:Event):void
		{
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_saveBoardTimer = new Timer(4000);
			_saveBoardTimer.stop();
			_saveBoardTimer.addEventListener(TimerEvent.TIMER,onFileTimer);
			
			_blackBoardSprite = new Sprite();
			this.addChild(_blackBoardSprite);
			
			addBackgroundPage();
		}
		
		public function showRes():void
		{
			(_boardArr[_pageID] as BlackBoard).showRes();
		}
		
		public function hideRes():void
		{
			(_boardArr[_pageID] as BlackBoard).hideRes();
		}
		
		public function addYuLanTuYa():void
		{
			(_boardArr[_pageID] as BlackBoard).onTuYaEnd(null);
		}
		
		public function getBloakBoardNum():int
		{
			return _boardArr.length;
		}
		
		public function getBlackBoard(id:int):BlackBoard
		{
			return _boardArr[id];
		}
		
		private function initListener():void
		{
//			stage.doubleClickEnabled = true;
//			stage.addEventListener(MouseEvent.DOUBLE_CLICK,onStageDoubleClick);
//			_blackBoardSprite.doubleClickEnabled = true;
//			_blackBoardSprite.addEventListener(MouseEvent.DOUBLE_CLICK,onStageDoubleClick);
		}
		
		
		
		private function onStageDoubleClick(e:MouseEvent):void
		{
			if(ApplicationData.getInstance().isLock==true)return;
			if(ApplicationData.getInstance().isTuYaBan==true)return;
			NotificationFactory.sendNotification(NotificationIDs.STAGE_DOUBLE_CLICK,e);
		}
		
		public function addBackgroundPage(isClone:Boolean=false):void
		{
			if(_boardArr.length>ApplicationData.getInstance().maxBoard)return;
//			if(_blackBoardYuLan.visible==true)
//			{
//				openFangDaJing(1);
//			}
			var _blackBoard:BlackBoard = new BlackBoard();
			_blackBoard.doubleClickEnabled = true;
			_blackBoard.name = "blackBoard_"+_boardArr.length;
			_blackBoard.setTuYaBG(ApplicationData.getInstance().blackID);
			if(isClone==true)
			{
				var bmpd:BitmapData;
				//trace((_boardArr[_pageID] as BlackBoard).bmpd,"ApplicationData.getInstance().nowBoardID",ApplicationData.getInstance().nowBoardID)
				if((_blackBoardSprite.getChildByName("blackBoard_"+ApplicationData.getInstance().nowBoardID) as BlackBoard).isManYou)
				{
					_blackBoard.setWH(1920*3,990*3);
					bmpd = new BitmapData(1920*3,990*3,true,0);
				} else {
					_blackBoard.setWH(1920,1080-32);
					bmpd = new BitmapData(1920,1080-32,true,0);
				}
				_blackBoard.setTuYaBG(_boardArr[ApplicationData.getInstance().nowBoardID].bgID);
				if((_blackBoardSprite.getChildByName("blackBoard_"+ApplicationData.getInstance().nowBoardID) as BlackBoard).tuYa.bmpd==null)
				{
					bmpd = null;
				} else {
					bmpd = (_blackBoardSprite.getChildByName("blackBoard_"+ApplicationData.getInstance().nowBoardID) as BlackBoard).tuYa.bmpd.clone();
				}
						
				_blackBoard.copyBlackBoard(bmpd);
				_blackBoard.setGeZiShow(_boardArr[ApplicationData.getInstance().nowBoardID].geZiObj);
				_boardArr.splice(ApplicationData.getInstance().nowBoardID+1,0,_blackBoard);
				ApplicationData.getInstance().nowBoardID = ApplicationData.getInstance().nowBoardID + 1;
			}else{
				_blackBoard.setWH(1920,1080-32);
				_boardArr.push(_blackBoard);
				ApplicationData.getInstance().nowBoardID = _boardArr.length - 1;
			}
			blackBoardWeiZhi();
			_blackBoardSprite.addChild(_blackBoard);
			ApplicationData.getInstance().blachBoardLength = _boardArr.length;
//			ApplicationData.getInstance().nowBoardID = _boardArr.length;
			if(isClone==true)
			{
				setBlackBoardWeiZhi(ApplicationData.getInstance().nowBoardID);
			} else {
				setBlackBoardWeiZhi(_boardArr.length-1);
			}
		}
		
		private function blackBoardWeiZhi():void
		{
			for (var i:int = 0; i < _boardArr.length; i++) 
			{
				_boardArr[i].name = "blackBoard_"+i;
				_boardArr[i].x = i*1920;
			}
			trace("_boardArr.length",_boardArr.length);
			if(_boardArr.length > 10)
			{
				NotificationFactory.sendNotification(NotificationIDs.CLEAR_SYSTEMMEMORY);
			}
		}
		
		public function removeBackgroundPage(index:int):void
		{
			/*try
			{*/
			trace(index,_boardArr.length,"removeBackgroundPage")
				_boardArr[index].dispose();
				_blackBoardSprite.removeChild(_boardArr[index]);
				_boardArr.splice(index,1);
				for (var i:int = 0; i < _boardArr.length; i++) 
				{
					_boardArr[i].name = "blackBoard_"+i;
					_boardArr[i].x = i*1920;
				}
				ApplicationData.getInstance().blachBoardLength = _boardArr.length;
			/*} 
			catch(error:Error) 
			{
				Tool.log("黑板删除出错");
			}*/
			
		}
		
		public function setBlackBoardWeiZhi(index:int):void
		{
			_pageID = index;
//			trace("_pageID",_pageID)
			Tweener.addTween(_blackBoardSprite,{x:-_pageID*1920,time:0.5,transition:"easeInQuad"});
		}
		
		public function setBlackBoardVO(vo:StyleVO):void
		{
			(_boardArr[_pageID] as BlackBoard).setVO(vo);
		}
		/**
		 *涂鸦板清除所有 
		 * 
		 */		
		public function clearAll():void
		{
			(_boardArr[_pageID] as BlackBoard).clearAll();
		}
		
		public function setGeZiShow(obj:Object):void
		{
			(_boardArr[_pageID] as BlackBoard).setGeZiShow(obj);
		}
		
		public function setBlackBoardBG(id:int):void
		{
			(_boardArr[_pageID] as BlackBoard).setTuYaBG(id);
		}
		
		public function clearSystemMemory():void
		{
			for (var i:int = 0; i < _boardArr.length; i++) 
			{
				_boardArr[i].clearSystemMemory();
			}
		}
		
		public function saveAllBoard():void
		{
			_fileID = -1;
			var date:Date = new Date();
			var mouth:String = "";
			var date1:String = "";
			if(int(date.month+1) < 10)
			{
				mouth = "0"+(date.month+1);
			} else {
				mouth = ""+(date.month+1);
			}
			
			if(date.date <10)
			{
				date1 = "0"+date.date;
			} else {
				date1 = ""+date.date;
			}
			_filePath = ApplicationData.getInstance().appPath+"黑板板书/"+String(date.fullYear)+"-"+String(mouth)+"-"+String(date1)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds)+"/";
			_saveBoardTimer.reset();
			_saveBoardTimer.start();
		}
		
		/**
		 *涂鸦撤销 
		 */		
		public function cheXiao():void
		{
			(_boardArr[_pageID] as BlackBoard).cheXiao();
			_stepID = (_boardArr[_pageID] as BlackBoard).stepID;
//			NotificationFactory.sendNotification(NotificationIDs.TUYA_END);
		}
		
		/**
		 *涂鸦重做 
		 */		
		public function chongZuo():void
		{
			(_boardArr[_pageID] as BlackBoard).chongZuo();
			_stepID = (_boardArr[_pageID] as BlackBoard).stepID;
//			NotificationFactory.sendNotification(NotificationIDs.TUYA_END);
		}
		/**
		 * 
		 *获取记录的数组  和撤销的步骤 
		 */		
		public function  setArrID():int
		{
			/*(_boardArr[_pageID] as BlackBoard).setARRID()
			_jlArr = (_boardArr[_pageID] as BlackBoard).jlArr;
			_stepID = (_boardArr[_pageID] as BlackBoard).stepID;*/
			
			(_boardArr[_pageID] as BlackBoard).setARRID();
			_stepID = ((_boardArr[_pageID] as BlackBoard) as BlackBoard).stepID;
			return (_boardArr[_pageID] as BlackBoard).tuYa.jiLuArr.length;
		}
		
		/**
		 *打开关闭放大镜 
		 * @param id =0  打开放大镜 id 关闭放大镜
		 * 
		 */		
		public function openFangDaJing(id:int):void
		{
			_tempBlackBoard = (_boardArr[_pageID] as BlackBoard);
			if(id==0)
			{
				_tempBlackBoard.openFangDaJing();
			}else{//关闭放大镜
				_tempBlackBoard.closeFangDaJing();
			}
		}
		
		private function onFileTimer(event:TimerEvent):void
		{
			if(_fileID<_boardArr.length-1)
			{
				_fileID++;
				var str:String = "正在保存第"+(_fileID + 1)+"张黑板板书内容，请稍候...";
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,str);
				var fileName:String = _filePath + _fileID +".png";
//				ConstData.saveLocalFile.saveBmpd((_boardArr[_fileID] as BlackBoard).saveBitmapData(),fileName,false);
				ToolKit.saveLocalFile((_boardArr[_fileID] as BlackBoard).saveBitmapData(),fileName);
			}else{
				_fileID = -1;
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
				_saveBoardTimer.stop();
			}
		}
		
		public function openDrawShape(vo:TuXingVO):void
		{
			(_boardArr[_pageID] as BlackBoard).openDrawShape(vo);
		}
		
		public function getBmpd():BitmapData
		{
			if((_boardArr[_pageID] as BlackBoard).tuYa.bmpd== null)
			{
				return null;
			} 
			return (_boardArr[_pageID] as BlackBoard).tuYa.bmpd.clone();
		}
		/**
		 * 
		 * 添加数学工具涂鸦的内容
		 */		
		public function addShuXueShape(shape:DisplayObject):void
		{
			(_boardArr[_pageID] as BlackBoard).addShuXueShape(shape);
		}
		
		public function reset():void
		{
//			if(_tempBlackBoard){
//				_tempBlackBoard.x = ApplicationData.getInstance().nowBoardID*1920;
//				_tempBlackBoard.y = 0;
//				_tempBlackBoard.touchPathStart();
//				_tempBlackBoard=null;
//			}
		}

		public function get pageID():int
		{
			return _pageID;
		}

		public function get stepID():int
		{
			return _stepID;
		}

		public function get boardArr():Vector.<BlackBoard>
		{
			return _boardArr;
		}

			
	}
}