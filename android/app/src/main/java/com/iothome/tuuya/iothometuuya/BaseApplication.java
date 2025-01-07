package com.iothome.tuuya.iothometuuya;

//import android.app.Application;
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
        String appKey = "878yghw7cvcaqwfsyq3v";
        String SecretKey = "mwyvhhvd4m37wvasfcj8ed8r47nkqn3k";
        // Initialize Tuya SDK with error handling
        try {
            ThingHomeSdk.init((Application) getApplicationContext(), "878yghw7cvcaqwfsyq3v", "mwyvhhvd4m37wvasfcj8ed8r47nkqn3k");
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
