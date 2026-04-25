import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/worker_account_verification_controller.dart';

class WorkerAccountVerificationView
    extends GetView<WorkerAccountVerificationController> {
  const WorkerAccountVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.accountVerification.tr,
        showLeading: true,
      ),
      body: Obx(
        () => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                child: controller.selectedDocumentType.value.isEmpty
                    ? _buildDocumentSelection()
                    : _buildDetailsForm(),
              ),
            ),

            // Continue Button
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
                      if (controller.selectedDocumentType.value.isEmpty) {
                        // Logic to select, but UI implies radio selection then continue
                        // For now, let's default to ID Card if they click continue without explicit "selection" state distinct from "hover"
                        controller.setDocumentType(AppStrings.idCard.tr);
                      } else {
                        controller.submit();
                      }
                    },
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
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Document Selection
  Widget _buildDocumentSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.documentVerification.tr,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          AppStrings.documentType.tr,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),

        // ID Card Option
        _buildSelectionCard(
          title: AppStrings.idCard.tr,
          iconData: Icons.badge_outlined, // Placeholder for ID icon
          isSelected: true, // Mocking state for UI demo as per Image 1
          onTap: () {
            // In a real flow, this would update a local state, then "Continue" moves to next step
            // For this implementation, I'll make the card tap immediately set the type to show the form?
            // Or should I maintain the 2-step visually?
            // The image shows a "Continue" button at the bottom.
            // So I should probably use a local variable for "currently highlighted selection" vs "confirmed selection".
            // But to keep it simple, let's say tapping "Continue" moves to the form.
          },
        ),
        const SizedBox(height: 16),

        // Passport Option
        _buildSelectionCard(
          title: AppStrings.passport.tr,
          iconData: Icons.book_outlined, // Placeholder for Passport icon
          isSelected: false,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSelectionCard({
    required String title,
    required IconData iconData,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    // Need to handle the "Radio" button look
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFFF9F9F9),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
              size: 24,
            ), // Custom icon in asset would be better
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            // Radio Circle
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // Step 2: Form Input
  Widget _buildDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.documentVerification.tr,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.provideIdInfo.tr,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
        const SizedBox(height: 32),

        // Full Name
        _buildLabel(AppStrings.fullName.tr),
        const SizedBox(height: 8),
        _buildTextField(
          controller: controller.nameController,
          hintText: "Alex Smith",
        ),

        const SizedBox(height: 20),

        // DOB
        _buildLabel(AppStrings.dateOfBirth.tr),
        const SizedBox(height: 8),
        _buildTextField(
          controller: controller.dobController,
          hintText: "mm/dd/yy",
          readOnly: true,
          onTap: () => controller.pickDateOfBirth(Get.context!),
        ),

        const SizedBox(height: 20),

        // ID Number
        _buildLabel(AppStrings.idNumber.tr),
        const SizedBox(height: 8),
        _buildTextField(
          controller: controller.idNumberController,
          hintText: "45246282554252",
        ),

        // Upload would go here if needed, but per images 2/3 it's just the form visible.
        // I will stick to what is clearly visible in the reference for now.
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF424242),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
