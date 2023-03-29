import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topup2p_nodejs/api/user_api.dart';
import 'package:topup2p_nodejs/utilities/globals.dart';

class SellerAPIService {
  static Future<dynamic> readSellerData({required String shopName}) async {
    try {
      final token = await UserAPIService.getToken();
      final response = await http
          .get(Uri.parse('$baseUrl/seller/readSellerData/$shopName'), headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse;
    } catch (e) {
      if (kDebugMode) {
        print('Error SellerAPIService.readSellerData: $e');
      }
      return http.Response('Internal Server Error', 500);
    }
  }

  static Future<http.Response> addPayment(
      {required String shopName, required Map<String, dynamic> data}) async {
    try {
      final token = await UserAPIService.getToken();
      final response = await http.patch(
          Uri.parse('$baseUrl/seller/addPaymentMethod'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({'sellerName': shopName, 'paymentMethods': data}));
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error SellerAPIService.addPayment: $e');
      }
      return http.Response('Internal Server Error', 500);
    }
  }

  // final Map<String, dynamic> mapData = {
  //   'mop': mopMap,
  //   'rates': ratesMap,
  //   'info': {
  //     'status': forButton == 'ADD'
  //         ? 'enabled'
  //         : isEnabled!
  //             ? 'enabled'
  //             : 'disabled',
  //     'uid': userProvider.user!.uid,
  //     'name': userProvider.user!.name,
  //     'image': userProvider.user!.image_url
  //   }
  // };

  static Future<http.Response> readPayment(
      {required String shopName, required Map<String, dynamic> data}) async {
    try {
      final token = await UserAPIService.getToken();
      final response = await http.post(
          Uri.parse('$baseUrl/seller/addPaymentMethod'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({'sellerName': shopName, 'paymentMethods': data}));
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Error SellerAPIService.addPayment: $e');
      }
      return http.Response('Internal Server Error', 500);
    }
  }

  static Future<http.Response> addGame(
      {required String shopName,
      required String gameName,
      required Map<String, dynamic> data}) async {
    try {
      final token = await UserAPIService.getToken();
      final response = await http.post(Uri.parse('$baseUrl/seller/addGame'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          },
          body: json.encode({
            'sellerName': shopName,
            'gameName': gameName,
            'gameData': data
          }));

      return response;
    } catch (e) {
      print('Error SellerAPIService.addGame: $e');
      return http.Response('Internal Server Error', 500);
    }
  }

  static Future<List<dynamic>> readGameData(
      {String? shopName, required String gameName}) async {
    try {
      final token = await UserAPIService.getToken();
      final response = await http.get(
          Uri.parse('$baseUrl/seller/readGameData/$shopName/$gameName'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse;
      } else {
        if (kDebugMode) {
          print('getUserFavorites statusCode: ${response.statusCode}');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error SellerAPIService.readGameData: $e');
      }
      return [];
    }
  }
}
