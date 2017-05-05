package com.views.components.method
{
	import com.views.components.Operate;
	
	public class HundredOper extends Operate
	{
		public function HundredOper()
		{
			super();
		}
		
		override public function getResult():Number 
		{
			_result = _numA / 100;
			if(String(_result).length>=16)
			{
				var str:String= String(_result);
				_result=Number(str.substr(0,16));
			}
			return _result;
		}
	}
}