import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/worker_profile_controller.dart';

class WorkerChangeCityView extends GetView<WorkerProfileController> {
  const WorkerChangeCityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.city.tr, showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              // Assuming 'Change City' or similar key logic
              AppStrings.changeCity.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              hintText: AppStrings.city.tr,
              controller: controller.cityController,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateCity();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A9B5D),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.update.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
