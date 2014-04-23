package com.Xenon3D.rendering
{
	
	public interface X3IRenderMethod
	{
		
		function ApplyRenderContext ( Context:X3RenderContext ) : void;
		function UnApplyRenderContext () : void;
		function Render () : void;
		
	};
	
};