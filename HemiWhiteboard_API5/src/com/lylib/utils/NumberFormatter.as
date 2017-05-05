package com.lylib.utils
{
	public class NumberFormatter
	{
		private var _sMask:String;
		private var _group:String = ",";
		private var _kongBai_zs:String = " ";
		private var _kongBai_xs:String = "0";
		/**
		 * 格式化数值 
		 * @param sMask	掩码是由"#,.0"组成
		 * 
		 */		
		public function NumberFormatter(sMask:String = null)
		{
			_sMask = sMask;
		}
		
		
		
		/**
		 * 格式化数值，掩码是由"#,.0"组成 
		 * @param nNumber
		 * @return 
		 * 
		 */		
		public function format(nNumber:Number, oParameter1:Object=null):String
		{
			if(oParameter1!=null){
				if(oParameter1.group != null){
					_group = oParameter1.group;
				}
				if(oParameter1.zhengShu != null){
					_kongBai_zs = oParameter1.zhengShu;
				}
				if(oParameter1.xiaoShu != null){
					_kongBai_xs = oParameter1.xiaoShu;
				}
			}
			var sNumber:String = String(nNumber);
			
			var num1:String="";
			var num2:String="";
			var mask1:String="";
			var mask2:String="";
			var xS:String="";
			var dS:String = "";
			var jinWei:int=0;
			
			if(sNumber.split(".").length > 1){
				num2 = sNumber.split(".")[1];
			}
			num1 = sNumber.split(".")[0];
			if(_sMask.split(".").length > 1){
				mask2 = _sMask.split(".")[1];
			}
			mask1 = _sMask.split(".")[0];
			
			
			//处理小数部分
			if( mask2 != "" && Number(mask2)==0 ){
				//小数部分的掩码都是0 符合要求，获得0的个数
				var mask_x_len:int = mask2.length;
				if(num2=="")
				{
					//要格式化的Number没有小数部分，所以小数都为0,0的个数就是掩码0的个数
					xS = getChongFuChar(_kongBai_xs, mask_x_len);
				}else if(num2.length == mask_x_len){
					//小数位数等于掩码位数
					xS = num2;
				}else if(num2.length < mask_x_len){
					xS = num2 + getChongFuChar(_kongBai_xs, mask2.length-num2.length);;
				}else{
					for(var i:int=0; i<mask_x_len; i++){
						xS += num2.substr(i,1);
					}
					if(int(num2.substr(mask_x_len,1))>4){
						var xS_temp:String = String( int(xS) + 1 );
						if(xS_temp.length > mask_x_len)
						{
							xS = xS_temp.substr(xS_temp.length - mask_x_len, mask_x_len);
							jinWei = int(xS_temp.substr(0,1));
						}else{
							xS = xS_temp;
						}
					}
				}
			}else{
				//掩码中没有小数部分的定义
				if(num2!="")
				{	//要格式化的数据存在小数，原样返回
					xS = num2;
				}else{
					xS = "";
				}		
			}
			
			//处理整数部分
			num1 = String(int(num1) + jinWei);
			var num_d_len:int = num1.length;
			var mask_d_len:int = mask1.length;
			for(var i_num:int=1, i_mask:int=1; ; ){
				if(mask_d_len - i_mask >= 0){
					if( mask1.substr(mask_d_len - i_mask, 1) == "#" ){
						if(num_d_len - i_num >= 0){
							dS = num1.substr(num_d_len - i_num, 1) + dS;
							i_num++;
						}else{
							dS = _kongBai_zs + dS;
						}
					}else if( mask1.substr(mask_d_len - i_mask, 1) == "," ){
						if(num_d_len - i_num >= 0){
							dS = _group + dS;
						}else{
							dS = _kongBai_zs + dS;
						}
					}else{
						dS = num1;
						break;
					}
				}else{
					if(num_d_len - i_num >= 0){
						dS = num1.substr(0, num_d_len - i_num + 1) + dS;
					}
					break;
				}
				i_mask++;
			}
			
			
			return dS + ((xS!="")?("."+xS):"");
		}
		
		
		private function insertStr(src:String, index:int, str:String):void
		{
			
		}
		
		
		/**
		 * 返回重复的字符串
		 * @param char
		 * @param num
		 * @return 
		 */
		private function getChongFuChar(char:String, num:int):String{
			var str:String = "";
			for(var i:int=0; i<num; i++)
			{
				str += char;
			}
			return str;
		}
		
		public function get mask():String
		{
			return _sMask;
		}

		public function set mask(value:String):void
		{
			_sMask = value;
		}

	}
}