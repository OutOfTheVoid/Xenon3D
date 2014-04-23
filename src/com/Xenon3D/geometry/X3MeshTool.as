package com.Xenon3D.geometry
{
	import com.Xenon3D.math.X3Point;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	public class X3MeshTool
	{
		
		public static function TransformMesh ( Mesh:X3Mesh, PositionAttribute:String, Transform:Matrix3D ) : void
		{
			
			var attind:int = Mesh.attributes.IndexOfAttribute ( PositionAttribute, X3VertexTypes.VTYPE_VEC3 );
			var vsize:uint = Mesh.attributes.GetVertexSize ();
			
			if ( attind == -1 )
				return;
			
			var offs:uint = Mesh.attributes.GetVertexSizeBeforeAttribute ( attind );
			var verts:uint = Mesh.vertex.length / vsize;
			
			var TV:Vector3D = new Vector3D ();
			
			for ( var i:uint = 0; i < verts; i ++ )
			{
				
				TV.x = Mesh.vertex [ i * vsize + attind ];
				TV.y = Mesh.vertex [ i * vsize + attind + 1 ];
				TV.z = Mesh.vertex [ i * vsize + attind + 2 ];
				 
				TV = Transform.transformVector ( TV );
				
				Mesh.vertex [ i * vsize + attind ] = TV.x;
				Mesh.vertex [ i * vsize + attind + 1 ] = TV.y;
				Mesh.vertex [ i * vsize + attind + 2 ] = TV.z;
				
			}
			
		};
		
		public static function NormalizeMesh ( Mesh:X3Mesh, PositionAttribute:String, Offset:X3Point = null ) : void
		{
			
			if ( Offset == null )
				Offset = new X3Point ();
			
			Offset.x -= -0.5;
			Offset.y -= -0.5;
			Offset.z -= -0.5;
			
			var attind:int = Mesh.attributes.IndexOfAttribute ( PositionAttribute, X3VertexTypes.VTYPE_VEC3 );
			
			var vsize:uint = Mesh.attributes.GetVertexSize ();
			
			if ( attind == -1 )
				return;
			
			var offs:uint = Mesh.attributes.GetVertexSizeBeforeAttribute ( attind );
			var verts:uint = Mesh.vertex.length / vsize;
			
			var XMin:Number = Infinity;
			var XMax:Number = - Infinity;
			var YMin:Number = Infinity;
			var YMax:Number = - Infinity;
			var ZMin:Number = Infinity;
			var ZMax:Number = - Infinity;
			
			var Temp:Number;
			
			for ( var i:uint = 0; i < verts; i ++ )
			{
				
				Temp = Mesh.vertex [ i * vsize + offs ];
				
				if ( Temp < XMin )
					XMin = Temp;
				
				if ( Temp > XMax )
					XMax = Temp;
				
				Temp = Mesh.vertex [ i * vsize + offs + 1 ];
				
				if ( Temp < YMin )
					YMin = Temp;
				
				if ( Temp > YMax )
					YMax = Temp;
				
				Temp = Mesh.vertex [ i * vsize + offs + 2 ];
				
				if ( Temp < ZMin )
					ZMin = Temp;
				
				if ( Temp > ZMax )
					ZMax = Temp;
				
			}
			
			var GMin:Number = ( XMin < YMin ) ? XMin : ( YMin < ZMin ) ? YMin : ZMin;
			var GMax:Number = ( XMax > YMax ) ? XMax : ( YMax > ZMax ) ? YMax : ZMax;
			
			for ( i = 0; i < verts; i ++ )
			{
				
				Mesh.vertex [ i * vsize + offs ] = Offset.x + ( Mesh.vertex [ i * vsize + offs ] - ( ( XMax + XMin ) / 2 ) ) / ( GMin - GMax ) - 0.5;
				Mesh.vertex [ i * vsize + offs + 1 ] = Offset.y + ( Mesh.vertex [ i * vsize + offs + 1 ] - ( ( YMax + YMin ) / 2 ) ) / ( GMin - GMax ) - 0.5;
				Mesh.vertex [ i * vsize + offs + 2 ] = Offset.z + ( Mesh.vertex [ i * vsize + offs + 2 ] - ( ( ZMax + ZMin ) / 2 ) ) / ( GMin - GMax ) - 0.5;
				
			}
			
		};
		
		public static function NormalizeMeshList ( MeshList:X3MeshList, PositionAttribute:String ) : void
		{
			
			var BB:X3BoundingBox = new X3BoundingBox ();
			BB.AppendBoundList ( MeshList, PositionAttribute );
			
			var Transform:Matrix3D = new Matrix3D ();
			Transform.appendTranslation ( - ( BB.nx + BB.px ) / 2, - ( BB.ny + BB.py ) / 2, - ( BB.nz + BB.pz ) / 2 );
			
			var gscale:Number = 1 / ( ( BB.sizex > BB.sizey ) ? BB.sizex : ( ( BB.sizey > BB.sizez ) ? BB.sizey : BB.sizez ) );
			Transform.appendScale ( gscale, gscale, gscale );
			
			for ( var i:uint = 0; i < MeshList.meshCount; i ++ )
				TransformMesh ( MeshList.meshes [ i ], PositionAttribute, Transform );
			
		};
		
		public function X3MeshTool ()
		{
			
			throw new Error ( "X3MeshTool cannot be instantiated.", 0 );
			
		};
		
	};
	
};