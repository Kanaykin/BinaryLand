package org.myextend;

import android.content.Context;

import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import java.util.ArrayList;
import android.os.Bundle;

public class FacebookStatistic {

    private static AppEventsLogger mLogger;

    //-----------------------------------------------------
    public FacebookStatistic(final Context pContext) {
        mLogger = AppEventsLogger.newLogger(pContext);
    }

    //-----------------------------------------------------
    public static void sendScreenName(final String eventValue) {

        mLogger.logEvent(eventValue);
    }

    //-----------------------------------------------------
    public static void sendTime(	final String category, final String label,
                                    final String variable, int value) {

        Bundle args=new Bundle();
        args.putInt("value", value);

        args.putString("variable", variable);

        args.putString("label", label);
        args.putInt("value", value);
        mLogger.logEvent(category, args);
    }

    //-----------------------------------------------------
    public static void sendException(final String description, boolean fatal) {
        Bundle args=new Bundle();
        args.putBoolean("fatal", fatal);
        mLogger.logEvent(description, args);
    }

    //-----------------------------------------------------
    public static void sendEvent(final String category, final String action,
                                 final String label, final int value) {
        Bundle args=new Bundle();
        args.putInt("value", value);

        args.putString("action", action);

        args.putString("label", label);
        mLogger.logEvent(category, args);
    }
}