package org.myextend;

import org.myextend.Logger;
import org.myextend.GoogleStatistic;
import org.myextend.FacebookADS;
import android.app.Activity;
import android.app.Application;
import android.util.Log;

public class MyExtendHelper {
	private static GoogleStatistic 	sGoogleStatistic;
	private static FacebookADS 	sFacebookADS;
	
	public static void init(final Activity activity) {
		MyExtendHelper.sGoogleStatistic = new GoogleStatistic(activity);
		MyExtendHelper.sFacebookADS = new FacebookADS(activity, MyExtendHelper.sGoogleStatistic);
	}
	
	public static void sendEventToStatistic(final String category, final String action, 
											final String label, int value) {
		MyExtendHelper.sGoogleStatistic.sendEvent(category, action, label, value);
	}
	
	public static void sendTimeToStatistic(	final String category, final String label, 
											final String variable, int value) {
		MyExtendHelper.sGoogleStatistic.sendTime(category, label, variable, value);
	}
	
	public static void sendScreenNameToStatistic(final String screenName) {
		MyExtendHelper.sGoogleStatistic.sendScreenName(screenName);
	}
	
	public static boolean showADS() {
		Logger.info("MyExtendHelper:showADS");
		return MyExtendHelper.sFacebookADS.showADS();
	}

}
