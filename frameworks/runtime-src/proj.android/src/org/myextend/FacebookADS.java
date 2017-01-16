package org.myextend;

import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import com.facebook.ads.*;

public class FacebookADS {
	public FacebookADS(final Activity activity) {
		Application app = activity.getApplication();
		FacebookSdk.sdkInitialize(app.getApplicationContext());
        AppEventsLogger.activateApp(app);
	}
}
