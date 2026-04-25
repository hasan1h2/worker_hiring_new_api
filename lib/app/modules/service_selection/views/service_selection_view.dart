import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/service_chip.dart';
import '../controllers/service_selection_controller.dart';

class ServiceSelectionView extends GetView<ServiceSelectionController> {
  const ServiceSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                AppStrings.chooseServiceCategory.tr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 30),

              Expanded(
                child: SingleChildScrollView(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.services.map((service) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ServiceChip(
                            iconPath: service.icon,
                            label: service.label.tr,
                            isSelected: controller.selectedServices.contains(
                              service.label,
                            ),
                            onTap: () =>
                                controller.toggleService(service.label),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Obx(
                () => CustomButton(
                  text: AppStrings.done.tr,
                  onPressed: controller.onDone,
                  backgroundColor: controller.selectedServices.isNotEmpty
                      ? AppColors
                            .primary // Active color (green)
                      : Colors.grey, // Inactive color (grey)
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: controller.onSkip,
                  child: Text(
                    AppStrings.skip.tr,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
