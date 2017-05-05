package com.views.components.method
{
	import com.views.components.Operate;
	
	public class SqrtOper extends Operate
	{
		public function SqrtOper()
		{
			super();
		}
		
		override public function getResult():Number 
		{
			_result = Math.sqrt(_numA);
			if(String(_result).length>=16)
			{
				var str:String= String(_result);
				_result=Number(str.substr(0,16));
			}
			return _result;
		}
	}
}