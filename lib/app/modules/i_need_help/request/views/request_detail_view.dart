import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../controllers/request_controller.dart';

class RequestDetailView extends StatelessWidget {
  final TaskerModel tasker;
  const RequestDetailView({super.key, required this.tasker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.requestTitle.tr),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage(tasker.avatar),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tasker.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${tasker.rating}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      Text(
                        " (${tasker.completedTasks} ${AppStrings.taskCompletedCount.tr})",
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // "10 task completed" mock logic or badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "10 ${AppStrings.taskCompletedCount.tr}",
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        // Replace with Svg location pin if needed
                        padding: const EdgeInsets.only(right: 4),
                        child: SvgPicture.asset(
                          AppImages.location,
                          width: 14,
                          colorFilter: ColorFilter.mode(
                            const Color(0xFFFF3366),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      Text(
                        AppStrings.sanFranciscoCA.tr,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ), // Mock location
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                tasker.description, // Longer description
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Divider(thickness: 1, color: Color(0xFFF0F0F0)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.skills.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...tasker.skills.map(
                    (skill) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          // Using random icon for skill or generic
                          if (skill.contains("Home assistance"))
                            SvgPicture.asset(
                              AppImages.homeAssistance,
                              width: 20,
                            ),
                          if (skill.contains("Furniture"))
                            SvgPicture.asset(
                              AppImages.furnitureAssembly,
                              width: 20,
                            ),
                          if (skill.contains("Lock"))
                            SvgPicture.asset(AppImages.lockSmith, width: 20),
                          if (!skill.contains("Home") &&
                              !skill.contains("Furniture") &&
                              !skill.contains("Lock"))
                            const Icon(
                              Icons.work_outline,
                              size: 20,
                              color: AppColors.textSecondary,
                            ),

                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(thickness: 1, color: Color(0xFFF0F0F0)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.review.tr,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        // Left Side - Big Rating
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${tasker.rating}",
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                5,
                                (index) => Icon(
                                  Icons.star,
                                  color: index < tasker.rating
                                      ? Colors.amber
                                      : Colors.grey.shade300,
                                  size: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${tasker.reviews.length} ${AppStrings.reviews.tr}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        // Right Side - Progress Bars
                        Expanded(
                          child: Column(
                            children: [
                              for (int i = 5; i >= 1; i--)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10,
                                        child: Text(
                                          "$i",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          child: LinearProgressIndicator(
                                            value:
                                                tasker.ratingCounts[i] ?? 0.0,
                                            backgroundColor:
                                                Colors.grey.shade300,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                  Color
                                                >(Colors.amber),
                                            minHeight: 6,
                                          ),
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
                  const SizedBox(height: 24),
                  // Reviews List
                  ...tasker.reviews.map(
                    (review) => Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(
                                  review.reviewerAvatar,
                                ),
                                radius: 20,
                              ), // Mock
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.reviewerName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ...List.generate(
                                          5,
                                          (index) => Icon(
                                            Icons.star,
                                            color: index < review.rating
                                                ? Colors.amber
                                                : Colors.grey.shade300,
                                            size: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          review.timeAgo,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            review.comment,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      // Floating or Bottom Buttons if needed (Accept/Message not shown in Request Detail mock but assumed accessible)
      // Leaving out for now as mock focuses on Profile info. Previous screen has the buttons.
    );
  }
}
