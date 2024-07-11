

import 'package:flutter/material.dart';
import 'package:iothometuuya/state_management/providers/auth_providers.dart';
import 'package:iothometuuya/utils/common_widgets.dart';
import 'package:provider/provider.dart';




class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = new GlobalKey<FormState>();

  String _username="", _password="";

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(40.0),
        ),
      ),
    );
  }
}