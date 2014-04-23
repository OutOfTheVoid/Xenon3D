package com.Xenon3D.materials
{
	import com.Xenon3D.geometry.X3CommonMeshAttributes;
	import com.Xenon3D.geometry.X3MeshAttributes;
	import com.Xenon3D.geometry.X3VertexTypes;
	import com.Xenon3D.math.X3Color;
	import com.Xenon3D.math.X3Point;
	import com.Xenon3D.rendering.X3VertexFormat;
	import com.Xenon3D.shaders.X3AGALShaderProgram;
	import com.Xenon3D.shaders.X3IShaderProgram;
	
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.geom.Matrix3D;
	
	public class X3ColorMaterial implements X3IGeometricMaterial
	{
		
		public static const MESH_ATTRIBUTE_POSITION:String = X3CommonMeshAttributes.MESH_ATTRIBUTE_POSITION;
		public static const MESH_ATTRIBUTE_POSITION_TYPE:uint = X3CommonMeshAttributes.MESH_ATTRIBUTE_POSITION_TYPE;
		
		private var color:X3Color;
		
		private var ma:X3MeshAttributes;
		
		private var vf:X3VertexFormat;
		private var sh:X3AGALShaderProgram;
		
		private var m:Matrix3D;
		
		private var cctx:Context3D;
		
		public function X3ColorMaterial ( Color:X3Color = null )
		{
			
			color = Color || new X3Color ();
			
			vf = new X3VertexFormat ( X3VertexFormat.NUMVECTOR_TYPE );
			
			vf.AddVertexType ( X3VertexTypes.VTYPE_VEC3, 0, 0 ); // Position xyz
			
			sh = new X3AGALShaderProgram 
			( 
				"m44 op, va0, vc0\n",
				"mov oc, fc0\n"
			);
			sh.Compile ();
			
			ma = new X3MeshAttributes ();
			ma.AddAttribute ( MESH_ATTRIBUTE_POSITION, MESH_ATTRIBUTE_POSITION_TYPE );
			
		};
		
		public function SetTransform ( Transform:Matrix3D ) : void
		{
			
			m = Transform;
			
		};
		
		[Inline]
		public function set Color ( Color:X3Color ) : void
		{
			
			color.Mirror ( Color );
			
		};
		
		[Inline]
		public function get Color () : X3Color
		{
			
			return color;
			
		};
		
		
		public function GetVertexFormat () : X3VertexFormat
		{
			
			return vf
			
		};
		
		public function GetMeshAttributes () : X3MeshAttributes
		{
			
			return ma;
			
		};
		
		public function GetResourceList () : Vector.<uint>
		{
			
			return null;
			
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
		
		public function Switch () : void
		{
			
			var cv:Vector.<Number> = new <Number> [ color.r, color.g, color.b, color.a ];
			
			cctx.setProgramConstantsFromMatrix ( Context3DProgramType.VERTEX, 0, m, true );
			cctx.setProgramConstantsFromVector ( Context3DProgramType.FRAGMENT, 0, cv, 1 );
			
			cv = null;
			
		};
		
		public function BuildTriangleVData ( P1:X3Point, P2:X3Point, P3:X3Point ) : Vector.<Number>
		{
			
			var VD:Vector.<Number> = new Vector.<Number> ();
			
			VD.push ( P1.x, P1.y, P1.z );
			VD.push ( P2.x, P2.y, P2.z );
			VD.push ( P3.x, P3.y, P3.z );
			
			return VD;
			
		};
		
	};
	
};