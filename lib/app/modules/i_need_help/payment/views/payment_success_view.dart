import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../routes/app_pages.dart';
class PaymentSuccessView extends StatelessWidget {
  final bool cameFromChat;
  const PaymentSuccessView({super.key, this.cameFromChat = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: CustomButton(
        text: cameFromChat ? "Done" : AppStrings.goOrder.tr, 
        onPressed: () {
          if (cameFromChat) {
            Get.back(result: true);
          } else {
            Get.toNamed(Routes.DASHBOARD);
          }
        },
        backgroundColor: AppColors.textPrimary,
      ).marginOnly(bottom: 60,left: 20,right: 20),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Big Green Check
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF64D864), // Bright Green
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 60,
              ), // Simple icon
              // or SvgPicture.asset(AppImages.checkBig),
            ),
            const SizedBox(height: 40),
            Text(
              AppStrings.paymentSuccessful.tr,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
