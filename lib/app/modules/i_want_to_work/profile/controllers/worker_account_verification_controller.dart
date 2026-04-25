import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../routes/app_pages.dart';
import '../views/worker_account_verification_camera_view.dart';
import '../views/worker_account_verification_result_view.dart';
import '../views/worker_account_verification_instruction_view.dart';
import 'worker_profile_controller.dart';

class WorkerAccountVerificationController extends GetxController {
  CameraController? cameraController;
  final isCameraInitialized = false.obs;

  final selectedDocumentType = 'ID Card'.obs;
  final nameController = TextEditingController();
  final dobController = TextEditingController();
  final idNumberController = TextEditingController();

  final idCardImagePath = ''.obs;
  final isVerificationSuccess = false.obs;
  final isVerified = false.obs;

  void setDocumentType(String type) {
    selectedDocumentType.value = type;
  }

  Future<void> pickDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dobController.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  void pickImage() {
    idCardImagePath.value = 'assets/simulated_id_card.png';
    Get.snackbar('Success', 'Image selected (simulated)');
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      idCardImagePath.value = image.path;
      _simulateVerification();
    }
  }

  void captureImage() async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        final image = await cameraController!.takePicture();
        idCardImagePath.value = image.path;
        _simulateVerification();
      } catch (e) {
        Get.snackbar('Error', 'Failed to capture image: $e');
      }
    } else {
      // Fallback for simulation if camera fails
      _simulateVerification();
    }
  }

  void _simulateVerification() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    await Future.delayed(const Duration(seconds: 2));

    // Safely close dialog without accidentally closing the route
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (nameController.text.toLowerCase().contains("fail")) {
      isVerificationSuccess.value = false;
    } else {
      isVerificationSuccess.value = true;
      isVerified.value = true;

      // Update Profile Controller directly so the badge appears
      if (Get.isRegistered<WorkerProfileController>()) {
        Get.find<WorkerProfileController>().isVerified.value = true;
      }
    }

    // Navigate to Result View
    Get.off(() => const WorkerAccountVerificationResultView());
  }

  void finishVerification() {
    // Go to Dashboard with Profile tab selected (Index 3)
    Get.offAllNamed(Routes.WORKER_D, arguments: {'initialIndex': 3});
  }

  void retryVerification() {
    // Close ResultView, returning to InstructionView (Home -> Form -> Instructions -> [Result popped])
    Get.back();
  }

  void submit() {
    if (nameController.text.isEmpty ||
        dobController.text.isEmpty ||
        idNumberController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }
    // Navigate to Instructions View
    Get.to(() => const WorkerAccountVerificationInstructionView());
  }

  Future<void> initializeCamera() async {
    try {
      // Dispose existing camera to prevent lockups if initialized multiple times
      if (cameraController != null) {
        await cameraController!.dispose();
      }

      final cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        cameraController = CameraController(
          cameras.first,
          ResolutionPreset.high,
          enableAudio: false,
        );
        await cameraController!.initialize();
        isCameraInitialized.value = true;
      }
    } catch (e) {
      // If camera fails (e.g. emulator), we might want to just log it or allow gallery only
      // Get.snackbar('Error', 'Camera initialization failed: $e');
      isCameraInitialized.value = false;
    }
  }

  void goToCamera() {
    Get.to(() => const WorkerAccountVerificationCameraView());
    initializeCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    nameController.dispose();
    dobController.dispose();
    idNumberController.dispose();
    super.onClose();
  }
}
