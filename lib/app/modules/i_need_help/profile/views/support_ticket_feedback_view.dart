import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_images.dart';

class SupportTicketFeedbackView extends StatelessWidget {
  const SupportTicketFeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 24),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          "Support Ticket Feedback",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                // Initial Ticket Submission Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9FBF9), // Very light greenish/grey tint
                    border: Border.all(color: const Color(0xFFE5E5E5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Header
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
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Alex Smith",
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Text(
                                  "Today, 11:40 AM",
                                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF4E5), // Light Orange
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Pending",
                              style: TextStyle(color: Color(0xFFFF9500), fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Subject & Order
                      const Text(
                        "Subject: Payment failed during checkout",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Order: Assemble an IKEA Desk",
                        style: TextStyle(color: Color(0xFF6CA34D), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      
                      // Description/Message
                      const Text(
                        "Hi, I tried to pay for the IKEA desk assembly order, but the app crashed and now I can't proceed. Could you please check this issue? I have attached the screenshot of the error.",
                        style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.4),
                      ),
                      const SizedBox(height: 16),
                      
                      // Attachment File
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.image_outlined, color: Colors.blue, size: 24),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Text(
                                "error_screenshot.jpg",
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.remove_red_eye_outlined, color: Color(0xFF6CA34D), size: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Divider indicating response area
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    children: [
                      Expanded(child: Divider(color: Color(0xFFE5E5E5), thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "Support Responses",
                          style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(child: Divider(color: Color(0xFFE5E5E5), thickness: 1)),
                    ],
                  ),
                ),
                _buildMessageRow(
                  isAdmin: true,
                  name: "Admin",
                  time: "11:46",
                  text: "That's awesome. I think our users will really appreciate the improvements.",
                  hasAttachment: true,
                ),
                const SizedBox(height: 24),
                _buildMessageRow(
                  isAdmin: false,
                  name: "Justine",
                  time: "11:46",
                  text: "That's awesome. I think our users will really appreciate the improvements.",
                  hasAttachment: true,
                ),
              ],
            ),
          ),
          _buildBottomInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageRow({
    required bool isAdmin,
    required String name,
    required String time,
    required String text,
    bool hasAttachment = false,
  }) {
    final bubble = Container(
      constraints: BoxConstraints(maxWidth: Get.width * 0.75),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7), // Light grey background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: isAdmin ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          // Header: Avatar, Name, Time
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: Image.asset(
                  AppImages.alexSmith, // Mock avatar
                  width: 24,
                  height: 24,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Message Text
          Text(
            text,
            style: const TextStyle(color: Colors.black87, fontSize: 14, height: 1.4),
            textAlign: isAdmin ? TextAlign.left : TextAlign.right,
          ),
          // Attachment Box
          if (hasAttachment) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.picture_as_pdf, color: Colors.black54, size: 20),
                  Spacer(),
                  Icon(Icons.download, color: Color(0xFF6CA34D), size: 20), // Green download icon
                ],
              ),
            ),
          ]
        ],
      ),
    );

    final moreIcon = const Icon(Icons.more_vert, color: Colors.black54, size: 20);

    return Row(
      mainAxisAlignment: isAdmin ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!isAdmin) moreIcon,
        if (!isAdmin) const SizedBox(width: 8),
        Flexible(child: bubble),
        if (isAdmin) const SizedBox(width: 8),
        if (isAdmin) moreIcon,
      ],
    );
  }

  Widget _buildBottomInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12).copyWith(bottom: 24), // SafeArea bottom spacing
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          const Icon(Icons.add, color: Color(0xFF6CA34D), size: 28), // Green plus
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Write message",
                  hintStyle: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.send_outlined, color: Color(0xFF535763), size: 24),
        ],
      ),
    );
  }
}
