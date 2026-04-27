import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/social_button.dart';
import '../../../../routes/app_pages.dart';
import '../../password_reset/views/forgot_password_view.dart';
import '../controllers/login_controller.dart';
import 'email_entry_view.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
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
            key: controller.loginFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  AppStrings.signIn.tr,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'or, ',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.SIGN_UP),
                      child: Text(
                        AppStrings.createAccount.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // Email Field
                Obx(() => CustomTextField(
                  hintText: "Email".tr,
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
                const SizedBox(height: 16),

                // Password Field
                Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomTextField(
                      hintText: "Password".tr,
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                      validator: (value) => (value == null || value.isEmpty) ? "Password is required" : null,
                      onChanged: controller.updatePasswordStrength,
                      borderColor: controller.strengthColor.value,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.passwordStrength.value == 'Strong')
                            const Icon(Icons.check_circle, color: Colors.green),
                          IconButton(
                            icon: Icon(
                              controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ],
                      ),
                    ),
                    if (controller.passwordStrength.value.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, right: 8),
                        child: Text(
                          controller.passwordStrength.value,
                          style: TextStyle(
                            color: controller.strengthColor.value,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                )),
                
                const SizedBox(height: 8),
                
                // Forgot Password & Send OTP Instead Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Navigate to ForgotPasswordView
                        Get.to(() => const ForgotPasswordView());
                      },
                      child: Text(
                        "Forgot password?",
                        style: const TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const EmailEntryView()),
                      child: Text(
                        "Send OTP instead".tr,
                        style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                Obx(() => CustomButton(
                  text: AppStrings.continueText.tr,
                  onPressed: controller.isPasswordLoginLoading.value ? () {} : controller.loginWithPassword,
                  isLoading: controller.isPasswordLoginLoading.value,
                )),

                const SizedBox(height: 24),

                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        AppStrings.or.tr,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 24),

                Obx(() => SocialButton(
                  text: AppStrings.continueWithGoogle.tr,
                  iconPath: AppImages.google,
                  onPressed: controller.isGoogleLoginLoading.value ? () {} : controller.loginWithGoogle,
                  isLoading: controller.isGoogleLoginLoading.value,
                )),
                const SizedBox(height: 16),
                SocialButton(
                  text: AppStrings.continueWithApple.tr,
                  iconPath: AppImages.apple,
                  onPressed: controller.onAppleSignIn,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
