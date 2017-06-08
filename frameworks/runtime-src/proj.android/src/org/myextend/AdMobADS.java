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

	public AdMobADS(final Activity activity,
			final GoogleStatistic googleStatistic) 
	{
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

	}

	//----------------------------------
	// Called when an ad request failed.
	@Override
	public void onAdFailedToLoad(int errorCode)
	{
		Logger.info("AdMobADS::onAdFailedToLoad");
	}

	//----------------------------------
	// Called when an ad is received.
	@Override
	public void onAdLoaded()
	{
		Logger.info("AdMobADS::onAdLoaded");
		//mInterstitialAd.show();
	}

	//----------------------------------
	@Override
	public void onAdOpened() 
	{

	}

	//----------------------------------
	public boolean showADS() 
	{
		Logger.info("AdMobADS::showADS");
		//mInterstitialAd.show();
		final InterstitialAd interstitial = mInterstitialAd;
		this.mActivity.runOnUiThread(new Runnable() {
        @Override public void run() {
            if (interstitial.isLoaded()) {
              interstitial.show();
         }
        }
    });
		return true;
	}
}
