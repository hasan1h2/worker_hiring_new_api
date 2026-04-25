import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/worker_profile_controller.dart';
import 'worker_change_name_view.dart';
import 'worker_change_phone_view.dart';
import 'worker_change_city_view.dart';
import '../../../../routes/app_pages.dart';

class WorkerAccountView extends GetView<WorkerProfileController> {
  const WorkerAccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.account.tr, showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Photo row (if needed, or just link to change photo)
              // For now, mirroring the "Account" list structure
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.WORKER_CHANGE_PHOTO);
                },
                child: _buildDetailRow(AppStrings.photo.tr, isPhoto: true),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.to(() => const WorkerChangeNameView()),
                child: _buildDetailRow(
                  AppStrings.name.tr,
                  value: controller.nameController.text,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.toNamed(Routes.WORKER_CHANGE_EMAIL),
                child: _buildDetailRow(
                  AppStrings.email.tr,
                  value: controller.emailController.text,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.to(() => const WorkerChangePhoneView()),
                child: _buildDetailRow(
                  AppStrings.phoneNumber.tr,
                  value: controller.phoneController.text,
                ),
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () => Get.to(() => const WorkerChangeCityView()),
                child: _buildDetailRow(
                  "Location", // AppStrings.locationName.tr or similar
                  value: controller.cityController.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, {String? value, bool isPhoto = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        if (isPhoto)
          Obx(
            () => CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(controller.avatar.value),
            ),
          )
        else
          Expanded(
            child: Text(
              value ?? "", // Should be observable if controller updates it
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
      ],
    );
  }
}
