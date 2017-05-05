package com.views.components
{
	import com.scxlib.LoaderImage;
	import com.tweener.transitions.Tweener;
	
	import flash.display.Sprite;

	/**
	 * 
	 * @author 祥子
	 * 相册
	 */	
	public class Album extends Sprite
	{
		private var _spCon:Sprite;
		private var _arrMC:Array=[];
		private var _pageID:int=0;
		private var _pageNum:int=0;
		private var _bg:AlbumBGRes;
		
		public function Album()
		{
			initContent();
			initListener();
		}
		
		private function initContent():void
		{
			_bg = new AlbumBGRes();
			
			_spCon = new Sprite();
			_spCon.x = 124;
			_spCon.y = -181.45;
			_bg.bian.visible = false;
			_bg.bian.alpha = 0;
			this.addChild(_bg);
			this.addChild(_spCon);
		}
		/**
		 * 
		 * arr 装载有图片的数组
		 */		
		public function setArr(arr:Array):void
		{
			clearAll(_spCon);
			_arrMC=[];
			_pageNum = int(arr.length/9);
			for (var i:int = _pageID*9; i < (arr.length>(_pageID+1)*9?(_pageID+1)*9:arr.length); i++) 
			{
				var albumMC:LoaderImage = new LoaderImage();
				albumMC.setWH(200,112.45,false);
				albumMC.setPath(arr[i].thumb);
				_arrMC.push(albumMC);
				albumMC.scaleX = albumMC.scaleY = 0;
				albumMC.visible = false;
				_spCon.addChild(albumMC);
			}
			outIn();
		}
		
		private function initListener():void
		{
			
		}
		
		/**
		 *进场 
		 */		
		public function outIn():void
		{
			for (var i:int = _arrMC.length; i>-1; i--) 
			{
				//albumMC.x = int(i%3)*220;
				//albumMC.y = int(i/3)*132;
				//(_arrMC[i] as LoaderImage).y = int(i/3)*132;
				Tweener.addTween(_arrMC[i],{x:int(i%3)*220,y:int(i/3)*135,time:0.5,delay:i*0.2,scaleX:1,scaleY:1,visible:true,transition:"easeInOutCubic"});
			}
			Tweener.addTween(_bg.bian,{time:0.5,alpha:1,delay:_arrMC.length*0.2,visible:true,transition:"easeInOutCubic"});
		}
		
		private function clearAll(sp:Sprite):void
		{
			while(sp.numChildren>0)
			{
				if(sp.getChildAt(0) is LoaderImage){
					(sp.getChildAt(0) as LoaderImage).dispose();
				}
				sp.removeChildAt(0);
			}
		}
	}
}