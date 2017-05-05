package com.lylib.air
{
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	public class ShutdownCommand extends NativeCommand
	{
		
		public function ShutdownCommand()
		{
			super();
			
			this.exeFile = new File("c:/windows/system32/shutdown.exe");
		}
		
		/**
		 * 关机
		 * @param seconds	倒计时 
		 */
		public function shutdown(seconds:int=0):void{
			var cmd:Vector.<String>=new Vector.<String>;
			cmd.push(instr+"s");
			cmd.push(instr+"t");
			cmd.push(seconds);
			runCmd(cmd);
		}
		
		
		/**
		 * 重启
		 * @param seconds	倒计时
		 */
		public function reset(seconds:int=0):void{
			var cmd:Vector.<String>=new Vector.<String>;
			cmd.push(instr+"r");
			cmd.push(instr+"t");
			cmd.push(seconds);
			runCmd(cmd);
		}
		
		/**
		 * 取消重启或者关机命令
		 */
		public function abort():void{
			var cmd:Vector.<String>=new Vector.<String>;
			cmd.push(instr+"a");
			runCmd(cmd);
		}
		
		private function get instr():String{
			switch(Capabilities.os){
				case "Windows 2000":
				case "Windows XP":
					return "-";
			}
			return "/";
		}
	}
}