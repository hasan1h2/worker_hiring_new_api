import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/profile_controller.dart';

class ChangePhotoView extends GetView<ProfileController> {
  const ChangePhotoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .white, // or transparent via modal usually, but design shows full screen with back?
      // Design shows "Change your phonto" content in a large area.
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.photo.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              AppStrings.changePhoto.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 40),

          // Avatar
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Obx(
                  () => InkWell(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(color: AppColors.border),
                                  ),
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Handle Take Photo
                                    Get.back();
                                  },
                                  child: Text(
                                    AppStrings.takePhoto.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    // Handle Choose from Library
                                    Get.back();
                                  },
                                  child: Text(
                                    AppStrings.chooseFromLibrary.tr,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => Get.back(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6A9B5D),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    AppStrings
                                        .update
                                        .tr, // Using 'Update' or just 'Cancel' in sheet?
                                    // Design image 2 shows "Update" button at bottom of sheet.
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage(controller.avatar.value),
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ),
                // Optional camera icon overlay or separate button? Design just shows avatar.
              ],
            ),
          ),

          const Spacer(),

          // Save Button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.onUpdateProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A9B5D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.save.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
