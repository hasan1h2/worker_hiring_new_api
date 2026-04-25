import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    // Guard against rogue initialization from Get.offAllNamed root reconstruction
    if (Get.currentRoute == Routes.SPLASH) {
      if (_storage.hasData('userRole')) {
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.offAllNamed(Routes.ONBOARDING);
      }
    }
  }
}
