import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/contextual_warning_banner.dart';

class TaskDetailSheet extends StatelessWidget {
  final Map<String, dynamic> job;

  const TaskDetailSheet({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    String bannerMsg;
    Color bgCol;
    Color txtCol;
    Color icnCol;
    IconData icn;

    final String status = job['status'] ?? 'Pending';

    switch (status) {
      case 'Pending':
        bannerMsg = "Please review the job details carefully before sending a request.";
        bgCol = const Color(0xFFE5F0FF); // Light Blue
        txtCol = const Color(0xFF004085); // Dark Blue Text
        icnCol = const Color(0xFF007AFF); // Blue Icon
        icn = Icons.info_outline;
        break;
      case 'Accepted':
      case 'Confirmed':
      case 'InProgress':
        bannerMsg = "Don't share the completing OTP with the client if the work is undone.";
        bgCol = const Color(0xFFFFE5E5); // Light Red/Pink
        txtCol = const Color(0xFFB30000); // Dark Red Text
        icnCol = const Color(0xFFFF3B30); // Red Icon
        icn = Icons.warning_amber_rounded;
        break;
      case 'Completed':
        bannerMsg = "Job completed successfully. Thank you for your hard work!";
        bgCol = const Color(0xFFE8FCEC); // Light Green
        txtCol = const Color(0xFF155724); // Dark Green Text
        icnCol = const Color(0xFF28A745); // Green Icon
        icn = Icons.check_circle_outline;
        break;
      default:
        bannerMsg = "Please review the job details carefully.";
        bgCol = const Color(0xFFE5F0FF);
        txtCol = const Color(0xFF004085);
        icnCol = const Color(0xFF007AFF);
        icn = Icons.info_outline;
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24),
      height: Get.height * 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(Icons.close, color: AppColors.textPrimary),
                ),
                Expanded(
                  child: Text(
                    AppStrings.viewOrder.tr,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 24),
              ],
            ),
          ),
          const SizedBox(height: 32),

          ContextualWarningBanner(
            message: bannerMsg,
            backgroundColor: bgCol,
            textColor: txtCol,
            iconColor: icnCol,
            icon: icn,
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job['title'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  // Category
                  Row(
                    children: [
                      const Icon(Icons.people_outline, size: 18, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Text(
                        job['category'],
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Posted By
                  Row(
                    children: [
                      Text(
                        AppStrings.postedBy.tr,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
                      const Icon(Icons.verified, color: Colors.blue, size: 16),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Distance
                  Row(
                    children: [
                      Text(
                        "${AppStrings.distance.tr} ",
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
                  const SizedBox(height: 10),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18, color: Colors.pinkAccent),
                      const SizedBox(width: 8),
                      Text(
                        job['location'],
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Date and Time
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: Color(0xFF6CA34D)),
                      const SizedBox(width: 8),
                      Text(
                        job['date'],
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      ),
                      const SizedBox(width: 16),
                      const Icon(Icons.access_time, size: 16, color: Color(0xFF6CA34D)),
                      const SizedBox(width: 6),
                      Text(
                        job['time'],
                        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // Price
                  const Text(
                    'Budget / Price',
                    style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${job['price']}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // Description
                  Text(
                    AppStrings.details.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "This is a detailed description of the task. I recently purchased an IKEA MICKE desk and need professional assistance with assembly. The desk is brand new and still in its original packaging. All parts, screws, and the instruction manual are included in the box.\n\nThe desk will be placed in my home office, which has enough space to work comfortably.",
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // Attached Photos
                  const Text(
                    "Attached Photos",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildPhotoPlaceholder(),
                      const SizedBox(width: 12),
                      _buildPhotoPlaceholder(),
                      const SizedBox(width: 12),
                      _buildPhotoPlaceholder(),
                    ],
                  ),
                  const Divider(height: 32, color: Color(0xFFEEEEEE)),

                  // Additional Notes
                  const Text(
                    "Additional Notes",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Icon(Icons.info_outline, size: 20, color: Colors.amber),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Please bring your own basic tools. A power drill will make the job much faster and easier.",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: const Center(
        child: Icon(
          Icons.image_outlined,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }
}
