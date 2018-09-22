package org.myextend;

import android.app.Activity;

import com.android.billingclient.api.BillingClient;
import com.android.billingclient.api.BillingClient.BillingResponse;
import com.android.billingclient.api.BillingClient.FeatureType;
import com.android.billingclient.api.BillingClient.SkuType;
import com.android.billingclient.api.BillingClientStateListener;
import com.android.billingclient.api.BillingFlowParams;
import com.android.billingclient.api.ConsumeResponseListener;
import com.android.billingclient.api.Purchase;
import com.android.billingclient.api.Purchase.PurchasesResult;
import com.android.billingclient.api.PurchasesUpdatedListener;
import com.android.billingclient.api.SkuDetails;
import com.android.billingclient.api.SkuDetailsParams;
import com.android.billingclient.api.SkuDetailsResponseListener;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Billing implements PurchasesUpdatedListener
{
    private BillingClient mBillingClient;
    private GoogleStatistic mGoogleStatistic;
    private Activity mActivity;

    /**
     * True if billing service is connected now.
     */
    private boolean mIsServiceConnected;

    //----------------------------------
    public Billing(final Activity activity,
                       final GoogleStatistic googleStatistic)
    {
        Logger.info("Billing::Billing");
        mGoogleStatistic = googleStatistic;

        mActivity = activity;

        mBillingClient = BillingClient.newBuilder(mActivity).setListener(this).build();

        StartServiceConnection(new Runnable() {
            @Override
            public void run() {
                // IAB is fully set up. Now, let's get an inventory of stuff we own.
                Logger.info("Billing::Billing Setup successful. Querying inventory.");
            }
        });
    }

    //----------------------------------
    public void StartServiceConnection(final Runnable executeOnSuccess)
    {
        mBillingClient.startConnection(new BillingClientStateListener() {
            @Override
            public void onBillingSetupFinished(@BillingResponse int billingResponseCode) {
                Logger.info("Billing::Billing Setup finished. Response code: " + billingResponseCode);

                if (billingResponseCode == BillingResponse.OK) {
                    mIsServiceConnected = true;
                    if (executeOnSuccess != null) {
                        executeOnSuccess.run();
                    }
                }
//                mBillingClientResponseCode = billingResponseCode;
            }

            @Override
            public void onBillingServiceDisconnected() {
                mIsServiceConnected = false;
            }
        });
    }

    //----------------------------------
    private void ExecuteServiceRequest(Runnable runnable) {
        if (mIsServiceConnected) {
            runnable.run();
        } else {
            // If billing service was disconnected, we try to reconnect 1 time.
            // (feel free to introduce your retry policy here).
            StartServiceConnection(runnable);
        }
    }

    //----------------------------------
    /**
     * Start a purchase or subscription replace flow
     */
    public void InitiatePurchaseFlow(final String skuId) {
        Runnable purchaseFlowRequest = new Runnable() {
            @Override
            public void run() {
                Logger.info("Billing::InitiatePurchaseFlow Launching in-app purchase flow.");
                BillingFlowParams purchaseParams = BillingFlowParams.newBuilder()
                        .setSku(skuId).setType(SkuType.INAPP).build();
                int responseCode = mBillingClient.launchBillingFlow(mActivity, purchaseParams);
            }
        };

        ExecuteServiceRequest(purchaseFlowRequest);
    }

    //----------------------------------
    /**
    * Handle a callback that purchases were updated from the Billing library
    */
    @Override
    public void onPurchasesUpdated(int resultCode, List<Purchase> purchases) {
        if (resultCode == BillingResponse.OK)
        {
            for (Purchase purchase : purchases)
            {
//                handlePurchase(purchase);
                Logger.info("Billing::onPurchasesUpdated onPurchasesUpdated() - Result Ok");
            }
            Logger.info("Billing::onPurchasesUpdated onPurchasesUpdated() - Result Ok");
            mGoogleStatistic.sendEvent("Billing", "BillingResponse", "success", -1);
        }
        else if (resultCode == BillingResponse.USER_CANCELED)
        {
            mGoogleStatistic.sendEvent("Billing", "BillingResponse", "canceled", -1);
            Logger.info("Billing::onPurchasesUpdated onPurchasesUpdated() - user cancelled the purchase flow - skipping");
        }
        else
        {
            mGoogleStatistic.sendEvent("Billing", "BillingResponse", "unknown", resultCode);
            Logger.info("Billing::onPurchasesUpdated onPurchasesUpdated() got unknown resultCode: " + resultCode);
        }
    }
}
