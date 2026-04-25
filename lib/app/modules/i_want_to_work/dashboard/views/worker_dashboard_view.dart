import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/worker_dashboard_controller.dart';
import '../../home/views/worker_home_view.dart';
import '../../my_job/views/my_job_view.dart';
import '../../../message/views/message_list_view.dart';
import '../../profile/views/worker_profile_view.dart';

class WorkerDashboardView extends GetView<WorkerDashboardController> {
  const WorkerDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: controller.tabIndex.value,
          children: const [
            // Added PageStorageKeys to maintain scroll states when switching tabs
            WorkerHomeView(key: PageStorageKey('WorkerHome')),
            MyJobView(key: PageStorageKey('WorkerMyJob')),
            MessageListView(key: PageStorageKey('WorkerMessage')),
            WorkerProfileView(key: PageStorageKey('WorkerProfile')),
          ],
        ),
      ),
      // Wrapped in Container and SafeArea to fix bottom spacing
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          bottom: true,
          child: Obx(
                () => BottomNavigationBar(
              elevation: 0, // Removed default shadow
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textSecondary,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              currentIndex: controller.tabIndex.value,
              onTap: controller.changeTabIndex,
              items: [
                _buildNavItem(AppImages.home, AppStrings.home.tr),
                _buildNavItem(
                  AppImages.order,
                  AppStrings.myJob.tr,
                ), // Icon reuse: order icon for My Job
                _buildNavItem(AppImages.chat, AppStrings.message.tr),
                _buildNavItem(AppImages.profile, AppStrings.profile.tr),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(String iconPath, String label) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: SvgPicture.asset(
          iconPath,
          width: 24,
          height: 24,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
      ),
      label: label,
    );
  }
}