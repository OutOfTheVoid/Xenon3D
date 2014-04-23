package com.Xenon3D.materials
{
	import com.Xenon3D.X3IContextApplicable;
	import com.Xenon3D.geometry.X3MeshAttributes;
	import com.Xenon3D.rendering.X3VertexFormat;
	import com.Xenon3D.shaders.X3IShaderProgram;
	
	public interface X3IMaterial extends X3IContextApplicable
	{
		
		function GetVertexFormat () : X3VertexFormat;
		function GetResourceList () : Vector.<uint>;
		function GetShaderProgram () : X3IShaderProgram;
		function GetMeshAttributes () : X3MeshAttributes
		
	};
	
};