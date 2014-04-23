package com.Xenon3D.geometry
{
	import com.Xenon3D.materials.X3IGeometricMaterial;
	import com.Xenon3D.math.X3Point;
	
	public class X3GeometryTool
	{
		
		public function X3GeometryTool ()
		{
			throw new Error ( "X3MatrixTool is a static class and cannot be instantiated" );
		};
		
		public static function CreateCubeMesh ( Material:X3IGeometricMaterial ) : X3Mesh
		{
			
			var vtx:Vector.<Number> = new Vector.<Number> ();
			var idx:Vector.<uint> = new Vector.<uint> ();
			
			var CP1:X3Point = new X3Point ();
			var CP2:X3Point = new X3Point ();
			var CP3:X3Point = new X3Point ();
			var CP4:X3Point = new X3Point ();
			
			CP1.Set ( -1.0, -1.0, -1.0 );
			CP2.Set ( +1.0, -1.0, -1.0 );
			CP3.Set ( +1.0, +1.0, -1.0 );
			CP4.Set ( -1.0, +1.0, -1.0 );
			
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP1, CP2, CP3 ) );
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP1, CP3, CP4 ) );
			idx.push ( 0, 1, 2, 3, 4, 5 );
			
			CP1.Set ( -1.0, -1.0, +1.0 );
			CP2.Set ( +1.0, -1.0, +1.0 );
			CP3.Set ( +1.0, +1.0, +1.0 );
			CP4.Set ( -1.0, +1.0, +1.0 );
			
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP1, CP3, CP2 ) );
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP1, CP4, CP3 ) );
			idx.push ( 6, 7, 8, 9, 10, 11 );
			
			CP1.Set ( +1.0, -1.0, -1.0 );
			CP2.Set ( +1.0, -1.0, +1.0 );
			CP3.Set ( +1.0, +1.0, +1.0 );
			CP4.Set ( +1.0, +1.0, -1.0 );
			
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP2, CP3, CP1 ) );
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP4, CP1, CP3 ) );
			idx.push ( 12, 13, 14, 15, 16, 17 );
			
			CP1.Set ( -1.0, -1.0, -1.0 );
			CP2.Set ( -1.0, -1.0, +1.0 );
			CP3.Set ( -1.0, +1.0, +1.0 );
			CP4.Set ( -1.0, +1.0, -1.0 );
			
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP1, CP3, CP2 ) );
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP3, CP1, CP4 ) );
			idx.push ( 18, 19, 20, 21, 22, 23 );
			
			CP1.Set ( -1.0, +1.0, -1.0 );
			CP2.Set ( -1.0, +1.0, +1.0 );
			CP3.Set ( +1.0, +1.0, +1.0 );
			CP4.Set ( +1.0, +1.0, -1.0 );
			
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP1, CP3, CP2 ) );
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP3, CP1, CP4 ) );
			idx.push ( 24, 25, 26, 27, 28, 29 );
			
			CP1.Set ( -1.0, -1.0, -1.0 );
			CP2.Set ( -1.0, -1.0, +1.0 );
			CP3.Set ( +1.0, -1.0, +1.0 );
			CP4.Set ( +1.0, -1.0, -1.0 );
			
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP2, CP3, CP1 ) );
			vtx = vtx.concat ( Material.BuildTriangleVData ( CP4, CP1, CP3 ) );
			idx.push ( 30, 31, 32, 33, 34, 35 );
			
			var NMesh:X3Mesh = new X3Mesh ( Material.GetMeshAttributes(), vtx, idx );
			
			return NMesh;
			
		};
		
	};
	
};