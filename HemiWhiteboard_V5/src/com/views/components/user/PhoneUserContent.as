package com.views.components.user
{
	import com.controls.ToolKit;
	import com.greensock.TweenLite;
	import com.models.ApplicationData;
	import com.models.ConstData;
	import com.models.vo.MediaVO;
	import com.models.vo.UserVO;
	import com.res.PhoneUserConBGRes;
	import com.scxlib.LoaderImage;
	
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flashx.textLayout.elements.Configuration;

	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-13 下午3:04:02
	 * 
	 */
	public class PhoneUserContent extends Sprite
	{
		private var _spCon:Sprite;
		private var _res:PhoneUserConBGRes;
		public var closeFun:Function;
		
		public function PhoneUserContent()
		{
			initViews();
		}
		
		private function initViews():void
		{
			_res = new PhoneUserConBGRes();
			this.addChild(_res);
			
			_spCon = new Sprite();
			_spCon.x = 45;
			_spCon.y = 48;
			this.addChild(_spCon);
			
			_res.closeBtn.addEventListener(MouseEvent.CLICK, onCloseBtnClick);
		}
		
		private function onCloseBtnClick(event:MouseEvent):void
		{
			if(closeFun)
			{
				closeFun();
			}
		}
		
		public function addUser(vo:UserVO):void
		{
			var user:PhoneUser = new PhoneUser();
			user.updataVO(vo);
			user.x = Math.ceil(_spCon.numChildren % 8) * 120;
			user.y = Math.floor(_spCon.numChildren / 8) * 140;
			_spCon.addChild(user);
		}
	}
}