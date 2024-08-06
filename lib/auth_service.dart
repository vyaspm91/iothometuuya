import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iothometuuya/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String apiUrl = 'https://your-api-url.com';

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = User.fromJson(data);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('user', jsonEncode(user));
      return user;
    } else {
      return null;
    }
  }

  Future<bool> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response.statusCode == 200;
  }

  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    } else {
      return null;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
