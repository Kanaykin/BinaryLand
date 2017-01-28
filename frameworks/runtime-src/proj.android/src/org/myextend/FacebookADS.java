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
	private InterstitialAd mInterstitialAd;
	private boolean mAdLoaded = false;
	public FacebookADS(final Activity activity) {
		Logger.info("FacebookADS::FacebookADS");
		Application app = activity.getApplication();
		FacebookSdk.sdkInitialize(activity);
        AppEventsLogger.activateApp(app);
        
        this.mActivity = activity;
        
        this.mInterstitialAd = new InterstitialAd(this.mActivity, "1763334180655470_1764632917192263");
        this.mInterstitialAd.setAdListener(this);
        this.mInterstitialAd.loadAd();
	}
	
	public boolean showADS() 
	{
		Logger.info("FacebookADS::showADS");
		this.mInterstitialAd.show();
		//interstitialAd.loadAd();
		//interstitialAd.loadAd();

	    
		//Intent intent = new Intent(this.mActivity, InterstitialActivity.class);
		//this.mActivity.startActivity(intent);
		return mAdLoaded;
	}
	@Override
	public void onError(Ad ad, AdError error) {
	    // Ad failed to load
	}
	
	@Override
	public void onAdLoaded(Ad ad) {
		this.mAdLoaded = true;
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
		mAdLoaded = false;
		mInterstitialAd = new InterstitialAd(this.mActivity, "1763334180655470_1764632917192263");
		mInterstitialAd.setAdListener(this);
		mInterstitialAd.loadAd();
	}
}
