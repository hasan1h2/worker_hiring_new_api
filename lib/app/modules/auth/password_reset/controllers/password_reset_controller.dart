import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../data/api_endpoints.dart';
import '../views/reset_password_confirm_view.dart';
import '../../../../routes/app_pages.dart';

class PasswordResetController extends GetxController {
  // Email Entry
  final emailController = TextEditingController();
  final emailFormKey = GlobalKey<FormState>();
  
  // OTP & New Password
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  final passwordController = TextEditingController();
  final resetFormKey = GlobalKey<FormState>();

  // Loading States
  final RxBool isRequestingOtp = false.obs;
  final RxBool isResettingPassword = false.obs;

  // Real-time Validations
  final RxBool isEmailValid = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxString passwordStrength = ''.obs;
  final Rx<Color> strengthColor = Colors.grey.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void validateEmailRealTime(String value) {
    if (GetUtils.isEmail(value)) {
      isEmailValid.value = true;
    } else {
      isEmailValid.value = false;
    }
  }

  void updatePasswordStrength(String value) {
    if (value == null || value.trim().isEmpty) {
      passwordStrength.value = '';
      strengthColor.value = Colors.grey;
      return;
    }
    
    if (value.length < 6) {
      passwordStrength.value = 'Very Weak';
      strengthColor.value = Colors.red;
    } else if (value.length < 8) {
      passwordStrength.value = 'Weak';
      strengthColor.value = Colors.orange;
    } else if (value.contains(RegExp(r'[a-zA-Z]')) && value.contains(RegExp(r'[0-9]')) && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      passwordStrength.value = 'Good';
      strengthColor.value = Colors.blue;
    } else if (value.length >= 8 && value.contains(RegExp(r'[A-Z]')) && value.contains(RegExp(r'[a-z]')) && value.contains(RegExp(r'[0-9]')) && value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      passwordStrength.value = 'Strong';
      strengthColor.value = Colors.green;
    } else {
      passwordStrength.value = 'Good';
      strengthColor.value = Colors.blue;
    }
  }

  // API 1: Request Password Reset OTP
  Future<void> requestResetOtp() async {
    if (!emailFormKey.currentState!.validate()) return;

    isRequestingOtp.value = true;
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.passwordReset}');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": emailController.text.trim()}),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Reset code sent to your email.");
        Get.to(() => const ResetPasswordConfirmView(), arguments: {'email': emailController.text.trim()});
      } else {
        final decoded = jsonDecode(response.body);
        Get.snackbar("Error", decoded['message'] ?? "Failed to request reset OTP.");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error occurred");
    } finally {
      isRequestingOtp.value = false;
    }
  }

  // API 2: Reset Password Confirm
  Future<void> resetPasswordConfirm() async {
    if (!resetFormKey.currentState!.validate()) return;
    
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      Get.snackbar("Error", "Please enter the complete 6-digit OTP");
      return;
    }

    if (passwordController.text.isEmpty) {
      Get.snackbar("Error", "Please enter a new password");
      return;
    }

    isResettingPassword.value = true;
    try {
      final url = Uri.parse('${ApiEndpoints.baseUrl}${ApiEndpoints.passwordResetConfirm}');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "otp": otp,
          "new_password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Password reset successfully. You can now login.");
        // Clear all controllers
        emailController.clear();
        passwordController.clear();
        for (var c in otpControllers) {
          c.clear();
        }
        Get.offAllNamed(Routes.SIGN_IN);
      } else {
        final decoded = jsonDecode(response.body);
        Get.snackbar("Error", decoded['message'] ?? "Failed to reset password.");
      }
    } catch (e) {
      print('API Error: $e');
      Get.snackbar(
        'Error', 
        'Failed to connect to the server or invalid OTP.', 
        snackPosition: SnackPosition.BOTTOM, 
        backgroundColor: Colors.red, 
        colorText: Colors.white
      );
    } finally {
      isResettingPassword.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    for (var c in otpControllers) {
      c.dispose();
    }
    super.onClose();
  }
}
