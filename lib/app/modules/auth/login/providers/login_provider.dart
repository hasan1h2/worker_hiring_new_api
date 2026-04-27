import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../data/api_endpoints.dart';
class LoginProvider {
  Future<http.Response> loginWithPassword(String email, String password) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.loginWithPassword}');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to login: $e');
    }
  }

  Future<http.Response> requestLoginOtp(String email) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.requestLoginOtp}');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to request OTP: $e');
    }
  }

  Future<http.Response> verifyLoginOtp(String email, String otp) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.verifyLoginOtp}');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "otp": otp,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to verify OTP: $e');
    }
  }

  Future<http.Response> loginWithGoogle(String accessToken) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.googleLogin}');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "access_token": accessToken,
        }),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to authenticate with Google on server: $e');
    }
  }
}
