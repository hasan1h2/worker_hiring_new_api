import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/password_reset_controller.dart';

class ForgotPasswordView extends GetView<PasswordResetController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    // If the controller isn't registered yet via binding, we can put it here temporarily
    // depending on the project's routing setup. Typically it's bound in AppPages.
    Get.put(PasswordResetController());

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.emailFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Enter your email to receive a reset code",
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),

                // Email Field
                Obx(() => CustomTextField(
                  hintText: "Email",
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                  onChanged: controller.validateEmailRealTime,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Email is required";
                    if (!GetUtils.isEmail(value)) return "Enter a valid email";
                    return null;
                  },
                  suffixIcon: controller.isEmailValid.value 
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                )),
                
                const SizedBox(height: 40),

                Obx(() => CustomButton(
                  text: "Send Reset OTP",
                  onPressed: controller.isRequestingOtp.value ? () {} : controller.requestResetOtp,
                  isLoading: controller.isRequestingOtp.value,
                )),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
