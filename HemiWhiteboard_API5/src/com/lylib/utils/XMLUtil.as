package com.lylib.utils
{
	public class XMLUtil
	{
		public function XMLUtil()
		{
		}
		
		static public function CDATA(nm: String, info: String):XML
		{
			var CDBegin:String = "\n\r<!" + "[CDATA[";
			var CDEnd:String = "]]" + ">\n\r";
			var xml:String = "<" + nm + ">" + CDBegin + info + CDEnd + "</" + nm + ">";
			
			return XML(xml);
		}
	}
}