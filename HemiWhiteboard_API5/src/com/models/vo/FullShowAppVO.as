package com.models.vo
{
	public class FullShowAppVO
	{
		/**
		 * 应用的绝对地址
		 * */
		public var appUrl:String="";
		/**
		 * 应用的类别
		 * */
		public var appType:String="";
		/**
		 * exe应用程序传递参数的数组
		 * */
		public var args:Vector.<String> = new Vector.<String>
		/**
		 * exe文件或者air文件
		 * */
		public static const EXE_APP:String="exe_app";
		/**
		 * 能用loader加载的对象
		 * */
		public static const LOADER_APP:String="loader_app";
		/**
		 * 能用html加载的对象
		 * */
		public static const HTML_APP:String="html_app";
		public function FullShowAppVO()
		{
		}
	}
}