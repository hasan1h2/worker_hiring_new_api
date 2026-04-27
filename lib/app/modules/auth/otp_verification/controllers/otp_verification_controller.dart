import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../sign_up/providers/signup_provider.dart';

import '../../login/providers/login_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController {
  late final String email;
  late final String flowType;
  
  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());
  
  final RxBool isLoading = false.obs;
  final RxInt countdown = 60.obs;
  Timer? _timer;
  
  final SignupProvider _signupProvider = SignupProvider();
  final LoginProvider _loginProvider = LoginProvider();
  final _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    email = args?['email'] ?? '';
    flowType = args?['flowType'] ?? 'signup';
    startTimer();
  }

  void startTimer() {
    countdown.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      Get.snackbar('Error', 'Please enter a valid 6-digit OTP',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;
    try {
      late final response;
      if (flowType == 'login') {
        response = await _loginProvider.verifyLoginOtp(email, otp);
      } else {
        response = await _signupProvider.verifyOtp(email, otp);
      }
      
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          responseData['message'] ?? 'OTP Verified successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        if (flowType == 'login') {
          final String? defaultProfile = responseData['data']['default_profile'];
          await _saveAuthData(responseData['data']);
          _navigateBasedOnRole(defaultProfile);
        } else {
          Get.offAllNamed(Routes.ROLE_SELECTION);
        }
      } else {
        String errorMessage = responseData['message'] ?? 'Verification failed';
        if (responseData['errors'] != null) {
          errorMessage = responseData['errors'].toString();
        }
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendOtp() async {
    if (countdown.value > 0) return;

    isLoading.value = true;
    try {
      late final response;
      if (flowType == 'login') {
        response = await _loginProvider.requestLoginOtp(email);
      } else {
        response = await _signupProvider.resendOtp(email);
      }
      
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          responseData['message'] ?? 'OTP resent successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        startTimer(); // Restart the countdown timer
      } else {
        String errorMessage = responseData['message'] ?? 'Failed to resend OTP';
        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    await _storage.write(key: 'access_token', value: data['access']);
    await _storage.write(key: 'refresh_token', value: data['refresh']);
    await _storage.write(key: 'default_profile', value: data['default_profile']);
  }

  void _navigateBasedOnRole(String? defaultProfile) {
    if (defaultProfile == null) {
      Get.offAllNamed(Routes.ROLE_SELECTION);
    } else if (defaultProfile.toUpperCase() == 'WORKER' || defaultProfile.toUpperCase() == 'ARTISAN') {
      Get.offAllNamed(Routes.WORKER_D);
    } else {
      Get.offAllNamed(Routes.MAIN);
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
