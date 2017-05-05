package com.lylib.codec
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	/**
	 * 图像数据解析
	 * @author Administrator	刘渊
	 */	
	public class ImageParser
	{
		private var _fileData:ByteArray;
		private var _width:int;
		private var _height:int;
		private var _byte:int;
		private var _length:int;
		
		public function ImageParser()
		{
			
		}
		
		
		/**
		 * 解析图片。分析fileData的文件结构，获得图片的宽和高。目前只支持JPEG，以后慢慢完善。 
		 * @param fileData
		 * 
		 */		
		public function parse(fileData:ByteArray):void{
			_fileData = fileData;
			_fileData.position = 0;
			if(getFileType(fileData) == "JPG"){
				jpegParse();
			}
		}
		
		
		/**
		 * 解析JPEG格式的图片
		 */		
		public function jpegParse():void{
			try
			{
				_byte = _fileData.readUnsignedShort();
				
				if(_byte == 0xFFC0 || _byte == 0xFFC2){
					//SOF0标记	帧开始
					_fileData.position += 3;
					_height = _fileData.readUnsignedShort();
					_width = _fileData.readUnsignedShort();
					return;
				}else{
					_length = _fileData.readUnsignedShort();
					_fileData.position += _length - 2;
					jpegParse();
				}
			}
			catch(err:Error)
			{
				trace("解析失败");
			}
			
			_fileData.position = 0;
		}
		
		
		/**
		 * 获得图片文件的类型，返回BMP,JPG,PNG,GIF,未知类型返回unknown
		 * @param fileData
		 * @return 
		 */		
		public function getFileType(fileData : ByteArray) : String {
			var b0 : int = fileData.readUnsignedByte();
			var b1 : int = fileData.readUnsignedByte();
			var fileType : String = "unknown";
			if(b0 == 66 && b1 == 77) {
				fileType = "BMP";
			}else if(b0 == 255 && b1 == 216) {
				fileType = "JPG";
			}else if(b0 == 137 && b1 == 80) {
				fileType = "PNG";
			}else if(b0 == 71 && b1 == 73) {
				fileType = "GIF";
			}
			return fileType;
		}
		
		
		/**
		 * 解析后图片的宽 
		 * @return 
		 * 
		 */		
		public function get width():int
		{
			return _width;
		}
		
		/**
		 * 解析后图片的高 
		 * @return 
		 * 
		 */		
		public function get height():int
		{
			return _height;
		}
		
		
	}
}