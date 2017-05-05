package com.notification
{
	/**
	 * 所有事件的集合类
	 * */
	public class NotificationIDs
	{
		/**
		 * 应用数据加载完成
		 */
		public static const APP_DATA_LOADED:int = 0;
		
		/**
		 * 模块数据加载完成
		 */
		public static const MODULE_DATA_COMPLETE:int = 2;
		
		/**
		 * 涂鸦样式的切换
		 */
		public static const HUIFU_STYLE:int = 1;
		
		/**
		 * 放大镜
		 */
		public static const FANGDAJING:int = 3;
		
		/**
		 * 恢复初始设置 
		 */
		public static const DEFAULT_SETTING:int = 4;
		
		/**
		 * 锁定屏幕
		 */
		public static const LOCK_SCREEN:int = 5;
		
		/**
		 * 锁定屏幕
		 */
		public static const SHOW_HIDE_MENU:int = 6;
		
		/**
		 * 屏幕拍照
		 */
		public static const PHOTO_GRAPH:int = 7;
		
		/**
		 * 添加黑板
		 */
		public static const ADD_BOARD:int = 8;
		
		/**
		 * 删除黑板
		 */
		public static const REMOVE_BOARD:int = 9;
		
		/**
		 * 显示第几个黑板
		 */
		public static const CHANGE_BOARD:int = 10;
		
		/**
		 * 清除所有
		 */
		public static const CLEAR_ALL:int = 11;
		
		/**
		 * 最小化窗口
		 * */
		public static const MINI_WINDOWN:int = 12;
	
		/**
		 * 显示涂鸦背景的纹理
		 * */
		public static const SHOW_WENLI:int = 13;
		
		/**
		 * 复制黑板
		 * */
		public static const COPY_BLACKBOARD:int = 14;
		
		/**
		 * 
		 * 撤销
		 */
		public static const CHEXIAO:int=15;
		
		/**
		 * 重做
		 */
		public static const CHONEZUO:int=16;
		
		/**
		 * 双击显示菜单
		 */
		public static const STAGE_DOUBLE_CLICK:int=17;
		/**
		 * 
		 * 
		 */
		public static const SHOW_BUTTON_CONTENT:int = 18;
		/**
		 * 
		 */		
		public static const DRAG_OBJECT:int = 19;
		/**
		 * 
		 * 
		 */		
		public static const DISPLAY_POP:int = 20;
		/**
		 * 弹出媒体
		 */		
		public static const OPP_MEDIA:int = 21;
		
		/**
		 *媒体预览 
		 */	
		public static const MEDIA_PREVIEW:int = 22;
		/**
		 * 
		 * 登录本地文件
		 */		
		public static const LOCAL_FILE:int = 23;
		
		/**
		 * 
		 * U盘模式文件
		 */		
		public static const UDISK_FILE:int = 24;
		/**
		 * 
		 * 切换课程
		 */
		public static const	SELECT_LESSON_CLASS:int =25;
		/**
		 * 
		 * 素材预览 
		 */		
		public static const MEDIA_YULAN:int = 26;
		/**
		 * 
		 * 卡片点击全屏
		 */
		public static const IS_FULL:int = 27;
		
		/**
		 * 
		 * 显示正在加载REs
		 */
		public static const SHOW_LOADING:int = 28;
		
		/**
		 * 
		 * 历史记录
		 */
		public static const HOSTORY:int = 29;
		/**
		 * 显示和隐藏最上层的按钮 
		 * 
		 */		
		public static const HIDE_SHOW_MENU:int = 30;
		/**
		 * 
		 * 拍照弹出卡片 
		 */		
		public static const OPP_CAMERA:int = 31;
		/**
		 * 
		 * 摄像头拍照
		 */	
		public static const CAMERA_VIDEO_LUZHI:int = 32;
		/**
		 * 
		 * 打开时钟
		 */
		public static const OPEN_CLOCK:int = 33;
		/**
		 * 打开本地文件 
		 */		
		public static const OPEN_LOCAL_FILE:int = 34;
		/**
		 * 
		 *涂鸦结束  
		 */		
		public static const TUYA_END:int = 35;
		/**
		 * 
		 * 弹出卡片最小化
		 */
		public static const MIN_DIS_THUMB:int =36;
		/**
		 * 
		 * 删除弹出来的卡片
		 */
		public static const REMOVE_DISPLAY:int = 37;
		/**
		 * 
		 *涂鸦开始
		 */		
		public static const TUYA_BEGIN:int = 38;
		/**
		 * 
		 * 幻灯模式
		 */		
		public static const HUANDENGMODEL:int = 39;
		/**
		 * 打开素材
		 */		
		public static const OPEN_MEDIA:int = 40;
		/**
		 *卡片处理完成 
		 */		
		public static const COMPLETE_MEDIA:int = 41;
		
		public static const APP_DATA_LOADING:int = 42;
		
		/**
		 * 打开计算器
		 */
		public static const OPEN_JISUANQI:int = 43;
		
		public static const OPEN_GONGJULAN:int = 44;
		/**
		 *设置偏好设置 
		 */		
		public static const PIANHAO_SETTING:int = 45;
		/**
		 *绘制图形 
		 */		
		public static const DRAW_SHAPE:int = 46;
		/**
		 *填充图形 
		 */		
		public static const DRAW_SHAPE_FILL:int = 47;
		/**
		 *绘制图形结束 
		 */		
		public static const DRAW_SHAPE_END:int = 48;
		/**
		 * 
		 * 打开数学工具
		 */
		public static const SHUXUE_GONGJU:int = 49;
		/**
		 *数学工具绘制结束 
		 */		
		public static const SHUXUE_GONGJU_END:int = 50;
		
		/**
		 *切换成手机模式 
		 */		
		public static const CHANGE_PHONE_MODEL:int = 51;
		
		/**
		 *切换成IPTID模式 
		 */	
		public static const CHANGE_IPTID_MODEL:int = 52;
		
		/**
		 *每次加载不同的课程时  切换小黑板问题
		 */	
		public static const CHANGE_SMALLBOARD:int =53;
		
		/**
		 * 读取教案
		 */		
		public static const READ_JIAOAN:int = 54;
		/**
		 * 最小化窗口
		 */		
		public static const MAX_WINDOW:int = 55;
		/**
		 *同步按钮 当切换到手机模式的时候 锁定按钮同步
		 */		
		public static const TONGBU_BTN:int = 56;
		
		/**
		 * 
		 * u盘接入后 在此读取数据
		 */
		public static const RE_LOGIN:int = 57;
		/**
		 * 开始截图
		 */		
		public static const START_SHOTSCREEN:int = 58;
		
//		public static const SHOW_TRACE:int = 59;
		/**
		 * 数据互拷  将本地的课件导入到移动盘  或者将移动盘的课件转到本地
		 */		
		public static const COPY_DATA:int = 60;
		/**
		 *显示加载等待条 
		 */		
		public static const HIDE_LOADING:int = 61;
		/**
		 * 打开探照灯
		 */		
		public static const OPEN_TANZHAODENG:int = 62;
		/**
		 * 关闭探照灯
		 */		
		public static const CLOSE_TANZHAODENG:int = 63;
		/**
		 * 关闭荧光笔
		 */		
		public static const CLOSE_YINGGUANGBI:int = 64;
		/**
		 *打开荧光笔 
		 */		
		public static const OPEN_YINGGUANGBI:int = 65;
		
		public static const REMOVE_PHONEUSER:int = 66;
		
		public static const SAVE_ALL:int = 67;
		
		public static const SOCKET_SHIBAI:int = 68;
		
		public static const SETTINGENVIR_COMPLETE:int = 69;
		
		public static const SETTING_ENVIR:int = 70;
		public static const SETTING_APP:int = 71;
		public static const ZIDONG_CHANGELESSON:int = 72;
		public static const CLEAR_SYSTEMMEMORY:int = 73;
		public static const HUANDENGMODEL_CLOSELUCK:int = 74;
		/**
		 * 添加第三方上传的文件 
		 */		
		public static const ADD_GHONEMEDIA:int = 75;
		/**
		 * 幻灯模式手机控制换页 
		 */		
		public static const HUANDENG_PAGEMOVE:int = 76;
		/**
		 * 隐藏小黑板 
		 */		
		public static const HIDE_SMALLBOARDBUTTON:int = 77;
		/**
		 *打开不是图片视频意外用系统自带方式打开的文件 
		 */		
		public static const OPEN_FILE:int = 78;
		
		/**
		 * 投票结束
		 */		
		public static const VOTE_END:int = 79;
		
		public function NotificationIDs();
		{
			
		}
	}
}