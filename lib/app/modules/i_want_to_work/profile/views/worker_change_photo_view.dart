import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/worker_profile_controller.dart';

class WorkerChangePhotoView extends GetView<WorkerProfileController> {
  const WorkerChangePhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.photo.tr, showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              AppStrings.changePhoto.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: GestureDetector(
                onTap: () => _showPhotoOptions(context),
                child: Obx(
                  () => CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage(controller.avatar.value),
                  ),
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: AppStrings.save.tr,
              onPressed: controller.updatePhoto,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Center(
                  child: Text(
                    AppStrings.takePhoto.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () => controller.pickImage(true), // Camera
              ),
              const Divider(height: 1),
              ListTile(
                title: Center(
                  child: Text(
                    AppStrings.chooseFromLibrary.tr,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () => controller.pickImage(false), // Gallery
              ),
              const Divider(height: 1), // Add separator
              ListTile(
                title: const Center(
                  child: Text(
                    "Cancel", // Should use AppStrings.cancel.tr
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                onTap: () => Get.back(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
