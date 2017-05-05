package com.views.components
{
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class CopyLesson extends Sprite
	{
		private var _urlLdr:URLLoader;
		private var _xml:XML;
		private var _localPath:String;
		private var _userXML:XML;
		private var _userLdr:URLLoader;
		private var _path:String;
		private var _isCunZai:Boolean;
		private var _item1:XML;
		private var _fileName:String;
		private var _leiBie:String;
		private var _len:int;
		private var _ldrID:int;
		
		public function CopyLesson()
		{
			
		}
		
		public function setPath(str:String):void
		{
			_path = str;
			if(_urlLdr==null)
			{
				_urlLdr = new URLLoader();
				_urlLdr.addEventListener(Event.COMPLETE,onLdrEnd);
				_urlLdr.addEventListener(IOErrorEvent.IO_ERROR,onXMLError);
			}
			if(ApplicationData.getInstance().UDiskModel)
			{
				_urlLdr.load(new URLRequest(ApplicationData.getInstance().UDiskPath+str));
			}else{
				_urlLdr.load(new URLRequest(ApplicationData.getInstance().assetsPath+str));
			}			
			
			if(ApplicationData.getInstance().UDiskModel)
			{
				var sourceFile:File=new File(ApplicationData.getInstance().UDiskPath+_path);
				if(!sourceFile.exists)
				{
					NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"课件不存在请检查...");
					Tweener.addTween(this,{time:1,onComplete:changeEnd});
					
					function changeEnd():void
					{
						NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"");
						Tweener.removeTweens(this);
					}
					return;
				}
				var destination:File=new File(ApplicationData.getInstance().assetsPath+_path);
			}else{
				var sourceFile:File=new File(ApplicationData.getInstance().assetsPath+_path);
				if(!sourceFile.exists)
				{
					NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"课件不存在请检查...");
					Tweener.addTween(this,{time:1,onComplete:changeEnd1});
					
					function changeEnd1():void
					{
						NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"");
						Tweener.removeTweens(this);
					}
					return;
				}
//				trace(ApplicationData.getInstance().UDiskPath+_path,"fsafasd");
				var destination:File=new File(ApplicationData.getInstance().UDiskPath+_path);	
			}
			sourceFile.copyToAsync(destination, true);
			sourceFile.addEventListener(Event.COMPLETE, fileMoveCompleteHandler1);
