package com.views.components.board
{
	import com.board.BoardBGRes;
	import com.scxlib.GraffitiLayer;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class QuestionBoard extends Sprite
	{
		private var _tuYa:GraffitiLayer;
		private var _res:BoardBGRes;
		private var _ldr:Loader;
		
		public function QuestionBoard()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_res = new BoardBGRes();
			_tuYa = new GraffitiLayer();
			_tuYa.setSize(1489,838);
			
			_ldr = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEnd);
			
			this.addChild(_res);
			this.addChild(_ldr);
			this.addChild(_tuYa);
			
			_res.cacheAsBitmap = true;
		}
		
		public function addQuestion(path:String):void
		{
			_ldr.load(new URLRequest(path));
		}
		
		private function onLdrEnd(e:Event):void
		{
			//trace("问题加载完成");
		}
		
		public function play():void
		{
			_tuYa.play();
		}
		
		public function stop():void
		{
			_tuYa.stop();
		}
		
		public function onClaerAllBtnClick():void
		{
			_tuYa.onClaerAll_btnClick();
		}
		
		public function onRecordBtnClick():void
		{
			_tuYa.onRecord_btnClick();
		}
		
		public function dispose():void
		{
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrEnd);
			this.removeChild(_res);
			this.removeChild(_ldr);
			this.removeChild(_tuYa);
			_ldr.unloadAndStop();
			_ldr=null;
		}
	}
}