package com.scxlib
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	internal class MemoryXML extends EventDispatcher
	{
		public var xml:XML;
		public var length:uint;
		public var coordinate_array:Array;
		public function MemoryXML(target:IEventDispatcher=null)
		{
			xml=new XML();
			length = 0;
			coordinate_array=new Array;	
			init();
			super(target);
		}
		public function init():void 
		{
			
			xml=<data></data>;
		}
		
		public function addNode(_obj:Object ):void {
			var _node:XML =<site></site>;
			for (var p:String in _obj) 
			{
				_node[p] = _obj[p]; 
			}
			xml.appendChild(_node);
			coordinate_array=_obj.coordinate?_obj.coordinate:[];
			length++;
			
		}
		public function removeNode(_int:int=-1 ):void {
			_int>=0&&_int<length?delete xml.site[_int]:(length>0?delete xml.site[length -1]:null);
			length>0 && length--;
		}
		public function updateNode(_x:Number , _y:Number):void 
		{
			coordinate_array.push(_x, _y);
			xml.site[length-1].coordinate=coordinate_array;
			
		}
	}
}