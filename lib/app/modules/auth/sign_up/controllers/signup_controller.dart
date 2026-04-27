import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../routes/app_pages.dart';
import 'package:geocoding/geocoding.dart';

import '../providers/signup_provider.dart';
class SignupController extends GetxController {
  // Provider
  final SignupProvider _provider = SignupProvider();

  // Text Editing Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final referralCodeController = TextEditingController();
  final addressLineController = TextEditingController();
  final cityController = TextEditingController();

  // Loading state
  final RxBool isLoading = false.obs;
  
  // Password Visibility & Strength
  final RxBool isPasswordHidden = true.obs;
  final RxString passwordStrength = ''.obs;
  final Rx<Color> strengthColor = Colors.grey.obs;

  // Email Validation
  final RxBool isEmailValid = false.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
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
      // Default to Good if it's 8+ chars and doesn't meet the strict 'Strong' criteria but isn't weak.
      passwordStrength.value = 'Good';
      strengthColor.value = Colors.blue;
    }
  }

  // Address data
  final RxString lat = "".obs;
  final RxString lng = "".obs;

  // Form key
  final signupFormKey = GlobalKey<FormState>();

  // Validation logic
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required'.tr;
    if (!GetUtils.isEmail(value)) return 'Enter a valid email'.tr;
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required'.tr;
    if (value.length < 6) return 'Password must be at least 6 characters'.tr;
    return null;
  }

  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) return '$fieldName is required'.tr;
    return null;
  }

  // Location logic
  Future<void> updateLocation(double latitude, double longitude) async {
    lat.value = latitude.toString();
    lng.value = longitude.toString();

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        cityController.text = place.locality ?? place.subAdministrativeArea ?? "";
        addressLineController.text = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
      }
    } catch (e) {
      Get.snackbar("Error", "Could not fetch address details.");
    }
  }

  // API Logic
  Future<void> signupUser() async {
    if (!signupFormKey.currentState!.validate()) return;

    if (lat.isEmpty || lng.isEmpty) {
      Get.snackbar("Error", "Please select a location on map".tr);
      return;
    }

    isLoading.value = true;

    final body = {
      "first_name": firstNameController.text.trim(),
      "last_name": lastNameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "password": passwordController.text,
      "address": {
        "address_line": addressLineController.text.trim(),
        "city": cityController.text.trim(),
        "lat": lat.value,
        "lng": lng.value
      },
      "referral_code": referralCodeController.text.trim()
    };

    try {
      final response = await _provider.signupUser(body);
      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", responseData['message'] ?? "Signup successful!".tr,
            backgroundColor: Colors.green, colorText: Colors.white);
        Get.toNamed(Routes.OTP, arguments: {'email': emailController.text.trim(), 'flowType': 'signup'});
      } else {
        String errorMessage = responseData['message'] ?? "Signup failed".tr;
        if (responseData['errors'] != null) {
          errorMessage = responseData['errors'].toString();
        }
        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString().tr,
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    referralCodeController.dispose();
    addressLineController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
