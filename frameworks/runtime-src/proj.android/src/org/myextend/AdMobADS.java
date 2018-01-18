package org.myextend;

import android.app.Activity;

import com.google.android.gms.ads.AdListener;
import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.AdView;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.InterstitialAd;

import org.myextend.Logger;

import org.myextend.IADS;
import org.myextend.IADSListener;
import org.myextend.AdsStatus;

public class AdMobADS extends AdListener implements IADS
{
	private InterstitialAd mInterstitialAd;
	private Activity mActivity;
	private GoogleStatistic mGoogleStatistic;
	private int mErrorCode = -1;
	private IADSListener mListener = null;
	private AdsStatus mStatus = AdsStatus.NONE;
	private boolean mCanceled = false;

	public AdMobADS(final Activity activity,
			final GoogleStatistic googleStatistic) 
	{
		mGoogleStatistic = googleStatistic;
		// Initialize the Mobile Ads SDK.
        MobileAds.initialize(activity, "ca-app-pub-7659372211727082~6359254059");

		this.mActivity = activity;
		createInterstitialAd();
	}

	private void createInterstitialAd()
	{
		mInterstitialAd = new InterstitialAd(this.mActivity);

		mInterstitialAd.setAdUnitId("ca-app-pub-7659372211727082/4753442858");

		mInterstitialAd.setAdListener(this);
	}

	//----------------------------------
	public void loadADS() 
	{
		if (!mInterstitialAd.isLoading() /*&& !mInterstitialAd.isLoaded()*/) {
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
		mErrorCode = errorCode;
		mStatus = AdsStatus.FAILED;

		createInterstitialAd();

		if(mListener != null)
		{
			mListener.OnError("");
		}
	}

	//----------------------------------
	// Called when an ad is received.
	@Override
	public void onAdLoaded()
	{
		Logger.info("AdMobADS::onAdLoaded");

		if(!mCanceled)
		{
			mInterstitialAd.show();
		}

		if(mListener != null)
		{
			mListener.OnSuccess();
		}
		mStatus = AdsStatus.LOADED;
	}

	//----------------------------------
	@Override
	public void onAdOpened() 
	{
		createInterstitialAd();

//		loadADS();
	}

	//----------------------------------
	@Override
	public void Cancel()
	{
		mCanceled = true;
		createInterstitialAd();
	}

	//----------------------------------
	@Override
	public boolean Show()
	{
		Logger.info("AdMobADS::showADS");

		/*if(mInterstitialAd.isLoaded() && mCanceled)
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
//		mGoogleStatistic.sendEvent("adMob", "show", "success", -1);

		mStatus = AdsStatus.LOADING;
		final AdMobADS self = this;
		this.mActivity.runOnUiThread(new Runnable() {
        @Override public void run()
		{
			self.loadADS();
        }});
		return true;
	}

	//----------------------------------
	@Override
	public int GetStatus()
	{
		return mStatus.GetValue();
	}

	//----------------------------------
	@Override
	public void SetListener(IADSListener listener)
	{
		mListener = listener;
	}
}
