import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../controllers/message_controller.dart';
import 'chat_view.dart';

class MessageListView extends GetView<MessageController> {
  const MessageListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MessageController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Disables the back arrow
        title: const Text(
          "Message", // Fallback, could utilize AppStrings if available
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        itemCount: controller.chats.length,
        separatorBuilder: (c, i) => const Divider(
          height: 1,
          color: Color(0xFFF0F0F0),
        ),
        itemBuilder: (context, index) {
          final chat = controller.chats[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 16, // Inset side padding
            ),
            onTap: () => Get.to(() => ChatView(chat: chat)),
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: 28, // Matches the larger visual weight
                  backgroundImage: AssetImage(chat.avatar),
                ),
                Positioned(
                  right: 0,
                  bottom: 2, // Slight offset for perfect nesting
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFF007AFF), // Verification Blue
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 10,
                      color: Colors.white,
                      weight: 700,
                    ),
                  ),
                ),
              ],
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic, // Ensures '8h' and Name align text baselines
              children: [
                Text(
                  chat.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                Text(
                  chat.timeAgo, // Ex: "8h"
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                chat.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.black, // Darken preview text
                  fontWeight: FontWeight.w600, // Thicken preview text
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
