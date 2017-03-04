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
	
	public static void sendEventToStatistic(final String category, final String action, final String label) {
		MyExtendHelper.sGoogleStatistic.sendEvent(category, action, label);
	}
	
	public static void sendScreenNameToStatistic(final String screenName) {
		MyExtendHelper.sGoogleStatistic.sendScreenName(screenName);
	}
	
	public static boolean showADS() {
		Logger.info("MyExtendHelper:showADS");
		return MyExtendHelper.sFacebookADS.showADS();
	}

}
