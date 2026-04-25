import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class SignupController extends GetxController {
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

  // Address data
  final RxString lat = "".obs;
  final RxString lng = "".obs;

  // Form key
  final formKey = GlobalKey<FormState>();

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
    if (!formKey.currentState!.validate()) return;

    if (lat.isEmpty || lng.isEmpty) {
      Get.snackbar("Error", "Please select a location on map".tr);
      return;
    }

    isLoading.value = true;

    final url = Uri.parse('https://samimdev.pythonanywhere.com/api/v1/auth/signup/');
    
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
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", responseData['message'] ?? "Signup successful!".tr,
            backgroundColor: Colors.green, colorText: Colors.white);
        // Navigate to login or next screen
        // Get.offNamed('/login');
      } else {
        String errorMessage = responseData['message'] ?? "Signup failed".tr;
        if (responseData['errors'] != null) {
          errorMessage = responseData['errors'].toString();
        }
        Get.snackbar("Error", errorMessage,
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.".tr,
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
