 package com.Xenon3D.ASSL
{
	
	public class X3ASSLVariableDefinition
	{
		
		public var name:String;
		public var type:uint;
		public var defr:Boolean;
		public var regs:String;
		public var texf:String;
		public var subr:Boolean;
		public var sbrd:String;
		public var cnst:Boolean;
		public var vary:Boolean;
		public var idef:Boolean;
		public var sdef:String;
		public var blen:uint;
		
		public static function Test ( Blocks:Vector.<String>, BaseBlock:uint = 0 ) : X3ASSLVariableDefinition
		{
			
			var out:X3ASSLVariableDefinition = new X3ASSLVariableDefinition ();
			
			out.vary = false;
			out.cnst = false;
			out.name = "";
			out.type = -1;
			out.defr = false;
			
			var i:uint = BaseBlock;
			
			while ( Blocks [ i ] == "const" || Blocks [ i ] == "varying" )
			{
				
				if ( Blocks [ i ] == "const" )
					out.cnst = true;
				else
					out.vary = true;
				
				i ++;
				
				if ( i >= Blocks.length )
					return null;
				
			}
			
			switch ( Blocks [ i ] )
			{
				
				case "vec1":
					
					out.type = X3ASSLTypes.ASSL_LT_V1;
					i ++;
					
					break;
				
				case "vec2":
						
					out.type = X3ASSLTypes.ASSL_LT_V2;
					i ++;
					
					break;
				
				case "vec3":
					
					out.type = X3ASSLTypes.ASSL_LT_V3;
					i ++;
					
					break;
				
				case "vec4":
					
					out.type = X3ASSLTypes.ASSL_LT_V4;
					i ++;
					
					break;
				
				case "matrix":
					
					out.type = X3ASSLTypes.ASSL_LT_MATRIX;
					i ++;
					
					break;
				
				case "texture":
					
					out.type = X3ASSLTypes.ASSL_LT_TEXTURE;
					i ++;
					
					if ( ! out.cnst )
						return null;
					
					break;
				
				default:
					
					return null;
			
			}
			
			if ( i >= Blocks.length )
				return null;
			
			var c:uint = Blocks [ i ].charCodeAt ( 0 );
			
			if ( ( c >= 0x41 && c <= 0x5A ) || ( c >= 0x61 && c <= 0x7A ) || ( c == 0x5f ) || ( c == 0x7E ) )
			{
				
				out.name = Blocks [ i ];
				i ++;
				
			}
			else
				return null;
			
			if ( i >= Blocks.length )
				return null;
			
			if ( Blocks [ i ] == ";" )
			{
				
				out.idef = false;	
				out.sdef = "";
				
				out.defr = false;
				out.regs = "?";
				
				out.blen = i + 1 - BaseBlock;
				
				return out;
			
			}
			else if ( Blocks [ i ] == "=" )
			{
				
				if ( out.cnst == false )
					return null;
				
				i ++;
				
				if ( i >= Blocks.length )
					return null;
				
				if ( Blocks [ i ].indexOf ( "${" ) == 0 )
				{
					
					var t:String;
					
					if ( Blocks [ i ] != "${" )
					{
						
						t = Blocks [ i ].slice ( 2 );
						
					}
					else
					{
						
						i ++;
						
						if ( i >= Blocks.length )
							return null;
						
						t = Blocks [ i ];
						
					}
					
					if ( t.charAt ( t.length - 1 ) == "}" )
					{
						
						t = t.slice ( 0, t.length - 2 );
						
						out.sbrd = t;
						out.subr = true;
						
						out.blen = i + 1 - BaseBlock;
						
						return out;
						
					}
					else
						return null;
					
				}
				else
				{
					
					switch ( out.type )
					{
						
						case X3ASSLTypes.ASSL_LT_V1:
							
							if ( Blocks [ i ].charAt ( 0 ) == "<" && Blocks [ i ].charAt ( Blocks [ i ].length - 1 ) == ">" )
							{
								
								out.idef = true;
								out.sdef = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							}
							else if ( ! isNaN (Number ( Blocks [ i ] ) ) )
							{
								
								out.idef = true;
								out.sdef = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_V2:
						case X3ASSLTypes.ASSL_LT_V3:
						case X3ASSLTypes.ASSL_LT_V4:
							
							if ( Blocks [ i ].charAt ( 0 ) == "<" && Blocks [ i ].charAt ( Blocks [ i ].length - 1 ) == ">" )
							{
								
								out.idef = true;
								out.sdef = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_MATRIX:
							
							if ( Blocks [ i ].charAt ( 0 ) == "[" && Blocks [ i ].charAt ( Blocks [ i ].length - 1 ) == "]" )
							{
								
								out.idef = true;
								out.sdef = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							}
							else
								return null;
							
							break;
						
						default:
							
							return null;
							
							break;
						
					}
					
				}
				
			}
			else if ( Blocks [ i ] == "@" )
			{
				
				i ++;
				
				if ( i >= Blocks.length )
					return null;
				
				if ( out.cnst )
				{
					
					var di:int;
					
					switch ( out.type )
					{
						
						case X3ASSLTypes.ASSL_LT_V1:
							
							if ( Blocks [ i ].slice ( 0, 2 ) == "vc" || Blocks [ i ].slice ( 0, 2 ) == "va" || Blocks [ i ].slice ( 0, 2 ) == "fc" )
							{
								
								di = Blocks.indexOf ( "." );
								
								if ( di == -1 )
									return null;
								
								if ( Blocks [ i ].length - di == 2 )
								{
									
									out.defr = true;
									out.regs = Blocks [ i ];
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_V2:
							
							if ( Blocks [ i ].slice ( 0, 2 ) == "vc" || Blocks [ i ].slice ( 0, 2 ) == "va" || Blocks [ i ].slice ( 0, 2 ) == "fc" )
							{
								
								di = Blocks.indexOf ( "." );
								
								if ( di == -1 )
									return null;
								
								if ( Blocks [ i ].length - di == 3 )
								{
									
									out.defr = true;
									out.regs = Blocks [ i ];
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_V3:
							
							if ( Blocks [ i ].slice ( 0, 2 ) == "vc" || Blocks [ i ].slice ( 0, 2 ) == "va" || Blocks [ i ].slice ( 0, 2 ) == "fc" )
							{
								
								di = Blocks.indexOf ( "." );
								
								if ( di == -1 )
									return null;
								
								if ( Blocks [ i ].length - di == 4 )
								{
									
									out.defr = true;
									out.regs = Blocks [ i ];
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_V4:
							
							if ( Blocks [ i ].slice ( 0, 2 ) == "vc" || Blocks [ i ].slice ( 0, 2 ) == "va" || Blocks [ i ].slice ( 0, 2 ) == "fc" )
							{
								
								if ( Blocks [ i ].length == 2 )
									return null;
								
								out.defr = true;
								out.regs = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_MATRIX:
							
							if ( Blocks [ i ].slice ( 0, 2 ) == "vc" )
							{
								
								if ( Blocks [ i ].length == 2 )
									return null;
								
								out.defr = true;
								out.regs = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_TEXTURE:
							
							if ( Blocks [ i ].slice ( 0, 2 ) == "fs" )
							{
								
								if ( Blocks [ i ].length == 2 )
									return null;
								
								out.regs = Blocks [ i ];
								
								i ++;
								
								if ( i >= Blocks.length )
									return null;
								
								if ( Blocks [ i ].charAt ( 0 ) == "<" && Blocks [ i ].charAt ( Blocks [ i ].length - 1 ) == ">" )
								{
									
									out.texf = Blocks [ i ];
									out.defr = true;
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								else
									return null;
								
							}
							else
								return null;
							
							break;
							
						
					}
					
				}
				else if ( out.vary )
				{
					
					switch ( out.type )
					{
						
						case X3ASSLTypes.ASSL_LT_V1:
							
							if ( Blocks [ i ].charAt ( 0 ) == "v" && Blocks [ i ].charAt ( 2 ) == "." )
							{
								
								if ( Blocks [ i ].length == 4 )
								{
									
									out.defr = true;
									out.regs = Blocks [ i ];
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_V2:
							
							if ( Blocks [ i ].charAt ( 0 ) == "v" && Blocks [ i ].charAt ( 2 ) == "." )
							{
								
								if ( Blocks [ i ].length == 5 )
								{
									
									out.defr = true;
									out.regs = Blocks [ i ];
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_V3:
							
							if ( Blocks [ i ].charAt ( 0 ) == "v" && Blocks [ i ].charAt ( 2 ) == "." )
							{
								
								if ( Blocks [ i ].length == 6 )
								{
									
									out.defr = true;
									out.regs = Blocks [ i ];
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_V4:
							
							if ( Blocks [ i ].charAt ( 0 ) == "v" && Blocks [ i ].charAt ( 2 ) == "." )
							{
								
								if ( Blocks [ i ].length == 7 )
								{
									
									out.defr = true;
									out.regs = Blocks [ i ];
									
									out.blen = i + 1 - BaseBlock;
									
									return out;
									
								}
								
							}
							else if ( Blocks [ i ].charAt ( 0 ) == "v" && Blocks [ i ].length == 2 )
							{
								
								out.defr = true;
								out.regs = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							}
							else
								return null;
							
							break;
						
						case X3ASSLTypes.ASSL_LT_MATRIX:
						case X3ASSLTypes.ASSL_LT_TEXTURE:
						default:
							
							return null;
						
					}
					
				}
				else //temporary registers
				{
					
					var ti:int;
					
					switch ( out.type )
					{
						
						case X3ASSLTypes.ASSL_LT_V1:
						case X3ASSLTypes.ASSL_LT_V2:
						case X3ASSLTypes.ASSL_LT_V3:
							
							if ( ( Blocks [ i ].slice ( 0, 2 ) == "vt" || Blocks [ i ].slice ( 0, 2 ) == "ft" ) && Blocks.indexOf ( "." ) != -1 )
							{
								
								out.defr = true;
								out.regs = Blocks [ i ];
								
								out.blen = i + 1 - BaseBlock;
								
								return out;
								
							};
							
							return null;
							
						case X3ASSLTypes.ASSL_LT_V4:
						case X3ASSLTypes.ASSL_LT_MATRIX:
						
						if ( Blocks [ i ].slice ( 0, 2 ) == "vt" || Blocks [ i ].slice ( 0, 2 ) == "ft" )
						{
							
							out.defr = true;
							out.regs = Blocks [ i ];
							
							out.blen = i + 1 - BaseBlock;
							
							return out;
								
						}
						
						case X3ASSLTypes.ASSL_LT_TEXTURE:
						default:
							
							return null;
						
					}
					
				}
				
			}
			else
				return null;
			
			return null;
			
		};
		
	};
	
};