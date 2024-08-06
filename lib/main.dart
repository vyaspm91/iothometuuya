import 'package:flutter/material.dart';
import 'package:iothometuuya/auth_service.dart';
import 'package:iothometuuya/dashboard_screen.dart';
import 'package:iothometuuya/login_screen.dart';
import 'package:iothometuuya/register_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Smart Light App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/dashboard': (context) => DashboardScreen(),
        },
      ),
    );
  }
}
