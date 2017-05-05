package com.views.components.menu
{
	import com.models.vo.MediaVO;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	
	public class SecondButton extends Sprite
	{
		private var _secondBtn:SecondBtnRes;
		private var _vo:MediaVO;
		
		public function SecondButton()
		{
			this.mouseChildren = false;
			_secondBtn = new SecondBtnRes();
			this.addChild(_secondBtn);
			
			_secondBtn.titT.embedFonts = true;
			_secondBtn.titT.defaultTextFormat = new TextFormat("SongTi_font",14,0xC2C2C2);
		}
		
		public function setVO(vo:MediaVO):void
		{
			_vo = vo;
			_secondBtn.titT.text = vo.title;
			if(_secondBtn.titT.width>83)
			{//trace("changeScale")
				_secondBtn.titT.scaleX = _secondBtn.titT.scaleY = Math.min(83/_secondBtn.titT.width);
				_secondBtn.titT.x = (83-_secondBtn.titT.width)*0.5;
				_secondBtn.titT.y = (26-_secondBtn.titT.height)*0.5;
			}
		}
		
		public function get vo():MediaVO
		{
			return _vo;
		}

		public function get secondBtn():SecondBtnRes
		{
			return _secondBtn;
		}

		
	}
}