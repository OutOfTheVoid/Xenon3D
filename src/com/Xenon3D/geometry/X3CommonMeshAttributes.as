package com.Xenon3D.geometry
{
	
	public class X3CommonMeshAttributes
	{
		
		public static const MESH_ATTRIBUTE_POSITION2D:String = "position_xy";
		public static const MESH_ATTRIBUTE_POSITION:String = "position_xyz";
		public static const MESH_ATTRIBUTE_POSITION2D_TYPE:uint = X3VertexTypes.VTYPE_VEC2;
		public static const MESH_ATTRIBUTE_POSITION_TYPE:uint = X3VertexTypes.VTYPE_VEC3;
		
		public static const MESH_ATTRIBUTE_NORMAL2D:String = "normal_xy";
		public static const MESH_ATTRIBUTE_NORMAL:String = "normal_xyz";
		public static const MESH_ATTRIBUTE_BINORMAL:String = "binormal_xyz";
		public static const MESH_ATTRIBUTE_TANGENT:String = "tangent_xyz";
		public static const MESH_ATTRIBUTE_NORMAL2D_TYPE:uint = X3VertexTypes.VTYPE_VEC2;
		public static const MESH_ATTRIBUTE_NORMAL_TYPE:uint = X3VertexTypes.VTYPE_VEC3;
		public static const MESH_ATTRIBUTE_BINORMAL_TYPE:uint = X3VertexTypes.VTYPE_VEC3;
		public static const MESH_ATTRIBUTE_TANGENT_TYPE:uint = X3VertexTypes.VTYPE_VEC3;
		
		public static const MESH_ATTRIBUTES_COLORA:String = "alpha_x";
		public static const MESH_ATTRIBUTES_COLORRGB:String = "color_rgb";
		public static const MESH_ATTRIBUTES_COLORRGBA:String = "color_rgba";
		public static const MESH_ATTRIBUTES_COLORA_TYPE:uint = X3VertexTypes.VTYPE_VEC1;
		public static const MESH_ATTRIBUTES_COLORRGB_TYPE:uint = X3VertexTypes.VTYPE_VEC3;
		public static const MESH_ATTRIBUTES_COLORRGBA_TYPE:uint = X3VertexTypes.VTYPE_VEC4;
		
		public static const MESH_ATTRIBUTES_UV:String = "uv_xy";
		public static const MESH_ATTRIBUTES_UV_TYPE:uint = X3VertexTypes.VTYPE_VEC2;
		
		public function X3CommonMeshAttributes ()
		{
			throw new Error ( "You cannot instantiate X3CommonMeshAttributes.", 0 );
		};
		
	};
	
};