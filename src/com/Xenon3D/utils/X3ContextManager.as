package com.Xenon3D.utils
{
	
	import flash.display.Stage;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	
	public class X3ContextManager 
	{
		
		private var stageInstance:Stage;
		private var totalContexts:uint;
		
		private var trackers:Vector.<Stage3DTracker>;
		
		public function X3ContextManager ( StageInstance:Stage )
		{
			
			stageInstance = StageInstance;
			
			totalContexts = stageInstance.stage3Ds.length;
			trackers = new Vector.<Stage3DTracker> ( totalContexts, true );
			
		};
		
		public function Init () : void
		{
			
			for ( var i:uint = 0; i < totalContexts; i ++ )
			{
				
				var t:Stage3DTracker = new Stage3DTracker ();
				
				t.Constructed = ( stageInstance.stage3Ds [ i ].context3D != null );
				t.Registered = false;
				
				trackers [ i ] = t;
				
			}
			
		};
		
		public function SetRegistered ( Stage3DIndex:uint ) : Boolean
		{
			
			if ( trackers [ Stage3DIndex ].Request != null )
				return false;
			
			trackers [ Stage3DIndex ].Registered = true;
			return true;
			
		};
		
		public function RequestContext ( OnContext:Function, IgnoreRegistered:Boolean = true, Profile:String = Context3DProfile.BASELINE_EXTENDED, ProfileImperative:Boolean = false ) : int
		{
			
			var req:ContextRequest = new ContextRequest ();
			req.func = OnContext;
			
			for ( var i:uint = 0; i < totalContexts; i ++ )
				if ( trackers [ i ].Constructed )
					if ( ! trackers [ i ].Registered || ! IgnoreRegistered )
					{
						
						req.func ( stageInstance.stage3Ds [ i ] );
						trackers [ i ].Registered = true;
						
						return i;
						
					};
			
			for ( var c:uint = 0; c < totalContexts; c ++ )
				if ( !trackers [ c ].Constructed && trackers [ c ].Request == null )
				{
					
					req.rqi = c;
					trackers [ c ].Request = req;
					
					stageInstance.stage3Ds [ c ].addEventListener ( Event.CONTEXT3D_CREATE, trackers [ c ].OnRequestSatisfied );
					if ( ! ProfileImperative )
						stageInstance.stage3Ds [ c ].requestContext3D ( Context3DRenderMode.AUTO, Profile );
					else
						stageInstance.stage3Ds [ c ].requestContext3D ( Context3DRenderMode.AUTO, Profile );
					
					return c;
					
				}	
			
			return -1;
			
		};
		
		public function ReturnContext ( Stage3DIndex:uint, KillRequest:Boolean = false ) : Boolean
		{
			
			if ( trackers [ Stage3DIndex ].Request != null )
			{
				
				if ( KillRequest )
				{
					
					stageInstance.stage3Ds [ Stage3DIndex ].removeEventListener ( Event.CONTEXT3D_CREATE, trackers [ Stage3DIndex ].Request.func );
					trackers [ Stage3DIndex ].Request = null;
					
					return true;
					
				}
				else
					return false;
				
			}
			
			trackers [ Stage3DIndex ].Registered = false;
			trackers [ Stage3DIndex ].Constructed = false;
			
			stageInstance.stage3Ds [ Stage3DIndex ].context3D.dispose ();
			
			return true;
			
		};
		
	};
	
};

import flash.display.Stage3D;
import flash.events.Event;

class ContextRequest
{
	
	public var func:Function;
	public var rqi:uint;
	
};

class Stage3DTracker
{
	
	public var Constructed:Boolean;
	public var Registered:Boolean;
	public var Request:ContextRequest;
	
	public function OnRequestSatisfied ( E:Event ) : void
	{
		
		( E.target as Stage3D ).removeEventListener ( Event.CONTEXT3D_CREATE, OnRequestSatisfied );
		Request.func ( ( E.target as Stage3D ) );
		Request = null;
		
		Constructed = true;
		Registered = true;
		
	};
	
};