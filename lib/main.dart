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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  Future<void> _sendVerificationCode(
      String countryCode, String phoneNumber) async {
    try {
      final String result =
          await platform.invokeMethod('sendVerificationCode', {
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
      });
      Fluttertoast.showToast(msg: result);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: "Failed to send verification code: '${e.message}'.");
    }
  }

  Future<void> _registerUser(String countryCode, String phoneNumber,
      String password, String code) async {
    try {
      final String result = await platform.invokeMethod('registerUser', {
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'password': password,
        'code': code,
      });
      Fluttertoast.showToast(msg: result);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "Failed to register user: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _countryCodeController,
              decoration: InputDecoration(
                labelText: 'Country Code',
              ),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                labelText: 'Verification Code',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendVerificationCode(
                    _countryCodeController.text, _phoneController.text);
              },
              child: Text('Send Verification Code'),
            ),
            ElevatedButton(
              onPressed: () {
                _registerUser(
                    _countryCodeController.text,
                    _phoneController.text,
                    _passwordController.text,
                    _codeController.text);
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

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser(
      String countryCode, String phoneNumber, String password) async {
    try {
      final String result = await platform.invokeMethod('loginUser', {
        'countryCode': countryCode,
        'phoneNumber': phoneNumber,
        'password': password,
      });
      Fluttertoast.showToast(msg: result);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(msg: "Failed to login user: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _countryCodeController,
              decoration: InputDecoration(
                labelText: 'Country Code',
              ),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _loginUser(_countryCodeController.text, _phoneController.text,
                    _passwordController.text);
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
