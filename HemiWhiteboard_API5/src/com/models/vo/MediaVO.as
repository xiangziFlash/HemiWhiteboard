package com.models.vo 
{
	import com.models.ApplicationData;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.ByteArray;

	/**
	 * ...
	 * @author wang
	 */
	public class MediaVO 
	{
		/**
		 * 标题
		 */
		public var title:String = "";	
		/**
		 * 索引
		 */
		public var mediaID:int;
		
		/**
		 * 缩略图路径
		 */
		public var thumb:String = "";
		
		
		/**
		 * 文件路径
		 */
		public var path:String = "";
		
		/**
		 * 作者
		 */
		public var author:String = "";
		
		/**
		 * 简介描述
		 */
		public var description:String = "";
		
		/**
		 * 文件类别，默认为图片文件 IMAGE
		 */
		public var type:String = IMAGE;		
		
		/**
		 * 主路径
		 */
		public var rootPath:String = "";
		
		public var copyPath:String = "";
		
		/**
		 * 视频文件
		 */
		static public const VIDEO:String = "video";
		
		
		/**
		 * 图片文件
		 */
		static public const IMAGE:String = "image";
		
		/**
		 * swf文件
		 */
		static public const SWF:String = "swf";
		
		/**
		 * mp3文件
		 */
		static public const MP3:String = "mp3";
		
		/**
		 * ppt文件
		 */
		static public const PPT:String = "ppt";
		/**
		 * 
		 */		
		static public const WORD:String = "word";
		
		static public const EXCEL:String = "excel";
		static public const TXT:String = "txt";
		static public const QITA:String = "qita";
		
		/**
		 * 专用图片关联声音的路径 
		 **/
		public var soundPathArr:Array=[];
		/**
		 * 专用图片关联声音的名称
		 **/
		public var soundNameArr:Array=[];
		/**
		 * 
		 * 是否自动打开
		 */
		public var isZiDong:Boolean = false;
		/**
		 *卡片弹出的开始位置 
		 */		
		public var globalP:Point;
		
		public var bmp:Bitmap;
		public var bmpd:BitmapData;
		public var isBmpd:Boolean = false;
		public var con:String="";
		public var ipAddress:String="";
		public var btyeArray:ByteArray;
		public var isServer:Boolean;
		public var isFull:Boolean;
		public var globaX:Number;
		public var globaY:Number;
		
		public var isHimi:Boolean = false;
		public var himiLink:String = "";
		
		public function MediaVO() 
		{
			
		}
		
		public function dispose():void
		{
			if(btyeArray)
			{
				btyeArray.clear();
				btyeArray = null;
			}
			
			if(bmpd)
			{
				bmpd.dispose();
				bmpd = null;
			}
			
			if(bmp)
			{
				bmp = null;
			}
			
			soundNameArr=[];
			soundNameArr=[];
		}
		
		/**
		 * 传递一个文件的路径，翻译成MediaVO
		 * @param	path  文件路径  
		 */
		//public function formatXML(xml:XML):void
		public function formatString(str:String):void
		{			
			path = str;
			switch (path.split(".")[path.split(".").length-1]) 
			{
				case "mp4":
				case "MP4":
					type = MediaVO.VIDEO;
				break;
				case "flv":
				case "FLV":
					type = MediaVO.VIDEO;
				break;
				case "swf":
				case "SWF":
					type = MediaVO.SWF
				break;
				
				case "mp3":
				case "MP3":
					type = MediaVO.MP3;
					break;
				
				case "ppt":
				case "PPT":
				case "pps":
				case "PPS":
					type = MediaVO.PPT;
					break;
				default:
					type = MediaVO.IMAGE;
			}
		}
		
		/**
		 * 传递一个标准的信息xml模板，翻译成MediaVO
		 * @param	xml  制定的信息模板xml
		 */
		public function formatXML(xml:XML):void
		{
			/*<item title="媒体一" icon="" bigImg="" path="assets/medias/1.jpg" bigPath="assets/medias/1.jpg">
			<author>媒体作者</author>
			<description><![CDATA[媒体简介]]> </description>
			</item>*/
			
			title = xml.@title;
			if(ApplicationData.getInstance().UDiskModel){
				thumb = ApplicationData.getInstance().UDiskPath+xml.@thumb;
				path = ApplicationData.getInstance().UDiskPath+xml.@path;	
			}else{
				thumb = ApplicationData.getInstance().assetsPath+xml.@thumb;
				path = ApplicationData.getInstance().assetsPath+xml.@path;	
			}
			
			author = xml.author;
//			if(thumb==rootPath){
//				thumb=path;
//			}
//			if(path==rootPath){
//				path=thumb;
//			}
			//trace(path,"++++",path.split(".")[path.split(".").length-1])
			switch (path.split(".")[path.split(".").length-1]) 
			{
				case "mp4":
				case "MP4":
					type = MediaVO.VIDEO;
					break;
				case "flv":
				case "FLV":
					type = MediaVO.VIDEO;
					break;
				case "mp3":
				case "MP3":
					type = MediaVO.MP3;
					break;
				case "swf":
				case "SWF":
					type = MediaVO.SWF;
					break;
				case "ppt":
				case "PPT":
				case "pps":
				case "PPS":
					type = MediaVO.PPT;
					break;
				default:
					type = MediaVO.IMAGE;
			}
		}
	}

}