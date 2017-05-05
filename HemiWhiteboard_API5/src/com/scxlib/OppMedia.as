package com.scxlib
{
	import com.charts.DrawPieGraph;
	import com.controls.ToolKit;
	import com.controls.utilities.VideoControl;
	import com.events.ChangeEvent;
	import com.events.DragEvent;
	import com.greensock.TweenLite;
	import com.lylib.components.media.SwfPlayer;
	import com.lylib.touch.objects.MultiPointRotationScale;
	import com.lylib.touch.objects.RotatableScalable;
	import com.lylib.touch.objects.RotatableScalable1;
	import com.lylib.utils.MathUtil;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.msgs.AddHimiMediaMSG;
	import com.models.msgs.ClientType;
	import com.models.vo.MediaVO;
	import com.notification.ILogic;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	import com.views.components.DisplaySprite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.PNGEncoderOptions;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.MediaType;
	import flash.net.FileReference;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	[Event(name=TouchMoveEvent, type="flash.events.Event")]
	[Event(name=TouchEndEvent, type="flash.events.Event")]
	[Event(name=TouchBeginEvent, type="flash.events.Event")]
	public class OppMedia extends RotatableScalable
	{
		public static const TouchMoveEvent:String="TouchMoveEvent";
		public static const TouchEndEvent:String="TouchEndEvent";
		public static const TouchBeginEvent:String="TouchBeginEvent";
		public var _mediaPlayer:MediaPlayer;
		public var _oppToolBar:OppToolBarRes;
		private var _isLock:Boolean;
//		private var _tuYa:GraffitiBoardMouse;
		private var _tempColor:MovieClip;
		private var _tempThincess:MovieClip;
		private var _tempBrush:MovieClip;
		
		private var _isFull:Boolean;
		private var _tempR:Number;
		private var _tempX:Number;
		private var _tempY:Number;
		private var _bmpd:BitmapData;
		private var _bmp:Bitmap;
		private var _mediaVO:MediaVO;
		private var _isPlay:Boolean=false;
		private var _stageW:Number;
		
		private var _lc:uint;
		private var _ls:int;
		private var _lt:int;
		private var _bg:Shape;
		private var _isCamera:Boolean = false;
		public var hideDic:Dictionary=new Dictionary();
		public var showDic:Dictionary = new Dictionary();
		public var hideID:int;
		public var hasMinisize:Boolean;
		public var isRemoveDown:Boolean;
		public var indexID:int;
		private var _toolsTimer:Timer;
		private var _isHuanDengModel:Boolean;
		private var _isClosed:Boolean= false;
		private var _spCon:DisplaySprite;
		private var _fileName:String;
		private var _beginX:Number=0;
		private var _beginY:Number=0;
		private var _numName:String ="";
		private var _strName:String ="";
		private var _isTouPiao:Boolean = false;
		private var _sp:Sprite;
		private var _vots:Loader;
		private var _isVote:Boolean = true;
		private var _mask:Shape;
		private var _fangXiangID:int;
		private var _positionID:int;
		private var _isLeft:Boolean;
		private var _isVoted:Boolean = false;//已经投过票了  
		private var _voteChart:DrawPieGraph;

		private var _titleType:String;

		private var _pieGraph:DrawPieGraph;
		private var _tempBtn:MovieClip;
		private var _isVoteOpen:Boolean;
		private var himiMedia:String="";

		private var _hitBoo:Boolean;

		private var _flvPath:String;
		private var _ldr:URLLoader;
		private var _isSave:Boolean;
		
		public function OppMedia()
		{
			touchEndFun=touchEnd;
			touchMoveFun=touchMove;
			touchBeginFun = touchBegin;
			initContent();
			initListener();
		}
		
		public function get strName():String
		{
			return _strName;
		}

		public function set strName(value:String):void
		{
			_strName = value;
		}

		public function get numName():String
		{
			return _numName;
		}

		public function set numName(value:String):void
		{
			_numName = value;
		}

		private function initContent():void
		{
			_spCon=NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			_sp = new Sprite();
			
			_bg = new Shape();
			_bg.graphics.clear();
			_bg.graphics.beginFill(0,1);
			_bg.graphics.drawRect(0,0,1920,1080);
			_bg.graphics.endFill();
			_mediaPlayer = new MediaPlayer();
			_mediaPlayer.changeFun = changeEnd;
			_mediaPlayer.addEventListener(Event.COMPLETE,onComplete);
			
			//_mediaPlayer.showTuYa();
			noInertia = true;
			_mediaPlayer.hideTuYa();
			_mediaPlayer.removeListener();
			_oppToolBar = new OppToolBarRes();
			
			_oppToolBar.x = 0;
			_oppToolBar.y = 1080-53;
			
//			this.addChild(_mask);
			this.addChild(_bg);
			this.addChild(_mediaPlayer);
			this.addChild(_oppToolBar);
//			_oppText.text = "测试";
//			this.mask = _mask;
//			_oppToolBar.visible = false;
			_oppToolBar.votePanel.transform.matrix = null;
			this.filters = [new DropShadowFilter(0,0,0,1,9,9)];
			_oppToolBar.votePanel.y = 55;
			_toolsTimer = new Timer(2000);
			_toolsTimer.addEventListener(TimerEvent.TIMER,onToolsTimer);
			_toolsTimer.start();
			chuShi();
			_oppToolBar.cheXiaoBtn.visible = false;
			_oppToolBar.chongZuoBtn.visible = false;
			
			//测试大屏发送图片
			/*var btn:Sprite = new Sprite();
			btn.graphics.clear();
			btn.graphics.beginFill(0);
			btn.graphics.drawRect(0,0,500,500);
			btn.graphics.endFill();
			this.addChild(btn);*/
			
			//btn.addEventListener(MouseEvent.CLICK,onBtnClick);
		}
		
		/*private function onBtnClick(event:MouseEvent):void
		{
			var msg:String = "condragon%AddMediaMSG-&controlType=transfer&MediaPath=http://192.168.3.78/assest/icon/1.jpg&clientType=client&end";
			ConstData.socket.sendMsg(msg);
		}*/
		
		public function setInertia(boo:Boolean):void
		{
			noInertia = boo;
			isInertiaEnd = false;
		}
		
		private function initListener():void
		{
			(_oppToolBar.votePanel.btn_2 as MovieClip).mouseChildren = false;
			(_oppToolBar.votePanel.btn_3 as MovieClip).mouseChildren = false;
			(_oppToolBar.votePanel.btn_4 as MovieClip).mouseChildren = false;
			(_oppToolBar.votePanel.btn_5 as MovieClip).mouseChildren = false;
			(_oppToolBar.votePanel.btn_6 as MovieClip).mouseChildren = false;
			_oppToolBar.addEventListener(MouseEvent.CLICK,onToolBarClick);
			_oppToolBar.votePanel.addEventListener(MouseEvent.CLICK,onVotePanelClick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onThisDown);
			_mediaPlayer.doubleClickEnabled = true;
			this.doubleClickEnabled = true;
			this.addEventListener(MouseEvent.DOUBLE_CLICK,onDoubleClick);
		}
		
		private function onDoubleClick(event:MouseEvent):void
		{
			if(isHuanDengModel || !_isVoteOpen)return;
			if(ConstData.voteResults.length == 0)
			{
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"没有检测到有人投票，请重新开始...");
				if(_isVoted)
				{
					_isVoted = false;
					_isVoteOpen = false;
				}
				setTimeout(function ():void
				{
					NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
				},1000);
				return;
			}
			resetXY();
//			trace(_isTouPiao,"_isTouPiao");
			if(!_isTouPiao)
			{
				_isTouPiao = true;
				var dataList:Array=[];
				var nameArray:Array=[];
				var promptList:Array=[];
				var colorList:Array=[];
				for (var j:int = 0; j < ConstData.voteResults.length; j++) 
				{
					dataList.push(ConstData.voteResults[j].share);
					nameArray.push(ConstData.voteResults[j].country);
					promptList.push(ConstData.voteResults[j].peoples);
					colorList.push(ConstData.colorList[j]);
				}
				_bg.graphics.clear();
				_bg.graphics.beginFill(0xFFFFFF);
				_bg.graphics.drawRect(0,0,1920,1080);
				_bg.graphics.endFill();
				this.addChild(_bg);
				
				if(_pieGraph == null)
				{
					_pieGraph = new DrawPieGraph(200,200,600,360,15,dataList,colorList,nameArray,promptList,.7);
					_pieGraph.doubleClickEnabled = true;
					_pieGraph.x = (_pieGraph.width * 0.5);
					_pieGraph.y = (_pieGraph.height * 0.5);
					_pieGraph.alpha = 0;
					_pieGraph.scaleX = _pieGraph.scaleY = 0.1;
				} 
				this.addChild(_pieGraph);
//				TweenLite.to(_pieGraph,0.5,{scaleX:1,scaleY:1,alpha:1,visible:true});	
				Tweener.addTween(_pieGraph,{time:0.5,scaleX:1,scaleY:1,alpha:1,visible:true});	
			} else {
				_bg.graphics.clear();
				_bg.graphics.beginFill(0xFFFFFF,0);
				_bg.graphics.drawRect(0,0,1920,1080);
				_bg.graphics.endFill();
				this.addChildAt(_bg,0);
				_isTouPiao = false;
				if(_pieGraph)
				{
//					TweenLite.to(_pieGraph,0.5,{scaleX:0.1,scaleY:0.1,alpha:0,visible:false});
					Tweener.addTween(_pieGraph,{time:0.5,scaleX:0.1,scaleY:0.1,alpha:0,visible:false});
				}
			}
		}
		
		/**
		 * 获取某个路径下的所有文件，可以根据文件类型返回数组
		 * @param	str  文件路径
		 * @param	fileType 要获取的文件格式 默认全部
		 * @return  File 数组 
		 */
		public function getFileArr(str:String,fileType:String="*"):Array
		{
			var fileArr:Array = [];
			var file:File = new File(str);
			
			fileArr = file.getDirectoryListing();
			//fileArr.sortOn("name",Array.CASEINSENSITIVE|Array.NUMERIC | Array.DESCENDING );
			//fileArr.sortOn("name", Array.CASEINSENSITIVE | Array.DESCENDING );
			//trace(fileArr);
			return fileArr;
		}
		
		/**
		 * 读取文字性文件内容
		 * @param fileName
		 * @return String  字符串
		 */		
		private function getUTFString(fileName:String):String
		{
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var str:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			file = null;
			fs = null;
			return str;
		}
		
		/**
		 * 保存文字性文件
		 * @param	str
		 * @param	fileName
		 */
		private function saveUTFString(str:String, fileName:String):void
		{
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
		}

		
		private function rotationEnd():void
		{
			if(_isFull)return;
			openDuoDian();
		}
		
		public function resetVote():void
		{
			if(_vots)
			{
				if(_vots.parent)
				{
					_vots.parent.removeChild(_vots);
					_vots.content.rotationY = 0;
				}
				
			}
			_oppToolBar.rotationY = 0;
			this.rotationY = 0;
			_isTouPiao = false;
		}
		
		private function loadVoting():void
		{
			if(_vots == null)
			{
				_vots = new Loader();
				_vots.doubleClickEnabled = true;
				_vots.contentLoaderInfo.addEventListener(Event.COMPLETE, onVotsCom);
				_vots.addEventListener(Event.CLOSE, onVotingClose);
			}
//			_vots.load(new URLRequest("assets/TuXing.swf"));
			if(!_isVoted)
			{
				_isVoted = true;
				_vots.load(new URLRequest("assets/VotingCharts.swf"));
			} else {
				this.addChildAt(_vots, 2);
			}
		}
		
		private function onVotePanelClick(e:MouseEvent):void
		{
			if(e.target.name.split("_")[0] != "btn")return;
			if(ConstData.isVoting)
			{
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"每次只能进行一次投票，请结束上个投票在启动...");
				setTimeout(function ():void
				{
					NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
				},2000);
				return;
			}
			_isVoted = false;
			if(_tempBtn)
			{
				_tempBtn.gotoAndStop(1);
			}
			_tempBtn = e.target as MovieClip;
			_tempBtn.gotoAndStop(2);
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在下发题目，请稍候...");
			ConstData.voteTitleType = e.target.name.split("_")[1];
			
			var msg:String = "condragon%VoteMSG-&clientType=client&voteType=0&questionsType=" + ConstData.voteTitleType + "&end";
			ConstData.isVoting = true;
			_oppToolBar.voteBtn.gotoAndStop(2);
			ConstData.socket.sendMsg(msg);
			ConstData.voteUsers.length = 0;
			ConstData.votes.length = 0;
			ConstData.voteResults.length = 0;
			
//			faQiVote(ConstData.voteTitleType);
			faQiVote(ConstData.voteTitleType);
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},200);
			//condragon%VoteMSG-&clientType=phone&voteType=0&titleType=0&voteQuestions=http://192.168.3.78/assest/icon/1.jpg&end
		}
		
		/*private function setVote(type:String):void
		{
			var str:String = "VoteStatus:" + type;
			saveUTFString(str,ApplicationData.getInstance().appPath+"UPloadfile/VoteStatus.txt")
		}*/
		
		private function faQiVote(type:String):void
		{
			var ldr:URLLoader=new URLLoader();//http://t.iptid.com/ws/eduVote.asmx?op=SetVote
//			var _request:URLRequest=new URLRequest("http://t.iptid.com/ws/eduVote.asmx?op=SetVote")
			var _request:URLRequest=new URLRequest("http://127.0.0.1:1986/SetVoteStatus")
			var params:URLVariables=new URLVariables();
			params.status = type;
			_request.method=URLRequestMethod.POST; 
			_request.data=params;
			ldr.load(_request);
			ldr.addEventListener(Event.COMPLETE,onUrlLdrEnd);
		}
		
		private function onUrlLdrEnd(event:Event):void
		{
			var msg:String = event.target.data;
			ToolKit.log("<<<<faQiVote"+ msg);
		}
		
		private function shangChuangImage(file:File):void
		{
			ToolKit.log(ConstData.serverAddress+"shangChuangImage")
			var urlRequest:URLRequest=new URLRequest();
			urlRequest.url="http://"+ConstData.serverAddress+":10000/ashx/UploadHandler.ashx";
			var urlvar:URLVariables=new URLVariables();
			urlvar.PWD="jgifouyjirohg";
			urlvar.fileName=file.name;
			urlRequest.method = URLRequestMethod.POST;
			urlRequest.data=urlvar;
			file.addEventListener(IOErrorEvent.IO_ERROR,onFileIoError);
			file.upload(urlRequest);
			file.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,completeHandler);
		}
		
		private function progressHandler(event:ProgressEvent):void
		{
			//			trace("progressHandler   "+int((event.bytesLoaded/event.bytesTotal)*100)+"  "+event.bytesLoaded);
//			addWaitKuang("图片已上传："+int((event.bytesLoaded/event.bytesTotal)*100));
		}
		
		private function onFileIoError(event:IOErrorEvent):void
		{
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"图片上传失败，图片已损坏");
//			trace("图片上传失败，图片已损坏");
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},500);
		}
		
		private function completeHandler(event:DataEvent):void
		{
//			_fileName = event.data.split("/")[event.data.split("/").length-1];
//			Tool.log("文件已上传完成"+event.data);
//			trace("文件已上传完成"+event.data);
			var voteQuestions:String = event.data;
			//condragon%AddMediaMSG-&controlType=transfer&MediaPath=http://192.168.3.78/assest/icon/1.jpg&clientType=client&end;
			var msg:String = "condragon%AddMediaMSG-&controlType=transfer&MediaPath="+voteQuestions+"&clientType=cleint&end";
			ConstData.socket.sendMsg(msg);
			NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
		}
		
		private function onVotingClose(event:Event):void
		{
			onDoubleClick(null);
		}
		
		private function onVotsCom(event:Event):void
		{
			_vots.transform.matrix = null;
			_vots.alpha = 0;
			//trace(_vots.content.width)
			//_vots.content.width = 1920;
		//	_vots.content.height = 1080;
			_vots.x = _vots.y = 0;
			this.addChildAt(_vots, 2);
			setTimeout(function():void
			{
				TweenLite.to(_vots, 0.5, {alpha:1});
			},100);
		}
		
		/**
		 * 注册点为中心点ta
		 */		
		public function setMediaXYCenter():void
		{
			if(_mediaPlayer.x != -1920 * 0.5 || _mediaPlayer.y != -1080 * 0.5)
			{
				this.x += _mediaPlayer.x + 1920 * this.scaleX * 0.5;
				this.y += _mediaPlayer.y + this.height * 0.5;
				_mediaPlayer.x = - 1920 * 0.5;
				_mediaPlayer.y = - 1080 * 0.5;
			}
			
			_oppToolBar.x = 1920 * 0.5;
			_oppToolBar.y = 1080 * 0.5-55;
		}
		
		private function onToolBarClick(e:MouseEvent):void
		{
			switch(e.target.name)
			{
				case "fit_btn":
				{
					this.dispatchEvent(new ChangeEvent(ChangeEvent.FIT_WEIZHI));
					break;
				}
				case "fullScreen_btn":
				{
					if(_isFull==false){
						_tempR = this.rotation;
						_isFull = true;
						this.dispatchEvent(new Event(Event.FULLSCREEN));
					}else{
						closeFullScreen();
						_isFull = false;
						this.dispatchEvent(new Event(Event.CHANGE));
					}
					NotificationFactory.sendNotification(NotificationIDs.IS_FULL,_isFull);
					break;
				}
				case "lock_btn":
				{
					var eve:DragEvent = new DragEvent(DragEvent.IMAGE_LOCK);
					if((e.target as MovieClip).currentFrame==1)
					{
						(e.target as MovieClip).gotoAndStop(2);
						_isLock = true;
						noRotat = false;
						noScale = false;
						noDrag = true;
						eve.isLock = true;
						_mediaPlayer.addListener();
						_mediaPlayer.showTuYa();
						removeEventListeners();
					}else{
						(e.target as MovieClip).gotoAndStop(1);
						_isLock = false;
						if(!_isFull){
							openDuoDian();
						}else{
							closeDuoDian();
						}
						eve.isLock = false;
						_mediaPlayer.hideTuYa();
						_mediaPlayer.removeListener();
					}
					eve.isFull = _isFull;
					this.dispatchEvent(eve);
					break;
				}
				case "close_btn":
				{
					_isClosed = true;
					drawShape();
//					this.dispatchEvent(new Event(Event.CLOSE));
					break;
				}
				case "add_btn":
				{
					if(ApplicationData.getInstance().oppArr.length>56)return;
					var vo:MediaVO = new MediaVO();
					if(_mediaVO.isBmpd)
					{
						vo.type = ".jpg";
						vo.isBmpd = true;
						vo.globalP = new Point(1920*0.5, 1080*0.5);
						vo.bmpd =_mediaVO.bmpd.clone();	
					} else {
						vo.type = _mediaVO.type;
						vo.isBmpd = _mediaVO.isBmpd;
						vo.globalP = _mediaVO.globalP;
						vo.bmpd =_mediaVO.bmpd;	
						vo.path = _mediaVO.path;
						vo.thumb = _mediaVO.thumb;
						vo.title = _mediaVO.title;
					}
					NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,vo);
					break;
				}
				case "min_btn":
				{
					if(_oppToolBar.lock_btn.currentFrame == 2)
					{
						var eve:DragEvent = new DragEvent(DragEvent.IMAGE_LOCK);
						_oppToolBar.lock_btn.gotoAndStop(1);
						_isLock = false;
						if(!_isFull){
							openDuoDian();
						}else{
							closeDuoDian();
						}
						eve.isLock = false;
						_mediaPlayer.hideTuYa();
						_mediaPlayer.removeListener();
						eve.isFull = _isFull;
						this.dispatchEvent(eve);
					}
					drawShape();
					//_mediaVO.bmp = _bmp;
					if(_mediaPlayer.mediaType==MediaVO.VIDEO||_mediaPlayer.mediaType==MediaVO.SWF)
					{
						_mediaPlayer.pauseMedia();
					}
					NotificationFactory.sendNotification(NotificationIDs.MIN_DIS_THUMB,[this]);
					hasMinisize = true;
					break;
				}
				case "save_btn":
				{
					var date:Date = new Date();
					var name:String = String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds);
					_bmpd = new BitmapData(1920,1080,true,0);
					_bmpd.draw(_mediaPlayer);
					var ba:ByteArray = new ByteArray(); 
					var jpegEncoder:PNGEncoderOptions = new PNGEncoderOptions(true);
					_bmpd.encode(_bmpd.rect,jpegEncoder,ba);
					var file:FileReference = new FileReference(); 
					file.save(ba,name+".png"); 
					file.addEventListener(Event.SELECT,onSaveComplete);
					file.addEventListener(Event.CANCEL,onSaveComplete);
					break;
				}
				case "play_btn":
				{
					_mediaPlayer.tuYa.play();
					break;
				}
				case "stop_btn":
				{
					if(_mediaPlayer.tuYa.isRecord)
					{
						_oppToolBar.record_btn.gotoAndStop(1);
						_mediaPlayer.tuYa.stop();
						_oppToolBar.play_btn.visible=true;
					}
					break;
				}
				case "record_btn":
				{
					if(_isLock)
					{
						_oppToolBar.record_btn.gotoAndStop(2);
						_mediaPlayer.tuYa.xmlRecord.newXML();
						_mediaPlayer.tuYa.isRecord=true;
					} else {
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"请先锁定涂鸦，再进行录制");
						
						setTimeout(function():void{
							NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
						},1500);
					}
					
					break;
				}
				case "clearBtn":
				{
					clearTuYa();
					break;
				}
				case "shared_btn":
				{
					moveEnd();
					break;
				}
					
				case "voteBtn":
				{
					if(_oppToolBar.voteBtn.currentFrame == 1)
					{
						trace("_isTouPiao",_isTouPiao)
						if(_isVoted)
						{
							NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"您已经发起过投票了，如果需要复制一个，重新发起投票...");
							setTimeout(function ():void
							{
								NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
							},2000);
							return;
						}
						if(_isVote)
						{
							_isVote = false;
							TweenLite.to(_oppToolBar.votePanel, 0.5,{y:-252});
						} else {
							_isVote = true;
							TweenLite.to(_oppToolBar.votePanel, 0.5,{y:55});
						}
					} else {
						_isVoteOpen = true;
						_isVoted = true;
						TweenLite.to(_oppToolBar.votePanel, 0.5,{y:55});
						_oppToolBar.voteBtn.gotoAndStop(1);
						ConstData.isVoting = false;
						NotificationFactory.sendNotification(NotificationIDs.VOTE_END);
						//condragon%VoteMSG-&clientType=client&voteType=2&end
//						var msg:String = "condragon%VoteMSG-&clientType=client&controlType=stop&end";
						var msg:String = "condragon%VoteMSG-&clientType=client&voteType=2&end";
						ConstData.socket.sendMsg(msg);
//						faQiVote("-1");
						faQiVote("-1")
					}
					break;
				}
					
				case "sendPhone":
				{
					/*NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在发送文件,请稍候。。。");
					if(_bmpd == null)
					{
						_bmpd = new BitmapData(_oppToolBar.width,_mediaPlayer.playerBg.height,true,0);
					}
					
					_bmpd.draw(_mediaPlayer);
					var date1:Date = new Date();
					var filePath1:String = ApplicationData.getInstance().appPath+"老师共享的图片/"+String(date1.fullYear)+"-"+String(date1.month)+"-"+String(date1.date)+"-"+String(date1.hours)+"-"+String(date1.minutes)+"-"+String(date1.seconds)+".jpg";
					ConstData.saveLocalFile.saveBmpd(_bmpd,filePath1,false);
					ConstData.saveLocalFile.addEventListener(Event.COMPLETE,onsaveLocalFileEnd);
					setTimeout(function ():void{
						shangChuangImage(new File(filePath1));
					},4000);*/
					NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在发送文件,请稍候。。。");
					if(_bmpd == null)
					{
						_bmpd = new BitmapData(_oppToolBar.width,_mediaPlayer.playerBg.height,true,0);
					}
					
					_bmpd.draw(_mediaPlayer);
					var date1:Date = new Date();
					var filePath1:String = "";
					var fileName:String = Math.abs(int(Math.random()*10000000000000))+".jpg"; 
					var fileParentName:String = "";
					
					var month:String = String(date1.month + 1);
					var day:String = String(date1.date);
					
					if(int(month) < 10)
					{
						month = "0"+month;
					} 
					
					if(int(day) < 10)
					{
						day = "0"+day;
					} 
					fileParentName = String(date1.fullYear)+"-"+String(month)+"-"+String(day);
					if(date1.month + 1 < 10)
					{
						filePath1 = ApplicationData.getInstance().httpAssets + fileParentName+ "/" +fileName;
					} else {
						filePath1 = ApplicationData.getInstance().httpAssets + fileParentName +"/"+fileName;
					}
					saveImage(_bmpd, filePath1, fileParentName, fileName);
					break;
				}
					
				case "chongZuoBtn":
				{
					/*if(_isLock == true)
					{
						_mediaPlayer.chongZuo();
					}*/
					break;
				}
					
				case "cheXiaoBtn":
				{
					/*if(_isLock == true)
					{
						_mediaPlayer.cheXiao();
					}*/
					break;
				}
					
				case "rotationBtn":
				{
					_mediaPlayer.changeRotation();
					/*_mediaPlayer.rotation +=90;
					//					trace(_mediaPlayer.rotation,"_mediaPlayer.rotation");
					if(_mediaPlayer.rotation == 90 )
					{
						_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
						//						trace(_mediaPlayer.width,_mediaPlayer.height);
						_mediaPlayer.scaleX = _mediaPlayer.scaleY = Math.min(1080/1920, 1920/1080);
						_mediaPlayer.x = (1920 + _mediaPlayer.width) * 0.5;
					} else if(_mediaPlayer.rotation == 180) {
						_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
						//						_mediaPlayer.scaleX = _mediaPlayer.scaleY = Math.min(1920/_mediaPlayer.width, 1080/_mediaPlayer.height);
						_mediaPlayer.x = 1920;
						_mediaPlayer.y = 1080;
					} else if(_mediaPlayer.rotation == -90) {
						_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
						_mediaPlayer.scaleX = _mediaPlayer.scaleY = Math.min(1080/1920, 1920/1080);
						_mediaPlayer.x = (1920-_mediaPlayer.width) * 0.5;
					} else if(_mediaPlayer.rotation == 0) {
						_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
						_mediaPlayer.x = 0;
						_mediaPlayer.y = 0;
					}*/
					break;
				}
			}
		}
		
		private function onsaveLocalFileEnd(event:Event):void
		{
			trace("onsaveLocalFileEnd-------");
		}
		
		private function chuShi():void
		{
			_mediaPlayer.lineThickness = 5;
			_mediaPlayer.lineStyle = 1;
			_mediaPlayer.isCir =false;
			_mediaPlayer.isEraser =false;
			_mediaPlayer.lcolor = ConstData.colorArr[1];
			
			if(ApplicationData.getInstance().clientType == ClientType.STUDENT)
			{
				_oppToolBar.voteBtn.visible = false;
				_oppToolBar.votePanel.visible = false;
				_oppToolBar.sendPhone.visible = false;
			}
		}
		
		public function showSaveImage():void
		{
			_oppToolBar.save_btn.visible = true;
		}
		
		/**
		 * 
		 * @param str 媒体路径
		 *  
		 */		
		public function setPath(vo:MediaVO,isBg:Boolean):void
		{
			_mediaVO = vo;
			_mediaVO.formatString(vo.path);
			_mediaPlayer.setMediaVO(vo, 1920, 1080, isBg);
		}
		
		public function setBitmap(bmpd:BitmapData):void
		{
			_isCamera = true;
			_mediaVO = new MediaVO();
			_mediaVO.bmpd = bmpd.clone();
			_mediaVO.isBmpd = true;
			_mediaPlayer.addBitmapData(bmpd);
//			_mediaVO.bmpd.dispose();
		}
		
		private function onComplete(e:Event):void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
