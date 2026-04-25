import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/worker_home_controller.dart';

class ProposalModal extends StatelessWidget {
  const ProposalModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.shortBio.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: AppStrings.tellYourWorkExp.tr,
                maxLines: 4,
              ),

              const SizedBox(height: 16),
              Text(
                AppStrings.proposedBudget.tr,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                hintText: '\$90',
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  Get.find<WorkerHomeController>().proposedBudget.value = value;
                },
              ),
              const SizedBox(height: 4),
              Obx(() {
                final controller = Get.find<WorkerHomeController>();
                final budget = controller.clientPays;
                final fee = controller.serviceFee;
                final revenue = controller.workerRevenue;
                if (budget == 0) {
                  return const Text(
                    "+ 20% Platform Fee",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "You receive (80%): \$${revenue.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Color(0xFF7CB342),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Platform Fee (20%): \$${fee.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Client Pays (Total): \$${budget.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  text: AppStrings.submitRequest.tr,
                  onPressed: () => Get.back(),
                  backgroundColor: const Color(0xFF7CB342),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
