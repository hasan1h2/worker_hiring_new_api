import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';

import '../../../../core/widgets/contextual_warning_banner.dart';
import '../../order/controllers/order_controller.dart';
import 'payment_success_view.dart';

import 'package:worker_hiring/app/modules/message/controllers/message_controller.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if an order was passed
    final dynamic args = Get.arguments;
    String amount = r"$90"; // Default fallback
    bool cameFromChat = false;

    if (args != null) {
      if (args is OrderModel) {
        amount = args.priceRange;
        if (args.title == "Negotiated Task") cameFromChat = true;
      } else if (args is Map && args.containsKey('message')) {
        cameFromChat = true;
        final msg = args['message'] as MessageModel;
        final total = msg.proposedBudget ?? msg.budget ?? 0.0;
        amount = "\$${total.toStringAsFixed(2)}";
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(icons: Icons.close, title: AppStrings.pay.tr),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () async {
              if (cameFromChat) {
                final result = await Get.to(() => const PaymentSuccessView(cameFromChat: true));
                if (result == true) {
                  Get.back(result: true);
                }
              } else {
                Get.to(() => const PaymentSuccessView());
              }
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF6CA34D),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: Text(
              "${AppStrings.pay.tr} $amount",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContextualWarningBanner(
              message: AppStrings.paymentBanner.tr,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Enter Amount
                  Text(
                    AppStrings.enterAmount.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              const SizedBox(height: 8),

              // Amount Value
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 60),

              // Payment Method
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppStrings.paymentMethod.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Visa Card Item
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.visa,
                      height: 20, // adjust width/height for visa aspect ratio
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Visa ending in 9380",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      AppStrings.change.tr,
                      style: const TextStyle(
                        color: Color(0xFF6CA34D),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: Color(0xFF6CA34D),
                      ),
                    ),
                  ],
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
