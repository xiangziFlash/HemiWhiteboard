package com.lylib.codec
{
	import flash.utils.ByteArray;

	public class ID3V23Parser
	{
		private var _frames:Array = ["AENC","APIC", "COMM", "COMR", "ENCR", "EQUA", "ETCO", "GEOB",
									 "GRID", "IPLS", "LINK", "MCDI", "MLLT", "OWNE", "PRIV", "PCNT",
									 "POPM", "POSS", "RBUF", "RVAD", "RVRB", "SYLT", "SYTC", "TALB",
									 "TBPM", "TCOM", "TCON", "TCOP", "TDAT", "TDLY", "TENC", "TEXT",
									 "TFLT", "TIME", "TIT1", "TIT2", "TIT3", "TLAN", "TLEN", "TMED",
									 "TOAL", "TOFN", "TOLY", "TOPE", "TORY", "TOWN", "TPE1", "TPE2",
									 "TPE3", "TPE4", "TPOS", "TPUB", "TRCK", "TRDA", "TRSN", "TRSO",
									 "TSIZ", "TSRC", "TSSE", "TYER", "TXXX", "UFID", "USER", "USLT",
									 "WCOM", "WCOP", "WOAF", "WOAR", "WOAS", "WORS", "WPAY", "WPUB",
									 "WXXX"];
		private var _frameID:String="";
		private var _frameLength:uint;
		
		private var _fileData:ByteArray;
		private var _apic:ByteArray=new ByteArray();
		
		private var _ver:int;			//版本号 ID3V2.3 就记录 3
		private var _revision:int;		//副版本号
		private var _size:int;			//标签大小,包括标签头的 10 个字节和所有的标签帧的大小
		
		public function ID3V23Parser(fileData:ByteArray)
		{
			_fileData = fileData;
		}
		
		public function parse():void{
			
			_fileData.position = 0;
			
			//判断是否存在ID3标签
			if(hasID3())
			{
				//标签头
				_ver = _fileData.readByte();
				_revision = _fileData.readByte();
				_fileData.position = 6;
				_size = (_fileData.readUnsignedByte()&0x7f) * 0x200000 +
						(_fileData.readUnsignedByte()&0x7f) * 0x400 +
						(_fileData.readUnsignedByte()&0x7f) * 0x80 +
						(_fileData.readUnsignedByte()&0x7f);
				
				if(_ver!=3){
					trace("不支持ID3V2."+_ver);
					return;
				}
				
				//继续读4个字节，检测是否会读到帧标识
				_fileData.position = 10;
				_frameID = _fileData.readMultiByte(4,"us-ascii");
				
				if(_frames.indexOf(_frameID)>0)
				{
					_fileData.position = 10;
				}else
				{
					_fileData.position = 10;
					var length:uint = _fileData.readUnsignedInt();
					_fileData.position += length;
				}
				
				findAPIC();
			}
			else
			{
				trace("不存在ID3标签");
			}
		}
		
		/**
		 * 判断是否存在ID3标签
		 * @return 
		 */		
		private function hasID3():Boolean
		{
			_fileData.position = 0;
			if(_fileData.readMultiByte(3,"us-ascii")=="ID3")
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function findAPIC():void
		{
			_apic.clear();
			_frameID = _fileData.readMultiByte(4,"utf-8");
			if(_frameID!="APIC")
			{
				_frameLength = _fileData.readUnsignedInt() + 2;
				_fileData.position += _frameLength;
				
				if(_fileData.position<_size){
					findAPIC();
				}
				else
				{
					trace("没有发现APIC");
					return;
				}
			}
			else
			{
				//trace("发现APIC");
				_frameLength = _fileData.readUnsignedInt();
				
				_fileData.position += 2;
				var i:int;
				for(i=0; i<128; i++)
				{
					var b:uint = _fileData.readUnsignedShort()
					//trace("---",b.toString(16));
					if(b==0xffd8)
					{
						_fileData.position -= 2;
						_fileData.readBytes(_apic, 0, _frameLength-i);
						break;
					}
					else
					{
						_fileData.position -= 1;
					}
				}
				
			}
		}

		
		/**
		 * 专辑封面
		 */		
		public function get apic():ByteArray
		{
			return _apic;
		}
		
		
	}
}