package org.myextend;

import com.facebook.FacebookSdk;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.provider.Settings.Secure;
import android.provider.Settings;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
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
        
        String android_id = Settings.Secure.getString(app.getContentResolver(), Settings.Secure.ANDROID_ID);
        Logger.info("FacebookADS::FacebookADS android_id " + android_id);
        String deviceId = md5(android_id).toUpperCase();
        Logger.info("FacebookADS::FacebookADS deviceId " + deviceId);
        //AdSettings.addTestDevice("adf6e3f989077bbec4fe6cc6ee6fa05e");
        AdSettings.addTestDevice(deviceId);
        
        this.mActivity = activity;
        
        this.mInterstitialAd = new InterstitialAd(this.mActivity, "1763334180655470_1764632917192263");
        this.mInterstitialAd.setAdListener(this);
        this.mInterstitialAd.loadAd();
	}
	
	public static final String md5(final String s) {
	    try {
	        // Create MD5 Hash
	        MessageDigest digest = java.security.MessageDigest
	                .getInstance("MD5");
	        digest.update(s.getBytes());
	        byte messageDigest[] = digest.digest();

	        // Create Hex String
	        StringBuffer hexString = new StringBuffer();
	        for (int i = 0; i < messageDigest.length; i++) {
	            String h = Integer.toHexString(0xFF & messageDigest[i]);
	            while (h.length() < 2)
	                h = "0" + h;
	            hexString.append(h);
	        }
	        return hexString.toString();

	    } catch (NoSuchAlgorithmException e) {
	        //Logger.logStackTrace(TAG,e);
	    }
	    return "";
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
		Logger.info("FacebookADS::onError "+ error.getErrorMessage());
	}
	
	@Override
	public void onAdLoaded(Ad ad) {
		this.mAdLoaded = true;
		Logger.info("FacebookADS::onAdLoaded");
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
