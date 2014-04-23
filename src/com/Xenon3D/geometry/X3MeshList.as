package com.Xenon3D.geometry
{
	
	public class X3MeshList
	{
		
		public var attribs:X3MeshAttributes;
		public var meshes:Vector.<X3Mesh>;
		public var meshCount:uint;
		
		public function X3MeshList ( Attributes:X3MeshAttributes, Meshes:Vector.<X3Mesh> )
		{
			
			meshes = Meshes;
			meshes.fixed = true;
			meshCount = meshes.length;
			
			attribs = Attributes;
			
		};
		
	};
	
};