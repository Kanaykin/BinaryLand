package org.myextend;

import android.content.Context;

import com.google.android.gms.analytics.Logger;
import com.google.android.gms.analytics.Tracker;
import com.google.android.gms.analytics.GoogleAnalytics;
import com.google.android.gms.analytics.HitBuilders;

public class GoogleStatistic {
	
    private static final String PROPERTY_ID = "UA-57126537-1";
	
    private static Tracker mTracker;
    
    //-----------------------------------------------------
	public GoogleStatistic(final Context pContext) {
		GoogleAnalytics analytics = GoogleAnalytics.getInstance(pContext);
		analytics.getLogger().setLogLevel(Logger.LogLevel.VERBOSE);
		
        GoogleAnalytics.getInstance(pContext).dispatchLocalHits();
		mTracker = analytics.newTracker(PROPERTY_ID);
		
//		mTracker.setSessionStart(true);
		
	}
	
	//-----------------------------------------------------
	public static void sendScreenName(final String eventValue) {
		mTracker.setScreenName(eventValue);
		mTracker.send(new HitBuilders.AppViewBuilder().build());		
	}
	
	//-----------------------------------------------------
	public static void sendTime(	final String category, final String label, 
			final String variable, int value) {
		HitBuilders.TimingBuilder tb = new HitBuilders.TimingBuilder()
		         .setCategory(category)
		         .setLabel(label)
		         .setValue(value)
		         .setVariable(variable);
		mTracker.send(tb.build());
	}
	
	//-----------------------------------------------------
	public static void sendException(final String description, boolean fatal) {
		HitBuilders.ExceptionBuilder exc = new HitBuilders.ExceptionBuilder()
		         .setDescription(description)
		         .setFatal(fatal);
		mTracker.send(exc.build());
	}
	
	//-----------------------------------------------------
	public static void sendEvent(final String category, final String action, 
			final String label, final int value) {
		
		HitBuilders.EventBuilder builder = new HitBuilders.EventBuilder()
		         .setCategory(category)
		         .setAction(action)
		         .setLabel(label); 
		if(value != -1) {
			builder.setValue(value);
		}
        mTracker.send(builder.build());
	}
}