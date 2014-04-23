package com.Xenon3D
{
	import flash.display3D.Context3D;
	
	public interface X3IContextApplicable
	{
		
		function Switch () : void;
		function ApplyContext ( Context:Context3D ) : void;
		function UnApplyContext () : void;
		
	};
	
};