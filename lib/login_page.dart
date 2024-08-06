import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatelessWidget {
  static const platform = MethodChannel('com.example.tuya_smart_light/methods');

  Future<void> _loginUser(String countryCode, String phoneNumber, String password) async {
    try {
      final String result = await platform.invokeMethod('loginUser', {
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'password': password,
      });
      print(result);
    } on PlatformException catch (e) {
      print("Failed to login user: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _loginUser("91", "8461809352", "Tuya@123");
          },
          child: Text('Login User'),
        ),
      ),
    );
  }
}
