import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../data/api_endpoints.dart';
class SignupProvider {
  Future<http.Response> signupUser(Map<String, dynamic> body) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.signup}');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to communicate with server: $e');
    }
  }

  Future<http.Response> verifyOtp(String email, String otp) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.signupOtpVerify}');
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

  Future<http.Response> resendOtp(String email) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.signupOtpResend}');
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
      throw Exception('Failed to resend OTP: $e');
    }
  }
}
