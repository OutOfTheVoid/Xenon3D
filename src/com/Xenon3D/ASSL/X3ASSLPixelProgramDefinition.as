package com.Xenon3D.ASSL
{
	
	public class X3ASSLPixelProgramDefinition
	{
		
		public static function Test ( Blocks:Vector.<String>, BaseBlock:uint = 0 ): X3ASSLPixelProgramDefinition
		{
			
			var out:X3ASSLPixelProgramDefinition = new X3ASSLPixelProgramDefinition ();
			
			var i:uint = BaseBlock;
			
			if ( Blocks.length < i + 1 )
				return null;
			
			if ( Blocks [ i ] != "vec3" )
				return null;
			
			i ++;
			
			if ( Blocks.length < i + 1 )
				return null;
			
			if ( Blocks [ i ] != "PixelShader" )
				return null;
			
			i ++;
			
			if ( Blocks.length < i + 1 )
				return null;
			
			if ( Blocks [ i ] == "{" )
			{
				
				i ++;
				
				if ( Blocks.length < i + 1 )
					return null;
				
				var more:Boolean = true;
				
				while ( i < Blocks.length && more )
				{
					
					// Test all possible sub-elements.
					
					if ( Blocks [ i ] == "}" )
					{
						
						return out;
						
					}
					
				}
				
				return null;
				
			}
			
			return null;
			
		};
		
	};
	
};