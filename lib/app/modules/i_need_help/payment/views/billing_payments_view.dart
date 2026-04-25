import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../controllers/billing_payments_controller.dart';
import 'add_billing_method_view.dart';

class BillingPaymentsView extends GetView<BillingPaymentsController> {
  const BillingPaymentsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.billingAndPayments.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 120), // Added bottom padding for bar
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.manageBillingMethod.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Add, update or remove your billing method.",
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),

              // Existing Card
              Obx(() => ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.paymentMethods.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final method = controller.paymentMethods[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SvgPicture.asset(AppImages.visa, width: 40),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${method.type} ending in ${method.last4}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    InkWell(
                                      onTap: () => controller
                                          .editPaymentMethod(method.id),
                                      child: Text(
                                        AppStrings.edit.tr,
                                        style: const TextStyle(
                                          color: Color(0xFF6A9B5D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    InkWell(
                                      onTap: () => controller
                                          .removePaymentMethod(method.id),
                                      child: Text(
                                        AppStrings.remove.tr,
                                        style: const TextStyle(
                                          color: Color(0xFFF65B5B),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            "CAD",
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      );
                    },
                  )),

              const SizedBox(height: 32),

              // Add Billing Method Button
              InkWell(
                onTap: () => Get.to(() => const AddBillingMethodView()),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Color(0xFF6A9B5D)),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.addBillingMethod.tr,
                      style: const TextStyle(
                        color: Color(0xFF6A9B5D),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              
              // New Select Voucher Section
              const Text(
                "Select Voucher",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Redesigned Voucher Input
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: controller.voucherCodeController,
                  decoration: InputDecoration(
                    hintText: "Voucher code here",
                    hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: InputBorder.none,
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () => controller.applyNewVoucherCode(controller.voucherCodeController.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A9B5D),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        child: const Text("Apply", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Redesigned Voucher List
              Obx(() => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.availableVouchers.length,
                    itemBuilder: (context, index) {
                      final voucher = controller.availableVouchers[index];
                      return Obx(() {
                        final isSelected = controller.selectedVoucher.value?.id == voucher.id;
                        return GestureDetector(
                          onTap: () => controller.selectVoucher(voucher),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? const Color(0xFF6A9B5D) : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Left Section - Amount
                                Column(
                                  children: [
                                    Text(
                                      voucher.amount,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const Text(
                                      "Discount",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 24),
                                // Middle Section - Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        voucher.title,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        voucher.code,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Right Section - Icon
                                Icon(
                                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: isSelected ? const Color(0xFF6A9B5D) : Colors.grey.shade400,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                    },
                  )),
            ],
          ),
        ),
      ),
      // Task 4: UI - Bottom 'Total Price' Section
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Total price",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Home assistant > Standard task > ...",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                Text(
                  "\$12.50", // Added a total price value
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A9B5D),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Post task logic
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A9B5D),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text(
                "Post task",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
