package com.models.vo 
{
	/**
	 * ...
	 * @author shi
	 */
	public class StyleVO 
	{
		/**
		 * 涂鸦线条的粗细
		 */
		public var lineThickness:int=5;
		/**
		 * 涂鸦线条的颜色
		 */
		public var lcolor:uint=0xFFFFFF;
		/**
		 * 是否是擦除
		 */
		public var isEraser:Boolean=false;
		/**
		 * 涂鸦线条的样式
		 */
		public var lineStyle:int=1;
		/**
		 * 是否是圈选删除
		 */
		public var isCir:Boolean =false;
		/**
		 * 
		 * 橡皮擦的粗细
		 */
		public var eraserThickness:int=15;
		public var shapeStyle:int=0;
		public var blackID:int = 0;
		
		public function StyleVO() 
		{
			
		}
		
	}

}