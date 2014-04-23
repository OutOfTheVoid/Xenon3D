package com.Xenon3D.geometry
{
	
	public class X3MeshAttributes
	{
		
		private var attribs:Vector.<MeshAttribute>;
		
		public function X3MeshAttributes ()
		{
			
			attribs = new Vector.<MeshAttribute> ();
			
		};
		
		public function AddAttribute ( Name:String, Type:uint ) : void
		{
			
			var attribute:MeshAttribute = new MeshAttribute ();
			attribute.name = Name;
			attribute.type = Type;
			
			attribs.push ( attribute );
			
		};
		
		public function IndexOfAttribute ( Name:String, Type:uint ) : int
		{
			
			for ( var i:uint = 0; i < attribs.length; i ++ )
				if ( attribs [ i ].name == Name && attribs [ i ].type == Type )
					return i;
			
			return -1;
			
		};
		
		public function GetNumberOfAttributes () : uint
		{
			
			return attribs.length;
			
		};
		
		public function GetVertexSize () : uint
		{
			
			var size:uint = 0;
			
			for ( var i:uint = 0; i < attribs.length; i ++ )
				size += GetAttributeTypeSize ( attribs [ i ].type );
			
			return size;
			
		};
		
		public function GetVertexSizeBeforeAttribute ( Index:uint ) : uint
		{
			
			var size:uint = 0;
			
			for ( var i:uint = 0; ( i < attribs.length ) && ( i < Index ); i ++ )
				size += GetAttributeTypeSize ( attribs [ i ].type );
			
			return size;
			
		};
		
		public function GetAttributeType ( Index:uint ) : uint
		{
			
			return attribs [ Index ].type;
			
		};
		
		public function GetAttributeName ( Index:uint ) : String
		{
			
			return attribs [ Index ].name;
			
		};
		
		public function Clear () : void
		{
			
			attribs.splice ( 0, attribs.length );
			
		};
		
		public static function GetAttributeTypeSize ( Type:uint ) : uint
		{
			
			switch ( Type )
			{
				
				case X3VertexTypes.VTYPE_VEC1:
				case X3VertexTypes.VTYPE_BYTE4:
					
					return 1;
					
					break;
				
				case X3VertexTypes.VTYPE_VEC2:
					
					return 2;
					
					break;
				
				case X3VertexTypes.VTYPE_VEC3:
					
					return 3;
					
					break;
				
				case X3VertexTypes.VTYPE_VEC4:
					
					return 4;
					
					break;
				
			}
			
			return 0;
			
		};
		
	};
	
};

class MeshAttribute
{
	
	public var name:String;
	public var type:uint;
	
};