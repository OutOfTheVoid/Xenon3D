package com.Xenon3D.rendering
{
	import com.Xenon3D.geometry.X3Mesh;
	import com.Xenon3D.materials.X3IMaterial;
	import com.Xenon3D.shaders.X3Shader;
	
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	
	public class X3MaterialMeshRenderer implements X3IRenderMethod
	{
		
		private var mesh:X3Mesh;
		private var mtrl:X3IMaterial;
		
		private var cctx:X3RenderContext;
		
		private var spgm:X3Shader;
		private var vtfm:X3VertexFormat;
		
		private var vbuf:VertexBuffer3D;
		private var ibuf:IndexBuffer3D;
		
		public function X3MaterialMeshRenderer ( Material:X3IMaterial, Mesh:X3Mesh )
		{
			
			mesh = Mesh;
			mtrl = Material;
			
			spgm = new X3Shader ( mtrl.GetShaderProgram () );
			vtfm = mtrl.GetVertexFormat ();
			
		};
		
		public function ApplyRenderContext ( Context:X3RenderContext ) : void
		{
			
			cctx = Context;
			
			spgm.ApplyContext ( cctx.context );
			mtrl.ApplyContext ( cctx.context );
			
			vbuf = cctx.context.createVertexBuffer ( mesh.vertex.length / vtfm.GetVectorSize (), vtfm.GetVectorSize () );
			ibuf = cctx.context.createIndexBuffer ( mesh.index.length );
			
			vbuf.uploadFromVector ( mesh.vertex, 0, mesh.vertex.length / vtfm.GetVectorSize () );
			ibuf.uploadFromVector ( mesh.index, 0, mesh.index.length );
			
		};
		
		public function UnApplyRenderContext () : void
		{
			
			vbuf.dispose ();
			ibuf.dispose ();
			
			vbuf = null;
			ibuf = null;
			
			mtrl.UnApplyContext ();
			spgm.UnApplyContext ();
			
			cctx = null;
			
		};
		
		public function Render () : void
		{
			
			vtfm.ApplyVertexBuffer ( cctx.context, vbuf );
			
			spgm.Switch ();
			mtrl.Switch ();
			
			cctx.context.drawTriangles ( ibuf );
			
			vtfm.UnApplyVertexBuffer ( cctx.context );
			
		};
		
	};
	
};