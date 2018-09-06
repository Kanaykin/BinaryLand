package org.myextend;

import org.myextend.Logger;
import org.myextend.GoogleStatistic;
import org.myextend.FacebookStatistic;
import org.myextend.FacebookADS;
import org.myextend.ADSContainer;
import org.myextend.AdMobADS;
import org.myextend.AppodealADS;
import org.myextend.RewardedVideoAdMobADS;
import org.myextend.Billing;
import android.app.Activity;
import android.app.Application;
import android.util.Log;

import com.google.ads.consent.*;

public class MyExtendHelper {
	private static GoogleStatistic 	sGoogleStatistic;
	private static FacebookStatistic sFacebookStatistic;
	private static IADS 	sADS;
	private static Billing 	sBilling;
	
	public static void init(final Activity activity) {
		if(MyExtendHelper.sGoogleStatistic == null) {
			MyExtendHelper.sGoogleStatistic = new GoogleStatistic(activity);
		}
//		MyExtendHelper.sFacebookStatistic = new FacebookStatistic(activity);

//		FacebookADS facebookADS = new FacebookADS(activity, MyExtendHelper.sGoogleStatistic);
//		AdMobADS adMobADS = new AdMobADS(activity, MyExtendHelper.sGoogleStatistic);
//		RewardedVideoAdMobADS adMobVideo = new RewardedVideoAdMobADS(activity, MyExtendHelper.sGoogleStatistic);

//		ADSContainer adsContainer = new ADSContainer();
//		adsContainer.Add(facebookADS);
//		adsContainer.Add(adMobADS);

		if(MyExtendHelper.sADS == null) {
			AppodealADS ads = new AppodealADS(activity, MyExtendHelper.sGoogleStatistic);
			MyExtendHelper.sADS = ads;
		}

		ConsentInformation consentInformation = ConsentInformation.getInstance(activity);
		String[] publisherIds = {"pub-7659372211727082"};

		consentInformation.requestConsentInfoUpdate(publisherIds, new ConsentInfoUpdateListener() {
			@Override
			public void onConsentInfoUpdated(ConsentStatus consentStatus) {
				// User's consent status successfully updated.
				Logger.info("MyExtendHelper:init User's consent status successfully updated.");
			}

			@Override
			public void onFailedToUpdateConsentInfo(String errorDescription) {
				// User's consent status failed to update.
				Logger.info("MyExtendHelper:init User's consent status failed to update.");
			}
		});

		if(MyExtendHelper.sBilling == null) {
			MyExtendHelper.sBilling = new Billing(activity, MyExtendHelper.sGoogleStatistic);
		}
	}
	
	public static void sendEventToStatistic(final String category, final String action, 
											final String label, int value) {
		MyExtendHelper.sGoogleStatistic.sendEvent(category, action, label, value);
//		MyExtendHelper.sFacebookStatistic.sendEvent(category, action, label, value);
	}
	
	public static void sendTimeToStatistic(	final String category, final String label, 
											final String variable, int value) {
		MyExtendHelper.sGoogleStatistic.sendTime(category, label, variable, value);
//		MyExtendHelper.sFacebookStatistic.sendTime(category, label, variable, value);
	}
	
	public static void sendExceptionToStatistic(final String description, boolean fatal) {
		MyExtendHelper.sGoogleStatistic.sendException(description, fatal);
//		MyExtendHelper.sFacebookStatistic.sendException(description, fatal);
	}
	
	public static void sendScreenNameToStatistic(final String screenName) {
		MyExtendHelper.sGoogleStatistic.sendScreenName(screenName);
//		MyExtendHelper.sFacebookStatistic.sendScreenName(screenName);
	}
	
	public static boolean showADS() {
		Logger.info("MyExtendHelper:showADS");
		return MyExtendHelper.sADS.Show();
	}

	public static void cancelADS() {
		Logger.info("MyExtendHelper:cancelADS");
		MyExtendHelper.sADS.Cancel();
	}

	public static int getStatusADS() {
		Logger.info("MyExtendHelper:getStatusADS");
		return MyExtendHelper.sADS.GetStatus();
	}

	public static void purchase(final String skuId)
	{
		Logger.info("MyExtendHelper:Purchase");
		MyExtendHelper.sBilling.InitiatePurchaseFlow(skuId);
	}
}
