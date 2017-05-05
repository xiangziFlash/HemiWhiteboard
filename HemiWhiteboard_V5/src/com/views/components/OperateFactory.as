package com.views.components
{
	import com.views.components.method.ChengOper;
	import com.views.components.method.ChuOper;
	import com.views.components.method.FractionOper;
	import com.views.components.method.HundredOper;
	import com.views.components.method.JiaOper;
	import com.views.components.method.JianOper;
	import com.views.components.method.SqrtOper;
	
	import flash.display.Sprite;
	
	import org.osmf.media.DefaultMediaFactory;

	public class OperateFactory extends Sprite
	{
		public function OperateFactory()
		{
			
		}
		
		public static function  createOper(_operate:String):Operate
		{
			var oper:Operate=null;
			switch(_operate)
			{
				case "+":
					oper = new JiaOper();
					break;
				case "-":
					oper = new JianOper();
					break;
				case "*":
					oper = new ChengOper();
					break;
				case "/":
					oper = new ChuOper();
					break;
				case "1/x":
					oper = new FractionOper();
					break;
				case "%":
					oper = new HundredOper();
					break;
				case "sqrt":
					oper = new SqrtOper();
					break;
				default:
					break;
			}
			return oper;
		}
	}
}