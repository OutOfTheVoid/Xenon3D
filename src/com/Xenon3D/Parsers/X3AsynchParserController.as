package com.Xenon3D.Parsers
{
	
	import com.Xenon3D.Parsers.X3AsynchParserMessages;
	import com.Xenon3D.geometry.X3Mesh;
	import com.Xenon3D.geometry.X3MeshList;
	
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class X3AsynchParserController
	{
		
		[ Embed ( source = "../../../../workerswfs/com/Xenon3D/Parsers/X3AsynchParsingWorker.swf", mimeType = "application/octet-stream" ) ]
		private static const ASYNCH_INTERFACE_CLASS:Class;
		
		private var mtow:MessageChannel;
		private var wtom:MessageChannel;
		
		private var shmm:ByteArray;
		
		private var aspw:Worker;
		
		private var ready:Boolean;
		private var parsing:Boolean;
		
		private var jque:Vector.<X3IAsynchParseJob>;
		
		private var cjob:X3IAsynchParseJob;
		private var cjtyp:uint;
		
		public function X3AsynchParserController ()
		{
			
			var workerBytes:ByteArray = new ASYNCH_INTERFACE_CLASS () as ByteArray;
			aspw = WorkerDomain.current.createWorker ( workerBytes, false );
			
			mtow = Worker.current.createMessageChannel ( aspw );
			aspw.setSharedProperty ( X3AsynchParserMessages.MAIN_TO_WORKER_CHANNEL, mtow );
			
			wtom = aspw.createMessageChannel ( Worker.current );
			aspw.setSharedProperty ( X3AsynchParserMessages.WORKER_TO_MAIN_CHANNEL, wtom );
			
			shmm = new ByteArray ();
			shmm.shareable = true;
			
			aspw.setSharedProperty ( X3AsynchParserMessages.SHARED_MEMORY, shmm );
			
			wtom.addEventListener ( Event.CHANNEL_MESSAGE, OnReceive );
			
			trace ( "Starting asynch interface..." );
			
			aspw.start ();
			
			jque = new Vector.<X3IAsynchParseJob> ();
			
			ready = false;
			parsing = false;
			
		};
		
		public function AddJobToQueue ( Job:X3IAsynchParseJob ) : void
		{
			
			jque.push ( Job );
			
			if ( ready )
				SendQueuedJob ();
			
		};
		
		private function OnReceive ( E:Event ) : void
		{
			
			var Message:String = wtom.receive ( false );
			if ( Message == null )
				return;
			
			switch ( Message )
			{
				
				case X3AsynchParserMessages.MESSAGE_READY:
					
					ready = true;
					
					trace ( "Interface ready!" );
					
					SendQueuedJob ();
					
					break;
				
				case X3AsynchParserMessages.MESSAGE_JOB_DONE:
					
					trace ( "JOBDONE" );
					
					HandleResult ();
					
					parsing = false;
					
					break;
				
				case X3AsynchParserMessages.MESSAGE_ERROR:
					
					trace ( "SYNCHIERROR" );
					
					HandleError ();
					
					break;
				
			};
			
		};
		
		private function SendQueuedJob () : void
		{
			
			if ( jque.length == 0 )
				return;
			
			var Job:X3IAsynchParseJob = jque.shift ();
			
			if ( Job is X3AsynchSTLParseJob )
			{
				
				SendSTLJob ( Job as X3AsynchSTLParseJob );
				
				return;
				
			}
			
			SendQueuedJob ();
			
		};
		
		private function SendSTLJob ( Job:X3AsynchSTLParseJob ) : void
		{
			
			cjob = Job;
			cjtyp = X3AsynchParserMessages.JOB_TYPE_STL;
			
			shmm.position = 0;
			shmm.endian = Endian.LITTLE_ENDIAN;
			shmm.writeUnsignedInt ( X3AsynchParserMessages.JOB_HEADER_STL );
			shmm.writeByte ( Job.Flags );
			shmm.writeUnsignedInt( Job.DefaultColor );
			shmm.writeByte ( Job.MeshAttributes.GetNumberOfAttributes () );
			
			for ( var i:uint = 0; i < Job.MeshAttributes.GetNumberOfAttributes (); i ++ )
			{
				
				shmm.writeUTF ( Job.MeshAttributes.GetAttributeName ( i ) );
				shmm.writeByte ( Job.MeshAttributes.GetAttributeType ( i ) );
				
			}
			
			shmm.writeUTF ( Job.ColorRGBAAttribute );
			shmm.writeUTF ( Job.ColorRGBAttribute );
			shmm.writeUTF ( Job.NormalAttribute );
			shmm.writeUTF ( Job.PositionAttribute );
			shmm.writeUnsignedInt ( Job.Length );
			shmm.writeBytes ( Job.STLFile, Job.Offset, Job.Length );
			
			parsing = true;
			
			mtow.send ( X3AsynchParserMessages.MESSAGE_JOB_SUBMIT );
			
		};
		
		private function ReceiveSTLResult () : void
		{
			
			var Job:X3AsynchSTLParseJob = cjob as X3AsynchSTLParseJob;
			
			shmm.position = 0;
			shmm.endian = Endian.LITTLE_ENDIAN;
			
			if ( shmm.readUnsignedInt () != X3AsynchParserMessages.JOB_HEADER_STL )
				return;
			
			var meshCount:uint = shmm.readUnsignedInt ();
			var meshes:Vector.<X3Mesh> = new Vector.<X3Mesh> ( meshCount, true );
			
			for ( var i:uint = 0; i < meshCount; i ++ )
			{
				
				var vDataSize:uint = shmm.readUnsignedInt ();
				var vData:Vector.<Number> = new Vector.<Number> ( vDataSize, true );
				
				for ( var mv:uint = 0; mv < vDataSize; mv ++ )
					vData [ mv ] = shmm.readFloat ();
				
				var iDataSize:uint = shmm.readUnsignedInt ();
				var iData:Vector.<uint> = new Vector.<uint> ( iDataSize, true );
				
				for ( var mi:uint = 0; mi < iDataSize; mi ++ )
					iData [ mi ] = shmm.readUnsignedInt ();
				
				var mesh:X3Mesh = new X3Mesh ( Job.MeshAttributes, vData, iData );
				meshes [ i ] = mesh;
				
			}
			
			parsing = false;
			
			Job.rslt = new X3MeshList ( Job.MeshAttributes, meshes );
			Job.OnSuccess ();
			
			cjob = null;
			Job = null;
			
			parsing = false;
			
			SendQueuedJob ();
			
		};
		
		private function HandleResult () : void
		{
			
			switch ( cjtyp )
			{
				
				case X3AsynchParserMessages.JOB_TYPE_STL:
					
					ReceiveSTLResult ();
					
					break;
				
			}
			
		};
		
		private function HandleError () : void
		{
			
			shmm.position = 0;
			shmm.endian = Endian.LITTLE_ENDIAN;
			cjob.OnFailure ( shmm.readUTF () );
			
			cjob = null;
			
			parsing = false;
			
			SendQueuedJob ();
			
		};
		
		public function get WorkerReady () : Boolean
		{
			
			return ready;
			
		};
		
		public function get ParsingJob () : Boolean
		{
			
			return parsing;
			
		};
		
	};
	
};