package com.views.components
{
	import com.controls.ToolKit;
	
	import flash.display.Sprite;
	import flash.events.DatagramSocketDataEvent;
	import flash.net.DatagramSocket;
	import flash.utils.ByteArray;
	
	/**
	 * @author XiangZi
	 * @E-mail: [email=995435501@qq.com][/email]
	 * 创建时间：2016-4-15 上午10:52:40
	 * 
	 */
	public class DatagramSocketComponents extends Sprite
	{
		private var _datagramSocket:DatagramSocket;
		
		public function DatagramSocketComponents()
		{
			initViews();
		}
		
		private function initViews():void
		{
			ToolKit.log("Tool.log");
			_datagramSocket = new DatagramSocket();
			_datagramSocket.bind();
			_datagramSocket.addEventListener( DatagramSocketDataEvent.DATA, dataReceived );
			_datagramSocket.receive();
			
			//send("ip:192.168.3.78");
		}
		
		private function dataReceived( event:DatagramSocketDataEvent ):void
		{
			ToolKit.log(event.data.readUTFBytes( event.data.bytesAvailable )+"dataReceived");
		}
		
		public function send(str:String):void
		{
			//Create a message in a ByteArray
			var data:ByteArray = new ByteArray();
			data.writeUTFBytes( str );
			
			//Send a datagram to the target
			try
			{
				_datagramSocket.send( data, 0, 0, "0.0.0.0", 8989); 
				trace( "Sent message to ", "0.0.0.0", 8989);
			}
			catch ( error:Error )
			{
				trace( error.message );
			}
		}
	}
}