import 'package:get/get.dart';
import '../../../i_need_help/profile/controllers/profile_controller.dart';
import '../controllers/worker_dashboard_controller.dart';
import '../../home/controllers/worker_home_controller.dart';
import '../../my_job/controllers/my_job_controller.dart';
import '../../../message/controllers/message_controller.dart';
import '../../profile/controllers/worker_profile_controller.dart';

class WorkerDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WorkerDashboardController>(() => WorkerDashboardController(), fenix: true);
    Get.lazyPut<WorkerHomeController>(() => WorkerHomeController(), fenix: true);
    Get.lazyPut<MyJobController>(() => MyJobController(), fenix: true);
    Get.lazyPut<MessageController>(() => MessageController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<WorkerProfileController>(() => WorkerProfileController(), fenix: true);
  }
}
