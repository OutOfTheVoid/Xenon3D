package com.Xenon3D.math
{
	
	public class X3Color
	{
		
		public static const Red:X3Color = new X3Color ( 1, 0, 0, 1 );
		public static const Green:X3Color = new X3Color ( 0, 1, 0, 1 );
		public static const Blue:X3Color = new X3Color ( 0, 0, 1, 1 );
		public static const White:X3Color = new X3Color ( 1, 1, 1, 1 );
		public static const Black:X3Color = new X3Color ( 0, 0, 0, 1 );
		
		public var r:Number;
		public var g:Number;
		public var b:Number;
		public var a:Number;
		
		public function X3Color ( R:Number = 0, G:Number = 0, B:Number = 0, A:Number = 0 )
		{
			
			r = R;
			g = G;
			b = B;
			a = A;
			
		};
		
		public function Set ( R:Number = 0, G:Number = 0, B:Number = 0, A:Number = 0 ) : void
		{
			
			r = R;
			g = G;
			b = B;
			a = A;
			
		};
		
		public function Mirror ( Color:X3Color ) : void
		{
			
			r = Color.r;
			g = Color.g;
			b = Color.b;
			a = Color.a;
			
		};
		
		public function ToU32 () : uint
		{
			
			return ( ( ( ( a * 255 ) as uint ) & 0xFF ) << 24 ) | ( ( ( ( r * 255 ) as uint ) & 0xFF ) << 16 ) | ( ( ( ( g * 255 ) as uint ) & 0xFF ) << 8 ) | ( ( ( b * 255 ) as uint ) & 0xFF );
			
		};
		
		public function SetU32 ( Color:uint ) : void
		{
			
			r = ( ( Color >> 16 ) & 0xFF ) / 255;
			g = ( ( Color >> 8 ) & 0xFF ) / 255;
			b = ( Color & 0x000000FF ) / 255;
			a = ( ( Color >> 24 ) & 0xFF ) / 255;
			
		};
		
	};
	
};