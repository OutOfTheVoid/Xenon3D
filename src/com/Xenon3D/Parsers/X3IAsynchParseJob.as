package com.Xenon3D.Parsers
{
	
	public interface X3IAsynchParseJob
	{
		
		function OnSuccess () : void;
		function OnFailure ( Error:String ) : void;
		
	};
	
};