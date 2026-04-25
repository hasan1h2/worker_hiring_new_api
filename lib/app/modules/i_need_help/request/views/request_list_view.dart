import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../controllers/request_controller.dart';
import 'request_detail_view.dart';

class RequestListView extends GetView<RequestController> {
  const RequestListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(RequestController()); // Ensure controller is ready

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: AppStrings.requestTitle.tr),
      body: Obx(() {
        if (controller.candidates.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volunteer_activism_outlined,
                    size: 64, color: const Color(0xFF6CA34D).withOpacity(0.5)),
                const SizedBox(height: 16),
                Text(
                  AppStrings.beFirstToHelp.tr,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.noRequestsRightNow.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.candidates.length,
          separatorBuilder: (c, i) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final tasker = controller.candidates[index];
            return Container(
              padding: EdgeInsets.only(top: 2, left: 16, bottom: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                // Design seems to have them as cards or just list items separated. Assume clean list.
                // Shadow or border? Design screenshot shows clean items.
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Assemble an IKEA Desk",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: AssetImage(tasker.avatar),
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
                                  tasker.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  tasker.timeAgo,
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  "${tasker.rating}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                Text(
                                  " (${tasker.completedTasks} ${AppStrings.tasks.tr})",
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                    size: 14, color: Color(0xFFFF3B30)),
                                const SizedBox(width: 4),
                                const Expanded(
                                  child: Text(
                                    "San Francisco CA • 1.8 km away",
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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

                  Row(
                    children: [
                      // Icon for date/time - mock same as order usually or just generic
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 14,
                        color: AppColors.textSecondary,
                      ), // generic
                      const SizedBox(width: 4),
                      const Text(
                        "12 Jan, 2026",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "10:00 AM",
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        tasker.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    tasker.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () =>
                        Get.to(() => RequestDetailView(tasker: tasker)),
                    child: Text(
                      AppStrings.seeMore.tr,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => controller.onMessage(tasker),
                          style: OutlinedButton.styleFrom(
                            side:
                                const BorderSide(color: AppColors.textPrimary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            AppStrings.message
                                .tr, // Ensure 'message' key exists
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => controller.onAccept(tasker),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text(
                            AppStrings.accept.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
