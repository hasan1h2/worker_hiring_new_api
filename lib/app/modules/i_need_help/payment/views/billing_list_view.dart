import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:worker_hiring/app/core/constants/app_images.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/billing_payments_controller.dart';
import 'add_billing_view.dart';

class BillingListView extends GetView<BillingPaymentsController> {
  const BillingListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.billingAndPayments.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.manageBillingMethod.tr,
              style: const TextStyle(
                fontSize: 20,
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
            const SizedBox(height: 30),
            Obx(
              () => ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.paymentMethods.length,
                separatorBuilder: (_, _) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final method = controller.paymentMethods[index];
                  // Using a simple Row layout instead of List Tile to match screens exactly
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon
                      Container(
                        width: 40,
                        height: 25,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F71), // Visa color
                          borderRadius: BorderRadius.circular(4),
                        ),
                        alignment: Alignment.center,
                        // Use the SVG if available, or text
                        child: SvgPicture.asset(
                          AppImages.visa,
                          width: 32,
                          // colorFilter:ColorFilter.mode(Colors.white, BlendMode.srcIn) ,
                        ),
                        // Note: The dummy asset might be colored, so color: argument might need check
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '${method.type} ending in ${method.last4}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const Text(
                                  'CAD',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    AppStrings.edit.tr,
                                    style: const TextStyle(
                                      color: Color(0xFF6A9B5D), // Green
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24), // Increased spacing
                                GestureDetector(
                                  onTap: () =>
                                      controller.removePaymentMethod(method.id),
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
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () {
                Get.to(() => const AddBillingView());
              },
              child: Row(
                children: [
                  const Icon(Icons.add, color: Color(0xFF6A9B5D), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.addBillingMethod.tr,
                    style: const TextStyle(
                      color: Color(0xFF6A9B5D),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
