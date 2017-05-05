package com.models.vo 
{
	import com.models.ApplicationData;

	/**
	 * ...
	 * @author shi
	 */
	public class MenuVO 
	{
		/**
		* 按钮的中文
		*/
		public var cName:String="";
		
		/**
		 * 按钮的英文
		 */
		public var eName:String="";
		
		/**
		 * 按钮的里面图标
		 */
		public var ico:String="";
		
		/**
		 * 按钮的图标
		 */
		public var thumb:String="";
		
		/**
		 * 点击弹出来的素材的路径
		 */
		public var path:String="";
		
		/**
		 * 素材的类型
		 */
		public var type:String="";
		
		public var data:String="";
		
		public var url:String="";
		
		public function MenuVO() 
		{
			
		}
		
		/**
		 * 传递一个标准的信息xml模板，翻译成MediaVO
		 * @param	xml  制定的信息模板xml
		 */
		public function formatXML(xml:XML):void
		{
			cName = xml.item.@cname;
			eName = xml.item.@ename;
			thumb = ApplicationData.getInstance().assetsPath+xml.item.@thumb;
			ico = ApplicationData.getInstance().assetsPath+xml.item.@ico;
			path = ApplicationData.getInstance().assetsPath+xml.item.@path;
			type = xml.item.@type;
		}
		
		public function formatKeJianXML(xml:XML):void
		{
//			<other name="挂图">
//				<resource type=".JPG" thumb="jiaoan/挂图/s/1119050125.JPG" path="jiaoan/挂图/b/1119050125.JPG">s16挂图——爸爸妈妈不见了</resource>
//			  </other>
			//vo.cname  = _part_xml.resource[j];
			//					vo.type = _part_xml.resource[j].@type;
			//					vo.thumb = _part_xml.resource[j].@thumb;
			//					vo.data = _part_xml.resource[j];
			//					vo.url = _part_xml.resource[j].@path;
			
			cName = xml.resource[0];
			if(ApplicationData.getInstance().UDiskModel==true)
			{
				thumb = ApplicationData.getInstance().UDiskPath+xml.resource[0].@thumb;
				url = ApplicationData.getInstance().UDiskPath+xml.resource[0].@path;
			}else{
				thumb = ApplicationData.getInstance().assetsPath+xml.resource[0].@thumb;
				url = ApplicationData.getInstance().assetsPath+xml.resource[0].@path;
			}
			type = xml.resource.@type;
			data = xml.resource[0];
		}
		
	}

}