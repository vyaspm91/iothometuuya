import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tuya Smart Light',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Tuya Smart Light'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;
  MyHomePage({required this.title});

  static const platform = MethodChannel("app.id.com/my_channel_name");

  Future<void> _checkSdk() async {
    try {
      final String result = await platform.invokeMethod('checkSdk');
      debugPrint("Tuya SDK configure Successfully: '${result}'");
      Fluttertoast.showToast(msg: result);
    } on PlatformException catch (e) {
      debugPrint("Failed to Configure Tuya SDK: '${e.message}'");
      Fluttertoast.showToast(msg: "Failed to check SDK: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PairDevicePage()),
                );
              },
              child: Text('Pair Device'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardPage()),
                );
              },
              child: Text('Dashboard'),
            ),
            ElevatedButton(
              onPressed: _checkSdk,
              child: Text('Check Tuya SDK'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const platform = MethodChannel("app.id.com/my_channel_name");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  bool _isCodeSent = false;

  Future<void> _sendVerificationCode(String countryCode,String region, String email) async {
    try {
      final String result = await platform.invokeMethod("sendVerificationCode", <String,dynamic>{
        'countryCode': countryCode,
        'email': email,
        'region': region,
      });
      setState(() {
        _isCodeSent = true;
        Fluttertoast.showToast(msg: result);
      });
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "Failed to send verification code: '${e.message}'.");
    }
  }

  Future<void> _verifyCode(String countryCode, String email, String code) async {
    try {
      final String result = await platform.invokeMethod('verifyCode', {
        'countryCode': countryCode,
        'email': email,
        'code': code,
      });
      Fluttertoast.showToast(msg: result);
      if (result == "Verification successful") {
        _registerUser(countryCode, email, _passwordController.text, code);
        debugPrint("verify code successfully: '${result}'");
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to verify code: '${e.message}'");
      Fluttertoast.showToast(msg: "Failed to verify code: '${e.message}'.");
    }
  }

  Future<void> _registerUser(String countryCode, String email, String password, String code) async {
    try {
      final String result = await platform.invokeMethod('registerUser', {
        'countryCode': countryCode,
        'email': email,
        'password': password,
        'code': code,
      });
      Fluttertoast.showToast(msg: result);
      if (result == "Register Successful") {
        debugPrint("Register user Successfully: '${result}'");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    } on PlatformException catch (e) {
      debugPrint("Failed to register user: '${e.message}'");
      Fluttertoast.showToast(msg: "Failed to register user: '${e.message}'.");
    }
  }

  Future<void> testMethodChannel() async {
    try {
      final String result = await platform.invokeMethod('test');
      print(result);
      debugPrint("Method Channel is working: '${result}'");
      Fluttertoast.showToast(msg: "Method Channel is working: '${result}'.");
    } on PlatformException catch (e) {
      debugPrint("Failed: Method Channel NOT working '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _countryCodeController,
              decoration: InputDecoration(labelText: 'Country Code'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            TextField(
              controller: _regionController,
              decoration: InputDecoration(labelText: 'Region'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            if (_isCodeSent)
              TextField(
                controller: _codeController,
                decoration: InputDecoration(labelText: 'Verification Code'),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: testMethodChannel,
              child: Text('Test MethodChannel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_isCodeSent) {
                  _verifyCode(_countryCodeController.text, _emailController.text, _codeController.text);
                } else {
                  _sendVerificationCode(_countryCodeController.text, _regionController.text ,_emailController.text);
                }
              },
              child: Text(_isCodeSent ? 'Verify Code' : 'Send Verification Code'),
            ),
            if (_isCodeSent)
              ElevatedButton(
                onPressed: () {
                  _verifyCode(_countryCodeController.text, _emailController.text, _codeController.text);
                },
                child: Text('Register'),
              ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  static const platform = MethodChannel("app.id.com/my_channel_name");
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser(String countryCode, String email, String password) async {
    try {
      final String result = await platform.invokeMethod('loginUser', {
        'countryCode': countryCode,
        'email': email,
        'password': password,
      });
      Fluttertoast.showToast(msg: result);
      debugPrint("Success to Login user: '${result}'");

    } on PlatformException catch (e) {
      debugPrint("Failed to Login user: '${e.message}'");
      Fluttertoast.showToast(msg: "Failed to login user: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _countryCodeController,
              decoration: InputDecoration(labelText: 'Country Code'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Address'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _loginUser(_countryCodeController.text, _emailController.text, _passwordController.text);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class PairDevicePage extends StatelessWidget {
  static const platform = MethodChannel("app.id.com/my_channel_name");

  Future<void> _pairDevice() async {
    try {
      final String result = await platform.invokeMethod('startDevicePairing');
      Fluttertoast.showToast(msg: result);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "Failed to pair device: '${e.message}'.");
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

class DashboardPage extends StatelessWidget {
  static const platform = MethodChannel("app.id.com/my_channel_name");

  Future<void> _controlDevice(String deviceId, bool turnOn) async {
    try {
      final String result = await platform.invokeMethod('controlDevice', {
        'deviceId': deviceId,
        'turnOn': turnOn,
      });
      Fluttertoast.showToast(msg: result);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "Failed to control device: '${e.message}'.");
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
