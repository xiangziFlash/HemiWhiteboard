/**
 * LayoutManager
 * 
 * @author	刘渊
 * @version	1.0.2.2011_01_20_beta
 */
package com.lylib.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * 布局管理类
	 * @author 刘渊
	 */	
	public class LayoutManager
	{
		
		public function LayoutManager()
		{
		}
		
		
		
		/**
		 * 根据参数width和height，改变disObj的大小，使它可以完全包含在矩形内 
		 * @param disObj		要改变大小的显示对象
		 * @param width		
		 * @param height
		 * @param forceEnlarge	强制放大，如果对象不够大，是否强制放大
		 */		
		public static function sizeToFit(disObj:DisplayObject, width:Number=NaN, height:Number=NaN, forceEnlarge:Boolean=true):void{
			var ratio:Number = getFitScale(disObj, width, height);
			if (ratio > 1)
			{
				if (forceEnlarge)
				{
					disObj.scaleX = ratio;
					disObj.scaleY = ratio;
				}
			}else {
				disObj.scaleX = ratio;
				disObj.scaleY = ratio;
			}
		}
		
		/**
		 * 获得合适的比例
		 * @param	disObj
		 * @param	width
		 * @param	height
		 * @return
		 */
		public static function getFitScale(disObj:DisplayObject, width:Number = NaN, height:Number = NaN):Number
		{
			var ratio:Number;
			var r:Rectangle = disObj.getBounds(disObj);
			if( !isNaN(width) && isNaN(height) ){
				ratio = width / r.width;
			}else if( isNaN(width) && !isNaN(height) ){
				ratio = height / r.height;
			}else if(!isNaN(width) && !isNaN(height)){
				ratio = Math.min(width / r.width, height / r.height);
			}else{
				return 1;
			}
			return ratio;
		}
		
		/**
		 * 将container中所有对象按alignMode的对齐方式对齐
		 * @param container
		 * @param alignMode
		 * @param isStageAngle
		 */		
		public static function align(container:DisplayObjectContainer, alignMode:String = "left_align", isStage:Boolean = false):void{
			var arr:Array = [];
			var i:int;
			for( i=0; i<container.numChildren; i++){
				arr.push(container.getChildAt(i));
			}
			
			//对齐
			if(alignMode == AlignMode.LEFT_ALIGN)
			{
				alignLeft( arr, isStage );
			}
			else if(alignMode == AlignMode.RIGHT_ALIGN)
			{
				alignRight( arr, isStage );
			}
			else if(alignMode == AlignMode.HORIZONTAL_ALIGN)
			{
				alignHorizontal( arr, isStage );
			}
			else if(alignMode == AlignMode.TOP_ALIGN)
			{
				alignTop( arr, isStage );
			}
			else if(alignMode == AlignMode.BOTTOM_ALIGN)
			{
				alignBottom( arr, isStage );
			}
			else if(alignMode == AlignMode.VERTICAL_ALIGN)
			{
				alignVertical( arr, isStage );
			}
		}
		
		
		
		/**
		 * 左对齐
		 * @param targets
		 * @param isStage
		 * @return 
		 */		
		public static function alignLeft(targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			var minX:int;
			targets.sort(sortOnLeftEdge);
			
			if(isStage){
				minX = 0;
			}else{
				minX = (targets[0] as DisplayObject).transform.pixelBounds.left;
			}
			
			for(var i:int=1; i<targets.length; i++){
				target = targets[i] as DisplayObject;
				target.x += minX - target.transform.pixelBounds.left;
			}
		}
		
		/**
		 * 右对齐
		 * @param targets
		 * @param isStage
		 * @return  
		 */		
		public static function alignRight(targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			var maxX:int;
			targets.sort(sortOnRightEdge);
			
			if(isStage){
				maxX =(targets[targets.length-1] as DisplayObject).stage.stageWidth;
			}else{
				maxX = (targets[targets.length-1] as DisplayObject).transform.pixelBounds.right;
			}
			
			for(var i:int=0; i<targets.length-1; i++){
				target = targets[i] as DisplayObject;
				target.x += maxX - target.transform.pixelBounds.right;
			}
		}
		
		
		/**
		 * 水平居中
		 * @param targets
		 * @param isStage
		 * @return 
		 * 
		 */		
		public static function alignHorizontal(targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			var centerX:int;
			targets.sort(sortOnVerticalCenter);
			
			if(isStage){
				centerX = (targets[targets.length-1] as DisplayObject).stage.stageWidth / 2;
			}else{
				centerX =( targets[0].transform.pixelBounds.left + targets[targets.length-1].transform.pixelBounds.right ) / 2;
			}
			
			for(var i:int=0; i<targets.length; i++){
				target = targets[i] as DisplayObject;
				target.x += centerX - (target.transform.pixelBounds.x + target.transform.pixelBounds.right)/2;
			}
		}
		
		
		/**
		 * 顶对齐
		 * @param targets
		 * @param isStage
		 * @return 
		 */		
		public static function alignTop(targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			var minY:int;
			targets.sort(sortOnTopEdge);
			
			if(isStage){
				minY = 0;
			}else{
				minY = (targets[0] as DisplayObject).transform.pixelBounds.y;
			}
			
			for(var i:int=1; i<targets.length; i++){
				target = targets[i] as DisplayObject;
				target.y += minY - target.transform.pixelBounds.y;
			}
		}
		
		
		/**
		 * 低对齐
		 * @param targets
		 * @param isStage
		 * @return 
		 */		
		public static function alignBottom(targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			var maxY:int;
			targets.sort(sortOnBottomEdge);
			
			if(isStage){
				maxY = (targets[targets.length-1] as DisplayObject).stage.stageHeight;
			}else{
				maxY = (targets[targets.length-1] as DisplayObject).transform.pixelBounds.bottom;
			}
			
			for(var i:int=0; i<targets.length-1; i++){
				target = targets[i] as DisplayObject;
				target.y += maxY - target.transform.pixelBounds.bottom;
			}
		}
		
		
		/**
		 * 垂直居中对齐
		 * @param targets
		 * @param isStage
		 * @return 
		 */		
		public static function alignVertical(targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			var centerY:int;
			targets.sort(sortOnHorizontalCenter);
			
			if(isStage){
				centerY = (targets[targets.length-1] as DisplayObject).stage.stageHeight / 2;
			}else{
				centerY =( targets[0].transform.pixelBounds.top + targets[targets.length-1].transform.pixelBounds.bottom ) / 2;
			}
			
			for(var i:int=0; i<targets.length; i++){
				target = targets[i] as DisplayObject;
				target.y += centerY - (target.transform.pixelBounds.top + target.transform.pixelBounds.bottom)/2;
			}
		}
		
		
		
		/**
		 * 分布
		 * @param container
		 * @param distributeMode
		 * @param isStage
		 */		
		public static function distribute(container:DisplayObjectContainer, distributeMode:String = "left_edge", isStage:Boolean = false):void{
			var arr:Array = [];
			var i:int;
			for( i=0; i<container.numChildren; i++){
				arr.push(container.getChildAt(i));
			}
			//分布
			if(distributeMode == DistributeMode.LEFT_EDGE){
				distributeLeftEdge(arr, isStage);
			}
			else if(distributeMode == DistributeMode.RIGHT_EDGE){
				distributeRightEdge(arr, isStage);
			}
			else if(distributeMode == DistributeMode.HORIZONAL_CENTER){
				distributeHorizonalConter(arr, isStage);
			}
			else if(distributeMode == DistributeMode.TOP_EDGE){
				distributeTopEdge(arr, isStage);
			}
			else if(distributeMode == DistributeMode.BOTTOM_EDGE){
				distributeBottomEdge(arr, isStage);
			}
			else if(distributeMode == DistributeMode.VERTICAL_CENTER){
				distributeVerticalCenter(arr, isStage);
			}
		}
		
		
		
		/**
		 * 左侧边界平均分布
		 * @param targets
		 * @param isStage
		 */
		public static function distributeLeftEdge( targets:Array, isStage:Boolean = false ):void{
			var target:DisplayObject;
			targets.sort(sortOnLeftEdge);
			if(isStage){
				target = targets[0] as DisplayObject;
				target.x -= target.transform.pixelBounds.x;
				target = targets[targets.length-1] as DisplayObject;
				target.x -= target.transform.pixelBounds.right - target.stage.stageWidth
			}
			//计算间隔
			var xMin:Number = (targets[0] as DisplayObject).transform.pixelBounds.x;
			var xMax:Number = (targets[targets.length-1] as DisplayObject).transform.pixelBounds.x;
			var xGap:Number	= (xMax - xMin) / (targets.length-1);
			// 移动显示对象，进行顶部分布操作。从第2个开始，到第 length - 1 个，第一个和最后一个不用移动。
			for( var i:int = 1; i < targets.length - 1; i++ ){
				target = targets[i] as DisplayObject;
				target.x += (xMin + xGap * i) - target.transform.pixelBounds.x;
			}
		}
		
		
		/**
		 * 右侧边界平均分布 
		 * @param targets
		 * @param isStage
		 */		
		public static function distributeRightEdge( targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			targets.sort(sortOnRightEdge);
			if(isStage){
				target = targets[0] as DisplayObject;
				target.x -= target.transform.pixelBounds.x;
				target = targets[targets.length-1] as DisplayObject;
				target.x -= target.transform.pixelBounds.right - target.stage.stageWidth
			}
			//计算间隔
			var xMin:Number = (targets[0] as DisplayObject).transform.pixelBounds.right;
			var xMax:Number = (targets[targets.length-1] as DisplayObject).transform.pixelBounds.right;
			var xGap:Number	= (xMax - xMin) / (targets.length-1);
			// 移动显示对象，进行顶部分布操作。从第2个开始，到第 length - 1 个，第一个和最后一个不用移动。
			for( var i:int = 1; i < targets.length - 1; i++ ){
				target = targets[i] as DisplayObject;
				target.x += (xMin + xGap * i) - target.transform.pixelBounds.right;
			}
		}
		
		/**
		 * 水平居中分布
		 * @param targets
		 * @param isStage
		 * 
		 */		
		public static function distributeHorizonalConter( targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			targets.sort(sortOnVerticalCenter);
			if(isStage){
				target = targets[0] as DisplayObject;
				target.x -= target.transform.pixelBounds.x;
				target = targets[targets.length-1] as DisplayObject;
				target.x -= target.transform.pixelBounds.right - target.stage.stageWidth
			}
			//计算间隔
			target = targets[0] as DisplayObject;
			var xMin:Number = target.transform.pixelBounds.x
							+ target.transform.pixelBounds.width/2;
			
			target = targets[targets.length-1] as DisplayObject;
			var xMax:Number = target.transform.pixelBounds.x
							+ target.transform.pixelBounds.width/2;
			
			var xGap:Number	= (xMax - xMin) / (targets.length-1);
			
			// 移动显示对象，进行顶部分布操作。从第2个开始，到第 length - 1 个，第一个和最后一个不用移动。
			for( var i:int = 1; i < targets.length - 1; i++ ){
				target = targets[i] as DisplayObject;
				target.x += (xMin + xGap * i) - (target.transform.pixelBounds.x + target.transform.pixelBounds.width/2);
			}
		}
		
		
		/**
		 * 上边界平均分布
		 * @param targets
		 * @param isStage
		 * 
		 */		
		public static function distributeTopEdge( targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			targets.sort(sortOnTopEdge);
			if(isStage){
				target = targets[0] as DisplayObject;
				target.y -= target.transform.pixelBounds.y;
				target = targets[targets.length-1] as DisplayObject;
				target.y -= target.transform.pixelBounds.bottom - target.stage.stageHeight;
			}
			
			//计算间隔
			var yMin:Number = (targets[0] as DisplayObject).transform.pixelBounds.top;
			var yMax:Number = (targets[targets.length-1] as DisplayObject).transform.pixelBounds.top;
			var yGap:Number	= (yMax - yMin) / (targets.length-1);
			
			// 移动显示对象
			for( var i:int = 1; i < targets.length - 1; i++ ){
				target = targets[i] as DisplayObject;
				target.y += (yMin + yGap * i) - target.transform.pixelBounds.top;
			}
		}
		
		
		/**
		 * 下边界平均分布 
		 * @param targets
		 * @param isStage
		 * 
		 */		
		public static function distributeBottomEdge( targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			targets.sort(sortOnBottomEdge);
			if(isStage){
				target = targets[0] as DisplayObject;
				target.y -= target.transform.pixelBounds.y;
				target = targets[targets.length-1] as DisplayObject;
				target.y -= target.transform.pixelBounds.bottom - target.stage.stageHeight;
			}
			
			//计算间隔
			var yMin:Number = (targets[0] as DisplayObject).transform.pixelBounds.bottom;
			var yMax:Number = (targets[targets.length-1] as DisplayObject).transform.pixelBounds.bottom;
			var yGap:Number	= (yMax - yMin) / (targets.length-1);
			
			// 移动显示对象
			for( var i:int = 1; i < targets.length - 1; i++ ){
				target = targets[i] as DisplayObject;
				target.y += (yMin + yGap * i) - target.transform.pixelBounds.bottom;
			}
		}
		
		
		/**
		 * 垂直居中分布 
		 * @param targets
		 * @param isStage
		 * 
		 */		
		public static function distributeVerticalCenter( targets:Array, isStage:Boolean = false):void{
			var target:DisplayObject;
			targets.sort(sortOnVerticalCenter);
			if(isStage){
				target = targets[0] as DisplayObject;
				target.y -= target.transform.pixelBounds.y;
				target = targets[targets.length-1] as DisplayObject;
				target.y -= target.transform.pixelBounds.bottom - target.stage.stageHeight;
			}
			
			//计算间隔
			target = targets[0] as DisplayObject;
			var yMin:Number = (target.transform.pixelBounds.bottom + target.transform.pixelBounds.top)/2;
			target = targets[targets.length-1] as DisplayObject;
			var yMax:Number = (target.transform.pixelBounds.bottom + target.transform.pixelBounds.top)/2;
			var yGap:Number	= (yMax - yMin) / (targets.length-1);
			
			// 移动显示对象
			for( var i:int = 1; i < targets.length - 1; i++ ){
				target = targets[i] as DisplayObject;
				target.y += (yMin + yGap * i) - (target.transform.pixelBounds.y + target.transform.pixelBounds.height/2);
			}
		}
		
		
		
		
		public static function getBounds(target:DisplayObject, parent:DisplayObjectContainer):Rectangle{
			var r:Rectangle = target.getBounds(target);
			
			var lt:Point = new Point(r.left, r.top);
			var rt:Point = new Point(r.right, r.top);
			var lb:Point = new Point(r.left, r.bottom);
			var rb:Point = new Point(r.right, r.bottom);
			
			var new_lt:Point = parent.globalToLocal( target.localToGlobal(lt) );
			var new_rt:Point = parent.globalToLocal( target.localToGlobal(rt) );
			var new_lb:Point = parent.globalToLocal( target.localToGlobal(lb) );
			var new_rb:Point = parent.globalToLocal( target.localToGlobal(rb) );
			
			var arr:Array = new Array(4);
			arr[0]=new_lt;
			arr[1]=new_rt;
			arr[2]=new_lb;
			arr[3]=new_rb;
			
			var min_x:Number;
			var min_y:Number;
			var max_x:Number;
			var max_y:Number;
			
			arr.sort(sortOnPointX);
			min_x = arr[0].x;
			max_x = arr[3].x;
			
			arr.sort(sortOnPointY);
			min_y = arr[0].y;
			max_y = arr[3].y;
			
			var r2:Rectangle = new Rectangle(min_x, min_y, max_x - min_x, max_y - min_y);
			trace(r2);
			
			return null;
		}
		
		
		
		//按左边界升序排序
		private static function sortOnLeftEdge(a:DisplayObject, b:DisplayObject):Number{
			var aValue:Number = a.transform.pixelBounds.x;
			var bValue:Number = b.transform.pixelBounds.x;
			
			if(aValue > bValue){
				return 1;
			}else if(aValue < bValue){
				return -1;
			}else{
				return 0;
			}
		}
		//按右边界升序排序
		private static function sortOnRightEdge(a:DisplayObject, b:DisplayObject):Number{
			var aValue:Number = a.transform.pixelBounds.right;
			var bValue:Number = b.transform.pixelBounds.right;
			
			if(aValue > bValue){
				return 1;
			}else if(aValue < bValue){
				return -1;
			}else{
				return 0;
			}
		}
		//按中垂线升序排序
		private static function sortOnVerticalCenter(a:DisplayObject, b:DisplayObject):Number{
			var aValue:Number = a.transform.pixelBounds.x + a.transform.pixelBounds.width/2;
			var bValue:Number = b.transform.pixelBounds.x + a.transform.pixelBounds.width/2;
			
			if(aValue > bValue){
				return 1;
			}else if(aValue < bValue){
				return -1;
			}else{
				return 0;
			}
		}
		//按顶边界升序排序
		private static function sortOnTopEdge(a:DisplayObject, b:DisplayObject):Number{
			var aValue:Number = a.transform.pixelBounds.top;
			var bValue:Number = b.transform.pixelBounds.top;
			
			if(aValue > bValue){
				return 1;
			}else if(aValue < bValue){
				return -1;
			}else{
				return 0;
			}
		}
		//按下边界升序排序
		private static function sortOnBottomEdge(a:DisplayObject, b:DisplayObject):Number{
			var aValue:Number = a.transform.pixelBounds.bottom;
			var bValue:Number = b.transform.pixelBounds.bottom;
			
			if(aValue > bValue){
				return 1;
			}else if(aValue < bValue){
				return -1;
			}else{
				return 0;
			}
		}
		//按水平线升序排序
		private static function sortOnHorizontalCenter(a:DisplayObject, b:DisplayObject):Number{
			var aValue:Number = (a.transform.pixelBounds.top + a.transform.pixelBounds.bottom)/2;
			var bValue:Number = (b.transform.pixelBounds.top + b.transform.pixelBounds.bottom)/2;
			
			if(aValue > bValue){
				return 1;
			}else if(aValue < bValue){
				return -1;
			}else{
				return 0;
			}
		}
		
		//按 point 的 x 升序排序
		private static function sortOnPointX(a:Point, b:Point):Number
		{
			if(a.x > b.x){
				return 1;
			}else if(a.x < b.x){
				return -1;
			}else{
				return 0;
			}
		}
		//按 point 的 y 升序排序
		private static function sortOnPointY(a:Point, b:Point):Number
		{
			if(a.y > b.y){
				return 1;
			}else if(a.y < b.y){
				return -1;
			}else{
				return 0;
			}
		}
	}
}