import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topup2p_nodejs/models/user_model.dart';
import 'package:topup2p_nodejs/utilities/sharedpreference.dart';

class UserAPIService {
  static const baseUrl = 'http://192.168.254.106:3000';

  static Future<UserModel?> getUser({required String userId}) async {
    try {
      final token = await getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/user/read/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        // Convert the response JSON string to a UserModel object
        final jsonResponse = jsonDecode(response.body);
        print('jsonresponse $jsonResponse');
        return UserModel.fromJson(jsonResponse);
      } else {
        //no user found
        if (kDebugMode) {
          print('getUser statusCode: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('error getUser: $e');
      }
      return null;
    }
  }

  static Future<Map<String, dynamic>> getUserFavorites(
      {required String userId}) async {
    try {
      final token = await getToken();
      // final response =
      //     await http.get(Uri.parse('$baseUrl/favs/readFavs/$userId'));
      final response = await http.get(
        Uri.parse('$baseUrl/favs/readFavs/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print('jsonResponse: $jsonResponse');
        return jsonResponse;
      } else {
        //no favorites for user
        if (kDebugMode) {
          print('getUserFavorites statusCode: ${response.statusCode}');
        }
        return {};
      }
    } catch (e) {
      if (kDebugMode) {
        print('error getUserFavorites: $e');
      }
      return {};
    }
  }

  static Future<http.Response> convertToSeller(
      {required String uid, required Map<String, dynamic> data}) async {
    try {
      final token = await getToken();
      final response = await http.patch(Uri.parse('$baseUrl/user/update'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({'data': data, 'uid': uid}));
      return response;
    } catch (e) {
      print('Error FavAPIService.convertToSeller: $e');
      return http.Response('Internal Server Error', 500);
    }
  }

  static Future<String> getToken() async {
    try {
      final prefsService = SharedPreferencesService();
      final token = await prefsService.getStringList('jwt');
      return token![1];
    } catch (e) {
      throw ('Something went wrong UserAPIService.getToken: $e');
    }
  }
}
