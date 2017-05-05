package com.scxlib
{
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-3-3 下午9:07:29
	 * 根据日期获取文件名称
	 */
	public class GetDateName
	{
		public function GetDateName()
		{
			
		}
		
		public static function getDateName():String
		{
			var date1:Date = new Date();
			var month:String = String(date1.month + 1);
			var day:String = String(date1.date);
			
			if(int(month) < 10)
			{
				month = "0"+month;
			} 
			
			if(int(day) < 10)
			{
				day = "0"+day;
			} 
			return String(date1.fullYear)+"-"+String(month)+"-"+String(day);
		}
		
		public static function getDateHMName():String
		{
			var date1:Date = new Date();
			var hour:String = String(date1.hours);
			var minute:String = String(date1.minutes);
			var month:String = String(date1.month + 1);
			var day:String = String(date1.date);
			
			if(int(month) < 10)
			{
				month = "0"+month;
			} 
			
			if(int(day) < 10)
			{
				day = "0"+day;
			} 
			
			if(int(hour) < 10)
			{
				hour = "0"+hour;
			} 
			
			if(int(minute) < 10)
			{
				minute = "0"+minute;
			} 
			return String(date1.fullYear) + "-" + String(month) + "-" + String(day) + "-" + String(hour) + "-" + String(minute);
		}
	}
}