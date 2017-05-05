package com.utils
{
	import flash.geom.Point;
	
	public class AString
	{
		static public function Trim(str:String):String
		{
			return str.replace(/(^\s*)|(\s*$)/g, "");
		}
		
		static public function LTrim(str:String):String
		{
			return str.replace(/(^\s*)/g, ""); 
		}
		
		static public function RTrim(str:String):String
		{
			return str.replace(/(\s*$)/g, ""); 
		}
		
		static public function getFileName(url:String):String
		{
			var index:int=url.lastIndexOf("/");
			if(index==-1)
				index=url.lastIndexOf("\\");
			
			return url.substring(index+1,url.length);
		}
		//忽略大小字母比较字符是否相等;
		static public function equalsIgnoreCase(char1:String,char2:String):Boolean
		{
			return char1.toLowerCase() == char2.toLowerCase();
		}
		//比较字符是否相等;
		static public function equals(char1:String,char2:String):Boolean
		{
			return char1 == char2;
		}
		//是否为Email地址;
		static public function isEmail(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			char = AString.Trim(char);
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(char);
			if(result == null)
			{
				return false;
			}
			return true;
		}
		
		//是否是数值字符串;
		static public function isNumber(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			
			return !isNaN(Number(char));
		}
		//是否为Double型数据;
		static public function isDouble(char:String):Boolean
		{
			char = AString.Trim(char);
			var pattern:RegExp = /^[-\+]?\d+(\.\d+)?$/;
			var result:Object = pattern.exec(char);
			if(result == null) 
			{
				return false;
			}
			return true;
		}
		
		//Integer;
		static public function isInteger(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			
			char = AString.Trim(char);
			var pattern:RegExp = /^[-\+]?\d+$/;
			var result:Object = pattern.exec(char);
			
			if(result == null) 
			{
				return false;
			}
			
			return true;
		}
		
		//English;
		static public function isEnglish(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			
			char = AString.Trim(char);
			var pattern:RegExp = /^[A-Za-z]+$/;
			var result:Object = pattern.exec(char);
			
			if(result == null)
			{
				return false;
			}
			
			return true;
		}
		//中文;
		static public function isChinese(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			
			char = AString.Trim(char);
			var pattern:RegExp = /^[\u0391-\uFFE5]+$/;
			var result:Object = pattern.exec(char);
			
			if(result == null) 
			{
				return false;
			}
			
			return true;
		}
		//双字节
		static public function isDoubleChar(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			
			char = AString.Trim(char);
			var pattern:RegExp = /^[^\x00-\xff]+$/;
			var result:Object = pattern.exec(char);
			
			if(result == null) 
			{
				return false;
			}
			
			return true;
		}
		
		//含有中文字符
		static public function hasChineseChar(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			char = AString.Trim(char);
			var pattern:RegExp = /[^\x00-\xff]/;
			var result:Object = pattern.exec(char);
			
			if(result == null) 
			{
				return false;
			}
			
			return true;
		}
		
		//注册字符;
		static public function hasAccountChar(char:String,len:uint=15):Boolean
		{
			if(char == null)
			{
				return false;
			}
			
			if(len < 10)
			{
				len = 15;
			}
			
			char = AString.Trim(char);
			var pattern:RegExp = new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,"+len+"}$", "");
			var result:Object = pattern.exec(char);
			
			if(result == null) 
			{
				return false;
			}
			
			return true;
		}
		//URL地址;
		static public function isURL(char:String):Boolean
		{
			if(char == null)
			{
				return false;
			}
			char = AString.Trim(char).toLowerCase();
			var pattern:RegExp = /^http:\/\/[A-Za-z0-9]+\.[A-Za-z0-9]+[\/=\?%\-&_~`@[\]\’:+!]*([^<>\"\"])*$/;
			var result:Object = pattern.exec(char);
			
			if(result == null) 
			{
				return false;
			}
			
			return true;
		}
		// 是否为空白;
		static public function isWhitespace(char:String):Boolean
		{
			switch (char)
			{
				case " ":
				case "\t":
				case "\r":
				case "\n":
				case "\f":
					return true;
				default:
					return false;
			}
		}
		
		//是否为前缀字符串;
		static public function beginsWith(char:String, prefix:String):Boolean
		{
			return (prefix == char.substring(0, prefix.length));
		}
		
		//是否为后缀字符串;
		static public function endsWith(char:String,suffix:String):Boolean
		{
			return (suffix == char.substring(char.length-1,suffix.length));
		}
		//去除指定字符串;
		static public function remove(char:String,remove:String):String
		{
			return replace(char,remove,"\"");
		}
		//字符串替换;
		static public function replace(char:String, replace:String, replaceWith:String):String
		{
			return char.split(replace).join(replaceWith);
		}
		//替换指定位置字符;
		static public function replaceAt(char:String, value:String, beginIndex:int, endIndex:int):String 
		{
			beginIndex = Math.max(beginIndex, 0);
			endIndex = Math.min(endIndex, char.length);
			var firstPart:String = char.substr(0, beginIndex);
			var secondPart:String = char.substr(endIndex, char.length);
			return (firstPart + value + secondPart);
		}
		
		//删除指定位置字符;
		static public function removeAt(char:String, beginIndex:int, endIndex:int):String 
		{
			return replaceAt(char, "", beginIndex, endIndex);
		}
		/**
		 *修复双换行符 
		 * @param char
		 * @return 
		 * 
		 */		
		static public function fixNewlines(char:String):String 
		{
			return char.replace(/\r\n/gm, "\n");
		}
		
		/**
		 *参数转换器 可将包括有{变量名}转换成vars中的即时数据
		 * @param args
		 * @return 
		 */		
		static public function TranArgs(args:String,vars:Object):String
		{
			if(vars==null||args.indexOf("{")==-1||args.indexOf("}")==-1)
				return args;
			__Vars=vars;
			///{变量名}
			args=args.replace(__Exp,__Method);
			__Vars=null;
			return args;
		}
		static private var __Vars:Object;
		static private var __Exp:RegExp=/\{([Z-z$_][^\}\{]+)\}/g;
		static private function __Method(...args):String{return __Vars[args[1]];}
		
		/**
		 *将格式为(numX|numY)的字符串转化成Point 
		 * @param posStr
		 * @return 
		 * 
		 */		
		static public function TranPoint(posStr:String):Point
		{
			var posIndex:int=posStr.indexOf("|");
			
			if(posIndex!=-1)
			{
				
				var x:int=int(posStr.substring(0,posIndex));
				var y:int=int(posStr.substring(posIndex+1,posStr.length));
				
				return new Point(x,y);
			}
			
			return null;
		}
	}
}