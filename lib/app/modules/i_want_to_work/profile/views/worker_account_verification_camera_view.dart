import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/worker_account_verification_controller.dart';

class WorkerAccountVerificationCameraView
    extends GetView<WorkerAccountVerificationController> {
  const WorkerAccountVerificationCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E), // Dark background from image
      body: Stack(
        children: [
          // Close button
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Get.back(),
            ),
          ),

          // Main Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Camera Frame
                Container(
                  width: Get.width * 0.85,
                  height: Get.width * 0.85 * 0.63,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Obx(() {
                      if (controller.isCameraInitialized.value &&
                          controller.cameraController != null) {
                        return CameraPreview(controller.cameraController!);
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                    }),
                  ),
                ),
                const SizedBox(height: 30),

                // Instruction Text
                Text(
                  AppStrings.placeIdInFrame.tr,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),

          // Shutter Button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Spacer to center the shutter button
                    const SizedBox(width: 60),

                    // Shutter Button
                    GestureDetector(
                      onTap: () => controller.captureImage(),
                      child: Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                        ),
                        child: Center(
                          child: Container(
                            width: 56,
                            height: 56,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Gallery Button
                    GestureDetector(
                      onTap: () => controller.pickImageFromGallery(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.photo_library, // Gallery icon
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
