import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../i_need_help/order/views/review_view.dart';

class MyJobCard extends StatelessWidget {
  final Map<String, dynamic> job;
  final VoidCallback onTap;
  final VoidCallback? onStartWork;
  final VoidCallback? onCompleteWork;
  final VoidCallback? onCancel;
  final VoidCallback? onProposeTime;
  final String
  status; // 'Pending', 'Accepted', 'Confirmed', 'InProgress', 'Completed'

  const MyJobCard({
    super.key,
    required this.job,
    required this.onTap,
    this.onStartWork,
    this.onCompleteWork,
    this.onCancel,
    this.onProposeTime,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'Accepted':
      case 'Confirmed':
        return const Color(0xFFF3E5F5); // Light purple/pink
      case 'InProgress':
        return const Color(0xFFFFF3E0); // Light orange mapping to Pending UI
      case 'Completed':
        return const Color(0xFFE8F5E9); // Light Green
      default:
        return const Color(0xFFFFF3E0); // Light Orange (default pending)
    }
  }

  Color _getStatusTextColor() {
    switch (status) {
      case 'Accepted':
      case 'Confirmed':
        return const Color(0xFF8E24AA); // Distinct Purple text
      case 'InProgress':
        return const Color(0xFFE65100); // Orange text
      case 'Completed':
        return const Color(0xFF4CAF50); // Green
      default:
        return const Color(0xFFFF9800); // Orange
    }
  }

  String _getStatusText() {
    switch (status) {
      case 'Accepted':
      case 'Confirmed':
        return AppStrings.confirmed.tr;
      case 'InProgress':
        return "In Progress"; // Maps "InProgress" state to "In Progress" visual badge
      case 'Completed':
        return AppStrings.completed.tr;
      default:
        return AppStrings.pending.tr;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        job['title'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusText(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getStatusTextColor(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    // Category Icon
                    const Icon(
                      Icons.people_outline,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      job['category'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      AppStrings.postedBy.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job['postedBy'] ?? AppStrings.nicolas.tr,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "${AppStrings.distance.tr} ",
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      job['distance'] ?? '1.8 km',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 18,
                              color: Colors.pinkAccent,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              job['location'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: Color(0xFF6CA34D), // Greenish from target
                            ),
                            const SizedBox(width: 8),
                            Text(
                              job['date'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Color(0xFF6CA34D),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              job['time'],
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textPrimary, 
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        '\$${job['price']}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                if (status == 'Pending' && onCancel != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onCancel ?? () {},
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Colors.redAccent),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onProposeTime ?? () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: const Color(0xFF6CA34D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Propose new time",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                if (status == 'Accepted' || status == 'Confirmed') ...[
                  const SizedBox(height: 20),
                  CustomButton(
                    text: AppStrings.startWork.tr,
                    onPressed: onStartWork ?? () {},
                    height: 45,
                    backgroundColor: const Color(0xFF589C3E),
                  ),
                ],
                if (status == 'InProgress') ...[
                  const SizedBox(height: 20),
                  CustomButton(
                    text: AppStrings.completed.tr,
                    onPressed: onCompleteWork ?? () {},
                    height: 45,
                    backgroundColor: const Color(0xFF2C5E1A), // Darker green for in-progress
                  ),
                ],
                if (status == 'Completed') ...[
                  const SizedBox(height: 20),
                  CustomButton(
                    text: AppStrings.giveAFeedback.tr,
                    onPressed: () => Get.to(() => const ReviewView(), arguments: job),
                    height: 45,
                    backgroundColor: const Color(0xFF589C3E),
                  ),
                ],
              ],
            ),
          ),
          const Divider(
            height: 1,
            color: Color(0xFFE5E5E5),
          ),
        ],
      ),
    );
  }
}
