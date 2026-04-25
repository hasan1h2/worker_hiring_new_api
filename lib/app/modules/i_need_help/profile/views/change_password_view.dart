import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.changePassword.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              AppStrings
                  .changePassword
                  .tr, // Or "Change password" as header again if needed, match screenshot (Has title "Change password")
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => CustomTextField(
                hintText: AppStrings.currentPassword.tr,
                obscureText: controller.obscureCurrent.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureCurrent.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.toggleCurrent,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomTextField(
                hintText: AppStrings.newPassword.tr,
                obscureText: controller.obscureNew.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureNew.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.toggleNew,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => CustomTextField(
                hintText: AppStrings.confirmPassword.tr,
                obscureText: controller.obscureConfirm.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.obscureConfirm.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: controller.toggleConfirm,
                ),
              ),
            ),

            const SizedBox(height: 30),
            CustomButton(
              // "Change password" button
              text: AppStrings.changePassword.tr,
              onPressed: controller.changePassword,
            ),

            const SizedBox(height: 20),
            Center(
              child: Text(
                AppStrings.forgotPassword.tr,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
