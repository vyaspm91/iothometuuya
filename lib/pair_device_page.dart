import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PairDevicePage extends StatelessWidget {
  static const platform = MethodChannel('com.example.tuya_smart_light/methods');

  Future<void> _pairDevice() async {
    try {
      final String result = await platform.invokeMethod('startDevicePairing');
      print(result);
    } on PlatformException catch (e) {
      print("Failed to pair device: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pair Device'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _pairDevice,
          child: Text('Pair Device'),
        ),
      ),
    );
  }
}
