import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_button.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.pages.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 4,
                    width: 40,
                    decoration: BoxDecoration(
                      color: controller.currentPage.value == index
                          ? AppColors.primary
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.pages.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          controller.pages[index].title.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 20,
                        ),
                        child: Text(
                          controller.pages[index].subTitle.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            // fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            image: DecorationImage(
                              image: AssetImage(controller.pages[index].image),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildTrustBadge(Icons.verified_user,
                        AppStrings.tenKVerified.tr, AppStrings.helpers.tr),
                  ),
                  Expanded(
                    child: _buildTrustBadge(Icons.shield, AppStrings.oneHundredPercent.tr,
                        AppStrings.securePayBadge.tr),
                  ),
                  Expanded(
                    child: _buildTrustBadge(Icons.star, AppStrings.ninetyNinePercent.tr,
                        AppStrings.successRate.tr),
                  ),
                ],
              ),
            ),

            // Bottom Area
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 10, 24.0, 24.0),
              child: CustomButton(
                text: AppStrings.getStarted.tr,
                onPressed: controller.createAccount,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrustBadge(IconData icon, String title, String subtitle) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF6CA34D), size: 28),
        const SizedBox(height: 4),
        Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
