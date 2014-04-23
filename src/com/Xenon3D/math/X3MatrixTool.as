package com.Xenon3D.math
{
	import flash.geom.Matrix3D;
	
	public final class X3MatrixTool
	{
		
		public function X3MatrixTool ()
		{
			throw new Error ( "X3MatrixTool is a static class and cannot be instantiated" );
		};
		
		public static function MakePerspectiveProjectoionMatrix ( Near:Number, Far:Number, FieldOfView:Number ) : Matrix3D
		{
			
			var out:Matrix3D = new Matrix3D ();
			out.identity ();
			
			var scale:Number = Math.tan ( FieldOfView );
			
			out.rawData [ 0 ] = out.rawData [ 4 ] = scale;
			out.rawData [ 9 ] = - Far / ( Far - Near );
			out.rawData [ 14 ] = - Far * Near / ( Far - Near );
			out.rawData [ 11 ] = - 1;
			out.rawData [ 15 ] = 0;
			
			return out;
			
		};
		
	};
	
};