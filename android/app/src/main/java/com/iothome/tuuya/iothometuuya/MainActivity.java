package com.iothome.tuuya.iothometuuya;

import androidx.annotation.NonNull;

import com.thingclips.smart.android.user.api.ILoginCallback;
import com.thingclips.smart.android.user.api.IRegisterCallback;
import com.thingclips.smart.android.user.bean.User;
import com.thingclips.smart.home.sdk.ThingHomeSdk;
import com.thingclips.smart.home.sdk.builder.ActivatorBuilder;
import com.thingclips.smart.sdk.api.IResultCallback;
import com.thingclips.smart.sdk.api.IThingSmartActivatorListener;
import com.thingclips.smart.sdk.bean.DeviceBean;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "app.id.com/my_channel_name";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            switch (call.method) {
                                case "sendVerificationCode":
                                    String countryCode = call.argument("countryCode");
                                    String email = call.argument("email");
                                    sendVerificationCode(countryCode, email, result);
                                    break;
                                case "verifyCode":
                                    countryCode = call.argument("countryCode");
                                    email = call.argument("email");
                                    String code = call.argument("code");
                                    verifyCode(countryCode, email, code, result);
                                    break;
                                case "registerUser":
                                    countryCode = call.argument("countryCode");
                                    email = call.argument("email");
                                    String password = call.argument("password");
                                    code = call.argument("code");
                                    registerUser(countryCode, email, password, code, result);
                                    break;
                                case "loginUser":
                                    countryCode = call.argument("countryCode");
                                    email = call.argument("email");
                                    password = call.argument("password");
                                    loginUser(countryCode, email, password, result);
                                    break;
                                case "startDevicePairing":
                                    startDevicePairing(result);
                                    break;
                                case "controlDevice":
                                    String deviceId = call.argument("deviceId");
                                    boolean turnOn = call.argument("turnOn");
                                    controlDevice(deviceId, turnOn, result);
                                    break;
                                case "test":
                                    result.success("Hello, from Tuya! Method channel is Working");
                                    break;
                                case "checkSdk":
                                    checkSdk(result);
                                    break;
                                default:
                                    result.notImplemented();
                                    break;
                            }
                        }
                );
    }

    private void checkSdk(MethodChannel.Result result) {
        try {
            ThingHomeSdk.getUserInstance();
            result.success("Tuya SDK is initialized and working.");
        } catch (Exception e) {
            result.error("SDK_ERROR", "Tuya SDK is not initialized or not working.", e.getMessage());
        }
    }

    private void sendVerificationCode(String countryCode, String email, MethodChannel.Result result) {
        ThingHomeSdk.getUserInstance().sendVerifyCodeWithUserName(email, "", countryCode, 1, new IResultCallback() {
            @Override
            public void onSuccess() {
                result.success("Verification code sent successfully.");
            }

            @Override
            public void onError(String code, String error) {
                result.error(code, error, null);
            }
        });
    }

    private void verifyCode(String countryCode, String email, String code, MethodChannel.Result result) {
        ThingHomeSdk.getUserInstance().checkCodeWithUserName(email, "", countryCode, code, 1, new IResultCallback() {
            @Override
            public void onSuccess() {
                result.success("Verification successful");
            }

            @Override
            public void onError(String code, String error) {
                result.error(code, error, null);
            }
        });
    }

    private void registerUser(String countryCode, String email, String password, String code, MethodChannel.Result result) {
        ThingHomeSdk.getUserInstance().registerAccountWithEmail(countryCode, email, password, code, new IRegisterCallback() {
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

    private void loginUser(String countryCode, String email, String password, MethodChannel.Result result) {
        ThingHomeSdk.getUserInstance().loginWithEmail(countryCode, email, password, new ILoginCallback() {
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
        ThingHomeSdk.getActivatorInstance().newMultiActivator(new ActivatorBuilder()
                .setContext(this)
                .setSsid("Your_WiFi_SSID")
                .setPassword("Your_WiFi_Password")
                .setTimeOut(100)
                .setListener(new IThingSmartActivatorListener() {
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
        ThingHomeSdk.newDeviceInstance(deviceId).publishDps("{\"1\": " + (turnOn ? "true" : "false") + "}", new IResultCallback() {
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
