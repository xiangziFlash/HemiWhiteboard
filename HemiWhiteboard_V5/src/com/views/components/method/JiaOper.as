package com.views.components.method
{
	import com.views.components.Operate;
	
	public class JiaOper extends Operate
	{
		public function JiaOper()
		{
			super();
		}
		
		override public function getResult():Number 
		{
			_result = _numA + _numB;
			if(String(_result).length>=12)
			{
				var str:String= String(_result);
				_result=Number(str.substr(0,12));
			}
			return _result;
		}
	}
}