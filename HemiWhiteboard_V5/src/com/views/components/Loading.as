package  com.views.components
{
	import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.display.Shape;
    import flash.events.Event;
	
	 import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Matrix;
    import flash.utils.Timer;
    import flash.events.TimerEvent;

	/**
	 * ...
	 * @author ljb
	 */
	public class Loading extends Sprite 
	{
		//private var nums:Number = 12;
        //private var segAngle:Number;
        //private var seg:Number;
        //private var arr:Array = new Array  ;
        //private var sprite:Sprite = new Sprite  ;
        //private var j:Number = 1;
		
		private var nums:int = 12;
        private var m2:Matrix = new Matrix();
        private var m:Matrix =  new Matrix();
        private var Abar:Array = new Array();
        private var segAngle:Number;
        private var seg:Number;
        private var j:Number = 0;
        private var timer:Timer =  new Timer(50);

        public function Loading():void
        {
            //init();
            initBar();

        }
		 //private function init():void
        //{
            //stage.align = StageAlign.TOP_LEFT;
            //stage.scaleMode = StageScaleMode.NO_SCALE;
            //seg = 1 / this.nums;
            //segAngle = Math.PI * 2 / this.nums;
            //addChild(sprite);
            //sprite.x = this.stage.stageWidth / 2;
            //sprite.y = this.stage.stageHeight / 2;
            //for (var i:int = 0; i < this.nums; i++)
            //{
                //var shape:Shape = new Shape  ;
                //shape.graphics.beginFill(0x000000);
                //shape.graphics.drawCircle(0, 0, 10);
                //shape.graphics.endFill();
                //sprite.addChild(shape);
//
                //shape.alpha = seg * i;
                //shape.x = 60 * Math.cos((i * segAngle));
                //shape.y = 60 * Math.sin((i * segAngle));
                //arr[i] = shape;
//
            //}
            //stage.addEventListener(Event.ENTER_FRAME,alphaHalder);
        //}
		 private function initBar():void
        {
            segAngle = 2 * Math.PI / this.nums;
            seg = 1 / this.nums;
            for (var i:int = 0; i < this.nums; i++)
            {
                var bar:Shape=new Shape();
                Abar[i] = bar;
                bar.graphics.beginFill(0xffffff);
                bar.graphics.drawRoundRect(0,0,10,3,4,4);
                bar.graphics.endFill();
                this.addChild(bar);
                bar.alpha = seg * i;
                bar.x = bar.y = 100;
                m.identity();
                m.translate(7,-1);
                m.rotate(segAngle*i);
                m.translate(-7,1);
                m2.identity();
                m2.translate(100,100);
                m.concat(m2);
                bar.transform.matrix = m;
            }
            timer.addEventListener(TimerEvent.TIMER,alphaHalder);
            timer.start();
        }


        //private function alphaHalder(evt:Event):void
        //{
            //for (var i:int = 0; i < nums; i++)
            //{
                //var shape:Shape = arr[i] as Shape;
                //shape.alpha = j;
                //j -=  seg;
                //if ((j == 0.08333333333333325))
                //{
                    //j = 1;
                //}
            //}
//
        //}
		private function alphaHalder(evt:TimerEvent):void
        {
            for (var i:int = 0; i < this.nums; i++)
            {
                var bar:Shape = Abar[i] as Shape;
                bar.alpha = j;
                if(j == 1.0833333333333333)
                {
                    j = 0;
                }
                j += seg;
            }
        }


		
	}

}