import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterPage extends StatelessWidget {
  static const platform = MethodChannel('com.example.tuya_smart_light/methods');

  Future<void> _registerUser(String countryCode, String phoneNumber, String password) async {
    try {
      final String result = await platform.invokeMethod('registerUser', {
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'password': password,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to register user: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _registerUser("+1", "1234567890", "password123");
          },
          child: Text('Register User'),
        ),
      ),
    );
  }
}