package org.myextend;

import android.content.Context;

import com.google.android.gms.analytics.Logger;
import com.google.android.gms.analytics.Tracker;
import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;

public class GoogleStatistic {
	
    private static final String PROPERTY_ID = "UA-57126537-1";
	
    private static Tracker mTracker;
    
	public GoogleStatistic(final Context pContext) {
		GoogleAnalytics analytics = GoogleAnalytics.getInstance(pContext);
		analytics.getLogger().setLogLevel(Logger.LogLevel.VERBOSE);
		
        GoogleAnalytics.getInstance(pContext).dispatchLocalHits();
		mTracker = analytics.newTracker(PROPERTY_ID);
		
//		mTracker.setSessionStart(true);
		
		//mTracker.set("sss", "Parent Fragment");
		//mTracker.send(MapBuilder.createAppView().build());
		
		//mTracker.setScreenName("Temp");
		//mTracker.send(new HitBuilders.AppViewBuilder().build());
	}
	
	public static void sendEvent(final String eventName, final String eventValue) {
		if(eventName.equals("setScreenName")) {
			mTracker.setScreenName(eventValue);
			mTracker.send(new HitBuilders.AppViewBuilder().build());
		}
		//mTracker.send(new HitBuilders.EventBuilder().setCategory("Temp")
        //        .setAction(eventName).setLabel("aaa").build());
	}
}