import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../controllers/home_controller.dart';

class HomeBanner extends GetView<HomeController> {
  const HomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          height: 160,
          margin: const EdgeInsets.all(20),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.blueGrey.shade100,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: PageView.builder(
              controller: controller.bannerPageController,
              onPageChanged: controller.onBannerPageChanged,
              itemCount: controller.bannerImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      controller.bannerImages[index],
                      fit: BoxFit.cover, // Ensures the banner area is fully filled
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withAlpha(200),
                            Colors.black.withAlpha(0),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.letLocal.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            AppStrings.expertsHelp.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            AppStrings.you.tr,
                            style: const TextStyle(
                              color: Color(0xFF6CA34D),
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        Obx(() {
          int currentIndex = controller.currentBannerIndex.value;
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.bannerImages.length,
                  (index) => AnimatedContainer( // Smoothly animates the width change
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                height: 5,
                width: currentIndex == index ? 36 : 30,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xFF6CA34D)
                      : const Color(0xFFE5E5E5), // Light grey dashes
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
