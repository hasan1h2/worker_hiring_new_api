import 'package:get/get.dart';
import '../controllers/worker_account_verification_controller.dart';

class WorkerAccountVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkerAccountVerificationController>(
      () => WorkerAccountVerificationController(),
    );
  }
}
