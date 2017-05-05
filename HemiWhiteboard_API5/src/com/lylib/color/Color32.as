package com.lylib.color
{
	public class Color32 extends Color24
	{
		
		private var _alpha:uint;
		
		public function Color32()
		{
		}
		
		
		public function setARGB(a:uint, r:uint, g:uint, b:uint):void
		{
			super.setRGB(r,g,b);
			this.alpha = a;
		}
		
		override public function setValue(value:uint):void
		{
			alpha = value >> 24; 
			red = value >> 16 & 0xFF; 
			green = value >> 8 & 0xFF; 
			blue = value & 0xFF; 
		}
		
		
		override public function getValue():uint
		{
			return alpha << 24 | red << 16 | green << 8 | blue;
		}

		public function get alpha():uint
		{
			return _alpha;
		}

		public function set alpha(value:uint):void
		{
			_alpha = value;
		}

	}
}