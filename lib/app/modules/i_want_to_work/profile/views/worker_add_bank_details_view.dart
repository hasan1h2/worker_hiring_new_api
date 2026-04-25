import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/worker_profile_controller.dart';

class WorkerAddBankDetailsView extends GetView<WorkerProfileController> {
  const WorkerAddBankDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Add Bank Details", // Add to AppStrings if needed
        showLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Bank Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF6A9B5D)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.cancel.tr.toLowerCase(),
                  style: const TextStyle(
                    color: Color(0xFF6A9B5D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            CustomTextField(hintText: "Account Holder Name"),
            const SizedBox(height: 16),
            CustomTextField(hintText: "Bank Name"),
            const SizedBox(height: 16),
            CustomTextField(hintText: "Account Number"),
            const SizedBox(height: 16),
            CustomTextField(hintText: "Routing / Sort Code"),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar("Success", "Bank details added");
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
