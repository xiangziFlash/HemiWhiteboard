package com.lylib.color
{
	/**
	 * 24位颜色
	 * @author 刘渊 
	 */	
	public class Color24
	{
		
		private var _red:uint;
		
		private var _green:uint;
		
		private var _blue:uint;
		
		public function Color24()
		{
			
		}

		
		public function setRGB(r:uint, g:uint, b:uint):void
		{
			this.red = r;
			this.green = g;
			this.blue = b;
		}
		
		
		public function setValue(value:uint):void
		{
			this.red = value >> 16;
			this.green = value >> 8 & 0xFF; 
			this.blue = value & 0xFF; 
		}
		
		
		public function getValue():uint
		{
			return red << 16 | green << 8 | blue;
		}
		
		
		
		
		
		public function get red():uint
		{
			return _red;
		}

		public function set red(value:uint):void
		{
			_red = value;
		}

		public function get green():uint
		{
			return _green;
		}

		public function set green(value:uint):void
		{
			_green = value;
		}

		public function get blue():uint
		{
			return _blue;
		}

		public function set blue(value:uint):void
		{
			_blue = value;
		}


	}
}