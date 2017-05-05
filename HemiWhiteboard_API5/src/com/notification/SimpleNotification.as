package com.notification
{
	public class SimpleNotification
	{
		private var id:int;
		private var body:Object;
		
		public function SimpleNotification(id:int, body:Object=null)
		{
			this.id = id;
			this.body = body;
		}
		
		public function getId():int
		{
			return this.id;
		}
		
		public function getBody():Object
		{
			return this.body;
		}
	}
}