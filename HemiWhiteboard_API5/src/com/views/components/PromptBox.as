package com.views.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2017-5-4 上午10:34:07
	 * 
	 * 白板提示框
	 */
	public class PromptBox extends Sprite
	{
		private var _res:PromptBoxRes;
		/**
		 * _type == 0  关闭软件，清空历史记录
		 * */
		private var _type:int;
		private var _tits:Array = ["是否将历史记录清空？","登录失败，重新登录？","正在登录，请稍候","被踢下线","认证失败","参数错误","用户没有加入到大屏管理后台","检测异常，需重新登录"]
		public var closeFun:Function;
		
		public function PromptBox()
		{
			init();
		}
		
		private function init():void
		{
			_res = new PromptBoxRes();
			this.addChild(_res);
			
//			_res.tit.embedFonts = true;
//			_res.tit.defaultTextFormat = new TextFormat("YaHei_font",20,0xffffff);
			_res.addEventListener(MouseEvent.CLICK,onResClick);
		}
		
		public function setPromptBox(message:String):void
		{
			_res.tit.text = message;
			_res.yesBtn.visible = false;
			_res.noBtn.visible = false;
		}
		
		/**
		 * @type 提示框类型
		 * */
		public function showPromptBox(type:int):void
		{
			_type = type;
			_res.yesBtn.alpha = 1;
			_res.noBtn.alpha = 1;
			if(_type == 0||_type == 7||_type == 4||_type == 5){
				_res.yesBtn.visible = true;
				_res.noBtn.visible = true;
				
				_res.yesBtn.x = 842;
				_res.yesBtn.y = 559;
				
				_res.noBtn.x = 975;
				_res.noBtn.y = 559;
			} else if(_type == 1){
				_res.yesBtn.visible = true;
				_res.noBtn.visible = true;
				
				_res.yesBtn.x = 842;
				_res.yesBtn.y = 559;
				
				_res.noBtn.x = 975;
				_res.noBtn.y = 559;
			} else if(_type == 2 ){
				_res.yesBtn.visible = false;
				_res.noBtn.visible = false;
			} else if(_type == 3 || _type == 6){
				_res.yesBtn.visible = true;
				_res.noBtn.visible = false;
				
				_res.yesBtn.x = 908;
				_res.yesBtn.y = 559;
			}
			_res.tit.text = _tits[_type];
		}
		
		private function onResClick(e:MouseEvent):void
		{
			var targetName:String = e.target.name;
			
			switch(targetName)
			{
				case "yesBtn":
				case "noBtn":
				{
					e.target.alpha = 0.5;
					if(closeFun){
						closeFun(targetName,_type);
					}
					break;
				}
			}
		}
	}
}