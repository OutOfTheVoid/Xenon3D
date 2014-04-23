package com.Xenon3D.rendering
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.VertexBuffer3D;
	
	import com.Xenon3D.geometry.X3VertexTypes;
	
	public class X3VertexFormat
	{
		
		public static const NUMVECTOR_TYPE:uint = 0;
		public static const BYTEARRAY_TYPE:uint = 1;
		
		private var mode:uint;
		private var size:uint;
		private var nodes:uint;
		
		private var vtlist:Vector.<uint>;
		
		public function X3VertexFormat ( Type:uint )
		{
			
			mode = Type;
			
			vtlist = new Vector.<uint> ();
			size = 0;
			nodes = 0;
			
		};
		
		public function AddVertexType ( Type:uint, Register:uint, BufferOffset:uint ) : void
		{
			
			if ( ( Type & ( X3VertexTypes.VTYPE_VEC1 | X3VertexTypes.VTYPE_VEC2 | X3VertexTypes.VTYPE_VEC3 | X3VertexTypes.VTYPE_VEC4 ) ) == 0 && mode == NUMVECTOR_TYPE )
				throw new Error ( "VertexFormat Error: Attempted to assign Non Vector type to NumberVector type Vertex Format", 0 );
			if ( ( Type & X3VertexTypes.VTYPE_BYTE4 ) == 0 && mode == BYTEARRAY_TYPE )
				throw new Error ( "VertexFormat Error: Attempted to assign Non Byte4 type to ByteArray type Vertex Format.", 0 );
			
			vtlist.push ( Type, Register, BufferOffset );
			
			if ( mode == NUMVECTOR_TYPE )
			{
				
				switch ( Type )
				{
					
					case X3VertexTypes.VTYPE_VEC1:
						size ++;
						break;
					
					case X3VertexTypes.VTYPE_VEC2:
						size += 2;
						break;
					
					case X3VertexTypes.VTYPE_VEC3:
						size += 3;
						break;
					
					case X3VertexTypes.VTYPE_VEC4:
						size += 4;
						break;
					
				}
				
			}
			else
				size += 1;
			
			nodes ++;
			
		};
		
		public function ApplyVertexBuffer ( Context:Context3D, Buffer:VertexBuffer3D ) : void
		{
			
			for ( var i:uint = 0; i < nodes; i ++ )
				Context.setVertexBufferAt ( vtlist [ i * 3 + 1 ], Buffer, vtlist [ i * 3 + 2 ], GetFormatString ( vtlist [ i * 3 ] ) );
			
		};
		
		public function UnApplyVertexBuffer ( Context:Context3D ) : void
		{
			
			for ( var i:uint = 0; i < nodes; i ++ )
				Context.setVertexBufferAt ( vtlist [ i * 3 + 1 ], null );
			
		};
		
		public function GetType () : uint
		{
			
			return mode;
			
		};
		
		public function GetVectorSize () : uint
		{
			
			if ( mode != NUMVECTOR_TYPE )
				throw new Error ( "VertexFormat Error: Attempted to attain vector size of a byte format." );
			
			return size;
			
		};
		
		public function GetWordSize () : uint
		{
			
			if ( mode != BYTEARRAY_TYPE )
				throw new Error ( "VertexFormat Error: Attempted to attain byte size of a vertex format." );
			
			return size;
			
		};
		
		public function ToString () : String
		{
			
			var st:String = "Vertex Format: \n";
			
			for ( var i:uint = 0; i < nodes; i ++ )
				st += "va" + vtlist [ i * 3 + 1 ].toString () + ": " + GetFormatString ( vtlist [ i * 3 ] ) + " @ " + vtlist [ i * 3 + 2 ].toString () + "\n";
			
			return st;
			
		};
		
		private static function GetFormatString ( Type:uint ) : String
		{
			
			switch ( Type )
			{
				
				case X3VertexTypes.VTYPE_VEC1:
					return Context3DVertexBufferFormat.FLOAT_1;
				
				case X3VertexTypes.VTYPE_VEC2:
					return Context3DVertexBufferFormat.FLOAT_2;
				
				case X3VertexTypes.VTYPE_VEC3:
					return Context3DVertexBufferFormat.FLOAT_3;
				
				case X3VertexTypes.VTYPE_VEC4:
					return Context3DVertexBufferFormat.FLOAT_4;
				
				case X3VertexTypes.VTYPE_BYTE4:
					return Context3DVertexBufferFormat.BYTES_4;
				
			}
			
			throw new Error ( "VertexFormat Internal Error: FormatString not indexed." );
			
			return null;
			
		};
		
	};
	
};