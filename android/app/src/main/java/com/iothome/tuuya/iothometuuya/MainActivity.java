package com.iothome.tuuya.iothometuuya;

import android.os.Bundle;
import androidx.annotation.NonNull;

import com.tuya.smart.android.user.api.ILoginCallback;
import com.tuya.smart.android.user.api.IRegisterCallback;
import com.tuya.smart.android.user.bean.User;
import com.tuya.smart.home.sdk.TuyaHomeSdk;
import com.tuya.smart.home.sdk.builder.ActivatorBuilder;
import com.tuya.smart.sdk.api.IResultCallback;
import com.tuya.smart.sdk.api.ITuyaSmartActivatorListener;
import com.tuya.smart.sdk.bean.DeviceBean;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.tuya_smart_light/methods";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("registerUser")) {
                                String countryCode = call.argument("countryCode");
                                String phoneNumber = call.argument("phoneNumber");
                                String password = call.argument("password");
                                registerUser(countryCode, phoneNumber, password, result);
                            } else if (call.method.equals("loginUser")) {
                                String countryCode = call.argument("countryCode");
                                String phoneNumber = call.argument("phoneNumber");
                                String password = call.argument("password");
                                loginUser(countryCode, phoneNumber, password, result);
                            } else if (call.method.equals("startDevicePairing")) {
                                startDevicePairing(result);
                            } else if (call.method.equals("controlDevice")) {
                                String deviceId = call.argument("deviceId");
                                boolean turnOn = call.argument("turnOn");
                                controlDevice(deviceId, turnOn, result);
                            } else {
                                result.notImplemented();
                            }
                        }
                );
    }

    private void registerUser(String countryCode, String phoneNumber, String password, MethodChannel.Result result) {
        TuyaHomeSdk.getUserInstance().registerAccountWithPhone(countryCode, phoneNumber, password, new IRegisterCallback() {
            @Override
            public void onSuccess(User user) {
                result.success("Register Successful");
            }
            @Override
            public void onError(String code, String error) {
                result.error(code, error, null);
            }
        });
    }

    private void loginUser(String countryCode, String phoneNumber, String password, MethodChannel.Result result) {
        TuyaHomeSdk.getUserInstance().loginWithPhonePassword(countryCode, phoneNumber, password, new ILoginCallback() {
            @Override
            public void onSuccess(User user) {
                result.success("Login Successful");
            }

            @Override
            public void onError(String code, String error) {
                result.error(code, error, null);
            }
        });
    }

    private void startDevicePairing(MethodChannel.Result result) {
        TuyaHomeSdk.getActivatorInstance().newMultiActivator(new ActivatorBuilder()
                .setContext(this)
                .setSsid("vihan")
                .setPassword("7552997352")
                .setTimeOut(1000)
                .setListener(new ITuyaSmartActivatorListener() {
                    @Override
                    public void onError(String errorCode, String errorMsg) {
                        result.error(errorCode, errorMsg, null);
                    }

                    @Override
                    public void onActiveSuccess(DeviceBean devResp) {
                        result.success("Device Paired Successfully");
                    }

                    @Override
                    public void onStep(String step, Object data) {
                        // Handle each step if necessary
                    }
                }));
    }

    private void controlDevice(String deviceId, boolean turnOn, MethodChannel.Result result) {
        TuyaHomeSdk.newDeviceInstance(deviceId).publishDps("{\"1\": " + (turnOn ? "true" : "false") + "}", new IResultCallback() {
            @Override
            public void onError(String code, String error) {
                result.error(code, error, null);
            }

            @Override
            public void onSuccess() {
                result.success("Device Control Successful");
            }
        });
    }
}
