import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/profile_controller.dart';
import 'change_photo_view.dart';
import 'change_name_view.dart';
import 'change_email_view.dart';
import 'change_phone_view.dart';
import 'change_city_view.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.profile.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // Edit avatar icon? Design shows Avatar with Name under it then list of fields.
          // Wait, design titled "Profile" (Screen 2) shows list of details: Name, Email, Phone, City.
          // And "Photo" row at top? No, top has Photo.
          // Design 2 is View Details? Or Edit?
          // It looks like "View Profile" because no inputs borders.
          // But usually "Account" implies edit or view details.
          // Let's implement as Display List as per design.
          GestureDetector(
            onTap: () => Get.to(() => const ChangePhotoView()),
            child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[200],
                child: const Icon(
                  Icons.person,
                  color: Colors.grey,
                ), // Placeholder or use user avatar
              ),
            ),
          ),
          // GestureDetector(
          //   onTap: () => Get.to(() => const ChangePhotoView()),
          //   child: Padding(
          //     padding: const EdgeInsets.only(right: 20),
          //     child: CircleAvatar(
          //       radius: 16,
          //       backgroundColor: Colors.grey[200],
          //       child: const Icon(
          //         Icons.person,
          //         color: Colors.grey,
          //       ), // Placeholder or use user avatar
          //     ),
          //   ),
          // ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Get.to(() => const ChangePhotoView()),
              child: _buildDetailRow(AppStrings.photo.tr, isPhoto: true),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Get.to(() => const ChangeNameView()),
              child: _buildDetailRow(
                AppStrings.name.tr,
                value: controller.nameController.text,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Get.to(() => const ChangeEmailView()),
              child: _buildDetailRow(
                AppStrings.email.tr,
                value: controller.emailController.text,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Get.to(() => const ChangePhoneView()),
              child: _buildDetailRow(
                AppStrings.phoneNumber.tr,
                value: controller.phoneController.text,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => Get.to(() => const ChangeCityView()),
              child: _buildDetailRow(
                AppStrings.city.tr,
                value: controller.cityController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, {String? value, bool isPhoto = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        if (isPhoto)
          Obx(
            () => CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(controller.avatar.value),
            ),
          )
        else
          Text(
            value ?? "",
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
      ],
    );
  }
}
