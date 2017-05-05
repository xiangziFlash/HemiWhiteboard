package com.views.components
{
	import flash.display.Sprite;
	
	public class MinuteFormat extends Sprite
	{
		public function MinuteFormat()
		{
			super();
			initContent();
		}
		private function initContent():void
		{
			for(var i:int=0;i<60;i++)
			{
				var text:textFieldRes=new textFieldRes();
				text.num.mouseEnabled=false;
				text.name="num_"+i;
				text.num.text=String(i);
				text.num.text=int(text.num.text)>=10?text.num.text:"0"+text.num.text;
				text.y=65*i;
				this.addChild(text);
			}
		}
	}
}