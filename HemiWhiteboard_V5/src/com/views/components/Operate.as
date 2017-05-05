package com.views.components
{
	public class Operate
	{
		public var _numA:Number;
		public var _numB:Number;
		public var _result:Number;
		
		public function Operate()
		{
			
		}
			
		public function getResult():Number
		{
			return _result;

		}

		public function get numA():Number
		{
			return _numA;
		}

		public function set numA(value:Number):void
		{
			_numA = value;
		}

		public function get numB():Number
		{
			return _numB;
		}

		public function set numB(value:Number):void
		{
			_numB = value;
		}

	}
}