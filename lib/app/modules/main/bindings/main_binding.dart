import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../i_want_to_work/dashboard/bindings/worker_dashboard_binding.dart';
import '../../i_need_help/dashboard/bindings/dashboard_binding.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController(), fenix: true);
    WorkerDashboardBinding().dependencies();
    DashboardBinding().dependencies();
  }
}
