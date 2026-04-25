import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/worker_account_verification_controller.dart';

class WorkerAccountVerificationResultView
    extends GetView<WorkerAccountVerificationController> {
  const WorkerAccountVerificationResultView({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine state from arguments or controller
    // For simplicity, let's assume controller holds the state of "last attempt"
    // Or we pass it as argument. Let's use controller observable.

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.accountVerification.tr,
        showLeading: false,
      ),
      body: Obx(() {
        final isSuccess = controller.isVerificationSuccess.value;

        return Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: isSuccess
                              ? const Color(0xFF69F0AE).withValues(alpha: 0.2)
                              : const Color(0xFFFFEBEE), // Light Green / Red
                          shape: BoxShape.circle,
                        ),
                        // Actual design uses specific shapes/colors
                        // Success: Green scalloped shape with check
                        // Failure: Red circle with X
                        child: isSuccess
                            ? const Icon(
                                Icons.check,
                                color: Color(0xFF00C853),
                                size: 60,
                              ) // Placeholder for scalloped shape
                            : const Icon(
                                Icons.close,
                                color: Color(0xFFD32F2F),
                                size: 60,
                              ),
                      ),

                      const SizedBox(height: 24),

                      // Title
                      Text(
                        isSuccess
                            ? AppStrings.verificationSuccessful.tr
                            : AppStrings.verificationFailed.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Button - Pinned to bottom with SafeArea
            SafeArea(
              child: Padding(
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
                    onPressed: () {
                      if (isSuccess) {
                        controller.finishVerification();
                      } else {
                        controller.retryVerification();
                      }
                    },
                    child: Text(
                      isSuccess ? AppStrings.close.tr : AppStrings.tryAgain.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
