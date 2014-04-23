package com.Xenon3D.geometry
{
	
	public class X3Mesh
	{
		
		public var vertex:Vector.<Number>;
		public var index:Vector.<uint>;
		
		public var attributes:X3MeshAttributes;
		
		public function X3Mesh ( Attributes:X3MeshAttributes, VertexData:Vector.<Number>, IndexData:Vector.<uint> )
		{
			
			vertex = VertexData;
			index = IndexData;
			
			attributes = Attributes;
			
		}
		
	};
	
};