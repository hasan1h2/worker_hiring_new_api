import 'package:get/get.dart';

class WorkerDashboardController extends GetxController {
  final RxInt tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      if (Get.arguments['initialIndex'] != null) {
        tabIndex.value = Get.arguments['initialIndex'];
      }
    }
  }

  void changeTabIndex(int index) {
    tabIndex.value = index;
  }
}
