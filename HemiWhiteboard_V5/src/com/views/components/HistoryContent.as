package  com.views.components
{
	import com.events.ChangeEvent;
	import com.models.vo.MediaVO;
	import com.notification.NotificationFactory;
	import com.notification.NotificationIDs;
	import com.tweener.transitions.Tweener;
	
	import flash.display.JPEGEncoderOptions;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class HistoryContent extends Sprite
	{
//		private var _arr:Array=[];
		private var _arr:Vector.<HistoryMC> = new Vector.<HistoryMC>;
		private var _spCon:Sprite;
		private var _index:int;
		private var _downX:Number=0;
		private var _tempX:Number=0;
		private var _downY:Number=0; 
		private var _tempY:Number=0; 
		private var _maskSp:Shape;
		private var _historyMc:HistoryMCRes;
		private var _tempObj:HistoryMC;
		
		public function HistoryContent()
		{
			_historyMc = new HistoryMCRes();
			_historyMc.y = 28;
			this.addChild(_historyMc);
			
			_spCon = new Sprite();
			_spCon.y = -15;
//			_spCon.graphics.clear();
//			_spCon.graphics.beginFill(0xFFFF00,0.5);
//			_spCon.graphics.drawRect(0,0,60,400);
//			_spCon.graphics.endFill();
			this.addChild(_spCon);
			
			_maskSp = new Shape();
			_maskSp.graphics.clear();
			_maskSp.graphics.beginFill(0xFFFF00,0.5);
			_maskSp.graphics.drawRect(0,0,60,400);
			_maskSp.graphics.endFill();
			_maskSp.y = -373;
			this.addChild(_maskSp);
			
			_spCon.mask = _maskSp;
			
			_spCon.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			_historyMc.addEventListener(MouseEvent.CLICK,onMCClick);
		}
		
		public function addThumb(vo:MediaVO):void
		{
			var _hisMC:HistoryMC = new HistoryMC();
//			trace(vo.bmp,"+++++++++++++++++++++++++++");
			if(vo.btyeArray==null)
			{
				trace("bitmap null")
				return;}
			_hisMC.addBitMap(vo);
			if(_arr.length>=10){
				var obj:HistoryMC = _arr.shift() as HistoryMC;
				obj.dispose();
				_spCon.removeChild(obj);
			}
			_arr.push(_hisMC);
			setWeiZhi();
		}
		
		private function setWeiZhi():void
		{
			for (var i:int = 0; i < _arr.length; i++) 
			{
				//_arr[i].y = -(i*40);
				_arr[i].name = "mc_"+i;
				Tweener.addTween(_arr[i],{y:-(i*40),time:0.2});
				_spCon.addChild(_arr[i]);
			}
		}
		
		private function onDown(e:MouseEvent):void
		{
//			_tempObj = e.target as HistoryMC;
			if(e.target is HistoryMC)
			{
				_tempObj = e.target as HistoryMC;
				_tempX = _tempObj.x;
				_tempY = _tempObj.y;
			}
			_downY = mouseY;
			_downX = mouseX;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onMove(e:MouseEvent):void
		{
//			_spCon.y += mouseY-_downY;
//			_downY = mouseY;
			if(_tempObj!=null)
			{
				_tempObj.x += mouseX-_downX;
				_downX = mouseX;
			}
		}
		
		private function onUp(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			if(_tempObj==null)return;
			Tweener.addTween(_spCon,{y:-13,time:0.5});
			if(Math.abs(_tempY-_tempObj.y)<5&&Math.abs(_tempX-_tempObj.x)<5)
			{//trace("是点击恢复卡片");
				var id:int = e.target.name.split("_")[1];
				/*if((e.target as HistoryMC).vo.isBmpd)
				{
					var ba:ByteArray = new ByteArray(); 
					var jpegEncoder:JPEGEncoderOptions = new JPEGEncoderOptions(100); 
					_arr[id].vo.bmpd.encode(_arr[id].vo.bmpd.rect,jpegEncoder,ba);
					NotificationFactory.sendNotification(NotificationIDs.OPP_CAMERA,ba);
				}else{*/
				/*	NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,(e.target as HistoryMC).vo);
				}*/
				(e.target as HistoryMC).vo.isFull = false;
				NotificationFactory.sendNotification(NotificationIDs.OPP_MEDIA,(e.target as HistoryMC).vo);
				_arr[id].reset();
				_spCon.removeChild(_arr[id]);
				_arr.splice(id,1);
				setWeiZhi();
			}else{//trace("清除卡片");
				if(Math.abs(_tempX-_tempObj.x)>5)
				{
					var id1:int = _tempObj.name.split("_")[1];
					_arr[id1].dispose();
					_spCon.removeChild(_arr[id1]);
					_arr.splice(id1,1);
					setWeiZhi();
				}
			}
			_tempObj=null;
		}
		
		private function onMCClick(e:MouseEvent):void
		{
			if(e.target.name=="btn_0")
			{
				if(_historyMc.btn_0.currentFrame == 1)
				{
					Tweener.addTween(_spCon,{y:400,time:0.5});
					_historyMc.btn_0.gotoAndStop(2);
				} else {
					_historyMc.btn_0.gotoAndStop(1);
					Tweener.addTween(_spCon,{y:-13,time:0.5});
				}
			}else if(e.target.name=="btn_1"){
				NotificationFactory.sendNotification(NotificationIDs.SHOW_LOADING,"正在整理板书内容请稍候...");
				setTimeout(function():void
				{
					NotificationFactory.sendNotification(NotificationIDs.SAVE_ALL);
				},100);
			}
			/*if(_spCon.y==-13){
				Tweener.addTween(_spCon,{y:400,time:0.5});
			}else{
				Tweener.addTween(_spCon,{y:-13,time:0.5});
			}*/
		}
	}
}