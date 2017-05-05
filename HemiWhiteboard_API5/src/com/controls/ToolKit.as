package com.controls
{
	import com.models.ApplicationData;
	import com.plter.air.windows.utils.NativeCommand;
	import com.plter.air.windows.utils.ShowCmdWindow;
	
	import fl.controls.TextArea;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.InterfaceAddress;
	import flash.net.NetworkInfo;
	import flash.net.NetworkInterface;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import mx.core.Application;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-3-17 上午9:59:01
	 * 
	 */
	public class ToolKit extends Sprite
	{
		public static var toolRes:ToolRes = new ToolRes();
		public static var textArea:TextArea;
		public static var sw:Number=0;
		public static var sh:Number=0;
		public static var isHide:Boolean=true;
		public static var stageTT:String;
		private static var isExist:Boolean;
		
		public function ToolKit()
		{
			
		}
		
		private static function onShengChengTxtClick(event:MouseEvent):void
		{
			var jb:ByteArray =new ByteArray();
			jb.writeMultiByte(textArea.text,"utf-8");
			new FileReference().save(jb,"logs.txt");
		}
		
		private static function onclearBtnClick(event:MouseEvent):void
		{
			textArea.text = "";
		}
		
		public static function log(str:String):void
		{
			textArea = toolRes.textArea;
			textArea.width = sw;
			textArea.height = sh;
			var date:Date = new Date();
//			trace("--->>>",str)
			toolRes.clearBtn.x = 0;
			toolRes.shengChengBtn.x = sw-toolRes.shengChengBtn.width;
			toolRes.hideBtn.x = (sw-toolRes.hideBtn.width)*0.5;
			
			//textArea.text += "\n"+getFormatDate()+"--->>>" + str;
//			stageTT += "\n" +getFormatDate()+"-->>"+ str;
			stageTT += "\n" + str;
//			textArea.text += "\n"+getFormatDate()+ str;
			textArea.text += "\n"+ str;
//			var tt_str:String=textArea.text.toString();
//			var tt_str:String="aa\nbb\ncc";
			saveLog(stageTT);
			if(!toolRes.shengChengBtn.hasEventListener(MouseEvent.CLICK))
			{
				toolRes.shengChengBtn.addEventListener(MouseEvent.CLICK,onShengChengTxtClick);
				toolRes.clearBtn.addEventListener(MouseEvent.CLICK,onclearBtnClick);
				toolRes.hideBtn.addEventListener(MouseEvent.CLICK,onHideBtnClick);
			}
		}
		
		/**
		 * 保存文字性文件
		 * @param	str
		 * @param	fileName
		 */
		public static function saveUTFString(str:String, fileName:String):void
		{
			var pattern2:RegExp = /\r\n/g;
			str = str.replace(pattern2, "\n");
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
		
		public static function saveLog(str:String):void
		{
//			trace("--",str)
			var pattern2:RegExp = /\r\n/g;
			str = str.replace(pattern2, "\n");
			var pattern:RegExp = /\n/g;
			str = str.replace(pattern, "\r\n");
			/*var jb:ByteArray =new ByteArray();
			jb.writeMultiByte(str,"utf-8");*/
//			new FileReference().save(jb,"tools.txt");
			var file1:File=File.applicationDirectory;   
			var appPath:String = file1.nativePath+"/";
			var pattern3:RegExp = /\\/g;//正则表达式，将“\”字符换成“/”字符
			appPath = appPath.replace(pattern3, "/");
			var file:File = new File(appPath+"loggers.txt");
			var fs:FileStream = new FileStream();
			fs.addEventListener(Event.COMPLETE,onSaveEd);
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(str);
			fs.close();
//			jb.clear();
		}
		
		private static function onSaveEd(event:Event):void
		{
			
		}
		
		private static function onHideBtnClick(event:MouseEvent):void
		{
			if(!isHide)
			{
				isHide = true;
				toolRes.hideBtn.label = "隐藏";
				showContent();
			}else{
				isHide = false;
				toolRes.hideBtn.label = "显示";
				hideContent();
			}
		}
		
		private  static function hideContent():void
		{
			toolRes.shengChengBtn.visible = false;
			toolRes.clearBtn.visible = false;
			textArea.visible = false;
		}
		
		private  static function showContent():void
		{
			toolRes.shengChengBtn.visible = true;
			toolRes.clearBtn.visible = true;
			textArea.visible = true;
		}
		
		public static function getFormatDate(id:int=0,type:String=""):String
		{
			var date:Date = new Date();
			var formatDate:String = date.fullYear+"年"+date.month +"月"+date.date+"日"+date.hours+"时"+date.minutes+"分"+date.seconds+"秒";
			return formatDate;
		}
		
		
		public static function killProcess(name:String):void
		{
			var args:Vector.<String>=new Vector.<String>;
			var str:String = "taskkill /im "+ name+".exe" +" /f";
			args.push(str);
			try
			{
				var _cmdNa:NativeCommand = new NativeCommand();
				_cmdNa.runCmd(args,ShowCmdWindow.HIDE);
			} 
			catch(error:Error) 
			{
			}
		}
		
		public static function openProcess(path:String):void
		{
			try
			{
				var nc:NativeCommand = new NativeCommand();
				var file:File =new File(path);
				nc.exec(file);
			} 
			catch(error:Error) 
			{
				
			}
			
		}
		
		public static function saveLocalFile(bmpd:BitmapData, imgagPath:String):void
		{
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(100); 
			bmpd.encode(bmpd.rect,jpegEncoder,ba);
			bmpd.dispose();
			bmpd=null;
			var file:File = new File(imgagPath);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeBytes(ba);
			fs.close();
		}
		
		/**
		 * @name 需要获取的进程的名称 
		 * */
		public static function getProcessExist(name:String,callback:Function):void
		{
			isExist = false;
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo(); 
			var file:File = File.applicationDirectory.resolvePath(ApplicationData.getInstance().appPath + "assets/GetProcess.exe"); 
			nativeProcessStartupInfo.executable = file; 
			var processArgs:Vector.<String> = new Vector.<String>(); 
			processArgs.push(name); 
			nativeProcessStartupInfo.arguments = processArgs; 
			var process:NativeProcess = new NativeProcess(); 
			//			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData); 
			process.addEventListener(NativeProcessExitEvent.EXIT,onProcessExit);
			process.start(nativeProcessStartupInfo); 
			
			function onProcessExit(event:NativeProcessExitEvent):void
			{
				if(event.exitCode > 0)
				{
					isExist = true;
				} else {
					isExist = false;
				}
				if(callback!=null) callback(isExist);
			}
		}
		
		public static function getInterfaceData(path:String,callback:Function):void
		{
			var urlLdr:URLLoader = new URLLoader(new URLRequest(path));
			urlLdr.addEventListener(Event.COMPLETE,onUrlLdrEnd);
			urlLdr.addEventListener(IOErrorEvent.IO_ERROR,onUrlLdrIO_ERROR);
			function onUrlLdrEnd(event:Event):void
			{
				var str:String = String(event.target.data);
				if(str == "")return;
				var obj:Object = JSON.parse(str);
				if(callback!=null) callback(obj);
			}
			
			function onUrlLdrIO_ERROR(event:IOErrorEvent):void
			{
				ToolKit.log("接口数据获取失败");
				if(callback!=null) callback(null);
			}
		}
		/*
		 * 清除文本框左右的空格 
		*/
		public static function Trim(ostr:String):String
		{
			var rebegin:RegExp=/^\s*/i;   
			var reend:RegExp=/\s*$/i;     
			return ostr.replace(rebegin,"").replace(reend,"") 
		}
		
		public static function readTxt(path:String,callback:Function):void
		{
			var txtLoad:URLLoader = new URLLoader();
			//txt.txt文本以UTF-8的编码保存。
//			var txtURL:URLRequest = new URLRequest("C:/Windows/TestTxt.dll");
			var txtURL:URLRequest = new URLRequest(path);
			txtLoad.addEventListener(Event.COMPLETE, showContent);
			txtLoad.addEventListener(IOErrorEvent.IO_ERROR, showContentIO_ERROR);
			txtLoad.load(txtURL);
			function showContent(evt:Event):void
			{ 
//				trace(evt.target.data);
				var data:String = evt.target.data;
				if(callback!=null) callback(data);
			}
		}
		
		protected static function showContentIO_ERROR(event:IOErrorEvent):void
		{
			// TODO Auto-generated method stub
			
		}
		
		public static function getMacAddress():String
		{
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;   
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces();   
			var macs:Vector.<String> = new Vector.<String>;
			if( interfaces != null )   
			{   
				for each ( var interfaceObj:NetworkInterface in interfaces )   
				{   
					macs.push(interfaceObj.hardwareAddress);
				}
			}
//			74-D4-35-D5-6D-FE   74:D4:35:D5:6D:FE
			var myPattern:RegExp = /-/g; 
			//RegExp 这家伙你可以把他当作正则的入口,/a/是要替换的字符，g全部有关字符串都将被替换 
			var str:String = macs[0]; 
			var replace:String = str.replace(myPattern,":"); 
			return replace;
		}
		
		public static function getIpAddress():String
		{
			var networkInfo:NetworkInfo = NetworkInfo.networkInfo;   
			var interfaces:Vector.<NetworkInterface> = networkInfo.findInterfaces();   
			var ips:Vector.<String> = new Vector.<String>;
			if( interfaces != null )   
			{   
				for each ( var interfaceObj:NetworkInterface in interfaces )   
				{   
					
					for each ( var address:InterfaceAddress in interfaceObj.addresses )   
					{   
						if(address.ipVersion == "IPv4"){
							if(address.address.indexOf("169.254") == -1){
								ips.push(address.address);
							}
						}
					}   
				}               
			}   
			
			for (var j:int = 0; j < ips.length; j++) 
			{
				if(ips[j].indexOf("192.168.") == 0 || ips[j].indexOf("10.0.") == 0)
				{
					return ips[j];
				}
			}
			
			ips.push("127.0.0.1");
			for (var i:int = 0; i < ips.length; i++) 
			{
				ToolKit.log("ips>>>"+ips[i]);
			}
			return ips[0];
		}
	}
}