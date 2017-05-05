package com.lylib.layout
{
	public class Padding
	{
		private var _top:Number;
		private var _bottom:Number;
		private var _left:Number;
		private var _right:Number;
		
		public function Padding(top:Number=15, bottom:Number=15, left:Number=15, right:Number=15)
		{
			_top = top;
			_bottom = bottom;
			_left = left;
			_right = right;
		}

		
		public function get top():Number
		{
			return _top;
		}

		public function set top(value:Number):void
		{
			_top = value;
		}

		public function get bottom():Number
		{
			return _bottom;
		}

		public function set bottom(value:Number):void
		{
			_bottom = value;
		}

		public function get left():Number
		{
			return _left;
		}

		public function set left(value:Number):void
		{
			_left = value;
		}

		public function get right():Number
		{
			return _right;
		}

		public function set right(value:Number):void
		{
			_right = value;
		}


	}
}