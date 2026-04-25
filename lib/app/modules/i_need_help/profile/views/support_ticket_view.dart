import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/support_ticket_controller.dart';

class SupportTicketView extends StatelessWidget {
  const SupportTicketView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller here since we don't have a binding set up from profile_view.dart route yet
    final controller = Get.put(SupportTicketController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,  color: Colors.black, size: 24),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.supportTicket.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subject
            Text(
              AppStrings.subject.tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: AppStrings.nameExample.tr,
                  hintStyle: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Order
            Row(
              children: [
                Text(
                  AppStrings.orderLabel.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.info, color: Color(0xFFBDBDBD), size: 16),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _showOrderSelectionSheet(context, controller),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final isSelected =
                          controller.selectedOrder.value.isNotEmpty;
                      return Text(
                        isSelected
                            ? controller.selectedOrder.value
                            : AppStrings.selectYourOrder.tr,
                        style: TextStyle(
                            color: isSelected
                                ? Colors.black
                                : const Color(0xFF9E9E9E),
                            fontSize: 14),
                      );
                    }),
                    const Icon(Icons.keyboard_arrow_down,
                        color: Color(0xFF9E9E9E), size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Attachment
            Row(
              children: [
                Text(
                  AppStrings.attachment.tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(width: 6),
                const Icon(Icons.info, color: Color(0xFFBDBDBD), size: 16),
              ],
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: controller.showAttachmentOptions,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final isAttached =
                          controller.attachedFileName.value.isNotEmpty;
                      return Text(
                        isAttached
                            ? controller.attachedFileName.value
                            : AppStrings.addAttachment.tr,
                        style: TextStyle(
                            color: isAttached
                                ? Colors.black
                                : const Color(0xFF9E9E9E),
                            fontSize: 14),
                      );
                    }),
                    Obx(() {
                      final isAttached =
                          controller.attachedFileName.value.isNotEmpty;
                      return Icon(
                        isAttached ? Icons.check_circle : Icons.attach_file,
                        color: isAttached
                            ? const Color(0xFF32C759)
                            : const Color(0xFF9E9E9E),
                        size: 20,
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Your message
            Text(
              AppStrings.yourMessage.tr,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: controller.toggleTermsAccepted,
                    behavior: HitTestBehavior
                        .opaque, // Ensures the entire bounding box is tappable even if empty
                    child: Obx(() {
                      return Container(
                        margin: const EdgeInsets.only(top: 2, right: 12),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: controller.isTermsAccepted.value
                                ? const Color(0xFF32C759)
                                : const Color(0xFFE5E5E5),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          color: controller.isTermsAccepted.value
                              ? const Color(0xFF32C759)
                              : Colors.transparent,
                        ),
                        child: controller.isTermsAccepted.value
                            ? const Icon(Icons.check,
                                size: 14, color: Colors.white)
                            : null,
                      );
                    }),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          color: Color(0xFF9E9E9E), // Light grey text
                          fontSize: 12,
                          height: 1.5,
                        ),
                        children: [
                          TextSpan(text: AppStrings.termsConfirmText1.tr),
                          TextSpan(
                            text: AppStrings.termsOfService.tr,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          TextSpan(text: AppStrings.termsConfirmText2.tr),
                          TextSpan(
                            text: AppStrings.privacyStatement.tr,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.submitTicket,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6CA34D),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.submitTicket.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderSelectionSheet(
      BuildContext context, SupportTicketController controller) {
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          shrinkWrap: true,
          children: controller.pastOrders
              .map(
                (order) => ListTile(
                  title: Text(order),
                  onTap: () => controller.selectOrder(order),
                ),
              )
              .toList(),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
