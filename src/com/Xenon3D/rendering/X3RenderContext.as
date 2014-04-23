package com.Xenon3D.rendering
{
	
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	
	public class X3RenderContext
	{
		
		private var stage:Stage3D;
		internal var context:Context3D;
		
		private var displaying:Boolean;
		
		private var w:Number;
		private var h:Number;
		
		private var antiAlias:uint;
		private var useDepthStencil:Boolean;
		private var highestResolution:Boolean;
		
		private var cRed:Number;
		private var cBlue:Number;
		private var cGreen:Number;
		private var cAlpha:Number;
		
		public function X3RenderContext ( Stage:Stage3D, Width:Number = 550, Height:Number = 400, AntiAliasing:uint = 4, DepthStencil:Boolean = true, BestResolution:Boolean = false )
		{
			
			if ( Stage == null )
				throw new Error ( "Xenon3D Error: Cannot create X3RenderContext with null Stage3D instance.", 0 );
			
			stage = Stage;
			context = stage.context3D;
			
			context.configureBackBuffer ( Width, Height, AntiAliasing, DepthStencil, BestResolution );
			context.setBlendFactors ( Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA );
			
			w = Width;
			h = Height;
			
			displaying = true;
			
			antiAlias = AntiAliasing;
			useDepthStencil = DepthStencil;
			highestResolution = BestResolution;
			
		};
		
		public function PushBuffer () : void
		{
			
			context.present ();
			
		};
		
		public function Clear () : void
		{
			
			context.clear ( cRed, cGreen, cBlue, cAlpha, 1.0, 0, 0xFFFFFFFF );
			
		};
		
		public function Destroy () : void
		{
			
			context.dispose ();
			
		};
		
		public function Reposition ( x:Number, y:Number ) : void 
		{
			
			stage.x = x;
			stage.y = y;
			
		};
		
		public function Resize ( w:Number, h:Number ) : void
		{
			
			if ( this.w != w || this.h != h )
			{
				
				context.configureBackBuffer ( w, h, antiAlias, useDepthStencil, highestResolution );
				
				this.w = w;
				this.h = h;
				
			}
			
		};
		
		//==========================[Getters/Setters]==========================
		
		public function set clearColor ( Value:uint ) : void
		{
			
			cRed = ( ( Value >> 16 ) & 0xFF ) / 255;
			cGreen = ( ( Value >> 8 ) & 0xFF ) / 255;
			cBlue = ( Value & 0x000000FF ) / 255;
			cAlpha = ( ( ( Value >> 24 ) & 0xFF ) as Number ) / 255;
			
		};
		
		public function get clearColor () : uint
		{
			
			return ( ( ( cRed * 255 ) as uint ) << 16 ) + ( ( ( cGreen * 255 ) as uint ) << 8 ) + ( ( cBlue * 255 ) as uint ) + ( ( ( cAlpha * 255 ) as uint ) << 24 );
			
		};
		
		public function set display ( Value:Boolean ) : void
		{
			
			stage.visible = Value;
			displaying = Value;
			
		}
		
		public function get display () : Boolean
		{
			return displaying;
		}
		
		public function set x ( Value:Number ) : void
		{
			stage.x = Value;
		};
		
		public function set y ( Value:Number ) : void
		{
			stage.y = Value;	
		};
		
		public function get x () : Number
		{
			return stage.x;	
		}
		
		public function get y () : Number
		{
			return stage.y;
		}
		
	};
	
};