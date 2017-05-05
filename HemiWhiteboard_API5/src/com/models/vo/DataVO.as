package com.models.vo
{
	import flash.display.Bitmap;
	import flash.geom.Point;

	public class DataVO
	{
		/**
		 * 文件类型  jpg,flv,mp3
		 */
		public var type:String="";
		/**
		 * 文件名称
		 */
		public var name:String = "";
		/**
		 * 文件地址
		 */
		public var url:String = "";
		/**
		 *文件图标地址 
		 */
		public var ico:String = "";
		/**
		 *全局坐标 
		 */
		public var globalP:Point;
		/**
		 *bmp 
		 */
		public var bmp:Bitmap;
		
		public var xml:XML;
		public var id:int;
		public function DataVO()
		{
		}
	}
}