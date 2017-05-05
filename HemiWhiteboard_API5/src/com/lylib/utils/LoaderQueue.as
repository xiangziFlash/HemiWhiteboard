package com.lylib.utils
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
		
	public class LoaderQueue
	{
		static public const ERROR_MAX:int = 5;
		private var errorCount:int;
		
		private var ldr:Loader;
		private var handlerList:Array;
		private var ioErrHandlerList:Array;
		private var pathList:Array;
		
		private var isLoading:Boolean;
		private var _isComplete:Boolean;
		
		public function LoaderQueue()
		{
			handlerList = [];
			ioErrHandlerList = [];
			pathList = [];
			
			ldr = new Loader();
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		static private var _instance:LoaderQueue;

		public function get isComplete():Boolean
		{
			return _isComplete;
		}

		static public function getInstance():LoaderQueue
		{
			if(_instance==null)
				_instance = new LoaderQueue();
			return _instance;
		}
		
		
		
		public function addRes(path:String, handler:Function, ioErrHandler:Function=null):void
		{
			handlerList.push(handler);
			ioErrHandlerList.push(ioErrHandler);
			pathList.push(path);
			
			
			if(isLoading==false)
				loadNext();
		}
		
		
		
		private function loadNext():void
		{
			isLoading = true;
			
			CONFIG::DEBUG{
				trace("[LoaderQueue] 加载资源: "+pathList[0]);
			}
			ldr.load( new URLRequest(pathList[0]) );
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			CONFIG::DEBUG{
				trace("[LoaderQueue] IOError: "+pathList[0]);
			}
			errorCount++;
			if(errorCount>ERROR_MAX)
			{
				if(ioErrHandlerList[0]!=null)
					ioErrHandlerList[0](pathList[0]);
				removeOneComplete();
			}
			else
			{
				loadNext();
			}
		}	
		
		private function onComplete(event:Event):void
		{
			errorCount = 0;
			var fun:Function = handlerList[0];
			if(fun!=null)
				fun(ldr.content);
			
			removeOneComplete();
		}
		
		private function removeOneComplete():void
		{
			handlerList[0]=null;
			pathList[0]=null;
			ioErrHandlerList[0]=null;
			
			handlerList.shift();
			pathList.shift();
			ioErrHandlerList.shift();
			
			if(handlerList.length==0 && pathList.length==0)
			{
				_isComplete = true;
				isLoading = false;
			}
			else
			{
				loadNext();
			}
		}
	}
}