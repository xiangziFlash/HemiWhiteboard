package com.views.components.menu
{
	import com.models.vo.MediaVO;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class OneButton extends Sprite
	{
		private var _oneBtnRes:ZhuTiBtnRes;
		private var _vo:MediaVO;
		
		public function OneButton()
		{
			this.mouseChildren = false;
			_oneBtnRes = new ZhuTiBtnRes();
			this.addChild(_oneBtnRes);
			
			_oneBtnRes.titT.embedFonts = true;
			_oneBtnRes.titT.defaultTextFormat = new TextFormat("SongTi_font",15,0xC2C2C2);
			_oneBtnRes.titT.autoSize ="left";
		}
		
		public function setVO(vo:MediaVO):void
		{
			_vo = vo;
			_oneBtnRes.titT.text = vo.title;
			if(_oneBtnRes.titT.width>83)
			{//trace("changeScale")
				_oneBtnRes.titT.scaleX = _oneBtnRes.titT.scaleY = Math.min(83/_oneBtnRes.titT.width);
				_oneBtnRes.titT.x = 18;
				_oneBtnRes.titT.y = (21-_oneBtnRes.titT.height)*0.5;
			}
		}

		public function get vo():MediaVO
		{
			return _vo;
		}

		public function get oneBtnRes():ZhuTiBtnRes
		{
			return _oneBtnRes;
		}


	}
}