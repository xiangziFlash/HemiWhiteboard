package com.views.components.dengLu
{
	import com.models.ApplicationData;
	import com.models.vo.StyleVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.views.components.CustomBackground;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class PianHaoSetting extends Sprite
	{
		private var _pianHaoSetting:PianHaoSetRes;
		private var _tempBrush:MovieClip;
		private var _tempColor:MovieClip;
		private var _tempBlack:MovieClip;
		private var _colorArr:Array=[0xBF2115,0xEEC848,0x71AD34,0x0396DB,0xFFFFFF];
		private var _brushID:int=0;
		private var _thincessID:int=0;
		private var _colorID:int=0;
		private var _blackID:int=0;
		private var _downX:Number=0;
		private var _pianHaoVO:StyleVO;
		private var _file:File;
		
		public function PianHaoSetting()
		{
			_pianHaoSetting = new PianHaoSetRes();
			this.addChild(_pianHaoSetting);
			
			_pianHaoVO = new StyleVO();
			_pianHaoVO.blackID = 1;
			_pianHaoVO.lcolor  = 4;
			_pianHaoVO.lineStyle = 1;
			_pianHaoVO.lineThickness = 5;
			
			_pianHaoSetting.addEventListener(MouseEvent.CLICK,onClick);
			_pianHaoSetting.thincess.bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarDown);
			chuShi();
		}
		
		private function chuShi():void
		{
			for (var i:int = 1; i < 5; i++) 
			{
				(_pianHaoSetting["brush_"+i] as MovieClip).gotoAndStop(1);
			}
			
			for (var j:int = 0; j < 5; j++) 
			{
				(_pianHaoSetting["color_"+j] as MovieClip).gotoAndStop(1);
			}
			
			for (var k:int = 1; k < 6; k++) 
			{
				(_pianHaoSetting["back_"+k] as MovieClip).gotoAndStop(1);
			}
			_tempBrush = _pianHaoSetting.brush_2;
			_tempBrush.gotoAndStop(2);
			
			_tempColor = _pianHaoSetting.color_4;
			_tempColor.gotoAndStop(2);
			
			_tempBlack = _pianHaoSetting.back_1;
			_tempBlack.gotoAndStop(2);
			_pianHaoSetting.thincess.bar.gotoAndStop(1);
			(_pianHaoSetting.thincess.bar.TT as TextField).embedFonts = true;
			(_pianHaoSetting.thincess.bar.TT as TextField).defaultTextFormat = new TextFormat("YaHei_font",10,0xFFFFFF);
			(_pianHaoSetting.thincess.bar.TT as TextField).text = "5";
//			_pianHaoSetting.thincess.bar.x/132*18+1=5;
			_pianHaoSetting.thincess.bar.x = 4+132/18;
			
			_brushID = 1;
			_colorID = 4;
			_thincessID = 5;
		}
		
		private function onClick(event:MouseEvent):void
		{
			switch(event.target.name)
			{
				case "brush_4":
				case "brush_1":
				case "brush_2":
				case "brush_3":
				{
					if(_tempBrush)
					{
						_tempBrush.gotoAndStop(1);
					}
					_tempBrush = event.target as MovieClip;
					_tempBrush.gotoAndStop(2);
					_brushID = int(event.target.name.split("_")[1]-1);
//					ApplicationData.getInstance().styleVO.lineStyle = _brushID;
					break;
				}
					
				case "color_0":
				case "color_1":
				case "color_2":
				case "color_3":
				case "color_4":
				case "color_5":
				{
					if(_tempColor)
					{
						_tempColor.gotoAndStop(1);
					}
					_tempColor = event.target as MovieClip;
					_tempColor.gotoAndStop(2);
					_colorID = int(event.target.name.split("_")[1]);
//					ApplicationData.getInstance().styleVO.lcolor = _colorArr[_colorID];
					break;
				}
					
				case "back_5":
				case "back_1":
				case "back_2":
				case "back_3":
				case "back_4":
				{
					if(_tempBlack)
					{
						_tempBlack.gotoAndStop(1);
					}
					_tempBlack = event.target as MovieClip;
					_tempBlack.gotoAndStop(2);
					_blackID = int(event.target.name.split("_")[1]);
					ApplicationData.getInstance().blackID = _blackID;
					break;
				}
				case "okBtn":
				{
					this.dispatchEvent(new Event(Event.CLOSE));
					var styleVO:StyleVO = new StyleVO();
					styleVO.lineStyle = _brushID;
					styleVO.lcolor  = _colorID;
					styleVO.lineThickness = _thincessID;
					styleVO.blackID = _blackID;
					ApplicationData.getInstance().blackID = int(_blackID -1);
//					var obj:Object = new Object();
//					obj.brushID = _brushID;
//					obj.colorID = _colorID;
//					obj.blackID = _blackID;
//					obj.thincessID = _thincessID;
//					ApplicationData.getInstance().pianHaoObj = obj;
					ApplicationData.getInstance().pianHaoObj = styleVO;
					NotificationFactory.sendNotification(NotificationIDs.PIANHAO_SETTING,styleVO);
					writeXML();
					break;
				}
				case "cancelBtn":
				{
					this.dispatchEvent(new Event(Event.CLOSE));
					break;
				}
					
				case "customBtn":
				{
					trace("customBtn")
					openLoaclFile();
					break;
				}
			}
		}
		
		private function writeXML():void
		{
//			trace(ApplicationData.getInstance().userXML==null,"++++");
			if(ApplicationData.getInstance().userXML==null)return;//trace("偏好设置写入xml");
			ApplicationData.getInstance().userXML.pianHao.lineStyle = _brushID;
			ApplicationData.getInstance().userXML.pianHao.backGround = _blackID;
			ApplicationData.getInstance().userXML.pianHao.color = _colorID;
			ApplicationData.getInstance().userXML.pianHao.thickness = _thincessID;
			
			if(ApplicationData.getInstance().UDiskModel)
			{
				//trace("u盘")
				saveUTFString(ApplicationData.getInstance().userXML.toString(),ApplicationData.getInstance().UDiskPath+"users/"+ApplicationData.getInstance().userName+".xml");
			}else{//trace("本地")
				saveUTFString(ApplicationData.getInstance().userXML.toString(),ApplicationData.getInstance().assetsPath+"users/"+ApplicationData.getInstance().userName+".xml");
			}
		}
		
		private function openLoaclFile():void
		{
			_file = new File();
			_file.addEventListener(FileListEvent.SELECT_MULTIPLE,onFileSelect);
			_file.browseForOpenMultiple("会议白板背景导入", [new FileFilter("image","*.png"),new FileFilter("image","*.jpg"),new FileFilter("image","*.jpeg")]);
		}
		
		/**
		 * 选择文件完成后 用系统默认程序打开该文件
		 * */
		private function onFileSelect(event:FileListEvent):void
		{
			//trace(_file.nativePath)
			_file.removeEventListener(FileListEvent.SELECT_MULTIPLE,onFileSelect);
			//var openFile:File = File.desktopDirectory.resolvePath(_file.nativePath);
			//trace(File.getRootDirectories());
		//	File.cacheDirectory.resolvePath(
			//CustomBackground.addBackground(new File(_file.nativePath));
			for (var i:int = 0; i < event.files.length; i++) 
			{
				trace(event.files[i].nativePath);
			}
			CustomBackground.addBackground(event.files[0]);
		}
		
		private function onBarDown(e:MouseEvent):void
		{
			_downX = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(event:MouseEvent):void
		{
			_pianHaoSetting.thincess.bar.x +=mouseX-_downX;
			_downX = mouseX;
			if(_pianHaoSetting.thincess.bar.x <0)
			{
				_pianHaoSetting.thincess.bar.x =0;
			}
			
			if(_pianHaoSetting.thincess.bar.x >133)
			{
				_pianHaoSetting.thincess.bar.x = 133;
			}
		}
		private function onUp(event:MouseEvent):void
		{
//			trace(int(_pianHaoSetting.thincess.bar.x/130*18));
			_pianHaoSetting.thincess.bar.TT.text = int(_pianHaoSetting.thincess.bar.x/132*18+1);
			_thincessID = int(_pianHaoSetting.thincess.bar.x/132*18+1);
//			ApplicationData.getInstance().styleVO.lineThickness = _thincessID;
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
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
		}
	}
}