import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';
import '../../modules/main/controllers/main_controller.dart';
import '../../modules/i_need_help/home/controllers/home_controller.dart';
import 'language_selector.dart';

class HomeHeader extends GetView<MainController> {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [_buildLocationHeader(), _buildRoleSwitcher()]);
  }

  Widget _buildLocationHeader() {
    // Find HomeController directly for location state
    final homeController = Get.isRegistered<HomeController>() ? Get.find<HomeController>() : Get.put(HomeController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => homeController.openLocationList(),
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF7CB342),
                      size: 26,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Obx(
                                  () => Text(
                                    homeController.currentAddress.value,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down, size: 20),
                            ],
                          ),
                          Text(
                            AppStrings.addressDetail.tr,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => Get.toNamed('/notification'),
            child: Stack(
              children: [
                SvgPicture.asset(
                  AppImages.bell,
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSwitcher() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Expanded(child: _buildToggleContainer()),
          const SizedBox(width: 10),
          const SizedBox(width: 140, child: LanguageSelector(isHomeView: true)),
        ],
      ),
    );
  }

  Widget _buildToggleContainer() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Obx(
        () => Row(
          children: [
            Expanded(
              child: _buildRoleButton(
                title: AppStrings.iNeedHelp.tr,
                isActive: controller.activePhase.value == 1,
                onTap: () {
                  if (controller.activePhase.value != 1) {
                    controller.changePhase(1);
                  }
                },
              ),
            ),
            Expanded(
              child: _buildRoleButton(
                title: AppStrings.iWantToWork.tr,
                isActive: controller.activePhase.value == 2,
                onTap: () {
                  if (controller.activePhase.value != 2) {
                    controller.changePhase(2);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.textPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