//			addLesson();
			updataUsersXML();
		}
		
		private function onXMLError(e:ErrorEvent):void
		{
			NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"没有检测到课件,请检查课件是否已损坏。");
			Tweener.addTween(this,{time:1,onComplete:changeEnd});
			
			function changeEnd():void
			{
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"");
				Tweener.removeTweens(this);
			}
		}
		
		private function fileMoveCompleteHandler1(event:Event):void
		{
			trace("課件XML 拷貝完成");
		}
		
		private function onLdrEnd(event:Event):void
		{
			_xml = new XML(event.target.data);
			fengXiData();
			/*<others>
			<other title="挂图">
			<resource type="openMedia" path="jiaoan/挂图/2014414221650.jpg" thumb="jiaoan/挂图/thumb/2014414221650.jpg" title="挂图_2014414221650"/>
			<resource type="openMedia" path="jiaoan/挂图/2014414221661.jpg" thumb="jiaoan/挂图/thumb/2014414221661.jpg" title="挂图_2014414221661"/>
			</other>
			<other title="绘本">
			<resource type="openMedia" path="jiaoan/绘本/2014414221660.jpg" thumb="jiaoan/绘本/thumb/2014414221660.jpg" title="绘本_2014414221660"/>
			</other>
			</others>*/
		}
		/**
		 * 
		 * 将课件的所有素材全部拷贝
		 */		
		private function fengXiData():void
		{
			_ldrID = 0;
			_len = _xml.others.other.resource.length();
			for (var i:int = 0; i < _xml.others.other.length(); i++) 
			{
				for (var j:int = 0; j < _xml.others.other[i].resource.length(); j++) 
				{
					copySuCai(_xml.others.other[i].resource[j].@path);
					copySuCai(_xml.others.other[i].resource[j].@thumb);
				}
			}
		}
		
		private function copySuCai(path:String):void
		{
			if(ApplicationData.getInstance().UDiskModel)
			{
				var sourceFile:File=new File(ApplicationData.getInstance().UDiskPath+path);
				var destination:File=new File(ApplicationData.getInstance().assetsPath+path);
			}else{
				var sourceFile:File=new File(ApplicationData.getInstance().assetsPath+path);
				var destination:File=new File(ApplicationData.getInstance().UDiskPath+path);	
			}
			sourceFile.copyToAsync(destination, true);
			sourceFile.addEventListener(Event.COMPLETE, fileMoveCompleteHandler);
		}
		
		private function fileMoveCompleteHandler(event:Event):void
		{
			_ldrID++;
//			trace(_ldrID,_len*2);
			if(_ldrID>_len*2-1)
			{
//				trace("素材拷贝完成");
				NotificationFactory.sendNotification(NotificationIDs.HIDE_LOADING,"素材拷贝完成");
			}
		}
		
		private function addLesson():void
		{
//			trace(ApplicationData.getInstance().userName,"+++++");
//			_userXML = ApplicationData.getInstance().userXML;
			var tempTT:String ="";
			if(ApplicationData.getInstance().UDiskModel)
			{
				tempTT= "U盘录入的课件";
			}else{
				tempTT = "本地录入的课件";
			}
			_isCunZai = false;
			for (var i:int = 0; i < _userXML.type[0].item.length(); i++) 
			{
				if( _userXML.type[0].item[i].@title == tempTT)
				{
					_item1 =  _userXML.type[0].item[i];
					_isCunZai = true;//说明已经拷贝过课件 不需要重新添加 复制的课件 的节点
				}
			}
			if(_isCunZai)
			{
				var list1:XML = <list/>;
				list1.@title = _path.split("/")[1].split(".")[0];
				list1.@type = "second";
				list1.@path = _path;
				_item1.appendChild(list1);
				_userXML.type[0].appendChild(_item1);
			}else{
				var item:XML=<item></item>;
				item.@title = tempTT;
				var list:XML = <list/>;
				list.@title = _path.split("/")[1].split(".")[0];
				list.@type = "second";
				list.@path = _path;
				item.appendChild(list);
				_userXML.type[0].appendChild(item);
			}
			
			if(ApplicationData.getInstance().UDiskModel)
			{
				_fileName = ApplicationData.getInstance().assetsPath+"users/"+"123"+".xml";
				//				_fileName = ApplicationData.getInstance().UDiskPath+"users/"+ApplicationData.getInstance().userName+".xml";
			}else{
				_fileName = ApplicationData.getInstance().UDiskPath+"users/"+"123"+".xml";
				//				_fileName = ApplicationData.getInstance().assetsPath+"users/"+ApplicationData.getInstance().userName+".xml";
			}
			
			var str:String = _userXML.toString();
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			var file:File = new File(_fileName);
			var fs:FileStream = new FileStream();
			fs.openAsync(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
//			updataUsersXML();
		}
		
		private function updataUsersXML():void
		{
			if(ApplicationData.getInstance().UDiskModel)
			{
				_fileName = ApplicationData.getInstance().assetsPath+"users/"+"123"+".xml";
				//				_fileName = ApplicationData.getInstance().UDiskPath+"users/"+ApplicationData.getInstance().userName+".xml";
			}else{
				_fileName = ApplicationData.getInstance().UDiskPath+"users/"+"123"+".xml";
				//				_fileName = ApplicationData.getInstance().assetsPath+"users/"+ApplicationData.getInstance().userName+".xml";
			}
			
			if(_userLdr==null)
			{
				_userLdr = new URLLoader();
				_userLdr.addEventListener(Event.COMPLETE,onUserLdrEnd);
			}
			_userLdr.load(new URLRequest(_fileName));
		}
		
		private function onUserLdrEnd(e:Event):void
		{
			_userXML = new XML(e.target.data);
//			trace("数据已更新");
			addLesson();
		}
	}
}