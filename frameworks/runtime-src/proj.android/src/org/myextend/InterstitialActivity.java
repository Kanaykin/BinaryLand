package org.myextend;

import android.app.Activity;
import android.os.Bundle;

import com.facebook.ads.*;

public class InterstitialActivity extends Activity implements InterstitialAdListener 
{
	private InterstitialAd interstitialAd;
	
	private void loadInterstitialAd() {
	    interstitialAd = new InterstitialAd(this, "1763334180655470_1764632917192263");
	    interstitialAd.setAdListener(this);
	    interstitialAd.loadAd();
	}
	
	@Override
	protected void onCreate(final Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        loadInterstitialAd();
	}
	
	@Override
	public void onError(Ad ad, AdError error) {
	    // Ad failed to load
	}
	
	@Override
	public void onAdLoaded(Ad ad) {
	    // Ad is loaded and ready to be displayed
	    // You can now display the full screen add using this code:
	    interstitialAd.show();
	}
	
	@Override
	public void onAdClicked(Ad ad) {
	}
	
	@Override
	public void onInterstitialDismissed(Ad ad) {
	}
	
	@Override
	public void onInterstitialDisplayed(Ad ad) {
	}
}
