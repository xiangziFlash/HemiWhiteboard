package com.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author wang
	 */
	public class ArticleEvent extends Event 
	{
		/**
		 * 文章初始化完成
		 */
		public static const ARTICLE_INIT_COMPLETE:String = "article_init_complete";
		
		/**
		 * 文章向右移动,上一篇文章
		 */
		public static const ARTICLE_RIGHT_MOVE:String = "article_right_move";
		/**
		 * 文章向左移动,下一篇文章
		 */
		public static const ARTICLE_LEFT_MOVE:String = "article_left_move";		
		/**
		 * 文章向上移动
		 */
		public static const ARTICLE_TOP_MOVE:String = "article_top_move";		
		/**
		 * 文章向下移动
		 */
		public static const ARTICLE_BOTTOM_MOVE:String = "article_bottom_move";	
		
		/**
		 * 文章移动动画结束
		 */
		public static const ARTICLE_MOVE_END:String = "article_move_end";
		
		/**
		 * 文章更换结束
		 */
		public static const ARTICLE_UPDATA_END:String = "article_updata_end";
		
		
		public function ArticleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new ArticleEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ArticleEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}