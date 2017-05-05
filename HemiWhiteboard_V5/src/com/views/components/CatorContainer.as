package com.views.components
{
	import com.lylib.touch.objects.RotatableScalable1;
	import com.views.UIRes;
	import com.views.components.Operate;
	import com.views.components.OperateFactory;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.dns.SRVRecord;
	import flash.text.ReturnKeyLabel;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 
	 * @author 
	 * 计算器
	 */	
	public class CatorContainer extends RotatableScalable1
	{
		public static const TouchEndEvent:String="TouchEndEvent";
		private var _uiRes:UIRes;
		private var _keyNum:String;
		private var _operStr:String;
		
		private var _numA:String;//numA
		private var _numB:String;//numA
		
		private var _isDefault:Boolean = false;
		private var _canOper:Boolean = false;//运算符是否已输入
		private var _canResult:Boolean = false;
		private var _isAddDot:Boolean = false;//是否添加了小数点
		private var _isSaveM:Boolean=false;
		private var _saveString:String;
		private var myResult:Operate;
		
		private var _secTxt:TextField;
		private var _mainTxt:TextField;
		private var _isSuoDing:Boolean;
		
		public function CatorContainer()
		{
			touchEndFun=touchEnd;
			initContainer();
			initListener();
		}
		
		private function initContainer():void
		{
			_uiRes = new UIRes();
//			//_uiRes.mainTxt.defaultTextFormat=new TextFormat("HeiTi_font",18,0xffffff);
//			//_uiRes.mainTxt.selectable=false;
//			//_uiRes.mainTxt.x=20;
//			//_uiRes.mainTxt.y=24;
//			//_uiRes.mainTxt.width=180;
//			//_uiRes.mainTxt.height=20;
//			//_uiRes.mainTxt.autoSize=TextFieldAutoSize.RIGHT;//先设置宽度，再设置对其方式
			_secTxt = new TextField();
			_secTxt.defaultTextFormat=new TextFormat("HeiTi_font",16,0xffffff);
//			_secTxt.autoSize = TextFieldAutoSize.RIGHT;
			_secTxt.mouseEnabled = false;
//			_secTxt.selectable=false;
			_secTxt.x=20;
			_secTxt.y=20;
			_secTxt.width=150;
			_secTxt.height=20;
			_secTxt.autoSize=TextFieldAutoSize.RIGHT;//先设置宽度，再设置对其方式
			
			_mainTxt = new TextField();
			_mainTxt.defaultTextFormat=new TextFormat("HeiTi_font",22,0xffffff);
			_mainTxt.selectable=false;
			_mainTxt.x=20;
			_mainTxt.y=36;
			_mainTxt.width=150;
			_mainTxt.height=30;
			_mainTxt.autoSize=TextFieldAutoSize.RIGHT;
					
			this.addChild(_uiRes);
			this.addChild(_secTxt);
			this.addChild(_mainTxt);
			_uiRes.closeBtn.gotoAndStop(2);
			_isSuoDing = false;
			noRotat = true;
		}
		
		private function initListener():void
		{
			for(var i:int=0;i<10;i++)
			{
				_uiRes["num_"+i].addEventListener(MouseEvent.CLICK,onNumClick);
			}
			_uiRes.ojia.addEventListener(MouseEvent.CLICK, optionHander);
			_uiRes.ojian.addEventListener(MouseEvent.CLICK, optionHander);
			_uiRes.ocheng.addEventListener(MouseEvent.CLICK, optionHander);
			_uiRes.ochu.addEventListener(MouseEvent.CLICK, optionHander);
			_uiRes.dot.addEventListener(MouseEvent.CLICK, _isAddDotHander);
			_uiRes.oresult.addEventListener(MouseEvent.CLICK, getResultHander);
			_uiRes.clear_btn.addEventListener(MouseEvent.CLICK, clearHander);
//			_uiRes.clearCE_btn.addEventListener(MouseEvent.CLICK,clearCEHander);
//			_uiRes.ofract.addEventListener(MouseEvent.CLICK,fractHander);
//			_uiRes.ohund.addEventListener(MouseEvent.CLICK,hundHander);
//			_uiRes.osqrt.addEventListener(MouseEvent.CLICK,sqrtHander);
			_uiRes.del.addEventListener(MouseEvent.CLICK, delHander);
			
//			_uiRes.oMC.addEventListener(MouseEvent.CLICK,onMcHd);
//			_uiRes.oMR.addEventListener(MouseEvent.CLICK,onMrHd);
//			_uiRes.oMS.addEventListener(MouseEvent.CLICK,onMsHd);
//			_uiRes.oMJIA.addEventListener(MouseEvent.CLICK,onMjiaHd);
//			_uiRes.oMJIAN.addEventListener(MouseEvent.CLICK,onMjianHd);
//			_uiRes.closeBtn.mouseChildren = false;
//			_uiRes.suoDingBtn.mouseChildren = false;
//			_uiRes.suoDingBtn.addEventListener(MouseEvent.CLICK,onSuoDingClick);
			_uiRes.closeBtn.addEventListener(MouseEvent.CLICK,onCloseBtnClick);
		}
		/**
		 * 锁定按钮
		 * */
		protected function onSuoDingClick(e:MouseEvent):void
		{
			//this.dispatchEvent(new Event(Event.CLOSE));
//			trace(e.target.name,e.target);
			if((e.target as MovieClip).currentFrame==1)
			{
				_isSuoDing = true;
				noDrag = true;
				noScale = true;
				(e.target as MovieClip).gotoAndStop(2);
			}else{
				_isSuoDing = false;
				noDrag = false;
				noScale = false;
				(e.target as MovieClip).gotoAndStop(1);
			}
		}
		
		private function onCloseBtnClick(e:MouseEvent):void
		{
			this.alpha = 0.3;
			this.parent.removeChild(this);
			this.visible = false;
		}
		/**
		 * MC是清除储存数据
		 * */
		protected function onMcHd(e:MouseEvent):void
		{
			if(_isSaveM)
			{
				_saveString="";
				_isSaveM=false;
			}
		}
		/**
		 * MR是读取储存的数据
		 * */
		protected function onMrHd(e:MouseEvent):void
		{
			if(_isSaveM)
			{
				_mainTxt.text = _saveString;
				//_uiRes.mainTxt.text=_saveString;
			}
		}
		/**
		 * MS将所显示的数存入存储器中，替换原来储存器的内容 
		 * */
		protected function onMsHd(e:MouseEvent):void
		{
			_saveString=String(_mainTxt.text);
			_isSaveM=true;
			_mainTxt.text="";
			//_uiRes.mainTxt.text="";
		}
		/**
		 * M+是计算结果并加上已经储存的数
		 * */
		protected function onMjiaHd(e:MouseEvent):void
		{
			_numA=String(_mainTxt.text);	
			var MOper:Operate = OperateFactory.createOper("+");
			MOper.numA = Number(_numA);
			MOper.numB = Number(_saveString);
			_mainTxt.text = String(MOper.getResult());
			//_uiRes.mainTxt.text = String(MOper.getResult());
			_numA=String(_mainTxt.text);
		}
		/**
		 * M-是计算结果并用已储存的数字减去目前的结果
		 * */
		protected function onMjianHd(e:MouseEvent):void
		{
			_numA=String(_mainTxt.text);	
			var MOper:Operate = OperateFactory.createOper("-");
			MOper.numA = Number(_numA);
			MOper.numB = Number(_saveString);
			_mainTxt.text = String(MOper.getResult());
			//_uiRes.mainTxt.text= String(MOper.getResult());
			_numA=String(_mainTxt.text);
		}
		/**
		 * 平方根
		 * */
		protected function sqrtHander(e:MouseEvent):void
		{
			if(_mainTxt.text!="")
			{
				_numA=String(_mainTxt.text);	
				var sqrtOper:Operate = OperateFactory.createOper("sqrt");
				sqrtOper.numA = Number(_numA);
				_mainTxt.text = String(sqrtOper.getResult());
				//_uiRes.mainTxt.text = String(sqrtOper.getResult());
				_numA=String(_mainTxt.text);
			}
		}
		/**
		 * 百分比
		 * */
		protected function hundHander(e:MouseEvent):void
		{
			if(_mainTxt.text!="")
			{
				_numA=String(_mainTxt.text);	
				var hundOper:Operate = OperateFactory.createOper("%");
				hundOper.numA = Number(_numA);
				_mainTxt.text = String(hundOper.getResult());
				_numA=String(_mainTxt.text);
			}
		}
		
		/**
		 * 倒数
		 * */
		protected function fractHander(e:MouseEvent):void
		{
			if(_mainTxt.text!="")
			{
				_numA=String(_mainTxt.text);		
				var fractionOper:Operate = OperateFactory.createOper("1/x");
				fractionOper.numA = Number(_numA);
				_mainTxt.text = String(fractionOper.getResult());
				_numA=String(_mainTxt.text);
				
			}
		}
		/**
		 * 选择数字
		 * */
		private function onNumClick(e:MouseEvent):void
		{
			//if(_isSuoDing == true)return;
			if(_mainTxt.text.length>=10)
			{
				var str:String=_mainTxt.text;
				_mainTxt.defaultTextFormat=new TextFormat("HeiTi_font",16,0xffffff);
				_mainTxt.text=str;
				
				if(_mainTxt.text.length>=18)
				{
					return;
				}
			}
			else
			{
				var str0:String=_mainTxt.text;
				_mainTxt.defaultTextFormat=new TextFormat("HeiTi_font",22,0xffffff);
				_mainTxt.text=str0;
			}
			
			_keyNum = e.target.name.split("_")[1];
			
			//trace(_keyNum,"--------")
			if (!_isDefault) {
				if (_keyNum != "0") {
					_isDefault = true;
				}
				_mainTxt.text = _keyNum;
				
			}else {
				_mainTxt.appendText(_keyNum);
			}
			
			if(!_canOper)
			{
				_numA=String(_mainTxt.text);
			}else
			{
				_numB=String(_mainTxt.text);
			}
			//_canOper = false;
		}
		/**
		 * 点击运算符
		 * */
		private function optionHander(e:MouseEvent):void 
		{
//			if(_isSuoDing == true)return;
			//if(_canOper)
			//{
//				var str:String=_secTxt.text;
//				_secTxt.text=str.substr(0,str.length-1);
				//return;
		//	}
			if(_secTxt.width>150)return;
			getResultHander(e);
			_secTxt.appendText(_mainTxt.text);
			_mainTxt.text = "";
			if (e.currentTarget.name == "ojia") {
				if(_secTxt.text!=null)
				{
					if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="+")
					{
						return;
					}else if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="-"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="/"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="*"){
						_secTxt.text = _secTxt.text.slice(0,_secTxt.text.length-1);
						_secTxt.appendText("+");
						_operStr="+";
					}else{
						_secTxt.appendText("+");
						_operStr="+";
					}
				}else{
					_secTxt.appendText("+");
					_operStr="+";
				}
			}else if (e.currentTarget.name == "ojian") {
				if(_secTxt.text!=null)
				{
					if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="-")
					{
						return;
					}else if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="+"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="/"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="*"){
						_secTxt.text = _secTxt.text.slice(0,_secTxt.text.length-1);
						_secTxt.appendText("-");
						_operStr="-";
					}
					else{
						_secTxt.appendText("-");
						_operStr="-";
					}
				}else{
					_secTxt.appendText("-");
					_operStr="-";
				}
			}else if (e.currentTarget.name == "ocheng") {
				if(_secTxt.text!=null)
				{
					if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="*")
					{
						return;
					}else if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="-"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="/"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="+"){
						_secTxt.text = _secTxt.text.slice(0,_secTxt.text.length-1);
						_secTxt.appendText("*");
						_operStr="*";
					}else{
						_secTxt.appendText("*");
						_operStr="*";
					}
				}else{
					_secTxt.appendText("*");
					_operStr="*";
				}
			}else if (e.currentTarget.name == "ochu") {
				if(_secTxt.text!=null)
				{
					if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="/")
					{
						return;
					}else if(_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="-"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="+"||_secTxt.text.substr(_secTxt.text.length-1,_secTxt.text.length)=="*"){
						_secTxt.text = _secTxt.text.slice(0,_secTxt.text.length-1);
						_secTxt.appendText("/");
						_operStr="/";
					}else{
						_secTxt.appendText("/");
						_operStr="/";
					}
				}else{
					_secTxt.appendText("/");
					_operStr="/";
				}
			}
			
			if(_canOper)
			{
				if(_numA==null || _numB==null)
				{
					return;
				}
				myResult.numA =Number(_numA);
				myResult.numB =Number(_numB);	
				_mainTxt.text = String(myResult.getResult());
					
				_numA=String(_mainTxt.text);
				myResult = OperateFactory.createOper(_operStr);
				_isDefault=false;
			}
			else
			{
				myResult = OperateFactory.createOper(_operStr);
			}
			_canOper = true;
			_isAddDot=false;
		}
		/**
		 * 点击 点
		 * */
		private function _isAddDotHander(e:MouseEvent):void {
//			if(_isSuoDing == true)return;
			if (!_isAddDot) {
				_mainTxt.appendText(".");
				_isDefault = true;
				_isAddDot = true;
			}
		}
		/**
		 * 退格
		 * */
		private function delHander(e:MouseEvent):void
		{
//			if(_isSuoDing == true)return;
			var str:String = _mainTxt.text;
			if(str.length>0)
			{
				_mainTxt.text=str.substr(0,str.length-1);
			}
			else
			{
				_mainTxt.text="";
			}
			_numA=String(_mainTxt.text);
		}
		
		/**
		 * 清除当前显示框的内容 
		 * */
		private function clearCEHander(e:MouseEvent):void 
		{
//			if(_isSuoDing == true)return;
			_mainTxt.text = "0";
			_isDefault = false;
			_canOper = false;
			_canResult = false;
			_isAddDot = false;
		}
		
		/**
		 * 清除全部
		 * */
		private function clearHander(e:MouseEvent):void 
		{
//			if(_isSuoDing == true)return;
			_mainTxt.text = "0";
			_secTxt.text = "";
			_operStr = "";
			_isDefault = false;
			_canOper = false;
			_canResult = false;
			_isAddDot = false;
		}
		
		/**
		 * = 算出结果
		 * */
		private function getResultHander(e:MouseEvent):void
		{
//			if(_isSuoDing == true)return;
			if(_numA==null || _numB==null)
			{
				return;
			}
			try
			{
				myResult = OperateFactory.createOper(_operStr);
				myResult.numA =Number(_numA);
				myResult.numB =Number(_numB);
				_mainTxt.text = String(myResult.getResult());
				_numA=String(_mainTxt.text);
				_isDefault = false;
				_canOper = false;
				_canResult = false;
				_isAddDot = false;
				_operStr = "";
				_secTxt.text = "";
				_numB = "";
			} 
			catch(error:Error) 
			{
				trace("计算器出错了")
			}
		}
		
		private function touchEnd():void
		{
			trace("所有点弹起");
			var rect:Rectangle = this.transform.pixelBounds;
			//下面的数字是参考垃圾箱的位置以及宽度后定的
			if(rect.left<960&&rect.right>980){
				//	trace(rect.top,rect.bottom)
				if(rect.top>1000-rect.height*0.2){
					this.alpha = 0.3;
					this.parent.removeChild(this);
					this.visible = false;
				}					
			}
		}
		
		public function reset():void
		{
			clearCEHander(null);
			clearHander(null);
		}
	}
}