package com.views.components
{
	import com.models.vo.MediaVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	public class HistoryMC extends Sprite
	{
		private var _vo:MediaVO;
		private var _bmp:Bitmap;
		private var _bmp1:Bitmap;
		private var _sp:Sprite;
		private var _ldr:Loader;
		
		public function HistoryMC()
		{
			this.graphics.beginFill(0xFF0000,0);
			this.graphics.drawRect(0,0,52,30);
			this.graphics.endFill();
			this.mouseChildren = false;
			_sp = new Sprite();
//			this.addChild(_sp);
			
			this.filters=[new DropShadowFilter(0,0,0,1,9,9)];
		}
		
		public function addBitMap(vo:MediaVO):void
		{
			_vo = vo;
		/*	_bmp = vo.bmp;
			_bmp.width = 53;
			_bmp.height = 32;
			this.addChild(_bmp);*/
			/*var bmpd:BitmapData = new BitmapData(_sp.width,_sp.height);
			bmpd.draw(_sp);
			_bmp1 = new Bitmap(bmpd);
			this.addChild(_bmp1);
			
			_sp.removeChild(_bmp);
			_bmp.bitmapData.dispose();
			_bmp = null;*/
//			trace("生成所约图");
			if(vo.btyeArray==null)return;
			if(_ldr==null)
			{
				_ldr = new Loader();
				_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrBaEnd);
				_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			}
			_ldr.loadBytes(vo.btyeArray);
			
			/*vo.btyeArray.position = 0;
			var bmpd:BitmapData = new BitmapData(1920,1080,true,0);
			bmpd.setPixels(new Rectangle(0, 0, 1920, 1080), vo.btyeArray);
			var bmp1:Bitmap = new Bitmap(bmpd);
			bmp1.smoothing = true;
			bmp1.scaleX = 53/1920;
			bmp1.scaleY = 30/1080;
//			trace(1920/53, 1080/30);
			//bmp1.width = 53;
		//	bmp1.height = 30;
			this.addChild(bmp1);*/
		}
		
		private function onIOError(event:IOErrorEvent):void
		{
			trace("加载byteArray 报错");
			vo.btyeArray.position = 0;
			var bmpd:BitmapData = new BitmapData(1920,1080,true,0);
			bmpd.setPixels(new Rectangle(0, 0, 1920, 1080), vo.btyeArray);
			var bmp1:Bitmap = new Bitmap(bmpd);
			bmp1.smoothing = true;
			bmp1.width = 53;
			bmp1.height = 30;
			this.addChild(bmp1);
		}
		
		private function onLdrBaEnd(event:Event):void
		{
//			trace("生成所约图完成");
			vo.bmpd = (_ldr.content as Bitmap).bitmapData;
			_ldr.width = 53;
			_ldr.height = 30;
			this.addChild(_ldr);
			/*if(vo.btyeArray)
			{
				vo.btyeArray.clear();
			}
			var ba:ByteArray = new ByteArray(); 
			var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(100); 
			(_ldr.content as Bitmap).bitmapData.encode((_ldr.content as Bitmap).bitmapData.rect,jpegEncoder,ba);
			vo.btyeArray = ba;*/
		}
		
		public function dispose():void
		{
			if(_vo.btyeArray != null)
			{
				_vo.btyeArray.clear();
			}
			
			if(_ldr!=null)
			{
				_ldr.unloadAndStop();
				_ldr = null;
			}
			this.graphics.clear();
			this.filters=[];
			
			_vo.dispose();
			_vo = null;
			_bmp = null;
			_bmp1 = null;
			_sp = null;
		}
		
		public function reset():void
		{
			if(_ldr!=null)
			{
				_ldr.unloadAndStop();
				_ldr = null;
			}
			this.graphics.clear();
			this.filters=[];
			
			_bmp = null;
			_bmp1 = null;
			_sp = null;
		}

		public function get vo():MediaVO
		{
			return _vo;
		}

	}
}