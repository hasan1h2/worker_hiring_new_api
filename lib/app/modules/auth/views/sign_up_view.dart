import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_link_button/app_link_button.dart';
import '../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/signup_controller.dart';
import 'map_picker_view.dart';
import 'sign_in_view.dart';

class SignUpView extends GetView<SignupController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize SignupController
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: controller.formKey,
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
                const SizedBox(height: 8),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      AppStrings.alreadyHaveAccount.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    AppLinkButton(
                      text: AppStrings.signIn.tr,
                      onTap: () => Get.to(() => const SignInView()),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // First Name & Last Name
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        hintText: AppStrings.firstName.tr,
                        controller: controller.firstNameController,
                        validator: (value) => controller.validateRequired(value, "First Name"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomTextField(
                        hintText: AppStrings.lastName.tr,
                        controller: controller.lastNameController,
                        validator: (value) => controller.validateRequired(value, "Last Name"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Email
                CustomTextField(
                  hintText: AppStrings.email.tr,
                  keyboardType: TextInputType.emailAddress,
                  controller: controller.emailController,
                  validator: controller.validateEmail,
                ),
                const SizedBox(height: 16),

                // Phone
                CustomTextField(
                  hintText: AppStrings.phoneHint.tr,
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                  validator: (value) => controller.validateRequired(value, "Phone"),
                ),
                const SizedBox(height: 16),

                // Password
                CustomTextField(
                  hintText: AppStrings.password.tr,
                  obscureText: true,
                  controller: controller.passwordController,
                  validator: controller.validatePassword,
                ),
                const SizedBox(height: 16),

                // Referral Code
                CustomTextField(
                  hintText: "Referral Code (Optional)".tr,
                  controller: controller.referralCodeController,
                ),
                const SizedBox(height: 16),

                // Address Section
                const Text(
                  "Address",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                
                // Select Location Button
                InkWell(
                  onTap: () async {
                    final LatLng? result = await Get.to(() => const MapPickerView());
                    if (result != null) {
                      await controller.updateLocation(result.latitude, result.longitude);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.border),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on, color: Color(0xFF6E9E4A)),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Select Location on Map",
                            style: TextStyle(color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Display Selected Address
                Obx(() => controller.addressLineController.text.isNotEmpty 
                  ? Column(
                      children: [
                        CustomTextField(
                          hintText: "Address Line".tr,
                          controller: controller.addressLineController,
                          readOnly: true,
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          hintText: "City".tr,
                          controller: controller.cityController,
                          readOnly: true,
                        ),
                      ],
                    )
                  : const SizedBox.shrink()),

                const SizedBox(height: 30),

                // Signup Button
                Obx(() => controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: AppStrings.signUp.tr,
                        onPressed: controller.signupUser,
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
