import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import '../providers/login_provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../views/otp_verify_view.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  
  final loginFormKey = GlobalKey<FormState>();
  final emailEntryFormKey = GlobalKey<FormState>();

  final List<TextEditingController> otpControllers = List.generate(6, (index) => TextEditingController());

  final RxBool isPasswordLoginLoading = false.obs;
  final RxBool isOtpVerifyLoading = false.obs;
  final RxBool isOtpRequestLoading = false.obs;
  final RxBool isGoogleLoginLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  // Real-time validation properties
  final RxBool isEmailValid = false.obs;
  final RxString passwordStrength = ''.obs;
  final Rx<Color> strengthColor = Colors.grey.obs;

  final _storage = const FlutterSecureStorage();
  
  // NOTE: For Web support, replace the clientId with your actual Web Client ID from Google Cloud Console.
  // Example: clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com'
  final _googleSignIn = GoogleSignIn(
    clientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com', // Replace this!
  );
  final LoginProvider _provider = LoginProvider();

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
    if (value.isEmpty) {
      passwordStrength.value = '';
      strengthColor.value = Colors.grey;
    } else if (value.length < 6) {
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

  // API A: Login with Email & Password
  Future<void> loginWithPassword() async {
    if (!loginFormKey.currentState!.validate()) return;


    isPasswordLoginLoading.value = true;
    try {
      final response = await _provider.loginWithPassword(
        emailController.text.trim(),
        passwordController.text,
      );

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 && decoded['status'] == true) {
        final String? defaultProfile = decoded['data']['default_profile'];
        await _saveAuthData(decoded['data']);
        _navigateBasedOnRole(defaultProfile);
        Get.snackbar("Success", "Logged in successfully");
      } else {
        Get.snackbar("Error", decoded['message'] ?? "Login failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error occurred");
    } finally {
      isPasswordLoginLoading.value = false;
    }
  }

  // API B: Request Login OTP
  Future<void> requestLoginOtp() async {
    if (!emailEntryFormKey.currentState!.validate()) return;


    isOtpRequestLoading.value = true;
    try {
      final response = await _provider.requestLoginOtp(emailController.text.trim());

      final decoded = jsonDecode(response.body);
      if (response.statusCode == 200 && decoded['status'] == true) {
        Get.snackbar("Success", decoded['message'] ?? "OTP sent successfully");
        Get.to(() => const OtpVerifyView(), arguments: {'email': emailController.text.trim()});
      } else {
        Get.snackbar("Error", decoded['message'] ?? "Failed to request OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error occurred");
    } finally {
      isOtpRequestLoading.value = false;
    }
  }

  // API C: Verify Login OTP
  Future<void> verifyLoginOtp() async {
    String otp = otpControllers.map((c) => c.text).join();
    if (otp.length < 6) {
      Get.snackbar("Error", "Please enter the complete 6-digit OTP");
      return;
    }

    isOtpVerifyLoading.value = true;
    try {
      final response = await _provider.verifyLoginOtp(emailController.text.trim(), otp);
      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 && decoded['status'] == true) {
        final String? defaultProfile = decoded['data']['default_profile'];
        await _saveAuthData(decoded['data']);
        _navigateBasedOnRole(defaultProfile);
        Get.snackbar("Success", "Verified and logged in successfully");
      } else {
        Get.snackbar("Error", decoded['message'] ?? "Invalid OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Network error occurred");
    } finally {
      isOtpVerifyLoading.value = false;
    }
  }

  // API D: Google Sign-In
  Future<void> loginWithGoogle() async {
    isGoogleLoginLoading.value = true;
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        Get.snackbar("Error", "Failed to get Google access token");
        return;
      }

      final response = await _provider.loginWithGoogle(accessToken);

      final decoded = jsonDecode(response.body);
      // Backend response structure might vary for Google login, adjusting based on provided info
      if (response.statusCode == 200 || response.statusCode == 201) {
        String? defaultProfile;
        if (decoded.containsKey('access')) {
           defaultProfile = decoded['default_profile'];
           await _saveAuthData(decoded);
        } else if (decoded.containsKey('data')) {
           defaultProfile = decoded['data']['default_profile'];
           await _saveAuthData(decoded['data']);
        }
        _navigateBasedOnRole(defaultProfile);
        Get.snackbar("Success", "Logged in with Google");
      } else {
        Get.snackbar("Error", decoded['message'] ?? "Google login failed");
      }
    } catch (e) {
      Get.snackbar("Error", "Google Sign-In failed");
    } finally {
      isGoogleLoginLoading.value = false;
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

  void onAppleSignIn() {
    Get.snackbar("Info", "Apple Sign in clicked");
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
