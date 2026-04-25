import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../routes/app_pages.dart';
import '../../../../core/constants/app_images.dart';

class WorkerProfileController extends GetxController {
  final nameController = TextEditingController(text: "William Jonson");
  final firstNameController = TextEditingController(text: "William");
  final lastNameController = TextEditingController(text: "Jonson");
  final emailController = TextEditingController(text: "williamjon@gmail.com");
  final phoneController = TextEditingController(text: "+1 234 567 8900");
  final cityController = TextEditingController(text: "San Francisco CA");

  var avatar = AppImages.profilePlaceholder.obs;
  var strikes = 1.obs;
  var completionRate = 98.obs;
  var isVerified = false.obs;

  @override
  void onClose() {
    nameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.onClose();
  }

  void updateName() {
    nameController.text =
        "${firstNameController.text} ${lastNameController.text}";
    Get.back();
    Get.snackbar("Success", "Name updated");
  }

  void updatePhone() {
    Get.back();
    Get.snackbar("Success", "Phone updated");
  }

  void updateCity() {
    Get.back();
    Get.snackbar("Success", "City updated");
  }

  void updateEmail() {
    Get.back();
    Get.snackbar("Success", "Email updated");
  }

  Future<void> pickImage(bool fromCamera) async {
    // Logic to pick image would go here.
    // For now, simulating a successful pick.
    Get.back(); // Close bottom sheet
    // In real app:
    // final pickedFile = await ImagePicker().pickImage(source: fromCamera ? ImageSource.camera : ImageSource.gallery);
    // if (pickedFile != null) avatar.value = pickedFile.path; (or upload to server)
    Get.snackbar("Success", "Photo updated (Simulation)");
  }

  void updatePhoto() {
    // This might be called if there's a specific "Save" button on the photo page,
    // though usually picking the image updates it or sets it to a pending state.
    // Following design which has a "Save" button in one of the images.
    Get.back();
    Get.snackbar("Success", "Photo saved");
  }

  void signOut() {
    // Clear local storage/session data
    GetStorage().erase();
    
    // Redirect to login page
    Get.offAllNamed(Routes.SIGN_IN);
  }
}
