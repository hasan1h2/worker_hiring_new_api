import 'package:get/get.dart';

import '../controllers/helper_list_controller.dart';

class HelperListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelperListController>(
      () => HelperListController(),
    );
  }
}
