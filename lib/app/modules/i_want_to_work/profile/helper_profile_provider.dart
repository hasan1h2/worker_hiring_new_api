import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HelperProfileProvider {
  final String baseUrl = 'https://samimdev.pythonanywhere.com/api/v1';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _getHeaders() async {
    String? token = await _storage.read(key: 'access_token');
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> getHelperProfile() async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/helper-profile/');
    return await http.get(url, headers: headers);
  }

  Future<http.Response> createHelperProfile(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/create-helper-profile/');
    return await http.post(url, headers: headers, body: jsonEncode(data));
  }

  Future<http.Response> updateHelperProfile(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl/helper-profile/');
    return await http.patch(url, headers: headers, body: jsonEncode(data));
  }
}
