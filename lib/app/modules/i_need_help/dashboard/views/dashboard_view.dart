import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../message/views/message_list_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/dashboard_controller.dart';
import '../../home/views/home_view.dart';
import '../../order/views/order_view.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => IndexedStack(
          index: controller.tabIndex.value,
          children: [
            const HomeView(key: PageStorageKey('Home')),
            const OrderView(key: PageStorageKey('Order')),
            const MessageListView(key: PageStorageKey('Message')),
            const ProfileView(key: PageStorageKey('Profile')),
          ],
        ),
      ),
      // Wrap the Nav Bar to take absolute control of the bottom space
      bottomNavigationBar: Container(
        color: Colors.white, // Guarantees the background bleeds to the absolute bottom edge
        child: SafeArea(
          bottom: true, // Ensures clickable icons stay above the OS home indicator/notch
          child: Obx(
                () => BottomNavigationBar(
              elevation: 0, // Removes the default shadow which can cause visual gaps
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
                _buildNavItem(AppImages.order, AppStrings.order.tr),
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