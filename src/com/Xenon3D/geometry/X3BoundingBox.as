package com.Xenon3D.geometry
{
	
	public class X3BoundingBox
	{
		
		public var nx:Number;
		public var px:Number;
		public var ny:Number;
		public var py:Number;
		public var nz:Number;
		public var pz:Number;
		
		public function X3BoundingBox ( XMin:Number = Infinity, XMax:Number = - Infinity, YMin:Number = Infinity, YMax:Number = - Infinity, ZMin:Number = Infinity, ZMax:Number = - Infinity )
		{
			
			nx = XMin;
			px = XMax;
			ny = YMin;
			py = YMax;
			nz = ZMin;
			pz = ZMax;
			
		};
		
		public function AppendBound ( Mesh:X3Mesh, PositionAttribute:String = X3CommonMeshAttributes.MESH_ATTRIBUTE_POSITION ) : void
		{
			
			var attind:int = Mesh.attributes.IndexOfAttribute ( PositionAttribute, X3VertexTypes.VTYPE_VEC3 );
			var vsize:uint = Mesh.attributes.GetVertexSize ();
			
			if ( attind == -1 )
				return;
			
			var verts:uint = Mesh.vertex.length / vsize;
			
			var Temp:Number;
			
			for ( var i:uint = 0; i < verts; i ++ )
			{
				
				Temp = Mesh.vertex [ i * vsize + attind ];
				
				if ( Temp < nx )
					nx = Temp;
				
				if ( Temp > px )
					px = Temp;
				
				Temp = Mesh.vertex [ i * vsize + attind + 1 ];
				
				if ( Temp < ny )
					ny = Temp;
				
				if ( Temp > py )
					py = Temp;
				
				Temp = Mesh.vertex [ i * vsize + attind + 2 ];
				
				if ( Temp < nz )
					nz = Temp;
				
				if ( Temp > pz )
					pz = Temp;
				
			}
			
		};
		
		public function AppendBoundList ( Meshes:X3MeshList, PositionAttribute:String = X3CommonMeshAttributes.MESH_ATTRIBUTE_POSITION ) : void
		{
			
			for ( var i:uint = 0; i < Meshes.meshCount; i ++ )
				AppendBound ( Meshes.meshes [ i ], PositionAttribute );
			
		};
		
		public function get sizex () : Number
		{
			
			return px - nx;
			
		};
		
		public function get sizey () : Number
		{
			
			return py - ny;
			
		};
		
		public function get sizez () : Number
		{
			
			return pz - nz;
			
		};
		
	};
	
};