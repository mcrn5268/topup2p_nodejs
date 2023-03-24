import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/models/user_model.dart';

class FavAPIService {
  static const baseUrl = 'http://192.168.254.106:3000/favs';

  static Future<http.Response> toggleFavorite(
      {required String type,
      required String gameName,
      required String uid}) async {
    try {
      final token = await UserAPIService.getToken();
      final date = DateTime.now().toIso8601String(); // convert to ISO string
      final response = await http.patch(Uri.parse('$baseUrl/toggle'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode(
              {'type': type, 'gameName': gameName, 'uid': uid, 'date': date}));
      return response;
    } catch (e) {
      print('Error FavAPIService.toggleFavorite: $e');
      return http.Response('Internal Server Error', 500);
    }
  }
}
