	/** 
	 * @class:DrawPieGraph(画饼状图) 
	 * @author:ycccc8202 
	 * @date:2007.8.16 
	 * @example: 
	 * import com.ycccc.Graphics.*; 
	 * var dataList:Array=[10,10,10,100,10,10,10,100]; 
	 * var pie:DrawPieGraph=new DrawPieGraph(200,200,150,90,15,dataList,[0xFF0F00,0xFF6600,0xFF9E01,0xFCD202,0xF8FF01,0xB0DE09,0x04D215,0x0D8ECF],.7);
	 * addChild(sprite); 
	 */ 
package com.charts{ 
		import fl.transitions.Tween;
		import fl.transitions.TweenEvent;
		import fl.transitions.easing.*;
		
		import flash.display.Graphics;
		import flash.display.MovieClip;
		import flash.display.Shape;
		import flash.display.Sprite;
		import flash.events.MouseEvent;
		import flash.text.TextField;
		import flash.text.TextFieldAutoSize;
		import flash.text.TextFormat;

		public class DrawPieGraph extends MovieClip { 
			
			//存放shape对象 
			private var __contain:Object; 
			//设置角度从-90开始 
			private var R:int=-90; 
			private var D:uint=20; 
			private var _shape:Shape; 
			//初始饼图的圆心位置 
			private var _x0:Number; 
			private var _y0:Number; 
			//椭圆饼图的长轴与短轴长度 
			private var _a:Number; 
			private var _b:Number; 
			//饼图的厚度 
			private var _h:Number; 
			//透明度 
			private var _alpha:Number 
			//数据列表 
			private var _dataList:Array; 
			private var _promptList:Array; 
			private var _colorList:Array; 
			private var _angleList:Array; 
			private var _depthList:Array; 
			
			private var _names:Array=[];
			
			private var _tempMC:MovieClip;
			
			// 

			private var _mc:MovieClip = null;
			private var _promptTitle:TextField;

			private var _total:int;
			
			/** 
			 *@param:x0......>圆心x坐标 
			 *@param:y0......>圆心y坐标 
			 *@param:a......>长轴 
			 *@param:b......>短轴 
			 *@param:h......>厚度 
			 *@param:dataList......>数据列表 
			 *@param:dataList......>颜色列表 
			 *@param:promptList......>提示文字 
			 *@alpha:Number......>透明度,默认为1.0 
			 */ 
			public function DrawPieGraph(x0:Number,y0:Number,a:Number,b:Number,h:Number,
										 dataList:Array,colorList:Array,names:Array,promptList:Array,alpha:Number=1.0) { 
				_x0=x0; 
				_y0=y0; 
				_a=a; 
				_b=b; 
				_h=h; 
				_alpha=alpha 
				_names = names;
				_dataList=dataList; 
				_promptList = promptList;
				_colorList=colorList; 
				for (var i:int = 0; i < dataList.length; i++) 
				{
					_total +=dataList[i];
				}
				setAngleList(); 
				drawPie(); 
				drawTitle();
				setDepths(); 
			} 
			
			public function updata(x0:Number,y0:Number,a:Number,b:Number,h:Number,
								   dataList:Array,colorList:Array,names:Array,promptList:Array,alpha:Number=1.0):void
			{
				_x0=x0; 
				_y0=y0; 
				_a=a; 
				_b=b; 
				_h=h; 
				_alpha=alpha 
				_names = names;
				_dataList=dataList; 
				_promptList = promptList;
				_colorList=colorList; 
				for (var i:int = 0; i < dataList.length; i++) 
				{
					_total +=dataList[i];
				}
				setAngleList(); 
				drawPie(); 
				drawTitle();
				setDepths(); 
			}
			
			private function drawTitle():void
			{
				var sp:Sprite = new Sprite();
				sp.x = -_a * 0.5;
				sp.y = -_b * 0.5;
				this.addChild(sp);
				for (var i:int = 0; i < _names.length; i++) 
				{
					var title:Sprite = setTitle(i);
					title.y = i * 25;
					sp.addChild(title);
				}
			}
			
			private function setTitle(id:int):Sprite
			{
				var sp:Sprite = new Sprite();
				var shape:Shape = new Shape();
				shape.graphics.beginFill(_colorList[id]);
				shape.graphics.drawRect(0, 0, 20, 20);
				shape.graphics.endFill();
				var title:TextField = new TextField();
				title.text = _names[id];
				title.setTextFormat(new TextFormat(null,15));
				title.transform.matrix = null;
				title.x = 25;
				sp.addChild(shape);
				sp.addChild(title);
				return sp;
			}
			
			
			private function setAngleList():void { 
				_angleList=[]; 
				var totalData:int; 
				var len:uint=_dataList.length; 
				for (var j:uint=0; j < len; j++) { 
					totalData+= _dataList[j]; 
				} 
				for (j=0; j < len; j++) { 
					if (j == len - 1) { 
						_angleList.push([R,270]); 
					} else { 
						var r:uint=Math.floor(_dataList[j] / totalData * 360); 
						var posR:int=R + r; 
						_angleList.push([R,posR]); 
						R=posR; 
						trace(r+"___r"); 
						trace(R); 
					} 
				} 
				trace(_angleList + ":::"); 
			} 
			private function setDepths():void { 
				_depthList=[]; 
				var len:uint=_angleList.length; 
				for (var j:uint=0; j < len; j++) { 
					var minJ:Number=_angleList[j][0]; 
					var maxJ:Number=_angleList[j][1]; 
					switch (true) { 
						case minJ >= -90 && minJ <= 90 && maxJ<=90 : 
							_depthList[j]=minJ; 
							break; 
						default : 
							_depthList[j]=1000-minJ; 
					} 
				}//end for 
				trace(_depthList + "::::_depthList"); 
				_depthList=_depthList.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY); 
				trace(_depthList); 
				for (j=0; j<len; j++) { 
					setChildIndex(__contain["shape"+_depthList[j]],j); 
				} 
			} 
			private function drawPie():void { 
				__contain={}; 
				var len:uint=_angleList.length; 
				var step:uint=1; 
				for (var j:uint=0; j < len; j++) { 
					__contain["shape"+j]=new MovieClip;
					__contain["shape"+j].name = "mc_"+j;
					//设置中心角，方便以下进行点中移动 
					__contain["shape"+j].r=(_angleList[j][0]+_angleList[j][1])/2; 
					__contain["shape" + j].addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX); 
					addChild(__contain["shape"+j]); 
					var drakColor:uint=getDarkColor(_colorList[j]);//深色 
					var g:Graphics=__contain["shape"+j].graphics; 
					//g.lineStyle(1); 
					//先画底 
					//内弧 
					g.beginFill(_colorList[j],_alpha); 
					g.moveTo(_x0,_y0+_h); 
					var r:Number=_angleList[j][0]; 
					var minR:Number=r; 
					var maxR:int=_angleList[j][1]; 
					while (r + step < maxR) {      g.lineTo(getRPoint(_x0,_y0 + _h,_a,_b,r).x,getRPoint(_x0,_y0 + _h,_a,_b,r).y); 
						r+= step; 
					} 
					g.lineTo(getRPoint(_x0,_y0 + _h,_a,_b,maxR).x,getRPoint(_x0,_y0 + _h,_a,_b,maxR).y); 
					// 
					g.endFill(); 
					//画内侧面 
					g.beginFill(drakColor,_alpha); 
					g.moveTo(_x0,_y0+_h); 
					g.lineTo(getRPoint(_x0,_y0 + _h,_a,_b,minR).x,getRPoint(_x0,_y0 + _h,_a,_b,minR).y);
					g.lineTo(getRPoint(_x0,_y0,_a,_b,minR).x,getRPoint(_x0,_y0,_a,_b,minR).y); 
					g.lineTo(_x0,_y0); 
					g.endFill(); 
					//画外侧面 
					g.beginFill(drakColor,_alpha); 
					g.moveTo(_x0,_y0+_h); 
					g.lineTo(getRPoint(_x0,_y0 + _h,_a,_b,maxR).x,getRPoint(_x0,_y0 + _h,_a,_b,maxR).y);
					g.lineTo(getRPoint(_x0,_y0,_a,_b,maxR).x,getRPoint(_x0,_y0,_a,_b,maxR).y); 
					g.lineTo(_x0,_y0); 
					g.endFill(); 
					//画外弧侧面 
					g.beginFill(drakColor,_alpha); 
					//g.lineStyle(1); 
					g.moveTo(getRPoint(_x0,_y0 + _h,_a,_b,minR).x,getRPoint(_x0,_y0 + _h,_a,_b,minR).y); 
					g.lineTo(getRPoint(_x0,_y0,_a,_b,minR).x,getRPoint(_x0,_y0,_a,_b,minR).y); 
					r=minR; 
					while (r + step < maxR) { 
						r+= step; 
						g.lineTo(getRPoint(_x0,_y0,_a,_b,r).x,getRPoint(_x0,_y0,_a,_b,r).y); 
					} 
					g.lineTo(getRPoint(_x0,_y0,_a,_b,maxR).x,getRPoint(_x0,_y0,_a,_b,maxR).y); 
					g.lineTo(getRPoint(_x0,_y0 + _h,_a,_b,maxR).x,getRPoint(_x0,_y0 + _h,_a,_b,maxR).y); 
					while (r - step > minR) { 
						g.lineTo(getRPoint(_x0,_y0 + _h,_a,_b,r).x,getRPoint(_x0,_y0 + _h,_a,_b,r).y); 
						r-= step; 
					} 
					g.lineTo(getRPoint(_x0,_y0 + _h,_a,_b,minR).x,getRPoint(_x0,_y0 + _h,_a,_b,minR).y); 
					g.endFill(); 
					//画上表面 
					g.beginFill(_colorList[j],_alpha); 
					g.moveTo(_x0,_y0); 
					r=minR; 
					while (r + step < maxR) {
						g.lineTo(getRPoint(_x0,_y0,_a,_b,r).x,getRPoint(_x0,_y0,_a,_b,r).y); 
						r+= step; 
					} 
					g.lineTo(getRPoint(_x0,_y0,_a,_b,maxR).x,getRPoint(_x0,_y0,_a,_b,maxR).y); 
					g.endFill(); 
				} 
			} 
			private function onMouseDownX(e:MouseEvent):void { 
				if(_mc != null)
				{
					_tempMC = _mc;
				}
				_mc=e.target as MovieClip; 
				var posX:int=getRPoint(0,0,D,D,_mc.r).x; 
				var posY:int=getRPoint(0,0,D,D,_mc.r).y; 
				if (_mc.x==0 || _mc.y==0) {
					trace(_mc.name,"dddd");
					if(_tempMC)
					{
						if (_tempMC.x!=0 || _mc.y!=0)
						{
						//	_tempMC.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX); 
							var tween5=new Tween(_tempMC,"x",Bounce.easeOut,_mc.x,0,1,true); 
							var tween6=new Tween(_tempMC,"y",Bounce.easeOut,_mc.y,0,1,true); 
							//tween5.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish); 
						}
					}
					//_mc.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX); 
					var tween1=new Tween(_mc,"x",Bounce.easeOut,0,posX,1,true); 
					var tween2=new Tween(_mc,"y",Bounce.easeOut,0,posY,1,true); 
					//tween1.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish); 
				} else { 
					trace(_mc.name,"dddd1111");
					if(_tempMC)
					{
						if (_tempMC.x==0 || _mc.y==0)
						{
							//_tempMC.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX); 
							var tween7=new Tween(_tempMC,"x",Bounce.easeOut,0,posX,1,true); 
							var tween8=new Tween(_tempMC,"y",Bounce.easeOut,0,posY,1,true); 
						//	tween7.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish); 
						}
					}
				//	_mc.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX); 
					var tween3=new Tween(_mc,"x",Bounce.easeOut,_mc.x,0,1,true); 
					var tween4=new Tween(_mc,"y",Bounce.easeOut,_mc.y,0,1,true); 
					//tween3.addEventListener(TweenEvent.MOTION_FINISH,onMotionFinish); 
				} 
				if(_mc == null)return;
				if(_promptTitle == null)
				{
					_promptTitle = new TextField();
					_promptTitle.x = _a+250;
					_promptTitle.y = 50;
					_promptTitle.embedFonts = true;
					_promptTitle.defaultTextFormat = new TextFormat("YaHei_font",15,0x000000);
					_promptTitle.autoSize = TextFieldAutoSize.LEFT;
//					_promptTitle.width = 300;
//					_promptTitle.wordWrap = true;
					this.addChild(_promptTitle);
				}
				_promptTitle.text = getPrompt(_mc.name.split("_")[1]);
			} 
			private function onMotionFinish(e:TweenEvent):void { 
			//	var TG:MovieClip=e.currentTarget.obj as MovieClip; 
				//TG.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDownX); 
			} 
			private function getDarkColor(color:uint):uint { 
				var r:uint=color >> 16 & 0xFF / 1.3; 
				var g:uint=color >> 8 & 0xFF / 1.3; 
				var b:uint=color & 0xFF /1.1; 
				return r << 16 | g << 8 | b; 
			} 
			
			private function getPrompt(id:int):String
			{
				var country:String = _names[id];
				var share:int = _dataList[id];
				var percent:String = (_dataList[id]/_total).toString().substr(0,6);
				var peoples:String = _promptList[id];
				var str:String = country + "\n 投票总人数：" + _total  + "\n 获得投票数：" + share +"\n 百分比：" + String(int(Number(percent) *100)) + "%"+ "\n 投票人分别为："+peoples;
				return str;
			}
			
			private function getRPoint(x0:Number,y0:Number,a:Number,b:Number,r:Number):Object { 
				r=r * Math.PI / 180; 
				return {x:Math.cos(r) * a + x0,y:Math.sin(r) * b + y0}; 
			} 
			public function get contain():Object { 
				return __contain; 
			} 
		} 
	}
