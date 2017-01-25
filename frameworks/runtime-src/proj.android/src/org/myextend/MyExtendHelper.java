package org.myextend;

//import org.myextend.My;
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
		MyExtendHelper.sFacebookADS = new FacebookADS(activity);
	}
	
	public static void sendEventToStatistic(final String eventName, final String eventValue) {
		MyExtendHelper.sGoogleStatistic.sendEvent(eventName, eventValue);
	}
	
	public static void showADS() {
		Log.e("INFO", "MyExtendHelper:showADS");
		MyExtendHelper.sFacebookADS.showADS();
	}

}
