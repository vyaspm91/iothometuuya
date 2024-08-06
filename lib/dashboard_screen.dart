import 'package:flutter/material.dart';
import 'package:iothometuuya/auth_service.dart';
import 'package:iothometuuya/light_control.dart';
import 'package:provider/provider.dart';


class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await authService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Center(
        child: LightControl(),
      ),
    );
  }
}
