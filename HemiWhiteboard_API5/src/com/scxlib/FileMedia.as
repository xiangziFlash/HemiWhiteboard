package com.scxlib
{
	import com.models.vo.MediaVO;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.MediaType;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-12-28 下午2:32:33
	 * 
	 */
	public class FileMedia extends Sprite
	{
		private var _ldr:Loader;
		private var _mediaVO:MediaVO;
		private var _w:Number=0;
		private var _h:Number=0;
		
		public function FileMedia(vo:MediaVO,w:Number,h:Number)
		{
//			trace("FileMedia")
			_mediaVO = vo;
			_w = w;
			_h = h;
			
			_ldr = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEnd);
			_ldr.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLdrIO_ERROR);

			switch(_mediaVO.type)
			{
				case MediaVO.IMAGE:
				case MediaVO.SWF:
				{
					_ldr.load(new URLRequest(vo.path));
					break;
				}
				case MediaVO.EXCEL:
				{
					_ldr.load(new URLRequest("assets/fileIcons/excel.png"));
					break;
				}
				case MediaVO.MP3:
				{
					_ldr.load(new URLRequest("assets/fileIcons/mp3.png"));
					break;
				}
				case MediaVO.PPT:
				{
					_ldr.load(new URLRequest("assets/fileIcons/ppt.png"));
					break;
				}
				case MediaVO.TXT:
				{
					_ldr.load(new URLRequest("assets/fileIcons/txt.png"));
					break;
				}
				case MediaVO.VIDEO:
				{
					_ldr.load(new URLRequest("assets/fileIcons/video.png"));
					break;
				}
				case MediaVO.WORD:
				{
					_ldr.load(new URLRequest("assets/fileIcons/word.png"));
					break;
				}
				case MediaVO.QITA:
				{
					_ldr.load(new URLRequest("assets/fileIcons/other.png"));
					break;
				}
			}
		}
		
		private function onLdrIO_ERROR(event:IOErrorEvent):void
		{
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrEnd);
			_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLdrIO_ERROR);
			trace("文件路径出错了")
			//添加默认图标
		}
		
		private function onLdrEnd(event:Event):void
		{
			_ldr.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrEnd);
			_ldr.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLdrIO_ERROR);
			_ldr.width = _w;
			_ldr.height = _h;
			var sp:Sprite = new Sprite();
			sp.addChild(_ldr);
			var bmpd:BitmapData = new BitmapData(_w,_h,true,0);
			bmpd.draw(sp);
			var bmp:Bitmap = new Bitmap(bmpd);
			this.addChild(bmp);
			addTitle();
		}
		
		private function addTitle():void
		{
			var tt:TextField = new TextField();
			tt.embedFonts = true;
			tt.defaultTextFormat = new TextFormat("YaHei_font",14,0xFFFFFF);
			tt.autoSize = "left";
			tt.selectable = false;
			tt.y = _h;
			tt.width = _w;
			tt.wordWrap = true;
			
			if(_mediaVO.title == null)return;
			if(_mediaVO.title.length > 13)
			{
				_mediaVO.title = _mediaVO.title.substr(0, 13);
			} else {
				_mediaVO.title = _mediaVO.title;
			}
			try
			{
				tt.text = _mediaVO.title;
				this.addChild(tt);
			} 
			catch(error:Error) 
			{
				
			}
		}
		
		public function dispose():void
		{
			if(_ldr)
			{
				_ldr.unloadAndStop();
				_ldr = null;
			}
			while(this.numChildren > 0)
			{
				if(this.getChildAt(0) is Bitmap)
				{
					(this.getChildAt(0) as Bitmap).bitmapData.dispose();
					(this.getChildAt(0) as Bitmap).bitmapData = null;
					this.removeChildAt(0);
				} else{
					this.removeChildAt(0);
				}
			}
			_mediaVO.dispose();
			_mediaVO = null;
		}

		public function get mediaVO():MediaVO
		{
			return _mediaVO;
		}

	}
}