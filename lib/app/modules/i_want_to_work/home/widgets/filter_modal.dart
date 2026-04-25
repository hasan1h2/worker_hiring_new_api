import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/worker_home_controller.dart';

class FilterModal extends StatelessWidget {
  const FilterModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.category.tr,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: 'Furniture assembly', // Mock value
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: ['Furniture assembly', 'Home assistance'].map((
                  String value,
                ) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.home_work_outlined,
                          size: 20,
                          color: Colors.pinkAccent,
                        ), // Placeholder icon
                        const SizedBox(width: 8),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (_) {},
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Sort by Budget",
            style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(
                () => DropdownButton<String>(
                  value: Get.find<WorkerHomeController>().filterBudget.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: ['Highest to Lowest', 'Lowest to Highest'].map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null)
                      Get.find<WorkerHomeController>().filterBudget.value = val;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Sort by Date",
            style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: Obx(
                () => DropdownButton<String>(
                  value: Get.find<WorkerHomeController>().filterDate.value,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: ['Newest to Oldest', 'Oldest to Newest'].map((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null)
                      Get.find<WorkerHomeController>().filterDate.value = val;
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: AppStrings.reset.tr,
                  onPressed: () =>
                      Get.find<WorkerHomeController>().resetFilter(),
                  type: ButtonType.outline,
                  backgroundColor: AppColors.primary, // Outline color
                  textColor: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: CustomButton(
                  text: AppStrings.apply.tr,
                  onPressed: () =>
                      Get.find<WorkerHomeController>().applyFilter(),
                  backgroundColor: const Color(0xFF7CB342),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
