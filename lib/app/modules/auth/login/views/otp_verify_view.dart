import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/login_controller.dart';

class OtpVerifyView extends GetView<LoginController> {
  const OtpVerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    // Attempt to read email from arguments, fallback to controller text
    final args = Get.arguments as Map<String, dynamic>?;
    final String email = args?['email'] ?? controller.emailController.text;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'enterVerificationCode'.tr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${'codeSentTo'.tr} $email',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),

              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) => _buildOtpDigit(context, index)),
              ),

              const SizedBox(height: 24),

              // Info Box
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.lock_outline, size: 20, color: Colors.black54),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        AppStrings.communitySafetyOtp.tr,
                        style: const TextStyle(
                            fontSize: 13, color: Colors.black87, height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Resend Code
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'haventGotCode'.tr,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: controller.isOtpRequestLoading.value ? null : controller.requestLoginOtp,
                      child: Obx(() => Text(
                        controller.isOtpRequestLoading.value ? 'Sending...'.tr : 'resendCode'.tr,
                        style: TextStyle(
                          color: controller.isOtpRequestLoading.value ? Colors.grey : AppColors.primary,
                          fontWeight: FontWeight.w600,
                          decoration: controller.isOtpRequestLoading.value ? TextDecoration.none : TextDecoration.underline,
                        ),
                      )),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Verify Action Button
              Obx(() => CustomButton(
                text: AppStrings.continueText.tr,
                onPressed: controller.isOtpVerifyLoading.value ? () {} : controller.verifyLoginOtp,
                isLoading: controller.isOtpVerifyLoading.value,
              )),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOtpDigit(BuildContext context, int index) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller.otpControllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
        decoration: const InputDecoration(counterText: "", border: InputBorder.none),
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      ),
    );
  }
}
