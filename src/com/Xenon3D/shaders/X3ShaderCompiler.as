package com.Xenon3D.shaders
{
	
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.utils.ByteArray;
	
	public class X3ShaderCompiler
	{
		
		private static var AGALASM:AGALMiniAssembler;
		
		{
			
			AGALASM = new AGALMiniAssembler ( false );
			
		}
		
		public static function Compile ( Shader:String, Type:String ) : ByteArray
		{
			
			AGALASM.assemble ( Type, Shader, false );
			
			if ( !AGALASM.agalcode )
				throw new Error ( "AGAL Error: " + AGALASM.error, 0 ); 
			
			return AGALASM.agalcode;
			
		};
		
	};
	
};