package com.lylib.air
{
	import flash.filesystem.File;

	public class CmdCommand extends NativeCommand
	{
		public function CmdCommand()
		{
			super();
			
			this.exeFile = new File("c:/windows/system32/cmd.exe");
		}
		
		
		/**
		 * 以系统默认方式打开文件
		 * @param filePath
		 * 
		 */		
		public function call(filePath:String, ...args):void
		{
			var cmd:Vector.<String>=new Vector.<String>;
			cmd.push("/c");
			cmd.push(filePath);
			if(args!=null && args.length>0)
			{
				for(var i:int=0; i<args.length; i++)
				{
					cmd.push(args[i]);
				}
			}
			runCmd(cmd);
		}
	}
}