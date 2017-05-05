package com.views.components.user
{
	import com.models.vo.UserVO;
	
	import flash.display.Sprite;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-13 下午3:05:23
	 * 
	 */
	public class UserList extends Sprite
	{
		private var _spCon:Sprite;
		private var _userVO:UserVO;
		
		public function UserList()
		{
			initViews();
		}
		
		private function initViews():void
		{
			_spCon = new Sprite();
			this.addChild(_spCon);
		}
		
		public function addUser(vo:UserVO):void
		{
			_userVO = vo;
			var user:PhoneUser = new PhoneUser(vo);
			user.name = vo.userName;
			_spCon.addChild(user);
		}
		
		public function updataMediaNum(name:String):void
		{
			
		}
	}
}