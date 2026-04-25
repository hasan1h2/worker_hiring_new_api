import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../routes/app_pages.dart';

import '../../../../core/constants/app_images.dart';


class ProfileController extends GetxController {
  final nameController = TextEditingController(text: "Justin Leo");
  final emailController = TextEditingController(
    text: "justinleo@gmail.com",
  ); // readonly usually
  final phoneController = TextEditingController(text: "+1 658 145 0124");
  final cityController = TextEditingController(
    text: "San Francisco CA",
  ); // Keeping design typo "Farncisco" or fixing? Fixing to Francisco.

  // Mock Avatar
  var avatar = AppImages
      .alexSmith
      .obs; // Using generic, or specific justin if added. Using alexSmith as placeholder.

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void onUpdateProfile() {
    Get.back();
    Get.snackbar("Success", "Profile updated");
  }

  void signOut() {
    // Clear local storage/session data
    GetStorage().erase();
    
    // Redirect to login page
    Get.offAllNamed(Routes.SIGN_IN);
  }

  void updateLanguage(String langCode) {
    try {
      GetStorage().write('lang', langCode);
    } catch (e) {
      // In case GetStorage instance issue, but main.dart has GetStorage.init();
      debugPrint("Storage error: $e");
    }
  }
}
