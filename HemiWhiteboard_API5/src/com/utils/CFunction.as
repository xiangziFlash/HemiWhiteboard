package com.utils
{
	public class CFunction
	{
		public var target:Object;
		public var handler:Function;
		public var params:Array;
		
		public function CFunction(fun:Function,target:Object=null,params:Array=null)
		{
			this.target=target;
			this.handler=fun;
			this.params=params;
		}
		
		public function call(...args):*
		{
			if(handler!=null)
			{
				if((args as Array).length!=0)
					return handler.apply(target,args);
				else
					return handler.apply(target,null);
			}
		}
		
		public function apply(args:Array):*
		{
			return handler.apply(target,args);
		}
		
		public function invoke():*
		{
			return apply(params);
		}
		
		public function clear():void
		{
			this.params=null;
			this.target=null;
			this.handler=null;
		}
	}
}