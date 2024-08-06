import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatelessWidget {
  static const platform = MethodChannel('com.example.tuya_smart_light/methods');

  const DashboardPage({Key? key}) : super(key: key);

  Future<void> _controlDevice(String deviceId, bool turnOn) async {
    try {
      final String result = await platform.invokeMethod('controlDevice', {
        'deviceId': deviceId,
        'turnOn': turnOn,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to control device: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _controlDevice("your_device_id", true);
              },
              child: Text('Turn On Light'),
            ),
            ElevatedButton(
              onPressed: () {
                _controlDevice("your_device_id", false);
              },
              child: Text('Turn Off Light'),
            ),
          ],
        ),
      ),
    );
  }
}