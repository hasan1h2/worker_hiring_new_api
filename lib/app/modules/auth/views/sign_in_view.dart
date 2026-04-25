import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_link_button/app_link_button.dart';
import '../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/social_button.dart';
import '../controllers/auth_controller.dart';
import 'sign_up_view.dart';

class SignInView extends GetView<AuthController> {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is initialized
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  Text(
                    '${AppStrings.or.tr}, ', // "Or, "
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  AppLinkButton(
                    text: AppStrings.createAccount.tr,
                    onTap: () => Get.to(const SignUpView()),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              CustomTextField(
                hintText: AppStrings.phoneNumber.tr,
                keyboardType: TextInputType.phone,
                controller: controller.phoneController,
              ),

              const SizedBox(
                height: 200,
              ), // Spacing to push bottom content down, or use Spacer if utilizing Expanded

              CustomButton(
                text: AppStrings.continueText.tr,
                onPressed: controller.onSignIn,
              ),

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

              SocialButton(
                text: AppStrings.continueWithGoogle.tr,
                iconPath: AppImages.google,
                onPressed: controller.onGoogleSignIn,
              ),
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
    );
  }
}
