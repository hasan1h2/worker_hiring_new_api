import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/worker_profile_controller.dart';

class WorkerChangeEmailView extends GetView<WorkerProfileController> {
  const WorkerChangeEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.email.tr, showLeading: true),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Change email address", // Or AppStrings.changeEmail.tr if available, checking implementation plan... using hardcoded for now or adding to strings if rigorous
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: controller.emailController,
                decoration: InputDecoration.collapsed(
                  hintText: AppStrings.email.tr,
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: AppStrings.update.tr,
              onPressed: controller.updateEmail,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
