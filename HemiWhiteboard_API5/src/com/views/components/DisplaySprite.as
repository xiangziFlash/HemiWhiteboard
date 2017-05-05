package com.views.components
{
	import com.notification.ILogic;
	import com.notification.SimpleNotification;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * 
	 * @author 祥子
	 * 这个类专门控制显示列表 
	 */	
	public class DisplaySprite extends Sprite implements ILogic
	{
		static public const NAME:String="DisplaySprite";
		
		private var _topSprite:Sprite;
		private var _midSprite:Sprite;
		private var _bottomSprite:Sprite;
		private var _panelSprite:Sprite;
		private var _mediaSprite:Sprite;
		private var _menuSprite:Sprite;
		private var _hitSprite:Sprite;
		
		public function DisplaySprite()
		{
			_topSprite = new Sprite();
			
			_midSprite = new Sprite();
			
			_bottomSprite = new Sprite();
			
			_panelSprite = new Sprite();
			
			_mediaSprite = new Sprite();
			
			_menuSprite = new Sprite();
			_hitSprite = new Sprite();
			
			this.addChild(_hitSprite);
			this.addChild(_bottomSprite);
			this.addChild(_midSprite);
			this.addChild(_topSprite);
			this.addChild(_mediaSprite);
			this.addChild(_panelSprite);
			this.addChild(_menuSprite);
		}
		
		public function addSprite():void
		{
			
		}
		
		public function addHitSprite(obj:DisplayObject):void
		{
			_hitSprite.addChild(obj);
		}
		
		public function addTopSprite(obj:DisplayObject):void
		{
			_topSprite.addChild(obj);
		}
		
		public function addMidSprite(obj:DisplayObject):void
		{
			_midSprite.addChild(obj);
		}
		
		public function addBottomSprite(obj:DisplayObject):void
		{
			_bottomSprite.addChild(obj);
		}
		
		public function addPanelSprite(obj:DisplayObject):void
		{
			_panelSprite.addChild(obj);
		}
		
		public function addMediaSprite(obj:DisplayObject):void
		{
			_mediaSprite.addChild(obj);
		}
		
		public function addMenuSprite(obj:DisplayObject):void
		{
			_menuSprite.addChild(obj);
		}
		
		public function setPanelVisible(boo:Boolean):void
		{
			_panelSprite.visible = boo;
		}
		
		public function getLogicName():String
		{
			return NAME;
		}
		
		public function handleNotification(notification:SimpleNotification):void
		{
			
		}
		
		public function listNotificationInterests():Array
		{
			return [];
		}
		
		public function onRegister():void
		{
			
		}
		
		public function onRemove():void
		{
			
		}

		public function get topSprite():Sprite
		{
			return _topSprite;
		}

		public function get mediaSprite():Sprite
		{
			return _mediaSprite;
		}

		
	}
}