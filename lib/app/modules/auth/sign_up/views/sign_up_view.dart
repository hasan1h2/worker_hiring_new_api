import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/social_button.dart';
import '../controllers/signup_controller.dart';
import 'map_picker_view.dart';
import '../../../../routes/app_pages.dart';

class SignUpView extends GetView<SignupController> {
  const SignUpView({super.key});

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
            key: controller.signupFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  AppStrings.createAccount.tr,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 3,),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.SIGN_IN),
                      child: Text(
                        AppStrings.signIn.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Name Row
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: AppStrings.firstName.tr,
                        controller: controller.firstNameController,
                        validator: (value) =>
                            controller.validateRequired(value, "First Name"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        hintText: AppStrings.lastName.tr,
                        controller: controller.lastNameController,
                        validator: (value) =>
                            controller.validateRequired(value, "Last Name"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                Obx(() => CustomTextField(
                  hintText: AppStrings.email.tr,
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  validator: controller.validateEmail,
                  onChanged: controller.validateEmailRealTime,
                  suffixIcon: controller.isEmailValid.value 
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                )),
                const SizedBox(height: 16),

                // Password
                Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomTextField(
                        hintText: AppStrings.password.tr,
                        obscureText: controller.isPasswordHidden.value,
                        controller: controller.passwordController,
                        validator: controller.validatePassword,
                        onChanged: controller.updatePasswordStrength,
                        borderColor: controller.strengthColor.value,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (controller.passwordStrength.value == 'Strong')
                              const Icon(Icons.check_circle, color: Colors.green),
                            IconButton(
                              icon: Icon(
                                controller.isPasswordHidden.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
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
                  ),
                ),
                const SizedBox(height: 16),

                // Phone Number
                IntlPhoneField(
                  controller: controller.phoneController,
                  decoration: InputDecoration(
                    hintText: AppStrings.phoneHint.tr,
                    hintStyle: const TextStyle(
                      color: Colors.black38,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.red),
                    ),
                  ),
                  initialCountryCode: 'US',
                  onChanged: (phone) {
                    // Handled automatically by controller.phoneController for the number
                  },
                ),
                const SizedBox(height: 16),

                // Location/City Picker
                InkWell(
                  onTap: () async {
                    final LatLng? result = await Get.to(
                      () => const MapPickerView(),
                    );
                    if (result != null) {
                      await controller.updateLocation(
                        result.latitude,
                        result.longitude,
                      );
                    }
                  },
                  child: Obx(() {
                    // Read an Rx variable to register the Obx dependency
                    final hasLocation = controller.lat.value.isNotEmpty;

                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              controller.cityController.text.isNotEmpty
                                  ? controller.cityController.text
                                  : "City",
                              style: TextStyle(
                                color: controller.cityController.text.isNotEmpty
                                    ? AppColors.textPrimary
                                    : Colors.black38,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.location_on,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 16),

                // Referral Code (Optional)
                CustomTextField(
                  hintText: 'Referral Code (Optional)',
                  controller: controller.referralCodeController,
                ),
                const SizedBox(height: 24),

                // Terms & Conditions
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      children: [
                        const TextSpan(
                          text: 'By signing up, you agree to our ',
                        ),
                        TextSpan(
                          text: 'Terms of Service',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {},
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Sign Up Button
                Obx(
                  () => CustomButton(
                    text: AppStrings.signUp.tr,
                    onPressed: controller.isLoading.value
                        ? () {}
                        : controller.signupUser,
                    isLoading: controller.isLoading.value,
                  ),
                ),
                const SizedBox(height: 24),

                // OR Divider
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

                // Social Buttons
                SocialButton(
                  text: AppStrings.continueWithGoogle.tr,
                  iconPath: AppImages.google,
                  onPressed: () {}, // Add logic later or in controller
                ),
                const SizedBox(height: 16),
                SocialButton(
                  text: AppStrings.continueWithApple.tr,
                  iconPath: AppImages.apple,
                  onPressed: () {}, // Add logic later or in controller
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
