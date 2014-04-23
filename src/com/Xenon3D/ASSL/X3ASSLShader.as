package com.Xenon3D.ASSL
{
	
	public class X3ASSLShader
	{
		
		private var ShaderCode:String;
		
		public function X3ASSLShader ( Shader:String )
		{
			
			ShaderCode = Shader;
			
		};
		
		public function Parse () : Boolean
		{
			
			var blocks:Array;
			blocks = ShaderCode.split ( /[\s;]/ );
			
			var tblock:Vector.<String>;
			var i:int = 0;
			
			var variableTable:Vector.<X3ASSLVariableDefinition> = new Vector.<X3ASSLVariableDefinition> ();
			
			
			
			return false;
			
		};
		
	};
	
};