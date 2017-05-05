package com.views.components
{
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.StorageVolumeChangeEvent;
	import flash.filesystem.File;
	import flash.filesystem.StorageVolume;
	import flash.filesystem.StorageVolumeInfo;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class UDiskModel extends Sprite
	{
		private var _alertPlugin:AlertPlugin;
		private var _uPath:String;
		private var _userPath:String;
		private var _sp:DisplaySprite;
		private var _ldrXML:URLLoader;
		
		public function UDiskModel()
		{
			_sp =  NotificationFactory.getLogic(DisplaySprite.NAME) as DisplaySprite;
			_alertPlugin = new AlertPlugin();
			_sp.addMenuSprite(_alertPlugin);
			_alertPlugin.visible = false;
			openStorage();
		}
		
		/**
		 * 下列代码列出了每个装载的存储卷的根目录的本机路径：
		 */
		public function openStorage():void
		{
			var volumes:Vector.<StorageVolume> = new Vector.<StorageVolume>;
			volumes = StorageVolumeInfo.storageVolumeInfo.getStorageVolumes();
			
			for (var i:int = 0; i < volumes.length; i++)
			{
				try
				{
					for(var j:int = 0;j<volumes[i].rootDirectory.getDirectoryListing().length;j++)
					{
						//					trace(volumes[i].rootDirectory.getDirectoryListing()[j].name);
						if(volumes[i].rootDirectory.getDirectoryListing()[j].name == "DIGITALBOARD")
						{
							try
							{
								var url:String = volumes[i].rootDirectory.nativePath+"DIGITALBOARD" + "/users/";
								var xmlName:File = new File(volumes[i].rootDirectory.nativePath+"DIGITALBOARD" + "/users");
								//trace(volumes[i].rootDirectory.nativePath+"DIGITALBOARD" + "/jiaoan/user","_userPath");
								if(xmlName.exists)
								{
									_alertPlugin.visible = true;
									if(xmlName.getDirectoryListing().length==0)
									{
										_alertPlugin.setAlert("无法识别此U盘请于供应商联系",CancelHandel,CancelHandel);
										return;
									}else{
										ApplicationData.getInstance().UDiskJieRu = true;
										_uPath = volumes[i].drive+":/"+"DIGITALBOARD/";
										_userPath = url+xmlName.getDirectoryListing()[0].name;
										ApplicationData.getInstance().UDiskPath = _uPath; 
										_alertPlugin.setAlert("发现磁盘("+volumes[i].drive+":)存在DIGITALBOARD目录,是否安全打开",OKHandel,CancelHandel);
									}
								}
							} 
							catch(error:Error) 
							{
								trace("读取U盘报错了")
								_alertPlugin.visible = false;
							}
						}
					}
				} 
				catch(error:Error) 
				{
					
				}
			}
			StorageInfo();
		}
		
		private function StorageInfo():void
		{
			if (StorageVolumeInfo.isSupported)
			{
				//	trace("平台支持 StorageVolumeInfo 类");
				//卷装入;
				StorageVolumeInfo.storageVolumeInfo.addEventListener(StorageVolumeChangeEvent.STORAGE_VOLUME_MOUNT, onVolumeMount);
				
				//存储卷卸载;
				StorageVolumeInfo.storageVolumeInfo.addEventListener(StorageVolumeChangeEvent.STORAGE_VOLUME_UNMOUNT, onVolumeUnmount);
			}
			else
			{
				//trace("平台不支持 StorageVolumeInfo 类");
			}
		}
		
		private function onVolumeMount(e:StorageVolumeChangeEvent):void
		{
			trace("U盘插入");
//			ApplicationData.getInstance().UDiskModel = true;
			if(!e.storageVolume.rootDirectory.exists)return;
			for(var j:int = 0;j< e.storageVolume.rootDirectory.getDirectoryListing().length;j++){
				if(e.storageVolume.rootDirectory.getDirectoryListing()[j].name == "DIGITALBOARD"){
					ApplicationData.getInstance().UDiskJieRu = true;
					try
					{
						var file:File = File(e.storageVolume.rootDirectory.resolvePath(e.storageVolume.rootDirectory.nativePath+"DIGITALBOARD"));//+File.separator
						var url:String = e.storageVolume.rootDirectory.nativePath+"DIGITALBOARD" + "/users/";
						var xmlName:File = new File(e.storageVolume.rootDirectory.nativePath+"DIGITALBOARD" + "/users");
						if(!xmlName.exists)return;
						_uPath = e.storageVolume.drive+":/"+"DIGITALBOARD/";
						_userPath = url+xmlName.getDirectoryListing()[0].name;
						ApplicationData.getInstance().UDiskPath = _uPath; 
						_alertPlugin.visible = true;
						_alertPlugin.setAlert("发现磁盘可移动磁盘("+e.storageVolume.drive+":)存在DIGITALBOARD目录,是否安全打开",OKHandel,CancelHandel);
					} 
					catch(error:Error) 
					{
						trace("插于U盘读取出错了");
						_alertPlugin.visible = false;
					}
					
				}
			}
		}
		
		private function onVolumeUnmount(e:StorageVolumeChangeEvent):void
		{
			trace("U盘移除");
			ApplicationData.getInstance().UDiskModel = false;
			ApplicationData.getInstance().UDiskJieRu = false;
			ApplicationData.getInstance().nowLessonXML=null;
			ApplicationData.getInstance().UDiskXML = null;
			ApplicationData.getInstance().userName = "";
			this.dispatchEvent(new Event(Event.CLOSE));
			_alertPlugin.visible = false;
		}
		
		private function OKHandel():void
		{
			_alertPlugin.visible = false;
			ApplicationData.getInstance().UDiskModel = true;
			ApplicationData.getInstance().UDiskJieRu = true;
			ApplicationData.getInstance().UDiskPath = _uPath;
			ApplicationData.getInstance().localLessonLogin = false;
			
			ldrData();
			//trace(_uPath,"_userPath",_userPath)
		//	var ldr:URLLoader = new URLLoader();
		//	ldr.load(new URLRequest(_uPath+"双脑白板/media.xml"));
		//	ldr.addEventListener(Event.COMPLETE,onShuangNaoEnd);
		}
		
		public function ldrData():void
		{
			if(_ldrXML==null)
			{
				_ldrXML = new URLLoader();
				_ldrXML.addEventListener(Event.COMPLETE,onLdrEd);
			}
//			trace("_userPath",_userPath);
			_ldrXML.load(new URLRequest(_userPath));
		}
		
		private function onLdrEd(e:Event):void
		{//trace("6666666666666666")
			var xml:XML = new XML(e.target.data);
			ApplicationData.getInstance().userXML = xml;
			ApplicationData.getInstance().UDiskXML = xml;
			ApplicationData.getInstance().userName = "123";
//			trace(ApplicationData.getInstance().userXML,"ApplicationData.getInstance().userXML")
			if(ApplicationData.getInstance().UDiskModel)
			{
				ApplicationData.getInstance().userName = xml.username;
				var tempColor:int = xml.pianHao.color;
				var tempBg:int = xml.pianHao.backGround;
				var tempThickness:int = xml.pianHao.thickness;
				var tempLineStyle:int = xml.pianHao.lineStyle;
				ApplicationData.getInstance().styleVO.lcolor = tempColor;
				ApplicationData.getInstance().styleVO.blackID = tempBg;
				ApplicationData.getInstance().blackID = tempBg;
				ApplicationData.getInstance().styleVO.lineThickness = tempThickness;
				ApplicationData.getInstance().styleVO.lineStyle = tempLineStyle;
				NotificationFactory.sendNotification(NotificationIDs.PIANHAO_SETTING,ApplicationData.getInstance().styleVO);
			}
			if(ApplicationData.getInstance().UDiskModel){
				NotificationFactory.sendNotification(NotificationIDs.UDISK_FILE);
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function onShuangNaoEnd(e:Event):void
		{
			var xml:XML = new XML(e.target.data);
			ApplicationData.getInstance().shuangNaoXML = xml;
			ldrData();
		}
		
		private function CancelHandel():void
		{
			//trace("wwwwwwwwwwwwwwww")
			_alertPlugin.visible = false;
			ApplicationData.getInstance().UDiskModel = false;
			ApplicationData.getInstance().UDiskXML = null;
			if(ApplicationData.getInstance().UDiskJieRu==false)return;
			ApplicationData.getInstance().UDiskJieRu = true;
//			ldrData();
		}
	}
}