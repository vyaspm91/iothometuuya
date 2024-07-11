

import 'package:flutter/cupertino.dart';

enum AuthStatus{
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registrating,
  LoggedOut
}

class AuthProvider with ChangeNotifier{

  AuthStatus _loggedInStatus = AuthStatus.NotLoggedIn;
  AuthStatus _registeredInStatus = AuthStatus.NotRegistered;

  AuthStatus get loggedInStatus => _loggedInStatus;
  AuthStatus get registeredImStatus => _registeredInStatus;


  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'user': {
        'email': email,
        'password': password
      }
    };

    _loggedInStatus = AuthStatus.Authenticating;
    notifyListeners();

    result = {'status': true, 'message': 'Successful'};
    return result;
  }

}