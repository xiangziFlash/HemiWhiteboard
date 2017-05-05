package com.lylib.layout
{
	/**
	 * 分布排列的模式 
	 * @author Administrator	刘渊
	 * 
	 */	
	public class DistributeMode
	{
		
		/**
		 * 左侧分布。以显示对象左边缘为准，在最左边与最右边的显示对象之间平均分布所有显示对象。 
		 */		
		public static const LEFT_EDGE:String = "left_edge";
		
		/**
		 * 右侧分布。以显示对象右边缘为准，在最左边与最右边的显示对象之间平均分布所有显示对象。
		 */		
		public static const RIGHT_EDGE:String = "right_edge";
		
		
		/**
		 * 水平居中分布。 
		 */		
		public static const HORIZONAL_CENTER:String = "horizonal_center";
		
		
		/**
		 * 上边缘分布 
		 */		
		public static const TOP_EDGE:String = "top_edge";
		
		
		/**
		 * 下边缘分布 
		 */		
		public static const BOTTOM_EDGE:String = "bottom_edge";
		
		
		/**
		 * 垂直居中分布 
		 */		
		public static const VERTICAL_CENTER:String = "vertical_center";
		
		public function DistributeMode()
		{
		}
	}
}