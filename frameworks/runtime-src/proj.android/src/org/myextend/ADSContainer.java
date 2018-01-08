package org.myextend;
import java.util.*;

import org.myextend.IADS;

import org.myextend.IADSListener;
import org.myextend.AdsStatus;

public class ADSContainer implements IADS, IADSListener
{
    private ArrayList<IADS> mAdvertisements;
    private int mCurrentAdsIndex = -1;
    private AdsStatus mStatus = AdsStatus.NONE;

    public ADSContainer()
    {
        mAdvertisements = new ArrayList<IADS>();
    }

    //----------------------------------
    @Override
    public boolean Show()
    {
        mCurrentAdsIndex = 0;
        mStatus = AdsStatus.LOADING;
        return ShowImpl();
    }

    //----------------------------------
    public boolean ShowImpl()
    {
        IADS ads = mAdvertisements.get(mCurrentAdsIndex++);
        return ads.Show();
    }

    //----------------------------------
    @Override
    public void Cancel()
    {
        if( mStatus == AdsStatus.LOADING)
        {
            IADS ads = mAdvertisements.get(mCurrentAdsIndex - 1);
            ads.Cancel();
        }
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

    }

    //----------------------------------
    @Override
    public void OnError(String error)
    {
        if( mCurrentAdsIndex >= mAdvertisements.size() )
        {
            mStatus = AdsStatus.FAILED;
        }
        else
        {
            ShowImpl();
        }
    }

    //----------------------------------
    @Override
    public void OnSuccess()
    {
        mStatus = AdsStatus.LOADED;
    }

    public void Add(IADS ads)
    {
        mAdvertisements.add(ads);
        ads.SetListener(this);
    }
}