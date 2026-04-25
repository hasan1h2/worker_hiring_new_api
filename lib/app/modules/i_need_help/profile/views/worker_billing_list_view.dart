import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../i_want_to_work/profile/controllers/worker_profile_controller.dart';
import '../../../i_want_to_work/profile/views/worker_add_billing_view.dart';
import '../../../i_want_to_work/profile/views/worker_add_bank_details_view.dart';

class WorkerBillingListView extends GetView<WorkerProfileController> {
  const WorkerBillingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.billingAndPayments.tr,
        showLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.manageBillingMethod.tr,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.manageBillingDesc.tr,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // List of cards - Mocked for now
            // Reuse logic or create widget if needed, but simple list here fine.
            _buildBillingItem(
              cardType: "Visa",
              last4: "9380",
              currency: "CAD", // AppStrings.cad.tr
            ),

            const SizedBox(height: 20),

            // Add Billing Method Button
            TextButton.icon(
              onPressed: () => Get.to(() => const WorkerAddBillingView()),
              icon: const Icon(Icons.add, color: Color(0xFF6A9B5D)),
              label: Text(
                AppStrings.addBillingMethod.tr,
                style: const TextStyle(
                  color: Color(0xFF6A9B5D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: () => Get.to(() => const WorkerAddBankDetailsView()),
              icon: const Icon(Icons.account_balance, color: Color(0xFF6A9B5D)),
              label: const Text(
                "Add Bank Account",
                style: TextStyle(
                  color: Color(0xFF6A9B5D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text(
              "Voucher Code",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Enter voucher code",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    Get.snackbar("Success", "Voucher applied successfully");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6A9B5D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Apply",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillingItem({
    required String cardType,
    required String last4,
    required String currency,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Card Icon Placeholder -
              // ideally SvgPicture.asset('assets/icons/visa.svg')
              Container(
                width: 40,
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F71), // Visa Blue or image
                  borderRadius: BorderRadius.circular(4),
                ),
                alignment: Alignment.center,
                child: const Text(
                  "VISA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "$cardType ending in $last4",
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                currency,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  // Edit logic
                },
                child: Text(
                  AppStrings.edit.tr,
                  style: const TextStyle(
                    color: Color(0xFF6A9B5D), // Green
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 24),
              GestureDetector(
                onTap: () {
                  // Remove logic
                },
                child: Text(
                  AppStrings.remove.tr,
                  style: const TextStyle(
                    color: Color(0xFFFF5252), // Red
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
