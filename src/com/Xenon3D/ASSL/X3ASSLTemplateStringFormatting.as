package com.Xenon3D.ASSL
{
	
	public class X3ASSLTemplateStringFormatting
	{
		
		public static function StringTemplateIndexes ( S:String ) : Vector.<uint>
		{
			
			var ret:Vector.<uint> = new Vector.<uint> ();
			var i:int;
			
			while ( true )
			{
				
				i = S.indexOf ( "&{", i );
				
				if ( i == -1 )
					break;
				
				ret.push ( i );
				i ++;
				
			}
			
			return ret;
			
		};
		
	};
	
};