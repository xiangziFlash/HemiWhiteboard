package com.models.vo
{
	/**
	 * 
	 * @author 祥子
	 * 
	 */	
	public class XiangCeVO
	{
		public var modelID:int=5;
		public var LunBoTime:Number=5;
		public var isTimer:Boolean;//是否开启轮播
		public var isXunHuan:Boolean=true;//是否循环播放
		public var isLock:Boolean=false;//是否锁定涂鸦
		public var isClear:Boolean=false;//是否清除
		public var isVisible:Boolean=true;//相册是否显示
		public var isModel:Boolean;//点击的按钮是不是三个排列模式的其中一种
		public var isHemi:Boolean;//点击的按钮是不是三个排列模式的其中一种
		/**
		 *清除所有媒体 
		 */		
		public var isClearAllMedia:Boolean;
		
		public function XiangCeVO()
		{
			
		}
	}
}