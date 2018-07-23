package org.myextend;

import android.app.Activity;

import org.myextend.IADS;
import org.myextend.AdsStatus;

import com.appodeal.ads.Appodeal;
import com.appodeal.ads.Native;
import com.appodeal.ads.NativeAd;
import com.appodeal.ads.UserSettings;
import com.appodeal.ads.utils.Log;
import com.appodeal.ads.RewardedVideoCallbacks;
import com.google.android.gms.ads.MobileAds;

public class AppodealADS implements RewardedVideoCallbacks, IADS
{
	private GoogleStatistic mGoogleStatistic;
	private Activity mActivity;
	private AdsStatus mStatus = AdsStatus.NONE;
	private IADSListener mListener = null;
	private boolean mCanceled = false;

	public AppodealADS(final Activity activity,
		final GoogleStatistic googleStatistic) 
	{
		mGoogleStatistic = googleStatistic;

		mActivity = activity;
		String appKey = "ba5d75d04e0f85bfb450f4d20a3b54bce701bc5d64a94a56";
		Appodeal.disableLocationPermissionCheck();
		Appodeal.initialize(mActivity, appKey, Appodeal.REWARDED_VIDEO);
		Appodeal.setRewardedVideoCallbacks(this);
	}

	private void createInterstitialAd()
	{

	}

	@Override
	public void onRewardedVideoLoaded()
	{
//		if(!mCanceled && mRewardedVideoAd.isLoaded())
//		{
//			mRewardedVideoAd.show();
//		}

		if(mListener != null)
		{
			mListener.OnSuccess();
		}
		mStatus = AdsStatus.LOADED;
	}
	@Override
	public void onRewardedVideoFailedToLoad()
	{
		Logger.info("AppodealADS::onAdFailedToLoad");
		//mErrorCode = errorCode;
		mStatus = AdsStatus.FAILED;

		mGoogleStatistic.sendEvent("AppodealADS", "show", "error", 1);
//		createInterstitialAd();

		if(mListener != null)
		{
			mListener.OnError("");
		}
	}
	@Override
	public void onRewardedVideoShown() {
		mGoogleStatistic.sendEvent("AppodealADS", "show", "success", -1);
		mStatus = AdsStatus.LOADED;
		createInterstitialAd();
	}
	@Override
	public void onRewardedVideoFinished(int amount, String name)
	{
		mStatus = AdsStatus.LOADED;
		createInterstitialAd();
	}
	@Override
	public void onRewardedVideoClosed(boolean finished)
	{
		mStatus = AdsStatus.LOADED;
		createInterstitialAd();
	}

	//----------------------------------
	@Override
	public boolean Show()
	{
		mCanceled = false;
		mGoogleStatistic.sendEvent("AppodealADS", "show", "load", -1);
//		createInterstitialAd();

		this.mActivity.runOnUiThread(new Runnable() {
			@Override public void run()
			{
				if(!Appodeal.show(mActivity, Appodeal.REWARDED_VIDEO))
				{
					mStatus = AdsStatus.FAILED;
				}
			}});
		mStatus = AdsStatus.LOADING;
		return true;
	}

	//----------------------------------
	@Override
	public void Cancel()
	{
		mGoogleStatistic.sendEvent("AppodealADS", "show", "cancel", -1);
		mCanceled = true;
		mStatus = AdsStatus.FAILED;
		createInterstitialAd();
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