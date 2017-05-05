package com.lylib.air
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;

	/**
	 * 表示 NativeProcess 已关闭其错误流。
	 */
	[Event(name="standardErrorClose", type="flash.events.Event")]
	
	/**
	 * 指出 NativeProcess 对象已通过调用 closeInput() 方法关闭其输入流。
	 */
	[Event(name="standarInputClose", type="flash.events.Event")]
	
	/**
	 * 表示 NativeProcess 已关闭其输出流。
	 */
	[Event(name="standardOutputClose", type="flash.events.Event")]
	
	/**
	 * 表示从标准错误 (stderror) 流进行读取已失败。
	 */
	[Event(name="standardErrorIoError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 表示写入标准输入 (stdin) 流已失败。
	 */
	[Event(name="standardInputIoError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 表示从 stdout 流进行读取已失败。
	 */
	[Event(name="standardOutputIoError", type="flash.events.IOErrorEvent")]
	
	/**
	 * 表示本机进程已退出。
	 */
	[Event(name="exit", type="flash.events.NativeProcessExitEvent")]
	
	/**
	 * 表示标准错误 (stderror) 流上存在本机进程可以读取的数据。
	 */
	[Event(name="standardErrorData", type="flash.events.ProgressEvent")]
	
	/**
	 * 表示 NativeProcess 已经向子进程的输入流写入数据。
	 */
	[Event(name="standardInputProcess", type="flash.events.ProgressEvent")]
	
	/**
	 * 表示输出流上存在本机进程可以读取的数据。
	 */
	[Event(name="standardOutputData", type="flash.events.ProgressEvent")]
	
	
	/**
	 * 此类对本机命令程序进行封装，你可以通过runCmd方法来隐藏执行一条系统命令
	 * @author Administrator
	 *
	 */
	public class NativeCommand extends EventDispatcher
	{

		private var _process:NativeProcess;
		private var _exeFile:File;
	
		public function NativeCommand()
		{
			_process = new NativeProcess();
			process.addEventListener(Event.STANDARD_ERROR_CLOSE, this.process_standardErrorCloseHandler);
			process.addEventListener(Event.STANDARD_INPUT_CLOSE, this.process_standarInputCloseHandler);
			process.addEventListener(Event.STANDARD_OUTPUT_CLOSE, this.process_standardOutputCloseHandler);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, this.process_standardErrorIoErrorHandler);
			process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, this.process_standardInputIoErrorHandler);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, this.process_standardOutputIoErrorHandler);
			process.addEventListener(NativeProcessExitEvent.EXIT, this.process_exitHandler);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, this.process_standardErrorDataHandler);
			process.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, this.process_standardInputProcessHandler);
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, this.process_standardOutputDataHandler);
			return;
		}
		
		
		/**
		 * 启动一个可执行文件，并侦听文件的状态
		 * @param file		可执行文件
		 * @param args		参数列表
		 * 
		 */
		public function exec(file:File, args:Vector.<String>=null):void
		{
			if(file == null || !file.exists){
				return;
			}
			if (args == null)
			{
				args=new Vector.<String>;
			}
			var arguments:NativeProcessStartupInfo=new NativeProcessStartupInfo();
			arguments.executable=file;
			arguments.arguments=args;
			
			this.process.start(arguments);
			return;
		}


		/**
		 * 执行一条系统命令 
		 * @param args		参数列表
		 */		
		public function runCmd(args:Vector.<String>):void
		{
			this.exec(_exeFile, args);
			return;
		}
			
		
		/**
		 * 取得此命令所关联的本机进程对象
		 * @return
		 */
		public function get process():NativeProcess
		{
			return _process;
		}

		
		
		/**-------------------------------------handlers----------------------------------------------*/
		
		/**
		 * 表示 NativeProcess 已关闭其错误流。
		 */
		protected function process_standardErrorCloseHandler(event:Event):void{
			dispatchEvent(event);
		}
		
		/**
		 * 指出 NativeProcess 对象已通过调用 closeInput() 方法关闭其输入流。
		 */
		protected function process_standarInputCloseHandler(event:Event):void{
			dispatchEvent(event);
		}
		
		
		/**
		 * 表示 NativeProcess 已关闭其输出流。
		 */
		protected function process_standardOutputCloseHandler(event:Event):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示从标准错误 (stderror) 流进行读取已失败。
		 */
		protected function process_standardErrorIoErrorHandler(event:IOErrorEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示写入标准输入 (stdin) 流已失败。
		 */
		protected function process_standardInputIoErrorHandler(event:IOErrorEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示从 stdout 流进行读取已失败。
		 */
		protected function process_standardOutputIoErrorHandler(event:IOErrorEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示本机进程已退出
		 */
		protected function process_exitHandler(event:NativeProcessExitEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示标准错误 (stderror) 流上存在本机进程可以读取的数据。
		 */
		protected function process_standardErrorDataHandler(event:ProgressEvent):void{
			trace("ERROR -", process.standardError.readMultiByte(process.standardError.bytesAvailable,"cn-gb")); 
			dispatchEvent(event);
		}
		
		/**
		 * 表示 NativeProcess 已经向子进程的输入流写入数据。
		 */
		protected function process_standardInputProcessHandler(event:ProgressEvent):void{
			dispatchEvent(event);
		}
		
		/**
		 * 表示 NativeProcess 表示输出流上存在本机进程可以读取的数据。
		 */
		protected function process_standardOutputDataHandler(event:ProgressEvent):void{
			dispatchEvent(event);
		}

		
		/**
		 * 要启动的可执行文件
		 * @return 
		 */		
		public function get exeFile():File
		{
			return _exeFile;
		}
		public function set exeFile(value:File):void
		{
			_exeFile = value;
		}

	}
}