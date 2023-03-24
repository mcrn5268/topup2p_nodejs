import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:topup2p_nodejs/api/user_api.dart';

class AuthAPIService {
  static const baseUrl = 'http://192.168.254.106:3000/auth';
  static const headers = {'Content-Type': 'application/json'};

  static Future<http.Response> register(
      {required Map<String, dynamic> user, required String password}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/register'),
          headers: headers,
          body: json.encode({'user': user, 'password': password}));
      return response;
    } catch (e) {
      print('Error AuthAPIService.register: $e');
      return http.Response('Internal Server Error', 500);
    }
  }

  static Future<http.Response> login(
      {required String email, required String password}) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/login'),
          headers: headers,
          body: json.encode({'email': email, 'password': password}));

      return response;
    } catch (e) {
      print('Error AuthAPIService.login: $e');
      return http.Response('Internal Server Error', 500);
    }
  }

  static Future<http.Response> logout() async {
    try {
      final token = await UserAPIService.getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      return response;
    } catch (e) {
      print('Error AuthAPIService.logout: $e');
      return http.Response('Internal Server Error', 500);
    }
  }

  static Future<http.Response> checkJwtToken(String jwtToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/check_jwt_token'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $jwtToken'
        },
      );

      return response;
    } catch (e) {
      print('Error AuthAPIService.checkJwtToken: $e');
      return http.Response('Internal Server Error', 500);
    }
  }
}
