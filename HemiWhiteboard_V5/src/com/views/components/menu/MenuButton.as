package com.views.components.menu
{
	import com.models.vo.MediaVO;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * 
	 * @author 祥子
	 * 白板菜单按钮
	 */
	public class MenuButton extends Sprite
	{
		private var _btnRes:MenuBtnRes;
		private var _ldr:Loader;
		
		public function MenuButton()
		{
			this.mouseChildren = false;
			_btnRes = new MenuBtnRes();
			this.addChild(_btnRes);
			_btnRes.titT.embedFonts = true;
			_btnRes.titT.defaultTextFormat = new TextFormat("SongTi_font",12,0xC2C2C2);
			_btnRes.titT.autoSize = TextFieldAutoSize.CENTER;
			
			_ldr = new Loader();
			_ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEnd);
		}
		
		public function setVO(vo:MediaVO):void
		{
			_ldr.load(new URLRequest(vo.path));
			_btnRes.titT.text = vo.title;
		}
		
		private function onLdrEnd(e:Event):void
		{
			_ldr.width = 30;
			_ldr.height = 30;
			_ldr.x = 26.6;
			_ldr.y = 17.5;
			this.addChild(_ldr);
		}
	}
}