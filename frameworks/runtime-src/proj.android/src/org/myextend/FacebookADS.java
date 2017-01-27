package org.myextend;

import com.facebook.FacebookSdk;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import com.facebook.ads.*;
import com.facebook.appevents.AppEventsLogger;
import org.myextend.Logger;

public class FacebookADS implements InterstitialAdListener{
	private Activity mActivity;
	private InterstitialAd interstitialAd;
	public FacebookADS(final Activity activity) {
		Logger.info("FacebookADS::FacebookADS");
		
		Application app = activity.getApplication();
		FacebookSdk.sdkInitialize(activity);
        AppEventsLogger.activateApp(app);
        
        this.mActivity = activity;
        
	    interstitialAd = new InterstitialAd(this.mActivity, "1763334180655470_1764632917192263");
	    interstitialAd.setAdListener(this);
	    interstitialAd.loadAd();
	}
	
	public void showADS() 
	{
		Logger.info("FacebookADS::showADS");
		interstitialAd.show();
		//interstitialAd.loadAd();
		//interstitialAd.loadAd();

	    
		//Intent intent = new Intent(this.mActivity, InterstitialActivity.class);
		//this.mActivity.startActivity(intent);
	}
	@Override
	public void onError(Ad ad, AdError error) {
	    // Ad failed to load
	}
	
	@Override
	public void onAdLoaded(Ad ad) {
		//Logger.info("FacebookADS::onAdLoaded");
	    // Ad is loaded and ready to be displayed
	    // You can now display the full screen add using this code:
	    //interstitialAd.show();
	}
	
	@Override
	public void onAdClicked(Ad ad) {
	}
	
	@Override
	public void onInterstitialDismissed(Ad ad) {
		//interstitialAd.loadAd();
	}
	
	@Override
	public void onInterstitialDisplayed(Ad ad) {
		interstitialAd = new InterstitialAd(this.mActivity, "1763334180655470_1764632917192263");
	    interstitialAd.setAdListener(this);
	    interstitialAd.loadAd();
	}
}
