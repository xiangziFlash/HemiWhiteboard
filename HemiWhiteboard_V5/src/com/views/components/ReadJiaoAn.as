package com.views.components
{
	import com.lylib.layout.LayoutManager;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.GraffitiBoardMouse;
	import com.views.GongZhuLan;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ReadJiaoAn extends Sprite
	{
		private var _res:ReadJiaoAnRes;
		private var _textField:TextField;
		private var _mask:Shape;
		private var _downY:Number=0;
		private var _xiaLaTiaoRes:JiaoAnXiaLaTiaoRes;
		private var _barDownY:Number=0;
		private var _tools:GongZhuLan;
		private var _tuYa:GraffitiBoardMouse;
		private var _downX:Number;
		private var _tempX:Number;
		private var _tempY:Number;
		private var _toolsDownY:Number=0;
		private var _isFull:Boolean;
		private var _stageBmpd:BitmapData;
		
		public function ReadJiaoAn()
		{
			_res = new ReadJiaoAnRes();
			
			_textField = new TextField();
			_textField.x = 10;
			_textField.y = 10;
			
			_mask = new Shape();
			_mask.graphics.beginFill(0xFFFFFF,0.2);
			_mask.graphics.drawRect(0,0,920,520);
			_mask.graphics.endFill();
			_mask.x = _mask.y = 10;
			
			_xiaLaTiaoRes = new JiaoAnXiaLaTiaoRes();
			_xiaLaTiaoRes.x = 940;
			
			_tools = new GongZhuLan();
			_tools.scaleX = _tools.scaleY = Math.min(960/_tools.width);
			_tools.y = 540;
			
			_tuYa = new GraffitiBoardMouse();
			_tuYa.setWH(920,520);
			_tuYa.x = _tuYa.y = 10;
			
			this.addChild(_res);
			this.addChild(_textField);
			this.addChild(_xiaLaTiaoRes);
			this.addChild(_tuYa);
			this.addChild(_tools);
			this.addChild(_mask);
			
			_stageBmpd = new BitmapData(920,520,true,0);
			
			_textField.mask = _mask;
			_textField.embedFonts = true;
			_textField.defaultTextFormat = new TextFormat("YaHei_font",18,0xFFFFFF);
			_textField.width = 920;
			_textField.autoSize = "left";
			_textField.selectable = false;
			_textField.wordWrap = true;
			_textField.background = true;
			_textField.backgroundColor = 0x0E0E0E;
			_xiaLaTiaoRes.visible = false;
//			_tools.pop_btn.visible = false;
//			_tools.fullScreen_btn.visible = false;
			_tuYa.noTuYa = true;
			_tuYa.isGongYong = true;
			_tuYa.mouseEnabled = false;
			_xiaLaTiaoRes.bar.addEventListener(MouseEvent.MOUSE_DOWN,onBarDown);
			_tools.addEventListener(MouseEvent.MOUSE_DOWN,onToolsDown);
		}	
		
		public function setJiaoAn(str:String):void
		{
			reset();
			_textField.text = str;
			
			if(_textField.height>520)
			{
				_xiaLaTiaoRes.visible = true;
				_textField.addEventListener(MouseEvent.MOUSE_DOWN,onTTDown);
			}
		}
		
		private function onTTDown(e:MouseEvent):void
		{
			_downY = mouseY;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onTTMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onTTUp);
		}
		
		private function onTTMove(event:MouseEvent):void
		{
			_textField.y += mouseY-_downY;
			_downY = mouseY;
			
			if(_textField.y>_mask.y)
			{
				_textField.y = 10;
			}
			
			if(_textField.y<-(_textField.height-_mask.height-_mask.y))
			{
				_textField.y=-(_textField.height-_mask.height-_mask.y);
			}
			
			_xiaLaTiaoRes.bar.y = -(_textField.y-_mask.y)*500/(_textField.height-_mask.height);
		}
		
		private function onTTUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onTTMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onTTUp);
		}
		
		private function onBarDown(e:MouseEvent):void
		{
			_barDownY = mouseY;			
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onBarUp);
		}
		
		private function onBarMove(event:MouseEvent):void
		{
			_xiaLaTiaoRes.bar.y += mouseY-_barDownY;
			_barDownY = mouseY;
			
			if(_xiaLaTiaoRes.bar.y<0){
				_xiaLaTiaoRes.bar.y = 0;
			}
			
			if(_xiaLaTiaoRes.bar.y>500){
				_xiaLaTiaoRes.bar.y=500;
			}
			
			_textField.y = -(_xiaLaTiaoRes.bar.y*(_textField.height-_mask.height))/(500)+_mask.y;
		}
		
		private function onBarUp(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onBarMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onBarUp);
		}
		
		private function onToolsDown(event:MouseEvent):void
		{
			_downX = mouseX;
			_toolsDownY = mouseY;
			_tempX = mouseX;
			_tempY = mouseX;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onToolBarMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onToolBarUp);
		}
		
		private function onToolBarMove(e:MouseEvent):void
		{
			this.x += mouseX-_downX;
			this.y += mouseY-_toolsDownY;
			_downX = mouseX;
			_toolsDownY = mouseY;
		}
		
		private function onToolBarUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onToolBarMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onToolBarUp);
			if(Math.abs(_tempX-mouseX)<5||Math.abs(_tempY-mouseY)<5)
			{
				//	trace("预览工具栏点击了",e.target.name	);
				switch(e.target.name)
				{
					case "clear_btn":
					{
						_tuYa.clear();
						break;
					}
					case "lock_btn":
					{
						if((e.target as MovieClip).currentFrame==1)
						{
							_tuYa.noTuYa = false;
							_tuYa.mouseEnabled = true;
							(e.target as MovieClip).gotoAndStop(2);
						}else{
							_tuYa.noTuYa = true;
							_tuYa.mouseEnabled = false;
							(e.target as MovieClip).gotoAndStop(1);
						}
						break;
					}
					case "close_btn":
					{
						this.dispatchEvent(new Event(Event.CLOSE));
						this.visible= false;
						break;
					}
						
					case "fullScreen_btn":
					{
						if(!_isFull){
							_isFull= true;
							this.x = this.y = 0;
							this.width = 1920;
							this.height = 1080;
						}else{
							_isFull= false;
							this.width = 940;
							this.height = 540;
							this.x = (1920-940)*0.5;
							this.y = (1080-840)*0.5;
						}
						NotificationFactory.sendNotification(NotificationIDs.IS_FULL,_isFull);
						break;
					}
					case "pop_btn":
					{
						_stageBmpd.draw(this);
						NotificationFactory.sendNotification(NotificationIDs.OPP_CAMERA,_stageBmpd);
						break;
					}
				}
			}
		}
		
		private function reset():void
		{
			_textField.y =10;
			_xiaLaTiaoRes.bar.y = 0;
			_xiaLaTiaoRes.visible = false;
		}
	}
}