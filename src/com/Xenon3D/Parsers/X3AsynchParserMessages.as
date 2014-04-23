package com.Xenon3D.Parsers
{
	
	internal class X3AsynchParserMessages
	{
		
		internal static const JOB_TYPE_STL:uint = 0;
		
		internal static const MESSAGE_JOB_SUBMIT:String = "0";
		
		internal static const WORKER_TO_MAIN_CHANNEL:String = "X3AsynchParserInterface-WorkerToMain";
		internal static const MAIN_TO_WORKER_CHANNEL:String = "X3AsynchParserInterface-MainToWorker";
		internal static const SHARED_MEMORY:String = "X3AsynchParserInterface-SharedMem";
		
		internal static const MESSAGE_READY:String = "0";
		internal static const MESSAGE_ERROR:String = "1";
		internal static const MESSAGE_JOB_DONE:String = "2";
		
		internal static const JOB_HEADER_STL:uint = 0xFA000001;
		
	};
	
};