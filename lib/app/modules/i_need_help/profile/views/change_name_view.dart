import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/profile_controller.dart';

class ChangeNameView extends GetView<ProfileController> {
  const ChangeNameView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.name.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.changeName.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              hintText: AppStrings.firstName.tr,
              controller: TextEditingController(text: "Justin"), // Mock split
            ),
            const SizedBox(height: 16),
            CustomTextField(
              hintText: AppStrings.lastName.tr,
              controller: TextEditingController(text: "Leo"),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar("Success", "Name updated");
                },
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
                ), // "Save" or "Update"? Design shows "Save".
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
