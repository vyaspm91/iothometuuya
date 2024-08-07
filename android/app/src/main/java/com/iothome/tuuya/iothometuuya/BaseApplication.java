package com.iothome.tuuya.iothometuuya;

import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.widget.Toast;

import com.thingclips.smart.home.sdk.ThingHomeSdk;
import com.thingclips.smart.optimus.sdk.ThingOptimusSdk;
import com.thingclips.smart.sdk.api.INeedLoginListener;


public class BaseApplication  extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Toast.makeText(this, "", Toast.LENGTH_SHORT).show();
        ThingHomeSdk.init(this);
        ThingHomeSdk.setDebugMode(true);
        ThingOptimusSdk.init(this);


        System.loadLibrary("c++_shared");
        System.loadLibrary("ssl");
        System.loadLibrary("crypto");
        System.loadLibrary("tnet");
        System.loadLibrary("TBFClient");
        System.loadLibrary("thingclipsSmartSDK");

        ThingHomeSdk.setOnNeedLoginListener(new INeedLoginListener() {
            @Override
            public void onNeedLogin(Context context) {
                startActivity(new Intent(BaseApplication.this, MainActivity.class));
            }
        });

//        SpUtils.getInstance().initSp(this);
//        ZXingLibrary.initDisplayOpinion(this);
//        CameraUtils.init(this);
    }
}
