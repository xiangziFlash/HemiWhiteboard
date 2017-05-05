package com.scxlib
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.utils.Timer;
	public class XmlRecord extends EventDispatcher
	{
		static public const PEN_EVENT:String = "pen_event";
		public var _xml:XML;
//		public var _mem_xml:MemoryXML=new MemoryXML(); 
		public var _mem_xml:MemoryXML;
		public var _typeID:int;
		public var _isEraser:Boolean;
		public var nowArr:Array = [];
		public var draw_array:Array = [];
		private var _arr_lengths:Array=[];
		public var movie_position:Number;
		public var _arr:Array = [];
		private var _id:int;
		
		public var _suLvArr:Array=[];
		public function XmlRecord(target:IEventDispatcher=null)
		{
			super(target);
		}
		public function newXML():void
		{
			
			_mem_xml=new MemoryXML();
			_xml = _mem_xml.xml;
			
			
		}
		public function saveXML():void
		{
			_arr[_id] = _xml;
			_arr_lengths[_id]=_mem_xml.length;
		}
		public function odd_movie():void 
		{
			if (movie_position >= _arr_lengths[_id])
			{
				return;
			}
			if(_arr.length<1)return;
			_isEraser=_arr[id].site[movie_position].isEraser;
			_typeID = _arr[id].site[movie_position].typeID;
			nowArr = _arr[id].site[movie_position].coordinate.split(',');
			this.dispatchEvent(new Event(XmlRecord.PEN_EVENT));
			
		}		

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

	}
}