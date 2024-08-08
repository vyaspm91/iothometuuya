package com.iothome.tuuya.iothometuuya;

import android.app.Application;
import android.content.Context;
import com.thingclips.smart.home.sdk.ThingHomeSdk;
import com.thingclips.smart.optimus.sdk.ThingOptimusSdk;
import com.thingclips.smart.sdk.api.INeedLoginListener;
import android.util.Log;

public class BaseApplication extends Application {
    private static final String TAG = "BaseApplication";

    @Override
    public void onCreate() {
        super.onCreate();

        // Initialize Tuya SDK
        try {
            ThingHomeSdk.init(this);
            ThingHomeSdk.setDebugMode(true);
            ThingOptimusSdk.init(this);
            Log.d(TAG, "Tuya SDK initialized successfully");
        } catch (Exception e) {
            Log.e(TAG, "Tuya SDK initialization failed", e);
        }

        ThingHomeSdk.setOnNeedLoginListener(new INeedLoginListener() {
            @Override
            public void onNeedLogin(Context context) {
                Log.d(TAG, "Login required");
                // Implement your logic for handling login requirement here
            }
        });
    }
}
