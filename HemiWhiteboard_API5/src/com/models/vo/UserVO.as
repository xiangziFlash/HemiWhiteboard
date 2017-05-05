package com.models.vo
{
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2015-10-9 上午10:01:27
	 * 
	 */
	public class UserVO
	{
		public var userType:String="";
		
		/**
		 * 用户名称
		 */
		public var userName:String="";
		/**
		 * 用户图像
		 */
		public var userThumb:String="";
		/**
		 * 用户上传的媒体素材
		 */
		public var userMedias:Vector.<MediaVO> = new Vector.<MediaVO>;
		/**
		 * 用户机器ip地址
		 */
		public var userIP:String="";
		
		public var voteType:String="";// 0开始投票 1手机投票 2结束投票
		
		public var titleType:String="";//  投票题目的类型 0 == ABCD型 1 == 是否型
		
		public var voteTitle:String="";//  投票题目图片路径
		public var answer:String="";//  投票题目图片路径
		public var isFileTran:Boolean = false;//是否允许文件传输
		public var isPPTControl:Boolean = false;//是否允许ppt控制
		public var questionsType:int;
		
		public function UserVO()
		{
			
		}
	}
}