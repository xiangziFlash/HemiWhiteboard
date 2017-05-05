package com.views.components.method
{
	import com.views.components.Operate;
	
	public class ChuOper extends Operate
	{
		public function ChuOper()
		{
			super();
		}
		
		override public function getResult():Number 
		{
			_result = 0;
			if (_numB == 0)
			{
				var txt:Number=Number(_result);
				trace("除数不能为零");
			}
			
			_result = _numA / _numB;

			if(String(_result).length>=12)
			{
				var str:String= String(_result);
				_result=Number(str.substr(0,12));
			}
			return _result;
		}
	}
}