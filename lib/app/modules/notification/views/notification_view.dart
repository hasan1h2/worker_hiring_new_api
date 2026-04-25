import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../message/controllers/message_controller.dart';
import '../../message/views/chat_view.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data
    final List<Map<String, dynamic>> notifications = [
      {
        'id': 101,
        'type': 'system_strike',
        'icon': Icons.warning_amber_rounded,
        'text': AppStrings.strikeLateCancellation.tr,
        'time': '5${AppStrings.timeMinutesAgo.tr}',
        'isRead': false,
      },
      {
        'id': 102,
        'type': 'system_warning',
        'icon': Icons.report_problem_outlined,
        'text': AppStrings.visibilityAffected.tr,
        'time': '5${AppStrings.timeMinutesAgo.tr}',
        'isRead': false,
      },
      {
        'id': 1,
        'user': 'Justin leo',
        'avatar': AppImages.alexSmith, // Placeholder for Justin
        'type': 'request_accepted',
        'text': AppStrings.notificationRequest.trParams({
          'user': 'Justin leo',
          'task': AppStrings.furnitureAssembly.tr,
        }),
        'time': '1${AppStrings.timeHoursAgo.tr}',
        'isRead': false,
      },
      {
        'id': 2,
        'user': 'Justin leo',
        'avatar': AppImages.alexSmith,
        'type': 'message',
        'text': AppStrings.notificationMessage.trParams({'user': 'Justin leo'}),
        'time': '1${AppStrings.timeHoursAgo.tr}',
        'isRead': false,
      },
      {
        'id': 3,
        'type': 'system_message',
        'icon': Icons.notifications,
        'text': AppStrings.notificationMessage.trParams({'user': 'Justin leo'}),
        'time': '1${AppStrings.timeHoursAgo.tr}',
        'isRead': true,
      },
      {
        'id': 4,
        'user': 'Michael Brown',
        'avatar': AppImages.michael,
        'type': 'request',
        'text': AppStrings.notificationRequest.trParams({
          'user': 'Michael Brown',
          'task': AppStrings.furnitureAssembly.tr,
        }),
        'time': '1${AppStrings.timeHoursAgo.tr}',
        'isRead': true,
      },
      {
        'id': 5,
        'type': 'system_completed',
        'icon': Icons.check_circle_outline,
        'text': AppStrings.notificationCompleted.trParams({
          'task': AppStrings.furnitureAssembly.tr,
        }),
        'time': '20${AppStrings.timeMinutesAgo.tr}',
        'isRead': true,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.notification.tr),
      body: ListView.separated(
        itemCount: notifications.length,
        separatorBuilder: (c, i) =>
            const Divider(height: 1, color: AppColors.border),
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final isSystem = (notif['type'] as String).startsWith('system');

          return InkWell(
            onTap: () {
              // Navigate to ChatView if it's a message or request notification
              if (notif.containsKey('user')) {
                // Create a mock ChatModel for navigation
                final chat = ChatModel(
                  name: notif['user'],
                  avatar: notif['avatar'] ?? AppImages.alexSmith,
                  lastMessage: '',
                  timeAgo: notif['time'],
                  isOnline: true,
                  messages: [], // Empty messages for now
                );
                Get.to(() => ChatView(chat: chat));
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              color: (notif['isRead'] == false) ? Colors.white : Colors.white,
              // Kept white as per design cleanliness, previously considering gray for read but design looks all white.
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSystem)
                    CircleAvatar(
                      backgroundColor: const Color(0xFF333333),
                      radius: 24,
                      child: Icon(notif['icon'], color: Colors.white, size: 24),
                    )
                  else
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(notif['avatar']),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textPrimary,
                              height: 1.4,
                            ),
                            children: [
                              // We need to bold the username. The text string from AppStrings might be:
                              // "@user accepted your..."
                              // We used trParams, so the string is already interpolated.
                              // To bold just the name, we would need to parse the string or build it manually here.
                              // For simplicity and robustness with translation, we'll bold the first part if it matches user.
                              // But 'text' is already the full string.
                              // Let's just make the whole text normal for now, or bold the User name if we can split it.
                              // The design shows "Justin leo" in bold.
                              // Since we have the separate 'user' field, we can try to reconstruct for specific types.
                              if (!isSystem && notif.containsKey('user')) ...[
                                TextSpan(
                                  text: "${notif['user']} ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // We need the REST of the text.
                                // But notif['text'] is the FULL text.
                                // Hack: We can remove the username from the start of notif['text'] if it exists there.
                                // Or just display the full text for now.
                                // Let's stick to displaying full text to avoid string manipulation errors.
                                // Wait, if I display notif['text'], it includes the name.
                                // So I shouldn't prepend the name again.
                                TextSpan(
                                  text: notif['text'].toString().replaceFirst(
                                    notif['user'],
                                    '',
                                  ),
                                ),
                              ] else
                                TextSpan(text: notif['text']),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    notif['time'],
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
