package com.views.components
{
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.GraffitiBoardMouse;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class YingGuangBi extends Sprite
	{
		private var _ygbTools:YGBToolsRes;
		
		private var _tuYa0:GraffitiBoardMouse;
		private var _tuYa1:GraffitiBoardMouse;
		private var _tuYa2:GraffitiBoardMouse;
		private var _tuYa3:GraffitiBoardMouse;
		private var _tuYa4:GraffitiBoardMouse;
		
		private var _colorArr:Array=[0xBF2115,0xEEC848,0x71AD34,0x0396DB,0xFFFFFF];
		
		private var _lColor:uint=0xFF0000;
		private var _lThincess:int=5;
		private var _lineStyle:int =1;
		/**
		 * 是否是圈选删除
		 */
		public var isCir:Boolean;
		/**
		 * 是否是擦除
		 */
		public var _isEraser:Boolean;
		
		private var _tiXingDongHua:ChaoJiPiZhuTiShiRes;
		private var _downY:Number;
		private var _alpha:Number=0;
		private var _isOpen:Boolean=false;
		private var _tempThincess:int;
		private var _templineStyle:int;
		
		public function YingGuangBi()
		{
			initContent();
		}
		
		private function initContent():void
		{
			_ygbTools = new YGBToolsRes();
			_ygbTools.x = 27+20;
			_ygbTools.y = 127;
			
			_tuYa0 = new GraffitiBoardMouse();
			_tuYa0.name = "tuYa_0";
			_tuYa0.setWH(1920,1080);
			
			_tuYa1 = new GraffitiBoardMouse();
			_tuYa1.name = "tuYa_1";
			_tuYa1.setWH(1920,1080);
			
			_tuYa2 = new GraffitiBoardMouse();
			_tuYa2.name = "tuYa_2";
			_tuYa2.setWH(1920,1080);
			
			_tuYa3 = new GraffitiBoardMouse();
			_tuYa3.name = "tuYa_3";
			_tuYa3.setWH(1920,1080);
			
			_tuYa4 = new GraffitiBoardMouse();
			_tuYa4.name = "tuYa_4";
			_tuYa4.setWH(1920,1080);
			
			_tiXingDongHua = new ChaoJiPiZhuTiShiRes();
			_tiXingDongHua.x = 67;
			_tiXingDongHua.y = 48.55;
			this.addChild(_tiXingDongHua);
			this.addChild(_tuYa4);
			this.addChild(_tuYa3);
			this.addChild(_tuYa2);
			this.addChild(_tuYa1);
			this.addChild(_tuYa0);
			this.addChild(_ygbTools);
			_ygbTools.paiZhaoBtn.visible = false;
			_tiXingDongHua.visible= false;
			_ygbTools.bar.y = 354.5;
			hideTuYaAll();
			_ygbTools.hideShowBtn.mouseEnabled = false;
			_ygbTools.addEventListener(MouseEvent.CLICK,onToolsClick);
			_ygbTools.bar.addEventListener(MouseEvent.MOUSE_DOWN,onMcDown);
		}
		
		private function onToolsClick(event:MouseEvent):void
		{
			switch(event.target.name)
			{
				case "color_0":
				case "color_1":
				case "color_2":
				case "color_3":
				case "color_4":
				{
					resetTuYa();
					_ygbTools.paiZhaoBtn.eraserBtn.gotoAndStop(1);
					_ygbTools.paiZhaoBtn.chaChuBtn.gotoAndStop(1);
					ApplicationData.getInstance().styleVO.isCir = false;
					ApplicationData.getInstance().styleVO.isEraser = false;
					_ygbTools.hideShowBtn.mouseEnabled = true;
					this.graphics.beginFill(0,0);
					this.graphics.drawRect(0,0,1920,1016);
					this.graphics.endFill();
					_tiXingDongHua.visible= true;
					_isOpen = true;
					var id:int = event.target.name.split("_")[1];
					if((event.target as MovieClip).currentFrame==1)
					{
						(event.target as MovieClip).gotoAndStop(2);
						hideMouseAll();
						_lColor = _colorArr[id];
//						trace(_lColor,"_lColor");
						(this.getChildByName("tuYa_"+id) as GraffitiBoardMouse).mouseChildren = true;
						(this.getChildByName("tuYa_"+id) as GraffitiBoardMouse).mouseEnabled = true;
						(this.getChildByName("tuYa_"+id) as GraffitiBoardMouse).visible = true;
						(this.getChildByName("tuYa_"+id) as GraffitiBoardMouse).settingStyle(_lColor,_lineStyle,_lThincess);
					}else{
						(event.target as MovieClip).gotoAndStop(1);	
						(this.getChildByName("tuYa_"+id) as GraffitiBoardMouse).visible = false;
					}
					_ygbTools.paiZhaoBtn.visible = true;
					NotificationFactory.sendNotification(NotificationIDs.OPEN_YINGGUANGBI);
					break;
				}
				case "clearBtn":
				{
					resetTuYa();
					clearTuYa();
					_ygbTools.paiZhaoBtn.eraserBtn.gotoAndStop(1);
					_ygbTools.paiZhaoBtn.chaChuBtn.gotoAndStop(1);
					ApplicationData.getInstance().styleVO.isCir = false;
					ApplicationData.getInstance().styleVO.isEraser = false;
					break;
				}
				case "hideShowBtn":
				{
					resetTuYa();
					if((event.target as MovieClip).currentFrame==1)
					{
						(event.target as MovieClip).gotoAndStop(2);	
						_tiXingDongHua.gotoAndStop(2);
						this.graphics.clear();
						hideTuYaAll();
						_ygbTools.paiZhaoBtn.visible = false;
						NotificationFactory.sendNotification(NotificationIDs.CLOSE_YINGGUANGBI);
//						hideMouseAll();
					}else{
						_tiXingDongHua.gotoAndStop(1);
						(event.target as MovieClip).gotoAndStop(1);	
						showTuYaAll();
						_ygbTools.paiZhaoBtn.visible = true;
						NotificationFactory.sendNotification(NotificationIDs.OPEN_YINGGUANGBI);
//						showMouseAll();
					}
					_ygbTools.paiZhaoBtn.eraserBtn.gotoAndStop(1);
					_ygbTools.paiZhaoBtn.chaChuBtn.gotoAndStop(1);
					ApplicationData.getInstance().styleVO.isCir = false;
					ApplicationData.getInstance().styleVO.isEraser = false;
					break;
				}
				case "closeBtn":
				{
					resetTuYa();
					_ygbTools.hideShowBtn.mouseEnabled = false;
					this.graphics.clear();
					_tiXingDongHua.visible= false;
					_ygbTools.paiZhaoBtn.visible = false;
					_tiXingDongHua.gotoAndStop(1);
					_isOpen = false;
					hideMouseAll();
					hideTuYaAll();
					reset();
					NotificationFactory.sendNotification(NotificationIDs.CLOSE_YINGGUANGBI);
					break;
				}
				case "paizhao":
				{
					resetTuYa();
					NotificationFactory.sendNotification(NotificationIDs.PHOTO_GRAPH);
					this.graphics.clear();
					_ygbTools.hideShowBtn.gotoAndStop(2);	
					_tiXingDongHua.gotoAndStop(2);
					hideTuYaAll();
					_ygbTools.paiZhaoBtn.visible = false;
					NotificationFactory.sendNotification(NotificationIDs.CLOSE_YINGGUANGBI);
					break;
				}
					
				case "eraserBtn":
				{
					/*_ygbTools.paiZhaoBtn.eraserBtn.gotoAndStop(2);
					_ygbTools.paiZhaoBtn.chaChuBtn.gotoAndStop(1);
					ApplicationData.getInstance().styleVO.isCir = false;
					ApplicationData.getInstance().styleVO.isEraser = true;*/
					if(ApplicationData.getInstance().styleVO.isEraser)
					{
						resetTuYa();
					} else {
						_tempThincess = ApplicationData.getInstance().styleVO.lineThickness;
						_templineStyle = ApplicationData.getInstance().styleVO.lineStyle;
						ApplicationData.getInstance().styleVO.isCir = false;
						ApplicationData.getInstance().styleVO.isEraser = true;
						resetEraser(30);
						_ygbTools.paiZhaoBtn.eraserBtn.alpha = 0.5;
						_ygbTools.paiZhaoBtn.chaChuBtn.alpha = 1;
					}
					break;
				}
					
				case "chaChuBtn":
				{
					/*_ygbTools.paiZhaoBtn.eraserBtn.gotoAndStop(1);
					_ygbTools.paiZhaoBtn.chaChuBtn.gotoAndStop(2);
					ApplicationData.getInstance().styleVO.isCir = true;
					ApplicationData.getInstance().styleVO.isEraser = false;*/
					resetTuYa();
					ApplicationData.getInstance().styleVO.isCir = true;
					ApplicationData.getInstance().styleVO.isEraser = false;
					_ygbTools.paiZhaoBtn.chaChuBtn.alpha = 0.5;
					_ygbTools.paiZhaoBtn.eraserBtn.alpha = 1;
					break;
				}
			}
		}
		
		private function resetTuYa():void
		{
			if(ApplicationData.getInstance().styleVO.isEraser)
			{
				ApplicationData.getInstance().styleVO.lineThickness = _tempThincess;
				ApplicationData.getInstance().styleVO.lineStyle  = _templineStyle;
				ApplicationData.getInstance().styleVO.isCir = false;
				ApplicationData.getInstance().styleVO.isEraser = false;
				resetEraser(5);
			}
			_ygbTools.paiZhaoBtn.eraserBtn.alpha = 1;
			_ygbTools.paiZhaoBtn.chaChuBtn.alpha = 1;
		}
		
		private function resetEraser(id:int):void
		{
			if(id == 5)
			{
				_tuYa0.lineStyle = 1;
				_tuYa1.lineStyle = 1;
				_tuYa2.lineStyle = 1;
				_tuYa3.lineStyle = 1;
				_tuYa4.lineStyle = 1;
			} else {
				_tuYa0.lineStyle = 0;
				_tuYa1.lineStyle = 0;
				_tuYa2.lineStyle = 0;
				_tuYa3.lineStyle = 0;
				_tuYa4.lineStyle = 0;
			}
			_tuYa0.lineThickness = id;
			_tuYa1.lineThickness = id;
			_tuYa2.lineThickness = id;
			_tuYa3.lineThickness = id;
			_tuYa4.lineThickness = id;
		}
		
		private function hideMouseAll():void
		{
			for (var i:int = 0; i < 5; i++) 
			{
				(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).mouseChildren = false;
				(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).mouseEnabled = false;
			}
		}
		
		private function showMouseAll():void
		{
			for (var i:int = 0; i < 5; i++) 
			{
				(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).mouseChildren = true;
				(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).mouseEnabled = true;
			}
		}
		
		private function hideTuYaAll():void
		{
			_tuYa0.visible = false;
			_tuYa1.visible = false;
			_tuYa2.visible = false;
			_tuYa3.visible = false;
			_tuYa4.visible = false;
			
			for (var i:int = 0; i < 5; i++) 
			{
				(_ygbTools["color_"+i] as MovieClip).gotoAndStop(1);
			}
		}
		
		public function hideTools():void
		{
			_ygbTools.visible = false;
			_tiXingDongHua.visible = false;
		}
		
		public function showTools():void
		{
			_ygbTools.visible = true;
			if(_isOpen)
			{
				_tiXingDongHua.visible = true;
			}
		}
		
		private function showTuYaAll():void
		{
			_tuYa0.visible = true;
			_tuYa1.visible = true;
			_tuYa2.visible = true;
			_tuYa3.visible = true;
			_tuYa4.visible = true;
			
			for (var i:int = 0; i < 5; i++) 
			{
				(_ygbTools["color_"+i] as MovieClip).gotoAndStop(2);
			}
			(this.getChildByName("tuYa_"+0) as GraffitiBoardMouse).mouseChildren = true;
			(this.getChildByName("tuYa_"+0) as GraffitiBoardMouse).mouseEnabled = true;
			(this.getChildByName("tuYa_"+0) as GraffitiBoardMouse).visible = true;
			(this.getChildByName("tuYa_"+0) as GraffitiBoardMouse).settingStyle(_colorArr[0],_lineStyle,_lThincess);
		}
		
		private function clearTuYa():void
		{
			for (var i:int = 0; i < 5; i++) 
			{
				if((this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).visible==true)
				{
					(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).clear();
					(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).mouseChildren = false;
					(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).mouseEnabled = false;
					_ygbTools["color_"+i].gotoAndStop(1);
				}
			}
		}
		/**
		 * 改变工具的大小 
		 * @param id
		 * 
		 */		
		public function changeToosScale(id:int):void
		{
			_ygbTools.scaleX = _ygbTools.scaleY = id;
		}
		
		private function setTuYaAlpha():void
		{
			for (var i:int = 0; i < 5; i++) 
			{
				(this.getChildByName("tuYa_"+i) as GraffitiBoardMouse).alpha = _alpha;
			}
		}
		
		private function onMcDown(e:MouseEvent):void
		{
			_downY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
			_ygbTools.bar.y += mouseY-_downY;
			_downY = mouseY;
			if(_ygbTools.bar.y<265.7){
				_ygbTools.bar.y = 265.7;
			}
			
			if(_ygbTools.bar.y>354.5)
			{
				_ygbTools.bar.y = 354.5;
			}
		}
		
		private function onUp(e:MouseEvent):void
		{
			_alpha = 0.1+(_ygbTools.bar.y-265.7)/(110);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			//eve.alpha = 1-(_ygbTools.mc.y-284.6)/180;
			_ygbTools.bar.mc.alpha = _alpha;
			setTuYaAlpha();
		}
		
		public function reset():void
		{
			_ygbTools.hideShowBtn.gotoAndStop(1);
		}
	}
}