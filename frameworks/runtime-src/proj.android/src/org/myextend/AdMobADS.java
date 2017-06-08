package org.myextend;

import android.app.Activity;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.InterstitialAd;

import org.myextend.Logger;

public class AdMobADS extends AdListener {
	private InterstitialAd mInterstitialAd;
	private Activity mActivity;
	private boolean mAdLoaded = false;
	private GoogleStatistic mGoogleStatistic;
	private int mErrorCode = -1;

	public AdMobADS(final Activity activity,
			final GoogleStatistic googleStatistic) 
	{
		mGoogleStatistic = googleStatistic;
		// Initialize the Mobile Ads SDK.
        MobileAds.initialize(activity, "ca-app-pub-7659372211727082~6359254059");
        mInterstitialAd = new InterstitialAd(activity);

		mInterstitialAd.setAdUnitId("ca-app-pub-7659372211727082/4753442858");

		mInterstitialAd.setAdListener(this);
		loadADS();
		this.mActivity = activity;
	}

	//----------------------------------
	public void loadADS() 
	{
		if (!mInterstitialAd.isLoading() && !mInterstitialAd.isLoaded()) {
            AdRequest adRequest = new AdRequest.Builder().build();
            Logger.info("AdMobADS::loadADS ");
            mInterstitialAd.loadAd(adRequest);
        } else {
            Logger.info( "The interstitial adMobA wasn't loaded yet.");
        }

	}

	//----------------------------------
	// Called when the user is about to return to the application after clicking on an ad.
	@Override
	public void onAdClosed()
	{
		loadADS();
		mAdLoaded = false;
	}

	//----------------------------------
	// Called when an ad request failed.
	@Override
	public void onAdFailedToLoad(int errorCode)
	{
		Logger.info("AdMobADS::onAdFailedToLoad");
		mErrorCode = errorCode;
	}

	//----------------------------------
	// Called when an ad is received.
	@Override
	public void onAdLoaded()
	{
		Logger.info("AdMobADS::onAdLoaded");
		//mInterstitialAd.show();
		mAdLoaded = true;
	}

	//----------------------------------
	@Override
	public void onAdOpened() 
	{

	}

	//----------------------------------
	public boolean showADS() 
	{
		if(!mAdLoaded) {
			mGoogleStatistic.sendEvent("adMob", "show", "error", mErrorCode);
			return false;
		}
		Logger.info("AdMobADS::showADS");
		mGoogleStatistic.sendEvent("adMob", "show", "success", -1);
		//mInterstitialAd.show();
		final InterstitialAd interstitial = mInterstitialAd;
		this.mActivity.runOnUiThread(new Runnable() {
        @Override public void run() {
            if (interstitial.isLoaded()) {
              interstitial.show();
         	}
        }});
		return true;
	}
}
