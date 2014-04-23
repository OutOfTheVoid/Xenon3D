package com.Xenon3D.Parsers
{
	import com.Xenon3D.math.X3Color;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import com.Xenon3D.geometry.X3CommonMeshAttributes;
	import com.Xenon3D.geometry.X3Mesh;
	import com.Xenon3D.geometry.X3MeshAttributes;
	import com.Xenon3D.geometry.X3MeshList;
	import com.Xenon3D.geometry.X3VertexTypes;
	
	public class X3STLParser
	{
		
		public static const STL_TYPE_ASCII_FLAG:uint = 1;
		public static const CALC_NORMAL_FLAG:uint = 2;
		public static const SOLIDVIEW_COLOR_ATTRIBUTE_FLAG:uint = 4;
		
		private var dc:X3Color;
		private var flags:uint;
		
		private var data:ByteArray;
		private var doff:uint;
		
		private var loaded:Boolean;
		private var parsed:Boolean;
		
		private var meshlist:X3MeshList;
		
		private var matt:X3MeshAttributes;
		
		private var cattpos:String;
		private var cattnorm:String;
		private var cattcolrgb:String;
		private var cattcolrgba:String;
		
		public function X3STLParser ( Flags:uint, DefaultColor:X3Color = null )
		{
			
			dc = new X3Color ( 1, 1, 1, 1 );
			
			if ( DefaultColor != null )
				dc.Mirror ( DefaultColor );
			
			flags = Flags;
			
			loaded = false;
			parsed = false;
			
			cattpos = X3CommonMeshAttributes.MESH_ATTRIBUTE_POSITION;
			cattnorm = X3CommonMeshAttributes.MESH_ATTRIBUTE_NORMAL;
			cattcolrgb = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORRGB;
			cattcolrgba = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORRGBA;
			
		};
		
		public function LoadSTL ( STL:ByteArray, Offset:uint = 0 ) : Boolean
		{
			
			loaded = false;
			parsed = false;
			
			if ( STL == null )
				return false;
			
			if ( ( flags & STL_TYPE_ASCII_FLAG ) == 0 )
			{
				
				if ( STL.length - Offset < 84 )
					return false;
				
			}
			else 
				return false;
			// (No ascii support as of yet!)
			
			
			data = STL;
			doff = Offset;
			
			loaded = true;
			
			return true;
			
		};
		
		public function SetPositionAttributeName ( Name:String ) : void
		{
			
			cattpos = Name;
			
		};
		
		public function SetNormalAttributeName ( Name:String ) : void
		{
			
			cattnorm = Name;
			
		};
		
		public function SetColorRGBAttributeName ( Name:String ) : void
		{
			
			cattcolrgb = Name;
			
		};
		
		public function SetColorRGBAAttributeName ( Name:String ) : void
		{
			
			cattcolrgba = Name;
			
		};
		
		public function SetMeshAttributes ( MeshAttributes:X3MeshAttributes ) : void
		{
			
			matt = MeshAttributes;
			
		};
		
		public function Parse () : Boolean
		{
			
			if ( ! loaded )
				return false;
			
			if ( matt == null )
				return false;
			
			var OutVV:Vector.<Number> = new Vector.<Number> ();
			
			if ( ( flags & STL_TYPE_ASCII_FLAG ) == 0 )
			{
				
				data.position = doff;
				data.endian = Endian.LITTLE_ENDIAN;
				
				var hstring:String = data.readMultiByte ( 80, "us-ascii" );
				var tris:uint = data.readUnsignedInt ();
				
				trace ( "STL File has " + tris.toString () + " triangles. Header data:\n\"" + hstring + "\"" );
				
				var NI:Number;
				var NJ:Number;
				var NK:Number;
				
				var X1:Number;
				var Y1:Number;
				var Z1:Number;
				
				var X2:Number;
				var Y2:Number;
				var Z2:Number;
				
				var X3:Number;
				var Y3:Number;
				var Z3:Number;
				
				var WX:Number;
				var WY:Number;
				var WZ:Number;
				
				var VX:Number;
				var VY:Number;
				var VZ:Number;
				
				var ND:Number;
				
				var ExData:uint;
				
				var CDef:X3Color = new X3Color ();
				
				for ( var i:uint = 0; i < tris; i ++ )
				{
					
					NI = data.readFloat ();
					NJ = data.readFloat ();
					NK = data.readFloat ();
					
					X1 = data.readFloat ();
					Y1 = data.readFloat ();
					Z1 = data.readFloat ();
					
					X2 = data.readFloat ();
					Y2 = data.readFloat ();
					Z2 = data.readFloat ();
					
					X3 = data.readFloat ();
					Y3 = data.readFloat ();
					Z3 = data.readFloat ();
					
					if ( ( flags & CALC_NORMAL_FLAG ) != 0 )
					{
						
						WX = X2 - X1;
						WY = Y2 - Y1;
						WZ = Z2 - Z1;
						
						VX = X3 - X1;
						VY = Y3 - Y1;
						VZ = Z3 - Z1;
						
						NI = ( VY * WZ ) - ( VZ * WY );
						NJ = ( VZ * WX ) - ( VX * WZ );
						NK = ( VX * WY ) - ( VY * WX );
						
						ND = Math.sqrt ( NI * NI + NJ * NJ + NK * NK );
						
						NI /= ND;
						NJ /= ND;
						NK /= ND;
						
					}
					
					ExData = data.readUnsignedShort ();
					
					if ( ( flags & SOLIDVIEW_COLOR_ATTRIBUTE_FLAG ) != 0 )
					{
						
						if ( ExData >= 2 )
						{
							
							var cdata:uint = data.readUnsignedShort ();
							ExData -= 2;
							
							if ( ( cdata & 0x80 ) == 1 )
							{
								
								CDef.a = 1;
								CDef.r = ( ( cdata & 0x1F ) as Number ) / ( 0x1F as Number );
								CDef.r = ( ( ( cdata & 0x3E0 ) >> 5 ) as Number ) / ( 0x1F as Number );
								CDef.r = ( ( ( cdata & 0x7C00 ) >> 10 ) as Number ) / ( 0x1F as Number );
							
							}
							else
								CDef.Mirror ( dc );
							
						}
						else
							CDef.Mirror ( dc );
						
					}
					else
						CDef.Mirror ( dc );
					
					data.position += ExData;
					
					for ( var a:uint = 0; a < matt.GetNumberOfAttributes (); a ++ )
					{
						
						switch ( matt.GetAttributeName ( a ) )
						{
							
							case cattpos:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( X1, Y1, Z1 );
								else
									return false;
								
								break;
							
							case cattnorm:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( NI, NJ, NK );
								else
									return false;
								
								break;
							
							case cattcolrgb:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( CDef.r, CDef.g, CDef.b );
								else
									return false;
								
								break;
							
							case cattcolrgba:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( CDef.r, CDef.g, CDef.b, CDef.a );
								else
									return false;
								
								break;
							
							default:
								return false;
							
						}
						
					}
					
					for ( a = 0; a < matt.GetNumberOfAttributes (); a ++ )
					{
						
						switch ( matt.GetAttributeName ( a ) )
						{
							
							case cattpos:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( X2, Y2, Z2 );
								else
									return false;
								
								break;
							
							case cattnorm:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( NI, NJ, NK );
								else
									return false;
								
								break;
							
							case cattcolrgb:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( CDef.r, CDef.g, CDef.b );
								else
									return false;
								
								break;
							
							case cattcolrgba:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( CDef.r, CDef.g, CDef.b, CDef.a );
								else
									return false;
								
								break;
							
							default:
								return false;
								
						}
						
					}
					
					for ( a = 0; a < matt.GetNumberOfAttributes (); a ++ )
					{
						
						switch ( matt.GetAttributeName ( a ) )
						{
							
							case cattpos:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( X3, Y3, Z3 );
								else
									return false;
								
								break;
							
							case cattnorm:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( NI, NJ, NK );
								else
									return false;
								
								break;
							
							case cattcolrgb:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( CDef.r, CDef.g, CDef.b );
								else
									return false;
								
								break;
							
							case cattcolrgba:
								
								if ( matt.GetAttributeType ( a ) == X3VertexTypes.VTYPE_VEC3 )
									OutVV.push ( CDef.r, CDef.g, CDef.b, CDef.a );
								else
									return false;
								
								break;
							
							default:
								return false;
								
						}
						
					}
					
				}
				
				var MeshCount:uint = Math.ceil ( tris /  21845 );
				var MVect:Vector.<X3Mesh> = new Vector.<X3Mesh> ( MeshCount, true );
				
				var VOff:uint = 0;
				
				var vsize:uint = matt.GetVertexSize ();
				
				for ( var m:uint = 0; m < MeshCount; m ++ )
				{
					
					var MTris:uint = ( tris <  21845 ) ? tris :  21845;
					
					var MVData:Vector.<Number> = OutVV.slice ( VOff, VOff + MTris * 3 * vsize );
					var MIData:Vector.<uint> = new Vector.<uint> ( MTris * 3, true );
					for ( var vi:uint = 0; vi < MTris * 3; vi ++ )
						MIData [ vi ] = vi;
					
					tris -= MTris;
					VOff += MTris * 3 * vsize;
					
					MVect [ m ] = new X3Mesh ( matt, MVData, MIData );
					
				}
				
				meshlist = new X3MeshList ( matt, MVect );
				
				return true;
				
			}
			else
			{
				// ASCII
				
				data.position = doff;
				data.endian = Endian.LITTLE_ENDIAN;
				
				// quick and dirty for now...
				
				
			}
			
			
			parsed = false;
			return false;
			
		};
		
		public function GetMeshList () : X3MeshList
		{
			
			return meshlist;
			
		}
		
	};
	
};