package com.Xenon3D.Parsers
{
	
	import com.Xenon3D.geometry.X3MeshAttributes;
	import com.Xenon3D.geometry.X3MeshList;
	import com.Xenon3D.math.X3Color;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class X3AsynchParsingWorker extends Sprite
	{
		
		/**
		 *RECEIVE JOB FORMATS:
		 *====================
		 * 
		 * - STL Job:
		 * ----------
		 * * (u32) 0xFA 0x00 0x00 0x01  // Header
		 * * (u8) [Flags]               // Job flags
		 * * (u32) [Default color]      // Default color ( AARRGGBB )
		 * * (u8) [Mesh attribs length] // Number of Mesh Attributes
		 * * * (utf-string) [name]      // Mesh attribute name
		 * * * (u8) [Type]              // Mesh attribute type
		 * * (utf-string) [colRGBA]     // Color RGBA Attrib name
		 * * (utf-string) [colRGB]      // Color RGB Attrib name
		 * * (utf-string) [norm]        // Normal Attrib name
		 * * (utf-string) [pos]         // Position Attrib name
		 * * (u32) [length value]       // STL File size
		 * * (u8[]) Data...             // STL Data
		 *
		 * 
		 **/
		
		/**
		 *SUBMIT RESULT FORMATS:
		 *======================
		 * 
		 * - STL Job:
		 * ----------
		 * * (u32) 0xFA 0x00 0x00 0x01  // Header
		 * * (u32) [Mesh count]         // Number of meshes returned by parser.
		 * * * (u32) [VData size]       // Amount of Vertex Data
		 * * * (f32[]) [VData]          // Vertex data
		 * * * (u32) [IData size]       // Amount of Index Data
		 * * * (f32[]) [IData]          // Index data
		 **/
		
		private var wtom:MessageChannel;
		private var mtow:MessageChannel;
		
		private var shmm:ByteArray;
		
		private var thsw:Worker;
		
		public function X3AsynchParsingWorker ()
		{
			
			super();
			
			thsw = Worker.current;
			
			wtom = thsw.getSharedProperty ( X3AsynchParserMessages.WORKER_TO_MAIN_CHANNEL );
			mtow = thsw.getSharedProperty ( X3AsynchParserMessages.MAIN_TO_WORKER_CHANNEL );
			shmm = thsw.getSharedProperty ( X3AsynchParserMessages.SHARED_MEMORY );
			
			mtow.addEventListener ( Event.CHANNEL_MESSAGE, OnReceive );
			
			wtom.send ( X3AsynchParserMessages.MESSAGE_READY );
			
		};
		
		private final function OnReceive ( E:Event ) : void
		{
			
			var Message:String = mtow.receive ( false );
			if ( Message == null )
				return;
			
			trace ( "AIRECEIVE: " + Message );
			
			switch ( Message )
			{
				
				case X3AsynchParserMessages.MESSAGE_JOB_SUBMIT:
					
					DoJob ();
					
					break;
				
			};
			
		};
		
		private final function DoJob () : void
		{
			
			trace ( "DOJOB" );
			
			shmm.position = 0;
			shmm.endian = Endian.LITTLE_ENDIAN;
			var JobHeader:uint = shmm.readUnsignedInt ();
			
			switch ( JobHeader )
			{
				
				case X3AsynchParserMessages.JOB_HEADER_STL:
					
					DoSTLJob ();
					
					break;
				
				default:
					
					shmm.position = 0;
					shmm.endian = Endian.LITTLE_ENDIAN;
					shmm.writeUTF ( "ERROR: Job header corrupt." );
					
					wtom.send ( X3AsynchParserMessages.MESSAGE_ERROR );
					
					break;
				
			}
			
		};
		
		private final function DoSTLJob () : void
		{
			
			trace ( "DOSTL" );
			
			var flags:uint = shmm.readUnsignedByte ();
			
			var defaultColor:X3Color = new X3Color ();
			defaultColor.SetU32 ( shmm.readUnsignedInt () );
			
			var meshAttribs:X3MeshAttributes = new X3MeshAttributes ();
			
			var meshAttribsLength:uint = shmm.readUnsignedByte ();
			
			for ( var i:uint = 0; i < meshAttribsLength; i ++ )
			{
				
				var meshAttribName:String = shmm.readUTF ();
				var meshAttribType:uint = shmm.readUnsignedByte ();
				
				meshAttribs.AddAttribute ( meshAttribName, meshAttribType );
				
			};
			
			var colorRGBAAttrib:String = shmm.readUTF ();
			var colorRGBAttrib:String = shmm.readUTF ();
			var normalAttrib:String = shmm.readUTF ();
			var positionAttrib:String = shmm.readUTF ();
			
			var size:uint = shmm.readUnsignedInt ();
			
			var Parser:X3STLParser = new X3STLParser ( flags, defaultColor );
			
			Parser.LoadSTL ( shmm, shmm.position );
			
			Parser.SetMeshAttributes ( meshAttribs );
			
			Parser.SetColorRGBAAttributeName ( colorRGBAAttrib );
			Parser.SetColorRGBAttributeName ( colorRGBAttrib );
			Parser.SetNormalAttributeName ( normalAttrib );
			Parser.SetPositionAttributeName ( positionAttrib );
			
			try
			{
				
				if ( Parser.Parse () )
				{
					
					var meshes:X3MeshList = Parser.GetMeshList ();
					
					shmm.position = 0;
					shmm.endian = Endian.LITTLE_ENDIAN;
					
					shmm.writeUnsignedInt ( X3AsynchParserMessages.JOB_HEADER_STL );
					shmm.writeUnsignedInt ( meshes.meshCount );
					
					for ( i = 0; i < meshes.meshCount; i ++ )
					{
						
						shmm.writeUnsignedInt ( meshes.meshes [ i ].vertex.length );
						
						for ( var mv:uint = 0; mv < meshes.meshes [ i ].vertex.length; mv ++ )
							shmm.writeFloat ( meshes.meshes [ i ].vertex [ mv ] );
						
						shmm.writeUnsignedInt ( meshes.meshes [ i ].index.length );
						
						for ( var mi:uint = 0; mi < meshes.meshes [ i ].index.length; mi ++ )
							shmm.writeUnsignedInt ( meshes.meshes [ i ].index [ mi ] );
						
					}
					
					wtom.send ( X3AsynchParserMessages.MESSAGE_JOB_DONE );
					return;
					
				}
				else
				{
					
					shmm.position = 0;
					shmm.endian = Endian.LITTLE_ENDIAN;
					shmm.writeUTF ( "ERROR: Parse failed." );
					
					wtom.send ( X3AsynchParserMessages.MESSAGE_ERROR );
					
					return;
					
				}
				
			}
			catch ( E:Error )
			{
				
				shmm.position = 0;
				shmm.endian = Endian.LITTLE_ENDIAN;
				shmm.writeUTF ( "ERROR: Parse failed." );
				
				wtom.send ( X3AsynchParserMessages.MESSAGE_ERROR );
				
				return;
				
			}
			
		};
		
	};
	
};