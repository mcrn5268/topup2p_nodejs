import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:topup2p_nodejs/api/user_api.dart';

class SellerAPIService {
  static const baseUrl = 'http://192.168.254.106:3000';

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
}
