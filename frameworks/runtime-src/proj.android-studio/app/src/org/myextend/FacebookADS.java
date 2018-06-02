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
import org.myextend.GoogleStatistic;

import org.myextend.IADS;
import org.myextend.IADSListener;
import org.myextend.AdsStatus;


public class FacebookADS implements InterstitialAdListener, IADS
{
	private Activity mActivity;
	private InterstitialAd mInterstitialAd;
	private boolean mCanceled = false;
	private GoogleStatistic mGoogleStatistic;
	private String mErrorMessage;

	private IADSListener mListener = null;
	private AdsStatus mStatus = AdsStatus.NONE;
	
	public FacebookADS(final Activity activity,
			final GoogleStatistic googleStatistic) 
	{
		mGoogleStatistic = googleStatistic;
		Logger.info("FacebookADS::FacebookADS");
		Application app = activity.getApplication();
		FacebookSdk.sdkInitialize(activity);
        AppEventsLogger.activateApp(app);
        
        String android_id = Settings.Secure.getString(app.getContentResolver(), Settings.Secure.ANDROID_ID);
        Logger.info("FacebookADS::FacebookADS android_id " + android_id);
//        String deviceId = md5(android_id).toUpperCase();
//        Logger.info("FacebookADS::FacebookADS deviceId " + deviceId);
        //AdSettings.addTestDevice("adf6e3f989077bbec4fe6cc6ee6fa05e");
//        AdSettings.addTestDevice(deviceId);
        
        this.mActivity = activity;
        
        this.mInterstitialAd = new InterstitialAd(this.mActivity, "1763334180655470_1764632917192263");

        this.mInterstitialAd.setAdListener(this);
//        this.mInterstitialAd.loadAd();
	}

	public void onLoggingImpression(Ad ad){}
	
	public static final String md5(final String s)
	{
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

	@Override
	public int GetStatus()
	{
		return mStatus.GetValue();
	}

	@Override
	public void Cancel()
	{
		mGoogleStatistic.sendEvent("FacebookADS", "show", "cancel", -1);
		mCanceled = true;
	}

	//----------------------------------
	@Override
	public void SetListener(IADSListener listener)
	{
		mListener = listener;
	}

	@Override
	public boolean Show()
	{
		Logger.info("FacebookADS::showADS");
		/*if(mInterstitialAd.isAdLoaded() && mCanceled)
		{
			mCanceled = false;
			mStatus = AdsStatus.LOADING;

			final InterstitialAd ad = mInterstitialAd;

			this.mActivity.runOnUiThread(new Runnable() {
				@Override public void run()
				{
					ad.show();

					mStatus = AdsStatus.LOADED;

					if(mListener != null)
					{
						mListener.OnSuccess();
					}
				}});

			return true;
		}*/
		mCanceled = false;
		mGoogleStatistic.sendEvent("FacebookADS", "show", "load", -1);
//		this.mInterstitialAd.loadAd();

		mStatus = AdsStatus.LOADING;
		final InterstitialAd ad = mInterstitialAd;
		this.mActivity.runOnUiThread(new Runnable() {
			@Override public void run()
			{
				ad.loadAd();
			}});

//		if(mAdLoaded)
//		{
//			mGoogleStatistic.sendEvent("FacebookADS", "show", "success", -1);
//			this.mInterstitialAd.show();
//			return true;
//		}
//		else {
//			mGoogleStatistic.sendEvent("FacebookADS", "show", "error:"+mErrorMessage, -1);
//			mErrorMessage = "";
//		}

		return true;
	}

	@Override
	public void onError(Ad ad, AdError error)
	{
	    // Ad failed to load
		mErrorMessage = error.getErrorMessage();
		Logger.info("FacebookADS::onError "+ error.getErrorMessage());
		mGoogleStatistic.sendEvent("FacebookADS", "show", mErrorMessage, -1);

		mStatus = AdsStatus.FAILED;

		if(mListener != null)
		{
			mListener.OnError(mErrorMessage);
		}
	}
	
	@Override
	public void onAdLoaded(Ad ad)
	{
		if(!mCanceled)
		{
			this.mInterstitialAd.show();
		}
		mStatus = AdsStatus.LOADED;

		if(mListener != null)
		{
			mListener.OnSuccess();
		}
		Logger.info("FacebookADS::onAdLoaded");
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
		mInterstitialAd = new InterstitialAd(this.mActivity, "1763334180655470_1764632917192263");
		mInterstitialAd.setAdListener(this);
		mInterstitialAd.loadAd();
	}
}
