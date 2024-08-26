package com.iothome.tuuya.iothometuuya;

import android.app.Application;
import android.content.Context;
import com.thingclips.smart.home.sdk.ThingHomeSdk;
import com.thingclips.smart.optimus.sdk.ThingOptimusSdk;
import com.thingclips.smart.sdk.api.INeedLoginListener;

import android.content.Intent;
import android.util.Log;

public class BaseApplication extends Application {
    private static final String TAG = "BaseApplication";

    @Override
    public void onCreate() {
        super.onCreate();
        // Initialize Tuya SDK with error handling
        try {
            ThingHomeSdk.init(this);
            ThingHomeSdk.setDebugMode(true);
            Log.d(TAG, "Tuya SDK initialized successfully");
        } catch (Exception e) {
            Log.e(TAG, "Failed to initialize Tuya SDK: " + e.getMessage(), e);
        }

        // Set the login listener
        try {
            ThingHomeSdk.setOnNeedLoginListener(new INeedLoginListener() {
                @Override
                public void onNeedLogin(Context context) {
                    startActivity(new Intent(BaseApplication.this, MainActivity.class));
                    Log.d(TAG, "Login required");
                }
            });
        } catch (Exception e) {
            Log.e(TAG, "Failed to set login listener: " + e.getMessage(), e);
        }
    }
}
