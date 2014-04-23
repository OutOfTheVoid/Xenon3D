package com.Xenon3D.shaders
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display3D.Context3DProgramType;
	import flash.utils.ByteArray;
	
	public class X3AGALShaderProgram implements X3IShaderProgram
	{
		
		private static var AGALAssembler:AGALMiniAssembler;
		
		{
			
			AGALAssembler = new AGALMiniAssembler ( false );
			
		}
		
		private var vtxs:String;
		private var pxls:String;
		
		private var vbin:ByteArray;
		private var pbin:ByteArray;
		
		private var cmpd:Boolean;
		
		public function X3AGALShaderProgram ( VertexShader:String, PixelShader:String )
		{
			
			SetProgram ( VertexShader, PixelShader );
			
		};
		
		public function SetProgram ( VertexShader:String, PixelShader:String ) : void
		{
			
			cmpd = false;
			
			vtxs = VertexShader;
			pxls = PixelShader;
			
		};
		
		public function Compile () : void
		{
			
			vbin = AGALAssembler.assemble ( Context3DProgramType.VERTEX, vtxs, false );
			pbin = AGALAssembler.assemble ( Context3DProgramType.FRAGMENT, pxls, false );
			
			cmpd = true;
			
		};
		
		public function GetVertexBinary () : ByteArray
		{
			
			return vbin;
			
		};
		
		public function GetPixelBinary () : ByteArray
		{
			
			return pbin;
			
		};
		
		public function IsCompiled () : Boolean
		{
			
			return cmpd;
			
		};
		
	};
	
};