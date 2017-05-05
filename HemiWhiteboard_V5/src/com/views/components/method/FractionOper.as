package com.views.components.method
{
	import com.views.components.Operate;

	public class FractionOper extends Operate 
	{
		public function FractionOper()
		{
			super();
		}
		
		override public function getResult():Number 
		{
			_result = 1 / _numA;
			if(String(_result).length>=12)
			{
				var str:String= String(_result);
				_result=Number(str.substr(0,12));
			}
			return _result;
		}
	}
}