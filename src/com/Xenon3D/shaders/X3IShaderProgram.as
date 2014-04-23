package com.Xenon3D.shaders
{
	import flash.utils.ByteArray;
	
	public interface X3IShaderProgram
	{
		
		function Compile () : void;
		function GetVertexBinary () : ByteArray;
		function GetPixelBinary () : ByteArray;
		function IsCompiled () : Boolean;
		
	};
	
};