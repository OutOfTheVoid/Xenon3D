package com.Xenon3D.materials
{
	import com.Xenon3D.math.X3Point;
	
	public interface X3IGeometricMaterial extends X3IMaterial
	{
		
		function BuildTriangleVData ( P1:X3Point, P2:X3Point, P3:X3Point ) : Vector.<Number>;
		
	};
	
};