import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/api_endpoints.dart';

class AuthService extends GetxService {
  final _storage = const FlutterSecureStorage();

  Future<AuthService> init() async {
    return this;
  }

  // API 3: Verify Access Token
  Future<bool> verifyAccessToken(String token) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.tokenVerify}');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": token}),
      );

      // If the token is valid, typically returns 200 OK
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Error verifying token: $e");
      return false;
    }
  }

  // API 4: Refresh Tokens
  Future<bool> refreshTokens(String refreshToken) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.tokenRefresh}');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"refresh": refreshToken}),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded['access'] != null) {
          // Securely save the new access token
          await _storage.write(key: 'access_token', value: decoded['access']);
          // Sometimes refresh API also issues a new refresh token
          if (decoded['refresh'] != null) {
            await _storage.write(key: 'refresh_token', value: decoded['refresh']);
          }
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Error refreshing token: $e");
      return false;
    }
  }

  // Helper method to retrieve tokens
  Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: 'refresh_token');
  }

  // Logout method helper
  Future<void> logout() async {
    await _storage.deleteAll();
    Get.offAllNamed('/sign-in'); // Adjust to your initial route
  }
}
