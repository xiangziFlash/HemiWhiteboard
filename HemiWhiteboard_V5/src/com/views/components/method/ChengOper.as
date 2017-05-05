package com.views.components.method
{
	import com.views.components.Operate;
	
	public class ChengOper extends Operate
	{
		public function ChengOper()
		{
			super();
		}
		
		override public function getResult():Number 
		{
			_result = 0;
			_result = _numA * _numB;
			if(String(_result).length>=10)
			{
				var str:String= String(_result);
//				trace(_result,"-------")
				_result=Number(str.substr(0,10));
			}
			return _result;
		}
	}
}