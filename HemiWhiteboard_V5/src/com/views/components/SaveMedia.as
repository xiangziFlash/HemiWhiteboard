package com.views.components
{
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.AutoOppMedia;
	import com.scxlib.ShotScreen;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.setTimeout;
	
	public class SaveMedia extends Sprite
	{
		private var _img_path:String="";	
		private var _img_path1:String="";	
		private var _softwareTuYa:SoftwareTuYa;
		private var _shotScreen:ShotScreen;
		private var _smallPath:String;
		private var _bigPath:String;
		
		public function SaveMedia()
		{
			_softwareTuYa = new SoftwareTuYa();
			_shotScreen = new ShotScreen();
		}
		
		public function startJiePing():void
		{
			_softwareTuYa.setToolsVis(false);
			setTimeout(function ():void
			{
				_shotScreen.shotScreen();
				_shotScreen.addEventListener(ShotScreen.SHOT_COMPLETE,onShotScreenEnd0);
				_softwareTuYa.visible = true;
				_softwareTuYa.reset();
				_softwareTuYa.show();
				_softwareTuYa.addEventListener(Event.CLOSE,onTuYaClose);
				_softwareTuYa.addEventListener(Event.CHANGE,onTuYaChange);
			},20);
		}
		
		private function onShotScreenEnd0(event:Event):void
		{
			NotificationFactory.sendNotification(NotificationIDs.START_SHOTSCREEN,1);
			this.dispatchEvent(new Event(Event.COMPLETE));
			_softwareTuYa.setToolsVis(true);
			_shotScreen.removeEventListener(ShotScreen.SHOT_COMPLETE,onShotScreenEnd0);
			_softwareTuYa.setBG();
		}
		
		private function onTuYaClose(e:Event):void
		{
			_softwareTuYa.removeEventListener(Event.CLOSE,onTuYaClose);
			_softwareTuYa.hide();
			_softwareTuYa.clearAll();
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function onTuYaChange(e:Event):void
		{
			_softwareTuYa.removeEventListener(Event.CHANGE,onTuYaChange);
			_shotScreen.shotScreen();
			_shotScreen.addEventListener(ShotScreen.SHOT_COMPLETE,onShotScreenEnd);
		}
		
		private function onShotScreenEnd(event:Event):void
		{
			_shotScreen.removeEventListener(ShotScreen.SHOT_COMPLETE,onShotScreenEnd);
			_softwareTuYa.clearAll();
		//	trace(ApplicationData.getInstance().appPath+"jiepin.png")
			saveImage(ApplicationData.getInstance().appPath+"jiepin.png",ApplicationData.getInstance().appPath+"jiepin_s.png");
			//saveImage("D:/jiepin/jiepin.png","D:/jiepin/jiepin_s.png");
		}
		
		public function saveImage(str:String="",path:String=""):void
		{
			_smallPath = path;
			_bigPath = str;
			var file:File =new File(str);
			var path0:String=file.nativePath.replace(file.name,"");
			var type:String=file.name.substr(file.name.length-4,4);
			var sourceFile:File =new File(path0);
			var str1:String = String(uint(Math.random()*1000000000000));
			_img_path = "photo/"+str1+".jpg";
			sourceFile = sourceFile.resolvePath(file.name);
			//执行异步拷贝
			var destination:File = new File(ApplicationData.getInstance().assetsPath+_img_path);
			sourceFile.copyToAsync(destination, true);
			sourceFile.addEventListener(Event.COMPLETE, fileCopiedHandler1);
			sourceFile.addEventListener(IOErrorEvent.IO_ERROR,onError);
			
			var file1:File =new File(path);
			var path1:String=file1.nativePath.replace(file1.name,"");
			var type1:String=file1.name.substr(file1.name.length-4,4);
			var sourceFile1:File =new File(path0);
//			_img_path1 = "photo/"+path;
			_img_path1 = "photo/"+str1+"_s.jpg";
			sourceFile1 = sourceFile1.resolvePath(file1.name);
			//执行异步拷贝
			var destination1:File = new File(ApplicationData.getInstance().assetsPath+_img_path1);
			sourceFile1.copyToAsync(destination1, true);
			sourceFile1.addEventListener(Event.COMPLETE, fileCopiedHandler);
			sourceFile1.addEventListener(IOErrorEvent.IO_ERROR,onError);
		}
		
		private function fileCopiedHandler1(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, fileCopiedHandler1);
			delFile(_bigPath);
		}
		
		private function onError(event:IOErrorEvent):void
		{
			trace("IOErrorEvent");
		}
		
		private function fileCopiedHandler(event:Event):void 
		{
			event.target.removeEventListener(Event.COMPLETE, fileCopiedHandler);
//			trace("拷贝完成")
			delFile(_smallPath);
			Tweener.addTween(this,{time:0.1,delay:0.1,onComplete:moveEnd});
			
			function moveEnd():void
			{
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			addXml();
		}
		
		private function addXml():void
		{
//			if(ApplicationData.getInstance().userName==null){
//				return;
//			}
			var file:File = new File(ApplicationData.getInstance().assetsPath+"photo/用户/" +"历史记录.xml");
			var fileName:String = ApplicationData.getInstance().assetsPath+"photo/用户/" +"历史记录.xml";
			
			if(file.exists)
			{ 
				myXML = new XML(getUTFString(fileName));
				var img1:XML =<data></data>;
				img1.img=_img_path;
				img1.img.@thumb = _img_path1;
				img1.img.@type = "openMedia";
				myXML.appendChild(img1.img);
				saveUTFString(myXML.toString(),fileName);
			}
			else
			{
				var myXML:XML = <data></data>
				var img:XML =<data></data>;
				img.img=_img_path;
				img.img.@thumb = _img_path;
				img.img.@type = "openMedia";
				myXML.appendChild(img.img);
				
				saveUTFString(myXML.toString(),fileName);
			}
		}
		
		/**
		 * 读取xml内容
		 * @param fileName
		 * @return 
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
		 * xml写入
		 * @param fileName
		 * @return 
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
			autoOppBitmap();
		}
		
		/**删除文件
		 * path:文件路径
		 * 当软件关闭的时候让视频保存的图片删除  清理硬盘空间
		 */
		private function delFile(str:String):void
		{
			var delDirectory:File =new File(str);
			if(!delDirectory.exists)return;
			delDirectory.deleteDirectory(true);
		}
		
		private function autoOppBitmap():void
		{
			AutoOppMedia.setPath(_img_path);
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function dispose():void
		{
			_softwareTuYa.dispose();
		}
		
		public function hide():void
		{
			_softwareTuYa.hide();
		}
	}
}