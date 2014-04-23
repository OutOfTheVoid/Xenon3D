package com.Xenon3D.math
{
	
	public class X3Point
	{
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		
		public function X3Point ( X:Number = 0, Y:Number = 0, Z:Number = 0, W:Number = 0 )
		{
			
			x = X;
			y = Y;
			z = Z;
			w = W;
			
		};
		
		public function Set ( X:Number = 0, Y:Number = 0, Z:Number = 0, W:Number = 0 ) : X3Point
		{
			
			x = X;
			y = Y;
			z = Z;
			w = W;
			
			return this;
			
		};
		
		public function Mirror ( Point:X3Point ) : X3Point
		{
			
			x = Point.x;
			y = Point.y;
			z = Point.z;
			w = Point.w;
			
			return this;
			
		};
		
		public function Subtract ( Point:X3Point ) : X3Point
		{
			
			x -= Point.x;
			y -= Point.y;
			z -= Point.z;
			w -= Point.w;
			
			return this;
			
		};
		
		public function Add ( Point:X3Point ) : X3Point
		{
			
			x += Point.x;
			y += Point.y;
			z += Point.z;
			w += Point.w;
			
			return this;
			
		};
		
		public function Copy () : X3Point
		{
			
			return new X3Point ( x, y, z, w );
			
		}
		
		public function Normalize3 () : void
		{
			
			var l:Number = Math.sqrt ( x * x + y * y + z * z );
			x /= l;
			y /= l;
			z /= l;
			
		};
		
		public function Normalize4 () : void
		{
			
			var l:Number = Math.sqrt ( x * x + y * y + z * z + w * w );
			x /= l;
			y /= l;
			z /= l;
			w /= l;
			
		};
		
	};
	
};