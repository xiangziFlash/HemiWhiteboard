package com.views.components.camera
{
	import com.lylib.touch.objects.RotatableScalable;
	import com.lylib.touch.objects.RotatableScalable1;
	import com.models.ApplicationData;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.scxlib.AutoOppMedia;
	import com.tweener.transitions.Tweener;
	import com.views.components.camera.GetVideo;
	
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class CameraLuZhi extends RotatableScalable
	{
		private var _photo:GetVideo;
		private var _cameraRes:CameraRes;
		private var _downX:Number=0;
		private var _downY:Number=0;
		private var _tempX:Number=0;
		private var _tempY:Number=0;
		
		public function CameraLuZhi()
		{
			touchEndFun=touchEnd;
			_cameraRes = new CameraRes();
			this.addChild(_cameraRes);
			
			_photo = new GetVideo();
			_cameraRes.con.addChild(_photo);
			
			(_cameraRes.con.tt as TextField).embedFonts = true;
			(_cameraRes.con.tt as TextField).defaultTextFormat = new TextFormat("YaHei_font",38,0xFFFFFF);
			(_cameraRes.con.tt as TextField).autoSize = TextFieldAutoSize.CENTER;
			initListener();
		}
		
		public function startCamera():void
		{
			_photo.startGetVideo();
		}
		
		private function initListener():void
		{
			//			_cameraRes.btnCon.addEventListener(MouseEvent.CLICK,onPhotoGraph);
			_photo.addEventListener(Event.CLOSE,onChangeTT);
			this.addEventListener(MouseEvent.MOUSE_DOWN,onPhotoGraphDown);
//			this.addEventListener(MouseEvent.MOUSE_DOWN,onThisDown);
		}
		
		
		private function onThisDown(e:MouseEvent):void
		{
			this.parent.setChildIndex(this,this.parent.numChildren-1);
			this.startDrag();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onPadMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onPadUp);
		}
		
		private function onPadMove(e:MouseEvent):void
		{
			//	var pad:OppMedia = e.currentTarget as OppMedia;
			var rect:Rectangle = this.transform.pixelBounds;
			//	trace(rect.left,rect.right,"lf")
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<960&&rect.right>980){
				//	trace(rect.top,rect.bottom)
				if(rect.top>1000-rect.height*0.2){
					this.alpha = 0.5;
					return;
				}					
			}
			this.alpha = 1;
		}
		
		private function onPadUp(e:MouseEvent):void
		{
			//			trace("upup");
			//var pad:OppMedia = e.currentTarget as OppMedia;
			try
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE,onPadMove);
				stage.removeEventListener(MouseEvent.MOUSE_UP,onPadUp);
			} 
			catch(error:Error) 
			{
				trace("移除报错 585 OppMedia");
			}
			
			var rect:Rectangle = this.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(this.alpha<1){
				Tweener.addTween(this,{x:972,y:1056,scaleX:0.1,scaleY:0.1,alpha:0,time:0.5,onComplete:clearGraph});
			} else {
				if(e.target.name=="btn_0")
				{
					var bmpd:BitmapData = new BitmapData(_cameraRes.con.width,_cameraRes.con.height);
					bmpd.draw(_cameraRes.con);
					var ba:ByteArray = new ByteArray(); 
					var jpegEncoder:PNGEncoderOptions = new PNGEncoderOptions(100); 
					bmpd.encode(bmpd.rect,jpegEncoder,ba);
					bmpd.dispose();
					bmpd = null;
					
					var date:Date = new Date();
					var name:String = String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds)+".jpg";
					var file:File = new File(ApplicationData.getInstance().assetsPath+"photo/"+name);
					var fs:FileStream = new FileStream();
					//					fs.addEventListener(Event.COMPLETE,onSaveEd);
					fs.open(file,FileMode.WRITE);
					fs.writeBytes(ba);
					fs.close();
					AutoOppMedia.setPath("photo/"+name);
					//NotificationFactory.sendNotification(NotificationIDs.OPP_CAMERA,ba);
				}else if(e.target.name=="btn_2"){
					_photo.closeCamera();
					this.dispatchEvent(new Event(Event.CLOSE));
				}
			}
			function clearGraph():void
			{
				_photo.closeCamera();
				this.dispatchEvent(new Event(Event.CLOSE));
			}
		}
		
		private function onChangeTT(event:Event):void
		{
			_cameraRes.con.tt.text = _photo.str;
		}
		
		private function onPhotoGraphDown(e:MouseEvent):void
		{
			_downX = mouseX;
			_downY = mouseY;
			_tempX = mouseX;
			_tempY = mouseY;
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(event:MouseEvent):void
		{
//			this.x += mouseX-_downX;
//			this.y += mouseY-_downY;
//			_downX = mouseX;
//			_downY = mouseY;
			
			var rect:Rectangle = this.transform.pixelBounds;
			//	trace(rect.left,rect.right,"lf")
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<960&&rect.right>980){
				//	trace(rect.top,rect.bottom)
				if(rect.top>1000-rect.height*0.2){
					this.alpha = 0.5;
					return;
				}					
			}
			this.alpha = 1;
		}
		
		private function onUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			
			if(Math.abs(_tempX-mouseX)<5&&Math.abs(_tempY-mouseY)<5)
			{
				if(e.target.name=="btn_0")
				{
					var bmpd:BitmapData = new BitmapData(_cameraRes.con.width,_cameraRes.con.height);
					bmpd.draw(_cameraRes.con);
					var ba:ByteArray = new ByteArray(); 
					var jpegEncoder:PNGEncoderOptions = new PNGEncoderOptions(100); 
					bmpd.encode(bmpd.rect,jpegEncoder,ba);
					bmpd.dispose();
					bmpd = null;
					
					var date:Date = new Date();
					var name:String = String(date.fullYear)+"-"+String(date.month)+"-"+String(date.date)+"-"+String(date.hours)+"-"+String(date.minutes)+"-"+String(date.seconds)+".jpg";
					var file:File = new File(ApplicationData.getInstance().assetsPath+"photo/"+name);
					var fs:FileStream = new FileStream();
//					fs.addEventListener(Event.COMPLETE,onSaveEd);
					fs.open(file,FileMode.WRITE);
					fs.writeBytes(ba);
					fs.close();
					AutoOppMedia.setPath("photo/"+name);
					//NotificationFactory.sendNotification(NotificationIDs.OPP_CAMERA,ba);
				}else if(e.target.name=="btn_2"){
					_photo.closeCamera();
					this.dispatchEvent(new Event(Event.CLOSE));
				}
			} 
			if(this.alpha<1){
				Tweener.addTween(this,{x:972,y:1056,scaleX:0.1,scaleY:0.1,alpha:0,time:0.5,onComplete:clearGraph});
			}
		}
		
		private function clearGraph():void
		{
			_photo.closeCamera();
			this.dispatchEvent(new Event(Event.CLOSE));
		}
		
		private function touchEnd():void
		{
			
		}
		
	}
}