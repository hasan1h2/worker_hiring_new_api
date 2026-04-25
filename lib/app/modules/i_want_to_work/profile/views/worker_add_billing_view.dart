import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/worker_profile_controller.dart';

class WorkerAddBillingView extends GetView<WorkerProfileController> {
  const WorkerAddBillingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.billingAndPayments.tr,
        showLeading: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.addBillingMethod.tr,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),

            // Cancel Button (Outlined, Full Width)
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
                  AppStrings.cancel.tr
                      .toLowerCase(), // Design shows lowercase "cancel"
                  style: const TextStyle(
                    color: Color(0xFF6A9B5D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Card Icons row if needed, or just Inputs
            // Design shows card logos above card number input right? No, standard input.
            CustomTextField(
              hintText: "8340 3948 9303 2087", // AppStrings.cardNumber.tr,
              prefixIcon: const Icon(
                Icons.credit_card,
                color: AppColors.textSecondary,
              ), // Placeholder icon
            ),
            const SizedBox(height: 16),
            CustomTextField(hintText: AppStrings.cardHolderName.tr),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: CustomTextField(hintText: AppStrings.mm.tr)),
                const SizedBox(width: 16),
                Expanded(child: CustomTextField(hintText: AppStrings.yy.tr)),
              ],
            ),
            const SizedBox(height: 16),
            CustomTextField(hintText: AppStrings.cvc.tr),
            const SizedBox(height: 16),
            CustomTextField(hintText: AppStrings.address.tr),
            const SizedBox(height: 16),
            CustomTextField(hintText: AppStrings.city.tr), // generic city key
            const SizedBox(height: 16),
            CustomTextField(hintText: AppStrings.postalCode.tr),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                  Get.snackbar("Success", "Billing method added");
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
