package org.myextend;

import android.util.Log;

public class Logger
{
	public static boolean mNativeLogEnable = true; 
	public static void SetEnableNativeLog(boolean enable)
	{ mNativeLogEnable = enable; }
	
	public static void fatal( String s ) 
	{
		nativeLogFatal( s );
	}

	public static void error( String s ) 
	{
		nativeLogError( s );
	}
	public static void debug( String s ) 
	{
		nativeLogDebug( s );
	}
	public static void verbose( String s ) 
	{
		nativeLogVerbose( s );
	}
	public static void warn( String s ) 
	{
		nativeLogWarn( s );
	}
	public static void info( String s ) 
	{
		nativeLogInfo( s );
	}
	
    private native static void nativeLogError( String s );
    private native static void nativeLogDebug( String s );
    private native static void nativeLogVerbose( String s );
    private native static void nativeLogWarn( String s );
    private native static void nativeLogInfo( String s );
    private native static void nativeLogFatal( String s );
}
