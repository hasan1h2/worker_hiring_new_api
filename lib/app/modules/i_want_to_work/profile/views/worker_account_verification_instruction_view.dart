import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/contextual_warning_banner.dart';
import '../controllers/worker_account_verification_controller.dart';

class WorkerAccountVerificationInstructionView
    extends GetView<WorkerAccountVerificationController> {
  const WorkerAccountVerificationInstructionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.accountVerification.tr,
        showLeading: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 24),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ContextualWarningBanner(
              message:
                  "Your privacy is secured. We don't share your private information with others.",
              backgroundColor: const Color(0xFFE3F2FD), // Light blue
              textColor: const Color(0xFF1976D2), // Dark blue
              icon: Icons.security,
              iconColor: const Color(0xFF1976D2),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      AppStrings.documentVerification.tr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.takePicturesOfId.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // ID Card Illustration
                    Center(child: _buildIdCardIllustration()),
                    const SizedBox(
                      height: 20,
                    ), // Add some bottom spacing for scrollable content
                  ],
                ),
              ),
            ),

            // Continue Button - Pinned to bottom
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () => controller.goToCamera(),
                  child: Text(
                    AppStrings.continueText.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdCardIllustration() {
    return Container(
      width: 300,
      height: 190,
      decoration: BoxDecoration(
        color: const Color(0xFF78A8B6), // Teal-ish background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Header Text
          const Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Text(
              "ID CARD",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w400,
                letterSpacing: 1.5,
              ),
            ),
          ),

          // Content Area
          Positioned(
            top: 60,
            left: 12,
            right: 12,
            bottom: 12,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFA6CED7), // Lighter teal
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  // Photo Placeholder
                  Positioned(
                    top: 15,
                    left: 15,
                    bottom: 15,
                    width: 70,
                    child: Container(
                      color: const Color(0xFFF2E7C9), // Beige skin tone bg
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          // Rough shape of a person
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 70,
                              height: 30,
                              color: const Color(0xFF1A3348), // Dark blue suit
                            ),
                          ),
                          // Head/Neck would be complex to draw with containers,
                          // keeping it simple abstract or simple shapes
                          Positioned(
                            top: 15,
                            child: Container(
                              width: 35,
                              height: 45,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF3C774), // Face color
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Hair
                          Positioned(
                            top: 10,
                            child: Container(
                              width: 40,
                              height: 25,
                              decoration: const BoxDecoration(
                                color: Color(0xFF333333), // Hair color
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Text Lines
                  Positioned(
                    top: 20,
                    left: 100,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 6,
                          color: const Color(0xFF6B97A3),
                          width: 140,
                        ), // Title line
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              height: 6,
                              color: const Color(0xFF6B97A3),
                              width: 60,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 6,
                              color: const Color(0xFF6B97A3),
                              width: 40,
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 6,
                          color: const Color(0xFF6B97A3),
                          width: 100,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 6,
                          color: const Color(0xFF6B97A3),
                          width: 120,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              height: 6,
                              color: const Color(0xFF6B97A3),
                              width: 50,
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 6,
                              color: const Color(0xFF6B97A3),
                              width: 30,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Barcode
                  Positioned(
                    top: 15,
                    bottom: 15,
                    right: 15,
                    width: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        15,
                        (index) => Container(
                          height: 2,
                          color: const Color(0xFF455A64),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
