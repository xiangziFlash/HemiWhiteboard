package com.views.components.method
{
	import com.views.components.Operate;
	
	public class JianOper extends Operate
	{
		public function JianOper()
		{
			super();
		}
		
		override public function getResult():Number 
		{
			_result = 0;
			_result = _numA - _numB;
			if(String(_result).length>=12)
			{
				var str:String= String(_result);
				_result=Number(str.substr(0,12));
			}
			return _result;
		}
	}
}