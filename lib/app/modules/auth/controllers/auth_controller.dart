import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../i_need_help/create_task/widgets/location_picker_dialog.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  // Sign Up Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();

  // Observable state
  final RxBool isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void openMapDialog() {
    Get.dialog(
      LocationPickerDialog(
        onLocationSelected: () {
          // Logic for when location is selected (e.g., updating cityController)
          // For now, just close the dialog as per existing logic in LocationPickerDialog
          Get.back();
        },
      ),
    );
  }

  void onSignUp() {
    Get.toNamed('/otp', arguments: {'isSignIn': false});
  }

  void onSignIn() {
    Get.toNamed('/otp', arguments: {'isSignIn': true});
  }

  void onVerifyOtp() {
    final args = Get.arguments as Map<String, dynamic>?;
    final isSignIn = args?['isSignIn'] ?? false;

    if (isSignIn) {
      Get.offAllNamed(Routes.MAIN);
    } else {
      Get.offAllNamed(Routes.ROLE_SELECTION);
    }
  }

  void onResendOtp() {
    Get.snackbar("Info", "Code resent");
  }

  void onGoogleSignIn() {
    Get.snackbar("Info", "Google Sign in clicked");
  }

  void onAppleSignIn() {
    Get.snackbar("Info", "Apple Sign in clicked");
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
