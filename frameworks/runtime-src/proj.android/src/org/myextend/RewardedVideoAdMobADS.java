package org.myextend;

import android.app.Activity;

import com.google.android.gms.ads.AdRequest;
import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.reward.RewardedVideoAd;
import com.google.android.gms.ads.reward.RewardedVideoAdListener;
import com.google.android.gms.ads.reward.RewardItem;

import org.myextend.IADS;
import org.myextend.IADSListener;
import org.myextend.AdsStatus;

public class RewardedVideoAdMobADS implements RewardedVideoAdListener, IADS
{
    private GoogleStatistic mGoogleStatistic;
    private Activity        mActivity;
    private RewardedVideoAd mRewardedVideoAd;
    private boolean mCanceled = false;
    private AdsStatus mStatus = AdsStatus.NONE;
    private IADSListener mListener = null;

    public RewardedVideoAdMobADS(final Activity activity,
                    final GoogleStatistic googleStatistic)
    {
        mGoogleStatistic = googleStatistic;
        // Initialize the Mobile Ads SDK.
        MobileAds.initialize(activity, "ca-app-pub-7659372211727082~6359254059");

        this.mActivity = activity;

        // Use an activity context to get the rewarded video instance.
        mRewardedVideoAd = MobileAds.getRewardedVideoAdInstance(this.mActivity);
        mRewardedVideoAd.setRewardedVideoAdListener(this);

        //loadRewardedVideoAd();
    }

    private void loadRewardedVideoAd()
    {
        mRewardedVideoAd.loadAd("ca-app-pub-7659372211727082/4753442858",
                new AdRequest.Builder().build());
    }

    // Called when a rewarded video ad has triggered a reward.
    @Override
    public void onRewarded(RewardItem reward)
    {

    }

    // Called when a rewarded video ad is closed.
    @Override
    public void onRewardedVideoAdClosed()
    {

    }

    // Called when a rewarded video ad request failed.
    @Override
    public void onRewardedVideoAdFailedToLoad(int errorCode)
    {
        Logger.info("RewardedVideoAdMobADS::onAdFailedToLoad");
        //mErrorCode = errorCode;
        mStatus = AdsStatus.FAILED;

        mGoogleStatistic.sendEvent("RewardedVideoAdMob", "show", "error", errorCode);

        //createInterstitialAd();

        if(mListener != null)
        {
            mListener.OnError("");
        }
    }

    // Called when a rewarded video ad leaves the application (e.g., to go to the browser).
    @Override
    public void onRewardedVideoAdLeftApplication()
    {

    }

    // Called when a rewarded video ad is loaded.
    @Override
    public void onRewardedVideoAdLoaded()
    {
        Logger.info("AdMobADS::onAdLoaded");
        mGoogleStatistic.sendEvent("RewardedVideoAdMob", "show", "success", -1);

        if(!mCanceled && mRewardedVideoAd.isLoaded())
        {
            mRewardedVideoAd.show();
        }

        if(mListener != null)
        {
            mListener.OnSuccess();
        }
        mStatus = AdsStatus.LOADED;
    }

    // Called when a rewarded video ad opens a overlay that covers the screen.
    @Override
    public void onRewardedVideoAdOpened()
    {

    }

    @Override
    public void onRewardedVideoStarted()
    {

    }

    //----------------------------------
    @Override
    public boolean Show()
    {
        Logger.info("RewardedVideoAdMobADS::showADS");

        mCanceled = false;
        mGoogleStatistic.sendEvent("RewardedVideoAdMob", "show", "load", -1);

        mStatus = AdsStatus.LOADING;
        final RewardedVideoAdMobADS self = this;
        this.mActivity.runOnUiThread(new Runnable() {
            @Override public void run()
            {
                self.loadRewardedVideoAd();
            }});
        return true;
    }

    //----------------------------------
    @Override
    public void Cancel()
    {
        mGoogleStatistic.sendEvent("RewardedVideoAdMob", "show", "cancel", -1);
        mCanceled = true;
        //createInterstitialAd();
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