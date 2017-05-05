package com.views.components
{
	import flash.display.Sprite;
	
	public class Formats extends Sprite
	{
		public function Formats()
		{
			super();
		}
		
		/**
		 * 时间显示格式，不够十的加0
		 * */
		public function getTimeFormat(str:String):String
		{
			if(int(str)<10)
			{
				return "0"+str;
			}
			return str;
		}
		/**
		 * 星期显示格式，不够十的加0
		 * */
		public function getDayFormat(id:Number):String
		{
			var week:String;
			switch(id)
			{
				case 0:
				{
					week="日"
					break;
				}
				case 1:
				{
					week="一"
					break;
				}
				case 2:
				{
					week="二"
					break;
				}
				case 3:
				{
					week="三"
					break;
				}
				case 4:
				{
					week="四"
					break;
				}
				case 5:
				{
					week="五"
					break;
				}
				case 6:
				{
					week="六"
					break;
				}
					
				default:
				{
					break;
				}
			}
			return week;
		}
		
	}
}