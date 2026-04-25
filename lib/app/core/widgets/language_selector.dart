import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constants/app_colors.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key, this.isHomeView = false});
  final bool isHomeView;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isHomeView ? 12 : 16, vertical: isHomeView ? 8 : 12),
      decoration: BoxDecoration(
        border: isHomeView ? null : Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(isHomeView ? 25 : 12),
        color: isHomeView ? const Color(0xFFF0F0F0) : Colors.transparent,
        boxShadow: isHomeView
            ? [
          BoxShadow(
            color: Colors.black.withAlpha(13), // ~0.05 opacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ]
            : null,
      ),
      child: InkWell(
        onTap: () {
          _showLanguageBottomSheet(context);
        },
        child: Row(
          children: [
            ClipOval(
              child: SvgPicture.asset(
                Get.locale?.languageCode == 'zh'
                    ? AppIcons.flagZh
                    : AppIcons.flagEn,
                width: isHomeView ? 16 : 24,
                height: isHomeView ? 16 : 24,
                fit: BoxFit.cover, // Ensures the flag fills the 24x24 circle
              ),
            ),
            SizedBox(width: isHomeView ? 6 : 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isHomeView
                    ? const SizedBox()
                    : Text(
                  AppStrings.selectLanguage.tr,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  Get.locale?.languageCode == 'zh'
                      ? AppStrings.chinese
                      : AppStrings.english,
                  style: TextStyle(
                    fontSize: isHomeView ? 12 : 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            isHomeView ? const SizedBox(width: 2) : const Spacer(),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final box = GetStorage();
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SafeArea(
          bottom: true,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              children: [
                ListTile(
                  leading: SvgPicture.asset(AppIcons.flagEn, width: 24),
                  title: Text(AppStrings.english),
                  onTap: () {
                    Get.updateLocale(const Locale('en', 'US'));
                    box.write('lang', 'en');
                    Get.back();
                  },
                ),
                ListTile(
                  leading: SvgPicture.asset(AppIcons.flagZh, width: 24),
                  title: const Text('${AppStrings.chinese} (Simplified)'),
                  onTap: () {
                    Get.updateLocale(const Locale('zh', 'CN'));
                    box.write('lang', 'zh');
                    Get.back();
                  },
                ),
              ],
            ), // Closes Wrap
          ), // Closes Padding
        ), // Closes SafeArea
      ), // Closes Container
    ); // Closes Get.bottomSheet
  }
}