package com.Xenon3D.Parsers
{
	import com.Xenon3D.geometry.X3MeshAttributes;
	import com.Xenon3D.geometry.X3MeshList;
	
	import flash.utils.ByteArray;
	
	public class X3AsynchSTLParseJob implements X3IAsynchParseJob
	{
		
		private var flgs:uint;
		private var dfcl:uint;
		private var msha:X3MeshAttributes;
		private var cattpos:String;
		private var cattnorm:String;
		private var cattcolrgb:String;
		private var cattcolrgba:String;
		private var size:uint;
		private var file:ByteArray;
		private var offs:uint;
		private var oscc:Function;
		private var ofal:Function;
		
		internal var rslt:X3MeshList;
		
		public function X3AsynchSTLParseJob ( Flags:uint, DefaultColor:uint, MeshAttributes:X3MeshAttributes, PositionAttribute:String, NormalAttribute:String, ColorRGBAAttribute:String, ColorRGBAttribute:String, STLFile:ByteArray, Offset:uint, Length:uint, SuccessHandler:Function, FailureHandler:Function )
		{
			
			flgs = Flags;
			dfcl = DefaultColor;
			msha = MeshAttributes;
			cattpos = PositionAttribute;
			cattnorm = NormalAttribute;
			cattcolrgba = ColorRGBAAttribute;
			cattcolrgb = ColorRGBAttribute;
			size = Length;
			file = STLFile;
			oscc = SuccessHandler;
			ofal = FailureHandler;
			
		};
		
		public function OnSuccess () : void
		{
			
			oscc ( rslt );
			
		};
		
		public function OnFailure ( Error:String ) : void
		{
			
			trace ( "PARSE FAILURE: " + Error );
			
			ofal ();
			
		};
		
		internal function get Flags () : uint
		{
			
			return flgs;
			
		};
		
		internal function get DefaultColor () : uint
		{
			
			return dfcl;
			
		};
		
		internal function get MeshAttributes () : X3MeshAttributes
		{
			
			return msha;
			
		};
		
		internal function get PositionAttribute () : String
		{
			
			return cattpos;
			
		};
		
		internal function get NormalAttribute () : String
		{
			
			return cattnorm;
			
		};
		
		internal function get ColorRGBAAttribute () : String
		{
			
			return cattcolrgba;
			
		};
		
		internal function get ColorRGBAttribute () : String
		{
			
			return cattcolrgb;
			
		};
		
		internal function get STLFile () : ByteArray
		{
			
			return file;
			
		};
		
		internal function get Length () : uint
		{
			
			return size;
			
		};
		
		internal function get Offset () : uint
		{
			
			return offs;
			
		};
		
	};
	
};