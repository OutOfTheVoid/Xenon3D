package com.Xenon3D.materials
{
	import com.Xenon3D.geometry.X3CommonMeshAttributes;
	import com.Xenon3D.geometry.X3IMeshSpecifier;
	import com.Xenon3D.geometry.X3MeshAttributes;
	import com.Xenon3D.geometry.X3VertexTypes;
	import com.Xenon3D.lighting.X3AmbiantLight;
	import com.Xenon3D.lighting.X3DirectionalLight;
	import com.Xenon3D.lighting.X3PointLight;
	import com.Xenon3D.math.X3Color;
	import com.Xenon3D.math.X3Point;
	import com.Xenon3D.rendering.X3VertexFormat;
	import com.Xenon3D.shaders.X3AGALShaderProgram;
	import com.Xenon3D.shaders.X3IShaderProgram;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	
	public class X3DynamicColorMaterial implements X3IGeometricMaterial, X3IMeshSpecifier
	{
		
		public static const MESH_ATTRIBUTE_COLORA:String = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORA;
		public static const MESH_ATTRIBUTE_COLORRGB:String = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORRGB;
		public static const MESH_ATTRIBUTE_COLORRGBA:String = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORRGBA;
		public static const MESH_ATTRIBUTE_COLORA_TYPE:uint = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORA_TYPE;
		public static const MESH_ATTRIBUTE_COLORRGB_TYPE:uint = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORRGB_TYPE;
		public static const MESH_ATTRIBUTE_COLORRGBA_TYPE:uint = X3CommonMeshAttributes.MESH_ATTRIBUTES_COLORRGBA_TYPE;
		
		public static const MESH_ATTRIBUTE_POSITION:String = X3CommonMeshAttributes.MESH_ATTRIBUTE_POSITION;
		public static const MESH_ATTRIBUTE_POSITION_TYPE:uint = X3CommonMeshAttributes.MESH_ATTRIBUTE_POSITION_TYPE;
		
		public static const MESH_ATTRIBUTE_NORMAL:String = X3CommonMeshAttributes.MESH_ATTRIBUTE_NORMAL;
		public static const MESH_ATTRIBUTE_NORMAL_TYPE:uint = X3CommonMeshAttributes.MESH_ATTRIBUTE_NORMAL_TYPE;
		
		public static const COLOR_FLAG:uint = 1;
		public static const ALPHA_FLAG:uint = 2;
		public static const AMBIANT_FLAT_FLAG:uint = 4;
		public static const DIFFUSE_DIRECTIONAL_FLAG:uint = 8;
		public static const SPECULAR_DIRECTIONAL_FLAG:uint = 8;
		public static const DIFFUSE_POINT_FLAG:uint = 16;
		public static const SPECULAR_POINT_FLAG:uint = 32;
		
		private var flags:uint;
		
		private var r:Number;
		private var g:Number;
		private var b:Number;
		private var a:Number;
		private var c:X3Color;
		
		private var m_p:Matrix3D;
		private var m_trf:Matrix3D;
		private var m_tns:Matrix3D;
		
		private var PointLights:Vector.<X3PointLight>;
		private var DirectionalLights:Vector.<X3DirectionalLight>;
		private var AmbiantLight:X3AmbiantLight;
		
		private var vf:X3VertexFormat;
		private var sh:X3AGALShaderProgram;
		
		private var ma:X3MeshAttributes;
		
		private var psh:String;
		private var vsh:String;
		
		private var cctx:Context3D;
		
		public function X3DynamicColorMaterial ( Flags:uint )
		{
			
			ma = new X3MeshAttributes ();
			
			SetColor ( 0xFFFFFFFF );
			SetFlags ( Flags );
			
			DirectionalLights = new Vector.<X3DirectionalLight> ();
			PointLights = new Vector.<X3PointLight> ();
			
		};
		
		public function GetMeshAttributes () : X3MeshAttributes
		{
			
			return ma;
			
		};
		
		public function SetFlags ( Flags:uint ) : void
		{
			
			flags = Flags;
			
			ma.Clear ();
			
			ma.AddAttribute ( MESH_ATTRIBUTE_POSITION, MESH_ATTRIBUTE_POSITION_TYPE );
			
			if ( ( Flags & COLOR_FLAG ) != 0 )
			{
				
				if ( ( Flags & ALPHA_FLAG ) != 0 )
					ma.AddAttribute ( MESH_ATTRIBUTE_COLORRGBA, MESH_ATTRIBUTE_COLORRGBA_TYPE );
				else
					ma.AddAttribute ( MESH_ATTRIBUTE_COLORRGB, MESH_ATTRIBUTE_COLORRGB_TYPE );
				
			}
			else if ( ( Flags & ALPHA_FLAG ) != 0 )
				ma.AddAttribute ( MESH_ATTRIBUTE_COLORA, MESH_ATTRIBUTE_COLORA_TYPE );
			
			ma.AddAttribute ( MESH_ATTRIBUTE_NORMAL, MESH_ATTRIBUTE_NORMAL_TYPE );
			
		};
		
		public function SetColor ( Color:uint ) : void
		{
			
			r = ( ( Color >> 16 ) & 0xFF ) / 255;
			g = ( ( Color >> 8 ) & 0xFF ) / 255;
			b = ( Color & 0x000000FF ) / 255;
			a = ( ( ( Color >> 24 ) & 0xFF ) as Number ) / 255;
			
		};
		
		public function SetWorldTransform ( Transform:Matrix3D ) : void
		{
			
			m_p = Transform;
			
		};
		
		public function SetModelTransform ( Transform:Matrix3D ) : void
		{
			
			m_trf = Transform;
			
		};
		
		public function SetModelTranslation ( Transform:Matrix3D ) : void
		{
			
			m_tns = Transform;
			
		};
		
		public function AddPointLight ( PointLight:X3PointLight ) : void
		{
			
			if ( PointLights.indexOf ( PointLight ) == -1 )
				PointLights.push ( PointLight );
			
		};
		
		public function RemovePointLight ( PointLight:X3PointLight ) : void
		{
			
			if ( PointLight == null )
				return;
			
			if ( PointLights.indexOf ( PointLight ) != -1 )
				PointLights.splice ( PointLights.indexOf ( PointLight ), 1 );
			
		};
		
		public function AddDirectionalLight ( DirectionalLight:X3DirectionalLight ) : void
		{
			
			if ( DirectionalLight == null )
				return;
			
			if ( DirectionalLights.indexOf ( DirectionalLight ) == -1 )
				DirectionalLights.push ( DirectionalLight );
			
		};
		
		public function RemoveDirectionalLight ( DirectionalLight:X3DirectionalLight ) : void
		{
			
			if ( DirectionalLights.indexOf ( DirectionalLight ) != -1 )
				DirectionalLights.splice ( DirectionalLights.indexOf ( DirectionalLight ), 1 );
			
		};
		
		public function SetAmbiantLight ( AmbiantLight:X3AmbiantLight ) : void
		{
			
			this.AmbiantLight = AmbiantLight;
			
		};
		
		public function Build () : void
		{
			
			var i:uint = 0;
			
			vf = new X3VertexFormat ( X3VertexFormat.NUMVECTOR_TYPE );
			
			vsh = "m44 vt0, va0, vc0\n";
			vsh += "m44 vt0, vt0, vc4\n";
			if ( ( flags & ( DIFFUSE_POINT_FLAG | SPECULAR_POINT_FLAG ) ) != 0 )
			{
				vsh += "// v3 - fragment position in world space\n";
				vsh += "mov v3, vt0\n";
			}
			vsh += "m44 op, vt0, vc8\n";
			psh = "";
			
			vf.AddVertexType ( X3VertexTypes.VTYPE_VEC3, 0, 0 );
			
			if ( ( flags & COLOR_FLAG ) != 0 )
			{
				
				if ( ( flags & ALPHA_FLAG ) != 0 )
				{
					
					vf.AddVertexType ( X3VertexTypes.VTYPE_VEC4, 1, 3 );
					
					vsh += "mov vt0, va1\n";
					
				}
				else
				{
					
					vf.AddVertexType ( X3VertexTypes.VTYPE_VEC3, 1, 3 );
					
					vsh += "mov vt0.rgb, va1.rgb\n";
					vsh += "mov vt0.a, vc127.x\n";
					
				}
				
			}
			else if ( ( flags & ALPHA_FLAG ) != 0 )
			{
				
				vf.AddVertexType ( X3VertexTypes.VTYPE_VEC1, 1, 3 );
				
				vsh += "mov vt0.x, va1.x\n";
				vsh += "mov vt0.yzw, vc127.xxx\n";
				
			}
			else
			{
				
				vsh += "mov vt0.xyzw, vc127.xxxx\n";
				
			}
			
			if ( ( flags & AMBIANT_FLAT_FLAG ) != 0 && AmbiantLight != null )
				vsh += "mov vt1.xyz, vc126.xyz\n";
			else
				vsh += "mov vt1.xyz, vc127.yyy\n";
			
			vsh += "// v0 - fragment color\n";
			vsh += "mov v0, vt0\n";
			vsh += "// v1 - fragment prelight intensity\n";
			vsh += "mov v1.xyz, vt1.xyz\n";
			vsh += "mov v1.w, vc127.x\n";
			psh += "mov ft0, v1\n";
			
			if ( ( flags & ( DIFFUSE_DIRECTIONAL_FLAG | SPECULAR_DIRECTIONAL_FLAG | DIFFUSE_POINT_FLAG | SPECULAR_POINT_FLAG ) ) != 0 )
			{
				
				vf.AddVertexType ( X3VertexTypes.VTYPE_VEC3, 2, 3 + ( ( ( flags & ALPHA_FLAG ) != 0 ) ? 1 : 0 ) + ( ( ( flags & COLOR_FLAG ) != 0 ) ? 3 : 0 ) );
				vsh += "m44 vt0, va2, vc0\n";
				vsh += "// v2 - fragment normal\n";
				vsh += "nrm v2.xyz, vt0.xyz\n";
				vsh += "mov v2.w, va2.w\n";
				
				if ( ( flags & DIFFUSE_DIRECTIONAL_FLAG ) != 0 )
				{
					
					for ( i = 0; i < DirectionalLights.length; i ++ )
					{
						
						psh += "dp3 ft1.x, v2, fc" + ( 26 - ( i * 2 ) ).toString () + "\n";
						psh += "sat ft1.x, ft1.x\n";
						psh += "mul ft2.xyz, fc"+ ( 26 - ( i * 2 + 1 ) ).toString () + ".xyz, ft1.xxx\n";
						psh += "add ft0.xyz, ft0.xyz, ft2.xyz\n";
						
					}
					
				}
				
				if ( ( flags & ( DIFFUSE_POINT_FLAG | SPECULAR_POINT_FLAG ) ) != 0 )
				{
					
					for ( i = 0; i < PointLights.length; i ++ )
					{
						
						psh += "\n// Point light #" + i.toString () + "\n";
						psh += "sub ft1, v3, fc" + ( 26 - ( ( ( ( flags & DIFFUSE_DIRECTIONAL_FLAG ) != 0 ) ? DirectionalLights.length * 2 : 0 ) + i * 2 ) ).toString () + "\n";
						psh += "mov ft2, ft1\n";
						psh += "nrm ft1.xyz, ft1.xyz\n";
						psh += "dp3 ft1, ft1, v2\n";
						psh += "sat ft1.x, ft1.x\n";
						psh += "mul ft1.xyz, ft1.xxx, fc" + ( 26 - ( ( ( ( flags & DIFFUSE_DIRECTIONAL_FLAG ) != 0 ) ? DirectionalLights.length * 2 : 0 ) + i * 2 + 1 ) ).toString () + "\n";
						psh += "mul ft2.xyz, ft2.xyz, ft2.xyz\n";
						psh += "add ft2.x, ft2.x, ft2.y\n";
						psh += "add ft2.x, ft2.x, ft2.z\n";
						psh += "div ft2.xyz, ft1.xyz, ft2.xxx\n";
						psh += "add ft0.xyz, ft0.xyz, ft1.xyz\n";
						
					}
					
				}
				
			}
			
			psh += "\n// Multiply texture\n";
			psh += "mul ft0.xyz, v0.xyz, ft0.xyz\n";
			psh += "mov oc, ft0\n";
			
			sh = new X3AGALShaderProgram ( vsh, psh );
			
		};
		
		public function Switch () : void
		{
			
			var tarr:Vector.<Number> = new Vector.<Number> ( 4, true );
			var i:uint;
			
			tarr [ 0 ] = 1;
			tarr [ 1 ] = 0;
			tarr [ 2 ] = 0;
			tarr [ 3 ] = 0;
			
			cctx.setProgramConstantsFromVector ( Context3DProgramType.VERTEX, 127, tarr, 1 );
			cctx.setProgramConstantsFromVector ( Context3DProgramType.FRAGMENT, 27, tarr, 1 );
			
			if ( ( flags & AMBIANT_FLAT_FLAG ) != 0 )
			{
				
				tarr [ 0 ] = AmbiantLight.color.r;
				tarr [ 1 ] = AmbiantLight.color.g;
				tarr [ 2 ] = AmbiantLight.color.b;
				tarr [ 3 ] = 1;
				
				cctx.setProgramConstantsFromVector ( Context3DProgramType.VERTEX, 126, tarr, 1 );
			
			}
			
			cctx.setProgramConstantsFromMatrix ( Context3DProgramType.VERTEX, 0, m_trf, true );
			cctx.setProgramConstantsFromMatrix ( Context3DProgramType.VERTEX, 4, m_tns, true );
			cctx.setProgramConstantsFromMatrix ( Context3DProgramType.VERTEX, 8, m_p, true );
			
			if ( ( flags & ( DIFFUSE_DIRECTIONAL_FLAG | SPECULAR_DIRECTIONAL_FLAG ) ) != 0 )
			{
				
				for ( i = 0; i < DirectionalLights.length; i ++ )
				{
					
					tarr [ 0 ] = DirectionalLights [ i ].color.r;
					tarr [ 1 ] = DirectionalLights [ i ].color.g;
					tarr [ 2 ] = DirectionalLights [ i ].color.b;
					tarr [ 3 ] = 1;
					
					cctx.setProgramConstantsFromVector ( Context3DProgramType.FRAGMENT, 26 - ( i * 2 + 1 ), tarr, 1 ); 
					
					tarr [ 0 ] = DirectionalLights [ i ].direction.x;
					tarr [ 1 ] = DirectionalLights [ i ].direction.y;
					tarr [ 2 ] = DirectionalLights [ i ].direction.z;
					
					cctx.setProgramConstantsFromVector ( Context3DProgramType.FRAGMENT, 26 - ( i * 2 ), tarr, 1 );
					
				}
				
			}
			
			if ( ( flags & ( DIFFUSE_POINT_FLAG | SPECULAR_POINT_FLAG ) ) != 0 )
			{
				
				for ( i = 0; i < PointLights.length; i ++ )
				{
					
					tarr [ 0 ] = PointLights [ i ].color.r;
					tarr [ 1 ] = PointLights [ i ].color.g;
					tarr [ 2 ] = PointLights [ i ].color.b;
					tarr [ 3 ] = PointLights [ i ].f;
					
					cctx.setProgramConstantsFromVector ( Context3DProgramType.FRAGMENT, 26 - ( ( ( ( flags & ( DIFFUSE_DIRECTIONAL_FLAG | SPECULAR_DIRECTIONAL_FLAG ) ) != 0 ) ? DirectionalLights.length * 2 : 0 ) + 2 * i + 1 ), tarr, 1 );
					
					tarr [ 0 ] = PointLights [ i ].position.x;
					tarr [ 1 ] = PointLights [ i ].position.y;
					tarr [ 2 ] = PointLights [ i ].position.z;
					tarr [ 3 ] = 0;
					
					cctx.setProgramConstantsFromVector ( Context3DProgramType.FRAGMENT, 26 - ( ( ( ( flags & ( DIFFUSE_DIRECTIONAL_FLAG | SPECULAR_DIRECTIONAL_FLAG ) ) != 0 ) ? DirectionalLights.length * 2 : 0 ) + 2 * i ), tarr, 1 );
					
				};
				
			}
			
			tarr = null;
			
		};
		
		public function ApplyContext ( Context:Context3D ) : void
		{
			
			cctx = Context;
			
		};
		
		public function UnApplyContext () : void
		{
			
			cctx = null;
			
		};
		
		public function GetShaderProgram () : X3IShaderProgram
		{
			
			return sh;
			
		};
		
		public function GetVertexFormat () : X3VertexFormat
		{
			
			return vf;
			
		};
		
		public function GetResourceList () : Vector.<uint>
		{
			
			return new Vector.<uint> ();
			
		};
		
		public function BuildTriangleVData ( P1:X3Point, P2:X3Point, P3:X3Point ) : Vector.<Number>
		{
			
			var VD:Vector.<Number> = new Vector.<Number> ();
			
			var PU:X3Point = P2.Copy ().Subtract ( P1 );
			var PV:X3Point = P3.Copy ().Subtract ( P1 );
			
			var PO:X3Point = new X3Point ();
			
			PO.x = PU.y * PV.z - PU.z * PV.y;
			PO.y = PU.z * PV.x - PU.x * PV.z;
			PO.z = PU.x * PV.y - PU.y * PV.x;
			
			PO.Normalize3 ();
			
			VD.push ( P1.x, P1.y, P1.z );
			
			if ( ( flags & COLOR_FLAG ) != 0 )
			{
				
				VD.push ( r, g, b );
				if ( ( flags & ALPHA_FLAG ) != 0 )
					VD.push ( a );
				
			}
			else if ( ( flags & ALPHA_FLAG ) != 0 )
				VD.push ( a );
			
			if ( ( flags & ( DIFFUSE_DIRECTIONAL_FLAG | SPECULAR_DIRECTIONAL_FLAG | DIFFUSE_POINT_FLAG | SPECULAR_POINT_FLAG ) ) != 0 )
				VD.push ( PO.x, PO.y, PO.z );
			
			VD.push ( P2.x, P2.y, P1.z );
			
			if ( ( flags & COLOR_FLAG ) != 0 )
			{
				
				VD.push ( r, g, b );
				if ( ( flags & ALPHA_FLAG ) != 0 )
					VD.push ( a );
				
			}
			else if ( ( flags & ALPHA_FLAG ) != 0 )
				VD.push ( a );
			if ( ( flags & ( DIFFUSE_DIRECTIONAL_FLAG | SPECULAR_DIRECTIONAL_FLAG | DIFFUSE_POINT_FLAG | SPECULAR_POINT_FLAG ) ) != 0 )
				VD.push ( PO.x, PO.y, PO.z );
			
			VD.push ( P3.x, P3.y, P3.z );
			if ( ( flags & COLOR_FLAG ) != 0 )
			{
				
				VD.push ( r, g, b );
				if ( ( flags & ALPHA_FLAG ) != 0 )
					VD.push ( a );
				
			}
			else if ( ( flags & ALPHA_FLAG ) != 0 )
				VD.push ( a );
			if ( ( flags & ( DIFFUSE_DIRECTIONAL_FLAG | SPECULAR_DIRECTIONAL_FLAG | DIFFUSE_POINT_FLAG | SPECULAR_POINT_FLAG ) ) != 0 )
				VD.push ( PO.x, PO.y, PO.z );
			
			return VD;
			
		};
		
	};
	
};