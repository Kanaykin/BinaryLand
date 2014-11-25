package org.myextend;

//import org.myextend.My;

import android.app.Activity;

public class MyExtendHelper {
	private static String sGoogleStatistic;
	
	public static void init(final Activity activity) {
		
	}
	
	public static void sendEventToStatistic(final String event) {
		String hjk;
		hjk = event;
		sGoogleStatistic = hjk;
	}
}
