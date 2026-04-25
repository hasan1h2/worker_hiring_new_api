import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app/core/constants/app_strings.dart';
import 'app/core/theme/app_theme.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  // runApp(const MyApp());
  runApp(
    DevicePreview(enabled: !kReleaseMode, builder: (context) => const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Worker Hiring App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      translations: AppStrings(),
      locale: GetStorage().read('lang') == 'zh'
          ? const Locale('zh', 'CN')
          : const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,

      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
    );
  }
}
