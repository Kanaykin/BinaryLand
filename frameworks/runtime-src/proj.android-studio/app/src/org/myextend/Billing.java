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
                QueryPurchases();
            }
        });
    }

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

    /**
     * Query purchases across various use cases and deliver the result in a formalized way through
     * a listener
     */
    public void QueryPurchases() {
        Runnable queryToExecute = new Runnable() {
            @Override
            public void run() {
                long time = System.currentTimeMillis();
                PurchasesResult purchasesResult = mBillingClient.queryPurchases(SkuType.INAPP);
                Logger.info("Billing::QueryPurchases Querying purchases elapsed time: " + (System.currentTimeMillis() - time)
                        + "ms");
                if (purchasesResult.getResponseCode() == BillingResponse.OK) {
                    Logger.info("Billing::QueryPurchases Skipped subscription purchases query since they are not supported");
                } else {
                    Logger.info("Billing::QueryPurchases queryPurchases() got an error response code: "
                            + purchasesResult.getResponseCode());
                }
                OnQueryPurchasesFinished(purchasesResult);
            }
        };

        ExecuteServiceRequest(queryToExecute);
    }

    /**
     * Handle a result from querying of purchases and report an updated list to the listener
     */
    private void OnQueryPurchasesFinished(PurchasesResult result) {
        // Have we been disposed of in the meantime? If so, or bad result code, then quit
        if (mBillingClient == null || result.getResponseCode() != BillingResponse.OK) {
            Logger.info("Billing::OnQueryPurchasesFinished Billing client was null or result code (" + result.getResponseCode()
                    + ") was bad - quitting");
            return;
        }

        Logger.info("Billing::OnQueryPurchasesFinished Query inventory was successful.");

        // Update the UI and purchases inventory with new list of purchases
//        mPurchases.clear();
        onPurchasesUpdated(BillingResponse.OK, result.getPurchasesList());
    }

    private void ExecuteServiceRequest(Runnable runnable) {
        if (mIsServiceConnected) {
            runnable.run();
        } else {
            // If billing service was disconnected, we try to reconnect 1 time.
            // (feel free to introduce your retry policy here).
            StartServiceConnection(runnable);
        }
    }

    /**
     * Handles the purchase
     * <p>Note: Notice that for each purchase, we check if signature is valid on the client.
     * It's recommended to move this check into your backend.
     * See {@link Security#verifyPurchase(String, String, String)}
     * </p>
     * @param purchase Purchase to be handled
     */
    private void handlePurchase(Purchase purchase) {
//        if (!verifyValidSignature(purchase.getOriginalJson(), purchase.getSignature())) {
//            Log.i(TAG, "Got a purchase: " + purchase + "; but signature is bad. Skipping...");
//            return;
//        }

        Logger.info("Billing::handlePurchase Got a verified purchase: " + purchase);

//        mPurchases.add(purchase);
    }

    public void QuerySkuDetailsAsync(@SkuType final String itemType, final List<String> skuList,
                                     final SkuDetailsResponseListener listener) {
        // Creating a runnable from the request to use it inside our connection retry policy below
        Runnable queryRequest = new Runnable() {
            @Override
            public void run() {
                // Query the purchase async
                SkuDetailsParams.Builder params = SkuDetailsParams.newBuilder();
                params.setSkusList(skuList).setType(itemType);
                mBillingClient.querySkuDetailsAsync(params.build(),
                        new SkuDetailsResponseListener() {
                            @Override
                            public void onSkuDetailsResponse(int responseCode,
                                                             List<SkuDetails> skuDetailsList) {
                                Logger.info("Billing::onSkuDetailsResponse ");
                                if (responseCode == BillingResponse.OK && skuDetailsList != null) {
                                    for (SkuDetails skuDetails : skuDetailsList) {
                                        String sku = skuDetails.getSku();
                                        String price = skuDetails.getPrice();
                                        Logger.info("Billing::onSkuDetailsResponse sku: " + sku);
//                                        InitiatePurchaseFlow(sku, SkuType.INAPP);
                                    }
                                }
//                                listener.onSkuDetailsResponse(responseCode, skuDetailsList);
                            }
                        });
            }
        };

        ExecuteServiceRequest(queryRequest);
    }

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
                mBillingClient.launchBillingFlow(mActivity, purchaseParams);
            }
        };

        ExecuteServiceRequest(purchaseFlowRequest);
    }

    /**
     * Handle a callback that purchases were updated from the Billing library
     */
    @Override
    public void onPurchasesUpdated(int resultCode, List<Purchase> purchases) {
        if (resultCode == BillingResponse.OK) {
            for (Purchase purchase : purchases) {
                handlePurchase(purchase);
            }
//            mBillingUpdatesListener.onPurchasesUpdated(mPurchases);
        } else if (resultCode == BillingResponse.USER_CANCELED) {
            Logger.info("Billing::onPurchasesUpdated onPurchasesUpdated() - user cancelled the purchase flow - skipping");
        } else {
            Logger.info("Billing::onPurchasesUpdated onPurchasesUpdated() got unknown resultCode: " + resultCode);
        }

        List skuList = new ArrayList<> ();
        skuList.add("com.mycompany.binaryland.buycoffee");
        QuerySkuDetailsAsync(SkuType.INAPP, skuList, null);
    }
}
