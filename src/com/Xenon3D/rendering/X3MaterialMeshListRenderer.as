package com.Xenon3D.rendering
{
	
	import com.Xenon3D.geometry.X3MeshList;
	import com.Xenon3D.materials.X3IMaterial;
	import com.Xenon3D.shaders.X3Shader;
	
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	
	public class X3MaterialMeshListRenderer implements X3IRenderMethod
	{
		
		private var meshes:X3MeshList;
		private var mtrl:X3IMaterial;
		
		private var cctx:X3RenderContext;
		
		private var spgm:X3Shader;
		private var vtfm:X3VertexFormat;
		
		private var vbufs:Vector.<VertexBuffer3D>;
		private var ibufs:Vector.<IndexBuffer3D>;
		
		public function X3MaterialMeshListRenderer ( Material:X3IMaterial, Meshes:X3MeshList )
		{
			
			meshes = Meshes;
			mtrl = Material;
			
			spgm = new X3Shader ( mtrl.GetShaderProgram () );
			vtfm = mtrl.GetVertexFormat ();
			
			vbufs = new Vector.<VertexBuffer3D> ( meshes.meshCount, true );
			ibufs = new Vector.<IndexBuffer3D> ( meshes.meshCount, true );
			
		};
		
		public function ApplyRenderContext ( Context:X3RenderContext ) : void
		{
			
			cctx = Context;
			
			spgm.ApplyContext ( cctx.context );
			mtrl.ApplyContext ( cctx.context );
			
			for ( var i:uint = 0; i < meshes.meshCount; i ++ )
			{
				
				vbufs [ i ] = cctx.context.createVertexBuffer ( meshes.meshes [ i ].vertex.length / vtfm.GetVectorSize (), vtfm.GetVectorSize () );
				ibufs [ i ] = cctx.context.createIndexBuffer ( meshes.meshes [ i ].index.length );
				
				vbufs [ i ].uploadFromVector ( meshes.meshes [ i ].vertex, 0, meshes.meshes [ i ].vertex.length / vtfm.GetVectorSize () );
				ibufs [ i ].uploadFromVector ( meshes.meshes [ i ].index, 0, meshes.meshes [ i ].index.length );
				
			}
			
		};
		
		public function UnApplyRenderContext () : void
		{
			
			for ( var i:uint = 0; i < meshes.meshCount; i ++ )
			{
				
				vbufs [ i ].dispose ();
				ibufs [ i ].dispose ();
				
				vbufs [ i ] = null;
				ibufs [ i ] = null;
			
			}
			
			mtrl.UnApplyContext ();
			spgm.UnApplyContext ();
			
			cctx = null;
			
		};
		
		public function Render () : void
		{
			
			mtrl.Switch ();
			spgm.Switch ();
			
			for ( var i:uint = 0; i < meshes.meshCount; i ++ )
			{
				
				vtfm.ApplyVertexBuffer ( cctx.context, vbufs [ i ] );
				cctx.context.drawTriangles ( ibufs [ i ] );
				
			}
			
			vtfm.UnApplyVertexBuffer ( cctx.context );
			
		};
		
	};
	
};