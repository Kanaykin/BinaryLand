package org.myextend;

//import org.myextend.My;
import org.myextend.GoogleStatistic;
import android.app.Activity;


public class MyExtendHelper {
	private static GoogleStatistic 	sGoogleStatistic;
	
	public static void init(final Activity activity) {
		MyExtendHelper.sGoogleStatistic = new GoogleStatistic(activity);
		
	}
	
	public static void sendEventToStatistic(final String eventName, final String eventValue) {
		MyExtendHelper.sGoogleStatistic.sendEvent(eventName, eventValue);
	}

}
