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

        // Initialize Tuya SDK
            ThingHomeSdk.init(this);
            ThingHomeSdk.setDebugMode(true);
            /*ThingOptimusSdk.init(this);*/
            Log.d(TAG, "Tuya SDK initialized successfully");
        ThingHomeSdk.setOnNeedLoginListener(new INeedLoginListener() {
            @Override
            public void onNeedLogin(Context context) {
                startActivity(new Intent(BaseApplication.this, MainActivity.class));
                Log.d(TAG, "Login required");
                // Implement your logic for handling login requirement here
            }
        });
    }
}