//			drawShape();
			//_bmpd = _mediaPlayer.imageBmpd;
		}
		
		public function onClearBtnClick(e:MouseEvent):void
		{
			//_mediaPlayer.clear();
			clearTuYa();
		}
		
		/**
		 *清除涂鸦 
		 * 
		 */		
		public function clearTuYa():void
		{
			_mediaPlayer.clear();
		}
		
		private function onColorBtnClick(e:MouseEvent):void
		{
			if(e.target.name.split("_")[0]!="btn")return;
			var colorID:int = e.target.name.split("_")[1];
			if(_tempColor){
				_tempColor.gotoAndStop(1);
			}
			_tempColor = e.target as MovieClip;
			_tempColor.gotoAndStop(2);
			_mediaPlayer.lcolor = ConstData.colorArr[colorID];
			_lc = ConstData.colorArr[colorID];
			_mediaPlayer.changeStyle(_lc,_ls,_lt,false,false);
		}
		
		public function zanTingMedia():void
		{
			if(_mediaPlayer == null)return;
			_mediaPlayer.zanTingMedia();
		}
		
		private function touchMove():void
		{
			//this.dispatchEvent(new Event(TouchMoveEvent));
			
			/**var rect:Rectangle = this.bg.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<960&&rect.right>980){
				if(rect.top>1000-rect.height*0.2){
					this.alpha = 0.5;
					return;
				}					
			}
			this.alpha = 1;**/
		}
		
		private function touchEnd():void
		{
			if(_isClosed)return;
			if(!_isHuanDengModel)
			{
				_toolsTimer.reset();
				_toolsTimer.start();
			}
			
			ToolKit.log("所有点弹起了");
			
			//双屏判断边界
			if(!isInertiaEnd)
			{
				ToolKit.log("惯性结束检测边界"+_isClosed);
				judgeBorder();
			}else{
				ToolKit.log("中途抛出舞台了"+_isClosed+"   "+isLr);
				if(_isClosed)return;
				moveEnd(isLr);
			}
			this.dispatchEvent(new Event(TouchEndEvent));
		}
		/**
		 * 判断边界 
		 */		
		private function judgeBorder():void
		{
			this.filters=[];
			var leftBianJie:Number = this.transform.pixelBounds.left;
			var rightBianJie:Number = this.transform.pixelBounds.right;
			var topBianJie:Number = this.transform.pixelBounds.top;
			var bottomBianJie:Number = this.transform.pixelBounds.bottom;

			try
			{
				_hitBoo = HitTest.complexHitTestObject(this, ApplicationData.getInstance().hitSp);
			} 
			catch(error:Error) 
			{
				_hitBoo = true;
				return;
			}
			ToolKit.log("judgeBorder"+_hitBoo);
			if(_hitBoo)return;
			if(ApplicationData.getInstance().clientType == ClientType.TEACHER)
			{
				if(!_hitBoo)
				{
					if(leftBianJie>ConstData.stageWidth-5||rightBianJie<5)
					{//trace("111")
						ToolKit.log("左右");
						//					moveEnd(true);
						//双屏判断边界
						moveEnd(false);
					}else if(topBianJie>ConstData.stageHeight-5||bottomBianJie<5){//trace("22")
						ToolKit.log("上下");
						//					moveEnd(false);
						//双屏判断边界
						moveEnd(true);
					}else{
						ToolKit.log("bu 上下左右");
						//					moveEnd(true);
						//双屏判断边界
						moveEnd(false);
					}
				}else{
					ToolKit.log("发生了碰撞");
				}
			} else {
				if(!_hitBoo)
				{
					if(leftBianJie>ConstData.stageWidth-5)
					{//从屏幕的右边抛出
						moveEnd(false);
					}
					
					if(rightBianJie<5) 
					{//从屏幕的左边抛出
						moveEnd(false);
					}
				}else{
					ToolKit.log("发生了碰撞");
				}
			}
			
		}
		
		private function moveEnd(boo:Boolean=false):void
		{
			ConstData.isVoting = false;
			if(boo)
			{
				ToolKit.log("删除卡片");
				_isClosed = true;
				Tweener.removeTweens(this);
				drawShape();
				/*this.dispatchEvent(new Event(Event.CLOSE));
				NotificationFactory.sendNotification(NotificationIDs.IS_FULL,false);*/
				return;
			}
			
			try
			{
				_hitBoo = HitTest.complexHitTestObject(this, ApplicationData.getInstance().hitSp);
			} 
			catch(error:Error) 
			{
				_hitBoo = true;
				return;
			}
			if(_hitBoo)return;
			
			if(ApplicationData.getInstance().clientType == ClientType.TEACHER)
			{
				if(_isClosed)return;
				_isClosed=true;
				ToolKit.log("TEACHER");
				if(!_mediaVO.isHimi)
				{
					if(_mediaVO.type == MediaType.IMAGE)
					{
						ToolKit.log("TEACHER******************");
						_bmpd = new BitmapData(1920,1080,true,0);
						_bmpd.draw(_mediaPlayer);
						saceLocalImage(_bmpd,ConstData.himiID+".jpg");
						ConstData.himiID ++;
					}else if(_mediaVO.type == MediaType.VIDEO){
						//双屏判断边界
						if(_mediaVO.isServer)
						{
							var name:String = _mediaVO.path.split("/")[_mediaVO.path.split("/").length-1];
							var msg:String = "condragon%AddHimiMediaMSG" + "-" +"&thumb=" + _mediaVO.path +"&isHimi=false"+"&MediaPath="+ApplicationData.getInstance().httpAssets+GetDateName.getDateName()+"/"+name+"&userName="+ApplicationData.getInstance().msgNum+"&end";
							ConstData.socket.sendMsg(msg);
							_isClosed = true;
							this.dispatchEvent(new Event(Event.CLOSE));
							NotificationFactory.sendNotification(NotificationIDs.IS_FULL,false);
						} else {
							copyMedia(_mediaVO.path);
						}
						
					}else{
						ToolKit.log("同步数据格式不对"+_mediaVO.type);
						NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"同步数据格式不对");
						setTimeout(function ():void
						{
							NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
						},500);
						this.dispatchEvent(new Event(Event.CLOSE));
						NotificationFactory.sendNotification(NotificationIDs.IS_FULL,false);
					}
				} else {
					/*var msg1:AddHimiMediaMSG = new AddHimiMediaMSG();
					msg1.isHimi = "true";
					msg1.mediaPath = _mediaVO.himiLink;
					msg1.userName = String(ApplicationData.getInstance().msgNum);*/
					var msg1:String = "condragon%AddHimiMediaMSG" + "-" +"&thumb=" + _mediaVO.path +"&isHimi=true"+"&MediaPath="+_mediaVO.himiLink+"&userName="+ApplicationData.getInstance().msgNum+"&end";
					ConstData.socket.sendMsg(msg1);
				}
				
			}
		}
		
		/**
		 * 
		 * 异步复制视频
		 */		
		private function copyMedia(str:String):void
		{
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"视频太大正在玩命发送中,请稍候....");
			var file:File =new File(str);
			var path0:String=file.nativePath.replace(file.name,"");
			var type:String=file.name.substr(file.name.length-4,4);
			var sourceFile:File =new File(path0);
			var date:Date = new Date();
			_fileName = String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds);
			_flvPath = ConstData.himiID+file.type;
			ConstData.himiID++;
			sourceFile = sourceFile.resolvePath(file.name);
			//执行异步拷贝
			var destination:File = new File(ApplicationData.getInstance().httpAssets+GetDateName.getDateName()+"/"+_flvPath);
			sourceFile.copyToAsync(destination, true);
			//			Tool.log(sourceFile.size+"-"+destination.size);
			//			destination.addEventListener(Event.COMPLETE, fileCopiedHandler);
			sourceFile.addEventListener(Event.COMPLETE, fileCopiedHandler);
			sourceFile.addEventListener(IOErrorEvent.IO_ERROR,onError);
			destination.addEventListener(IOErrorEvent.IO_ERROR,onError);
			
		}
		
		private function saveImage(bmpd:BitmapData,filePath:String,fileParentName:String,fileName:String):void
		{
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(); 
			bmpd.encode(bmpd.rect,jpegEncoder,ba);
			var file:File = new File(filePath); 
			var fs:FileStream = new FileStream();
//			file.addEventListener(Event.COMPLETE,onSaveEnd);
			try{
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(ba);
				fs.close();
			}catch(e:Error){
				trace(e.message);
			}
			var tempPath:String = ApplicationData.getInstance().httpAssets + fileParentName+"/index.xml";
			addXml(tempPath,fileName,fileParentName);
		}
		
		private function addXml(path:String,name:String,parentName:String):void
		{
			var file:File = new File(path);
			var fileName:String = path;
			var imageHttpPath:String = "http://"+ApplicationData.getInstance().httpAddress + "/UPloadfile/" + parentName + "/" + name;
			if(file.exists)
			{ 
				myXML = new XML(getUTFString(fileName));
				var img1:XML =<data/>;
				img1.item.@size = _bmpd.width +"*" + _bmpd.height;
				img1.item.@path = imageHttpPath;
				myXML.appendChild(img1.item);
				saveUTFString(myXML.toString(),fileName);
			}
			else
			{
				var myXML:XML = <data></data>
				var img:XML =<data/>;
				img.item.@size = _bmpd.width +"*" + _bmpd.height;
				img.item.@path = imageHttpPath;
				myXML.appendChild(img.item);
				saveUTFString(myXML.toString(),fileName);
			}
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"文件已发送成功，请查收");
			setTimeout(function ():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			},1000);
		}
		
		/**
		 * 读取xml内容
		 * @param fileName
		 * @return 
		 */		
		private static function getUTFString(fileName:String):String
		{
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			var str:String = fs.readUTFBytes(fs.bytesAvailable);
			fs.close();
			file = null;
			fs = null;
			return str;
		}
		
		/**
		 * xml写入
		 * @param fileName
		 * @return 
		 */	
		/*private function saveUTFString(str:String, fileName:String):void
		{
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
		}*/
		
		private function onError(event:IOErrorEvent):void
		{
//			Tool.log("异步拷贝出错");
		}
		
		private function fileCopiedHandler(event:Event):void
		{
			trace("异步拷贝完成");
			NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING);
			
			var msg:String = "condragon%AddHimiMediaMSG" + "-" +"&thumb=" + _mediaVO.path +"&isHimi=false"+"&MediaPath=http://"+ApplicationData.getInstance().httpAddress+"UPloadfile/"+GetDateName.getDateName()+"/"+_flvPath+"&userName="+ApplicationData.getInstance().msgNum+"&end";
			ConstData.socket.sendMsg(msg);
			_isClosed = true;
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function touchBegin():void
		{
			this.filters=[];
			if(!_isHuanDengModel)
			{
				_toolsTimer.reset();
				_toolsTimer.stop();
				Tweener.removeTweens(_oppToolBar);
				Tweener.addTween(_oppToolBar,{visible:true,alpha:1,time:0.5});
			}
//			NotificationFactory.sendNotification(NotificationIDs.SHOW_TRACE,"点下");
			this.dispatchEvent(new Event(TouchBeginEvent));
		}
		
		public function hideTools():void
		{
			try
			{
				if(_oppToolBar == null)return;
				_oppToolBar.visible = false;
			} 
			catch(error:Error) 
			{
				
			}
			
		}
		
		public function showTools():void
		{
			if(_oppToolBar == null)return;
			_oppToolBar.visible = true;
			_oppToolBar.votePanel.visible = false;
			openDuoDian();
		}
		
		public function fullScreen():void
		{
			closeDuoDian();
		}
		
		public function openLock():void
		{
			_isLock = true;
			_mediaPlayer.addListener();
			_mediaPlayer.showTuYa();
			closeDuoDian();
		}
		
		public function closeLock():void
		{
			if(_oppToolBar == null)return;
			_oppToolBar.lock_btn.gotoAndStop(1);
			_isLock = false;
			//if(!_isFull){
				openDuoDian();
			//}else{
			//	closeDuoDian();
			//}
			_mediaPlayer.hideTuYa();
			_mediaPlayer.removeListener();
		}
		
		private function getIpAddress():String
		{
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;
			var networkInterface:Vector.<NetworkInterface> = networkInfo.findInterfaces();
			if(networkInterface != null)
			{
				//trace("Physical Address: " + networkInterface[0].hardwareAddress);
				//trace("IP Address: " + networkInterface[0].addresses[0].address);f
				for (var i:int = 0; i < networkInterface.length; i++) 
				{
					if(networkInterface[i].displayName =="本地连接")
					{
						var str:String = networkInterface[i].addresses[0].address;
					}
				}
//				interfaceObj.displayName;
			}
			return str;
		}
		
		public function getStageBmpd():BitmapData
		{
			_bmpd = new BitmapData(_oppToolBar.width,_mediaPlayer.playerBg.height,true,0);
			_bmpd.draw(_mediaPlayer);
			return _bmpd;
		}
		
		public function drawShape():void
		{
			_bmpd = new BitmapData(_oppToolBar.width,_mediaPlayer.playerBg.height,true,0);
			_bmpd.draw(_mediaPlayer);
			var ba:ByteArray = new ByteArray();
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(60); 
			_bmpd.encode(_bmpd.rect,jpegEncoder,ba);
//			trace(_bmpd.rect);
//			_bmpd.copyPixelsToByteArray(_bmpd.rect, ba);
			if(_mediaVO.btyeArray)
			{
				_mediaVO.btyeArray.clear();
			}
			_mediaVO.btyeArray = ba;
			_bmpd.dispose();
			_bmpd = null;
			ToolKit.log("drawShape");
			if(_isClosed)
			{
				ToolKit.log("_isClosed+++++");
				if(_oppToolBar == null)return;
				if(_oppToolBar.voteBtn == null)return;
				ToolKit.log("_oppToolBar.voteBtn.currentFrame "+_oppToolBar.voteBtn.currentFrame);
				if(_oppToolBar.voteBtn.currentFrame == 2)
				{
					ToolKit.log("****************************");
					_isVoteOpen = true;
					_isVoted = true;
					TweenLite.to(_oppToolBar.votePanel, 0.5,{y:55});
					_oppToolBar.voteBtn.gotoAndStop(1);
					ConstData.isVoting = false;
					var msg:String = "condragon%VoteMSG-&clientType=client&voteType=2&end";
					ConstData.socket.sendMsg(msg);
//					faQiVote("-1")
					faQiVote("-1")
				}
				
				this.dispatchEvent(new Event(Event.CLOSE));
				NotificationFactory.sendNotification(NotificationIDs.IS_FULL,false);
			}
		}
		
		public function changeEnd():void
		{
			_isSave = false;
		}
		
		public function getBmpd():BitmapData
		{
			if(_bmpd == null)
			{
				_bmpd = new BitmapData(_oppToolBar.width,_mediaPlayer.playerBg.height,true,0);
			}
			
			_bmpd.draw(_mediaPlayer);
			return _bmpd;
		}
		
		public function onSaveBtnClick(e:MouseEvent):void
		{
			//drawShape()
			var date:Date = new Date();
			var name:String = String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds);
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:PNGEncoderOptions = new PNGEncoderOptions(); 
			_bmpd.encode(_bmpd.rect,jpegEncoder,ba);
			var file:FileReference = new FileReference(); 
			file.save(ba,name+".jpg"); 
			file.addEventListener(Event.SELECT,onSaveComplete);
			file.addEventListener(Event.CANCEL,onSaveComplete);
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,true);
		}
		
		private function saceLocalImage(bmpd:BitmapData,path:String):void
		{
			var date:Date = new Date();
			_fileName = ApplicationData.getInstance().appPath+"assets/nsmanage/uploadfiles/"+GetDateName.getDateName()+"/"+path;
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(80); 
			_bmpd.encode(_bmpd.rect,jpegEncoder,ba);
			var file:File = new File(_fileName); 
			var fs:FileStream = new FileStream();
			fs.addEventListener(Event.COMPLETE,onFileComlete);
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			
			_bmpd.dispose();
			_bmpd = null;
			ba.clear();
			var msg:String = "condragon%AddHimiMediaMSG" + "-" +"&thumb=" + _mediaVO.path +"&isHimi=false"+"&MediaPath=http://"+ApplicationData.getInstance().httpAddress+"/upload/"+GetDateName.getDateName()+"/"+path+"&userName="+ApplicationData.getInstance().msgNum+"&end";
			ConstData.socket.sendMsg(msg);
			
			_isClosed = true;
			this.dispatchEvent(new Event(Event.CLOSE));
			NotificationFactory.sendNotification(NotificationIDs.IS_FULL,false);
		}
		
		private function onFileComlete(event:Event):void
		{
			trace("****onFileComlete")
			/*
			ConstData.saveLocalFile.removeEventListener(Event.COMPLETE,onLocalFileComlete);
			//trace(ConstData.saveLocalFile.fileName,"onLocalFileComlete");
			shangChuangImage(new File(ConstData.saveLocalFile.fileName));*/
		}
		
		private function onSaveComplete(e:Event):void
		{
			e.target.removeEventListener(Event.SELECT,onSaveComplete);
			e.target.removeEventListener(Event.CANCEL,onSaveComplete);
//			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,false);
		}
		
		public function closeFullScreen():void
		{
			if(_isLock){
				noRotat = true;
				noScale = true;
				noDrag = true;
//				removeEventListeners();
			}else{
				noRotat = false;
				noScale = false;
				noDrag = false;
				addEventListeners();
				//trace(this.name,"closeFullScreen")
			}
		}
		
		public function openDuoDian():void
		{
			noRotat = false;
			noScale = false;
			noDrag = false;
			timer.start();
			addEventListeners();
//			trace(this.name,"openDuoDian")
		}
		
		public function playVideo():void
		{
			if(_mediaVO.type==".flv"||_mediaVO.type==MediaType.VIDEO)
			{
				_mediaPlayer.resumeVideo();
			}
		}
		
		public function closeDuoDian():void
		{
			noRotat = true;
			noScale = true;
			noDrag = true;
			timer.stop();
//			trace("closeDuoDian")
//			removeEventListener1();
			removeEventListeners();
		}
		
		private function onThisDown(e:MouseEvent):void
		{
//			trace("down",_isLock)
			if(_isFull==true||_isLock==true||isRemoveDown==true)
			{
				if(!_isHuanDengModel)
				{
					_toolsTimer.reset();
					_toolsTimer.stop();
					Tweener.removeTweens(_oppToolBar);
					Tweener.addTween(_oppToolBar,{visible:true,alpha:1,time:0.5});
					stage.addEventListener(MouseEvent.MOUSE_UP,onPadUp);
				}
				return;
			}
			this.parent.setChildIndex(this,this.parent.numChildren-1);
			this.startDrag();
			this.filters=[];
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onPadMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onPadUp);
		}
		
		private function onPadMove(e:MouseEvent):void
		{
			if(this == null)return;
			if(this.bg == null)return;
		//	var pad:OppMedia = e.currentTarget as OppMedia;
			var rect:Rectangle = this.bg.transform.pixelBounds;
			//	trace(rect.left,rect.right,"lf")
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<ConstData.stageWidth*0.5-20&&rect.right>ConstData.stageWidth*0.5+20){
				//	trace(rect.top,rect.bottom)
				if(rect.top>(ConstData.stageHeight-80)-rect.height*0.2){
					this.alpha = 0.5;
					return;
				}					
			}
			this.alpha = 1;
		}
		private function onPadUp(e:MouseEvent):void
		{
//			trace("upup");
			//var pad:OppMedia = e.currentTarget as OppMedia;
			try
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onPadMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP,onPadUp);
			} 
			catch(error:Error) 
			{
				trace("移除报错 585 OppMedia");
			}
			
			stopDrag();
			
			if(_isFull||_isLock||isRemoveDown)
			{
				if(!_isHuanDengModel)
				{
					_toolsTimer.reset();
//					_toolsTimer.start();
				}
			}
			if(this == null)return;
			this.filters=[new DropShadowFilter(0,0,0,1,9,9)];
			var rect:Rectangle = this.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(this.alpha<1){
				Tweener.addTween(this,{x:972,y:1056,scaleX:0.1,scaleY:0.1,alpha:0,time:0.5,onComplete:clearGraph});
			}
			function clearGraph():void
			{
				if(_isClosed)return;
				_isClosed = true;
				Tweener.removeTweens(this);
				drawShape();
				/*this.dispatchEvent(new Event(Event.CLOSE));
				NotificationFactory.sendNotification(NotificationIDs.IS_FULL,false);*/
			}
		}
		
		private function onToolsTimer(e:TimerEvent):void
		{
			if(!_isHuanDengModel)
			{
				_toolsTimer.reset();
				_toolsTimer.stop();
				Tweener.removeTweens(_oppToolBar); 
				Tweener.addTween(_oppToolBar,{visible:false,alpha:0,time:0.5});
			}
		}
		
		public function removeDownEvent():void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onThisDown);
		}
		
		public function addDownEvent():void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN,onThisDown);
		}
		
		public function resetXY():void
		{
//			trace("resetXY");
			if(_mediaPlayer == null)return;
			if(_mediaPlayer.x !=0||_mediaPlayer.y!=0){
				/*this.x+=_mediaPlayer.x;
				this.y+=_mediaPlayer.y;
				_mediaPlayer.x = 0;
				_mediaPlayer.y = 0;*/
				_oppToolBar.x = 0;
				_oppToolBar.y = 1080-55;
				
				if(_mediaPlayer.rotation == 90 )
				{
					_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
					//						trace(_mediaPlayer.width,_mediaPlayer.height);
					_mediaPlayer.scaleX = _mediaPlayer.scaleY = Math.min(1080/1920, 1920/1080);
					_mediaPlayer.x = (1920 + _mediaPlayer.width) * 0.5;
				} else if(_mediaPlayer.rotation == 180) {
					_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
					//						_mediaPlayer.scaleX = _mediaPlayer.scaleY = Math.min(1920/_mediaPlayer.width, 1080/_mediaPlayer.height);
					_mediaPlayer.x = 1920;
					_mediaPlayer.y = 1080;
				} else if(_mediaPlayer.rotation == -90) {
					_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
					_mediaPlayer.scaleX = _mediaPlayer.scaleY = Math.min(1080/1920, 1920/1080);
					_mediaPlayer.x = (1920-_mediaPlayer.width) * 0.5;
				} else if(_mediaPlayer.rotation == 0) {
					_mediaPlayer.scaleX = _mediaPlayer.scaleY = 1;
					_mediaPlayer.x = 0;
					_mediaPlayer.y = 0;
				}
//				_oppToolBar.y = 358-21;
			}
		}
		
		public function chongZhi():void
		{
			if(_mediaPlayer == null)return;
			_mediaPlayer.chongZhi();
		}
		
		public function reset():void
		{
			if(_bg == null)return;
			this.removeChild(_bg);
			this.removeChild(_mediaPlayer);
			this.removeChild(_oppToolBar);
			_oppToolBar.removeEventListener(MouseEvent.CLICK,onToolBarClick);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,onThisDown);
			
			//			_bmpd.dispose();
			_oppToolBar.save_btn.visible = false;
			//			trace("dispose");
			
			if(_mediaVO.btyeArray)
			{
				_mediaVO.btyeArray.clear();
				_mediaVO.btyeArray.length = 0;
				_mediaVO.btyeArray = null;
			}
			_mediaVO.dispose();
			_mediaVO = null;
			
			_mediaPlayer.removeListener();
			_mediaPlayer.dispose();
			
			this.removeEventListeners();
			this.dispose();
			removeDownEvent();
			_mediaPlayer = null;
			_bg = null;
			_oppToolBar = null;
			_tempBrush = null;
			_tempColor = null;
			_tempThincess = null;
			_toolsTimer.stop();
			_toolsTimer.removeEventListener(TimerEvent.TIMER,onToolsTimer);
			_toolsTimer = null;
		}

		public function get mediaVO():MediaVO
		{
			return _mediaVO;
		}

		public function get stageW():Number
		{
			return _stageW;
		}

		public function get isLock():Boolean
		{
			return _isLock;
		}

		public function get isFull():Boolean
		{
			return _isFull;
		}

		public function get bg():Shape
		{
			return _bg;
		}

		public function get bmp():Bitmap
		{
			return _bmp;
		}

		public function get isPlay():Boolean
		{
			return _mediaPlayer.isPlay;
		}

		public function get isHuanDengModel():Boolean
		{
			return _isHuanDengModel;
		}

		public function set isHuanDengModel(value:Boolean):void
		{
			_isHuanDengModel = value;
		}

		public function get isClosed():Boolean
		{
			return _isClosed;
		}

		public function set isClosed(value:Boolean):void
		{
			_isClosed = value;
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