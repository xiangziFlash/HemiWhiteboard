package com.tweener.transitions
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;

	/**
	 * ...以参照注册点进行改变显示对象的属性
	 * @author  wang
	 */
	public class DynamicRegistrationTweener extends Sprite
	{
		private static var pointA:Point;
		private static var pointB:Point;
		
		public function DynamicRegistrationTweener()
		{
			
		}
		
		/**
		 * @param	disObj		DisplayObject  	要改变的显示对象
		 * @param	regPoint	Point  			显示对象更改属性参照的注册点
		 * @param	propObj		Object  		要改变显示对象的属性集   包含： x,y,alpha,scaleX,scaleY,width,height,动画效果：delay,time,onComplete:function
		 * @return
		 */
		public static function addTween(disObj:DisplayObject,regPoint:Point,propObj:Object):void
		{
			pointA = disObj.parent.globalToLocal(disObj.localToGlobal(regPoint));	
			if(propObj.x==undefined){
				propObj.x=disObj.x;
			}else{
				propObj.x -= regPoint.x;
			}
			
			if(propObj.y==undefined){
				propObj.y=disObj.y;
			}else{
				propObj.y -= regPoint.y;
			}			
			
			propObj.onUpdate=upDate;	
			Tweener.addTween(disObj,propObj);	
			
			function upDate():void
			{
				pointB = disObj.parent.globalToLocal(disObj.localToGlobal(regPoint));
				disObj.x +=  pointA.x - pointB.x;
				disObj.y +=  pointA.y - pointB.y;
			}	
			
		}
	}
}