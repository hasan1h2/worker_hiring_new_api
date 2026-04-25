import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/support_ticket_controller.dart';

import '../../../../core/constants/app_images.dart';
import 'support_ticket_feedback_view.dart';

class SupportTicketHistoryView extends GetView<SupportTicketController> {
  const SupportTicketHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SupportTicketController());
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 24),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.ticketHistory.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.ticketHistory.isEmpty) {
          return const Center(child: Text('No ticket history found.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.ticketHistory.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final ticket = controller.ticketHistory[index];

            return GestureDetector(
              onTap: () => Get.to(() => const SupportTicketFeedbackView()),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Header & Status
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            AppImages.alexSmith, // Mock user avatar
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Alex Smith",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                ticket['date'] ?? "Today, 11:40 AM",
                                style: const TextStyle(
                                  color: Color(0xFF9E9E9E),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: ticket['status'] == 'Pending'
                                ? const Color(0xFFFFF4E5)
                                : const Color(0xFFE8F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            ticket['status'] ?? "Pending",
                            style: TextStyle(
                              color: ticket['status'] == 'Pending'
                                  ? const Color(0xFFFF9500)
                                  : const Color(0xFF4CAF50),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Subject & Order
                    Text(
                      "Subject: ${ticket['subject'] ?? 'Issue with order'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      "Order: Assemble an IKEA Desk", // Can be dynamic if added to dummy data
                      style: TextStyle(
                        color: Color(0xFF6CA34D),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Description/Message
                    const Text(
                      "Hi, I tried to pay for the IKEA desk assembly order, but the app crashed and now I can't proceed. Could you please check this issue? I have attached the screenshot of the error.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),

                    // Attachment File
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E5E5)),
                        borderRadius: BorderRadius.circular(8),
                        color: const Color(0xFFF9FBF9),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.image_outlined,
                            color: Colors.blue,
                            size: 24,
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              "error_screenshot.jpg",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(
                            Icons.remove_red_eye_outlined,
                            color: Color(0xFF6CA34D),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
