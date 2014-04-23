package com.Xenon3D.ASSL
{
	
	public class X3ASSLVertexProgramDefinition
	{
		
		public var blen:uint;
		public var Variables:Vector.<X3ASSLVariableDefinition>;
		
		public function X3ASSLVertexProgramDefinition ()
		{
			
			blen = 0;
			Variables = new Vector.<X3ASSLVariableDefinition> ();
			
		};
		
		public static function Test ( Blocks:Vector.<String>, BaseBlock:uint = 0 ) : X3ASSLVertexProgramDefinition
		{
			
			var out:X3ASSLVertexProgramDefinition = new X3ASSLVertexProgramDefinition ();
			
			var i:uint = BaseBlock;
			
			if ( Blocks.length < i + 1 )
				return null;
			
			if ( Blocks [ i ] != "vec4" )
				return null;
			
			i ++;
			
			if ( Blocks.length < i + 1 )
				return null;
			
			if ( Blocks [ i ] != "VertexShader" )
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
					
					// VARIABLES
					
					var varDef:X3ASSLVariableDefinition = X3ASSLVariableDefinition.Test ( Blocks, i );
					
					if ( varDef != null )
					{
						
						out.Variables.push ( varDef );
						i += varDef.blen;
						
					}
					
					if ( Blocks [ i ] == "}" )
					{
						
						out.blen = i + 1 - BaseBlock;
						
						return out;
						
					}
					
					i ++;
					
					if ( Blocks.length < i + 1 )
						return null;
					
				}
				
				return null;
				
			}
			
			return null;
			
		};
		
	};
	
};