package org.myextend;

import org.myextend.Logger;
import org.myextend.GoogleStatistic;
import org.myextend.FacebookADS;
import org.myextend.ADSContainer;
import org.myextend.AdMobADS;
import android.app.Activity;
import android.app.Application;
import android.util.Log;

public class MyExtendHelper {
	private static GoogleStatistic 	sGoogleStatistic;
	private static IADS 	sADS;
	
	public static void init(final Activity activity) {
		MyExtendHelper.sGoogleStatistic = new GoogleStatistic(activity);

		FacebookADS facebookADS = new FacebookADS(activity, MyExtendHelper.sGoogleStatistic);
		AdMobADS adMobADS = new AdMobADS(activity, MyExtendHelper.sGoogleStatistic);

		ADSContainer adsContainer = new ADSContainer();
		adsContainer.Add(facebookADS);
		adsContainer.Add(adMobADS);

		MyExtendHelper.sADS = adsContainer;
	}
	
	public static void sendEventToStatistic(final String category, final String action, 
											final String label, int value) {
		MyExtendHelper.sGoogleStatistic.sendEvent(category, action, label, value);
	}
	
	public static void sendTimeToStatistic(	final String category, final String label, 
											final String variable, int value) {
		MyExtendHelper.sGoogleStatistic.sendTime(category, label, variable, value);
	}
	
	public static void sendExceptionToStatistic(final String description, boolean fatal) {
		MyExtendHelper.sGoogleStatistic.sendException(description, fatal);
	}
	
	public static void sendScreenNameToStatistic(final String screenName) {
		MyExtendHelper.sGoogleStatistic.sendScreenName(screenName);
	}
	
	public static boolean showADS() {
		Logger.info("MyExtendHelper:showADS");
		return MyExtendHelper.sADS.Show();
	}

	public static void cancelADS() {
		Logger.info("MyExtendHelper:cancelADS");
		MyExtendHelper.sADS.Cancel();
	}

	public static int getStatusADS() {
		Logger.info("MyExtendHelper:getStatusADS");
		return MyExtendHelper.sADS.GetStatus();
	}

}
