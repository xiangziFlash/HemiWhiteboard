package com.lylib.layout
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class HBoxPane extends BasePane
	{
		
		
		public function HBoxPane()
		{
			super();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			super.addChild( child );
			
			if(_content.numChildren == 1)
			{
				child.x = paddingLeft + _tempX - child.getRect(_content).left;
			}
			else
			{
				child.x = _tempX - child.getRect(_content).left;
			}

			_tempX = child.getRect(_content).left + child.getRect(_content).width + horizontalGap;
			
			child.y = paddingTop - child.getRect(_content).top;
			
			draw();
			
			return child;
		}
	}
}