import 'package:get/get.dart';
import '../controllers/service_selection_controller.dart';

class ServiceSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ServiceSelectionController());
  }
}
