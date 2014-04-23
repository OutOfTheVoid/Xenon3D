package com.Xenon3D.shaders
{
	
	import com.Xenon3D.X3IContextApplicable;
	
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.utils.ByteArray;
	
	public class X3Shader implements X3IContextApplicable
	{
		
		private var prog:Program3D;
		
		private var vbin:ByteArray;
		private var pbin:ByteArray;
		
		private var cctx:Context3D;
		
		public function X3Shader ( Program:X3IShaderProgram )
		{
			
			SetProgram ( Program );
			
		};
		
		public function SetProgram ( Program:X3IShaderProgram ) : void
		{
			
			vbin = null;
			pbin = null;
			
			if ( ! Program.IsCompiled () )
				Program.Compile ();
			
			vbin = Program.GetVertexBinary ();
			pbin = Program.GetPixelBinary ();
			
			if ( prog != null )
				prog.upload ( vbin, pbin );
			
		};
		
		public function GetProgram3DInstance () : Program3D
		{
			
			return prog;
			
		};
		
		public function ApplyContext ( Context:Context3D ) : void
		{
			
			if ( prog )
				UnApplyContext ();
			
			if ( vbin == null || pbin == null )
				throw new Error ( "X3Shader Error: Attempt made to load invalid shader programs.", 0 );
			
			prog = Context.createProgram ();
			prog.upload ( vbin, pbin );
			
			cctx = Context;
			
		};
		
		public function Switch () : void
		{
			
			cctx.setProgram ( prog );
			
		};
		
		public function UnApplyContext () : void
		{
			
			prog.dispose ();
			prog = null;
			
			cctx = null;
			
		};
		
	};
	
};