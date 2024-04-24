package com.iothome.tuuya.iothometuuya;

import androidx.annotation.NonNull;

import java.util.HashMap;
import java.util.Map;

import io.flutter.Log;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;


public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "app.id.com/my_channel_name";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        Log.d("@@@","configureFlutterEngine()");
        getTuyaWhileListCountries();
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {

                    getTuyaWhileListCountries();
                    if (call.method.equals("addnumbers")) {
                        int sum = addNumbers(call);
                        Log.v("@@@","Adding number in android native "+sum);
                        Map<String, Object> response = new HashMap<>();
                        response.put("Sum", sum);
                        Log.v("@@@","Adding number in android native "+sum);
                        result.success(response);
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private int addNumbers(MethodCall call) {
        Map<String, Object> args = (Map<String, Object>) call.arguments;
        int a = (int) args.get("n1");
        int b = (int) args.get("n2");
        return a + b;
    }

    private void getTuyaWhileListCountries(){
        Log.v("@@@","getTuyaWhileListCountries() called");
    }
}

