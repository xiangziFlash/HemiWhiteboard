package com.views.components.user
{
	import com.controls.ToolKit;
	import com.models.ApplicationData;
	import com.models.vo.UserVO;
	import com.res.UserRes;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-13 下午2:22:05
	 * 
	 */
	public class PhoneUser extends Sprite
	{
		private var _thumb:Loader;
		private var _userVO:UserVO;
		private var _res:UserRes;
		
		public function PhoneUser()
		{
			this.mouseChildren = false;
			_userVO = userVO;
			initViews();
		}
		
		private function initViews():void
		{
			_thumb = new Loader();
			_thumb.contentLoaderInfo.addEventListener(Event.COMPLETE,onLdrEnd);
			_thumb.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLdrIoError);
//			_thumb.load(new URLRequest(_userVO.userThumb));
			
			_res = new UserRes();
			_res.tt.embedFonts = true;
			_res.tt.defaultTextFormat = new TextFormat("YaHei_font",18, 0xFFFFFF);
			
			/*_res.numTitle.embedFonts = true;
			_res.numTitle.defaultTextFormat = new TextFormat("YaHei_font",16, 0xFFFFFF);*/
			
			this.addChild(_res);
			
//			_res.tt.text = _userVO.userName;
//			_res.numTitle.text = String(_userVO.userMedias.length);
		}
		
		private function onLdrIoError(event:IOErrorEvent):void
		{
			trace("用户图像加载失败");
		}
		
		public function updataVO(vo:UserVO):void
		{
			_userVO = vo;
			ToolKit.log(_userVO.userThumb+"thumb");
			_thumb.load(new URLRequest("http://"+ApplicationData.getInstance().pptAddress+"/user/user.png"));//http://192.168.7.253/user/user.png&end
//			_thumb.load(new URLRequest(_userVO.userThumb));
			_res.tt.text = _userVO.userName;
//			_res.numTitle.text = String(_userVO.userMedias.length);
		}
		
		public function updataUserNum(userVO:UserVO):void
		{
			_userVO = userVO;
//			_res.numTitle.text = String(_userVO.userMedias.length);
		}
		
		private function onLdrEnd(event:Event):void
		{
			_thumb.width = 80;
			_thumb.height = 80;
			_thumb.x = 0;
			_thumb.y = 0;
			_res.addChildAt(_thumb,0);
		}
		
		public function dispose():void
		{
			this.removeChild(_res);
			if(_thumb)
			{
				_thumb.contentLoaderInfo.removeEventListener(Event.COMPLETE,onLdrEnd);
				_thumb.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onLdrIoError);
				_thumb.unloadAndStop();
				_thumb = null;
			}
			_userVO = null;
		}
		
		public function get userVO():UserVO
		{
			return _userVO;
		}
		
	}
}