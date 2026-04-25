import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_text_field.dart';


class AddBillingMethodView extends StatelessWidget {
  const AddBillingMethodView({super.key});

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
          AppStrings.addBillingMethod.tr, // Or "Billing & payment" as design header? Design shows "Billing & payment" but subheader "Add a billing method". I'll stick to Title being Billing or Add... Design shows < Billing & payment.
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.addBillingMethod.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Cancel button? Design shows a wide 'cancel' button outline at top?
              // "cancel" in green outline box. Strange UI pattern but I will follow design.
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFF6A9B5D)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppStrings.cancel.tr,
                    style: const TextStyle(
                      color: Color(0xFF6A9B5D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Card Icons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // SvgPicture.asset(AppImages.mastercard),
                  SvgPicture.asset(AppImages.visa, width: 32),
                  // SvgPicture.asset(AppImages.amex),
                ],
              ),
              const SizedBox(height: 8),

              // Form
              CustomTextField(
                hintText: "8340 3948 9303 2087", // Placeholder or Mask
                prefixIcon: const Icon(
                  Icons.payment,
                  color: AppColors.textSecondary,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(hintText: AppStrings.cardHolderName.tr),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: CustomTextField(hintText: "MM")),
                  const SizedBox(width: 16),
                  Expanded(child: CustomTextField(hintText: "YY")),
                ],
              ),
              const SizedBox(height: 16),
              CustomTextField(hintText: AppStrings.cvc.tr),
              const SizedBox(height: 16),
              CustomTextField(hintText: AppStrings.address.tr),
              const SizedBox(height: 16),
              CustomTextField(hintText: AppStrings.city.tr),
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
