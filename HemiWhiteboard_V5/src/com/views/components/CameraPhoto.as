package com.views.components
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.AutoOppMedia;
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class CameraPhoto extends Sprite
	{
		private var _path:String="";
		private static var _imagePath:String="";
		private var _bmpd:BitmapData;
		public function CameraPhoto()
		{
			
		}
		
		public static function setBitMapData(bmpd:BitmapData,id:int):void
		{
			/*NotificationFactory.sendNotification(NotificationIDs.OPP_CAMERA,bmpd);
			NotificationFactory.sendNotification(NotificationIDs.COMPLETE_MEDIA);
			var date:Date = new Date();
			var name:String = String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds)+"page"+id+".jpg";
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(100); 
			bmpd.encode(bmpd.rect,jpegEncoder,ba);
			
			var file:File = new File(ApplicationData.getInstance().assetsPath+"photo/"+name);
			_imagePath = "photo/"+name;
			var fs:FileStream = new FileStream();
			fs.addEventListener(Event.COMPLETE,onSaveEd);
			try{
				fs.open(file,FileMode.WRITE);
				fs.writeBytes(ba);
				fs.close();
//				AutoOppMedia.setPath("photo/"+name);
				addXml();
			}catch(e:Error){
				trace(e.message);
			}*/
			
			var date:Date = new Date();
			var name:String = String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds)+"page"+id+".jpg";
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(100); 
			bmpd.encode(bmpd.rect,jpegEncoder,ba);
			bmpd.dispose();
			bmpd=null;
//			var file1:File = new File(ApplicationData.getInstance().assetsPath+"photo");
			var file:File = new File(ApplicationData.getInstance().assetsPath+"photo/"+name);
			_imagePath = "photo/"+name;
			var fs:FileStream = new FileStream();
			fs.addEventListener(Event.COMPLETE,onSaveEd);
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
			ToolKit.log("AutoOppMedia");
			AutoOppMedia.setPath("photo/"+name);
			NotificationFactory.sendNotification(NotificationIDs.COMPLETE_MEDIA);
			
			addXml();
		}
		
		private static function onSaveEd(event:Event):void
		{
			trace("图片加载完成");
			addXml();
		}
		
		private static function addXml():void
		{
			var file:File = new File(ApplicationData.getInstance().assetsPath+"photo/用户/" +"历史记录.xml");
			var fileName:String = ApplicationData.getInstance().assetsPath+"photo/用户/" +"历史记录.xml";
			
			if(file.exists)
			{ 
				myXML = new XML(getUTFString(fileName));
				var img1:XML =<data></data>;
				img1.img=_imagePath;
				img1.img.@thumb = _imagePath;
				img1.img.@type = "openMedia";
				myXML.appendChild(img1.img);
				saveUTFString(myXML.toString(),fileName);
			}
			else
			{
				var myXML:XML = <data></data>
				var img:XML =<data></data>;
				img.img=_imagePath;
				img.img.@thumb = _imagePath;
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
		private static function saveUTFString(str:String, fileName:String):void
		{//trace("数据处理完成")
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			
			var file:File = new File(fileName);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
			file = null;
			fs = null;
			//autoOppBitmap();
		}
		
		private function autoOppBitmap():void
		{
			//AutoOppMedia.setPath(_img_path);
		//	this.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}