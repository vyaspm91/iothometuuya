package com.iothome.tuuya.iothometuuya;

import android.app.Application;
import android.widget.Toast;

import com.thingclips.smart.home.sdk.ThingHomeSdk;
import com.thingclips.smart.optimus.sdk.ThingOptimusSdk;


public class BaseApplication  extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        Toast.makeText(this, "", Toast.LENGTH_SHORT).show();
        ThingHomeSdk.init(this);
        ThingHomeSdk.setDebugMode(true);
        ThingOptimusSdk.init(this);

//        SpUtils.getInstance().initSp(this);
//        ZXingLibrary.initDisplayOpinion(this);
//        CameraUtils.init(this);
    }
}
