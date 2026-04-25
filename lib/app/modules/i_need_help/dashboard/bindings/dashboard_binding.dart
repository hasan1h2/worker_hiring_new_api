import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../create_task/controllers/create_task_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../order/controllers/order_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<CreateTaskController>(() => CreateTaskController(), fenix: true);
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);
    Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
  }
}
