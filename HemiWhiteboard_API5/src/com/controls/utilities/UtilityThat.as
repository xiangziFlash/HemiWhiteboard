package com.controls.utilities 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 
	 */
	public class UtilityThat 
	{
		
		public function UtilityThat() 
		{
			
		}
		
		/**
		 * 清除容器内所有对象
		 * @param	disObjContainerName		容器名称
		 */
		public static function clearAll(disObjContainerName:DisplayObjectContainer):void {
			while (disObjContainerName.numChildren > 0) {
				disObjContainerName.removeChildAt(0);
			}
		}
		
		/**
		 * 设为顶层
		 * @param	container
		 * @param	child
		 */
		public static function setTop(container:DisplayObjectContainer, child:DisplayObject):void {
			container.setChildIndex(child, container.numChildren - 1);
		}
		
		/**
		 * 绘画虚线
		 * @param	p1		起始点
		 * @param	p2  	结束点
		 * @param	size	线条粗细
		 * @param	color	线条颜色
		 * @param	alpha	线条透明度
		 * @param	length	一段的长度
		 * @param	gap		线段的间距
		 */
		public static function DottedLine(p1:Point,p2:Point,thickness:Number=1,color:uint=0x000000, alpha:Number=1,length:Number=5,gap:Number=5):Shape 
		{
			var shape:Shape=new Shape();
			var max:Number = Point.distance(p1,p2);   
			var tempLen:Number = 0;   
			var p3:Point;   
			var p4:Point;   
			shape.graphics.lineStyle(thickness, color, alpha);
			while(tempLen<max)   
			{   
				p3 = Point.interpolate(p2,p1,tempLen/max);   
				tempLen+=length;   
				if (tempLen > max) tempLen = max;  
				p4 = Point.interpolate(p2,p1,tempLen/max);   
				shape.graphics.moveTo(p3.x,p3.y)   
				shape.graphics.lineTo(p4.x,p4.y)   
				tempLen += gap;   
				//trace("aaaa");
			}   
			return shape;
		}
		
		/**
		 * 更换中文逗号
		 */
		public static function replaceCNComma(s:String):String 
		{ 
			var pattern:RegExp = /，/g;
			s = s.replace(pattern, ",");
			return s;
		}
		
		/**
		 * 清除子串左侧空格 
		 */
		public static function LTrim(s:String):String 
		{ 
		  var i:Number = 0; 
		  while(s.charCodeAt(i) == 32 || s.charCodeAt(i) == 13 || s.charCodeAt(i) == 10 || s.charCodeAt(i) == 9) 
		  { 
			i++; 
		  } 
		  return s.substring(i,s.length); 
		} 
		/**
		 * 清除字串右侧空格 
		 */
		public static function RTrim(s:String):String 
		{ 
		  var i : Number = s.length - 1; 
		  while(s.charCodeAt(i) == 32 || s.charCodeAt(i) == 13 || s.charCodeAt(i) == 10 ||s.charCodeAt(i) == 9) 
		  { 
			i--; 
		  } 
		  return s.substring(0,i+1); 
		} 

		/**
		 * 清除字串左右的空格 
		 */
		public static function Trim(s:String):String 
		{ 
		  return LTrim(RTrim(s)); 
		}
	}
	
}