import 'package:get/get.dart';
import '../controllers/worker_profile_controller.dart';
import '../helper_profile_controller.dart';

class WorkerProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HelperProfileController>(() => HelperProfileController());
    Get.lazyPut<WorkerProfileController>(() => WorkerProfileController());
  }
}
