import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';

class AddBillingView extends StatelessWidget {
  const AddBillingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.billingAndPayments.tr),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                AppStrings.addBillingMethod.tr,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(
                      color: Color(0xFF6A9B5D),
                    ), // Green border
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.cancel.tr,
                    style: const TextStyle(
                      color: Color(0xFF6A9B5D), // Green text
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    'assets/icons/icon_mastercard.svg',
                    height: 20,
                  ),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/icon_visa.svg', height: 20),
                  const SizedBox(width: 8),
                  SvgPicture.asset('assets/icons/icon_amex.svg', height: 20),
                ],
              ),
              const SizedBox(height: 10),

              CustomTextField(
                hintText: '8340 3948 9303 2087',
                prefixIcon: const Icon(
                  Icons.credit_card,
                  color: Colors.black54,
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),

              CustomTextField(hintText: AppStrings.cardHolderName.tr),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: AppStrings.mm.tr,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      hintText: AppStrings.yy.tr,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                hintText: AppStrings.cvc.tr,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              CustomTextField(hintText: AppStrings.address.tr),
              const SizedBox(height: 16),
              CustomTextField(hintText: AppStrings.city.tr),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: AppStrings.postalCode.tr, // Ensure postalCode exists
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 40),

              CustomButton(
                text: AppStrings.save.tr,
                backgroundColor: const Color(0xFF6A9B5D), // Green
                onPressed: () {
                  Get.back();
                  Get.snackbar("Success", "Billing method added");
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
