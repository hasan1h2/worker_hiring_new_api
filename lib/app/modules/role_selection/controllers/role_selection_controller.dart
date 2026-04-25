import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_pages.dart';

class RoleSelectionController extends GetxController {
  final _storage = GetStorage();

  void selectClientRole() {
    // Store role using AppStrings constant to match MainController
    _storage.write('userRole', AppStrings.iNeedHelp);
    // Navigate to Customer Home screen and clear previous routes
    Get.offAllNamed(Routes.MAIN);
  }

  void selectWorkerRole() {
    _storage.write('userRole', AppStrings.iWantToWork);
    // Navigate to Choose Your Service Category screen
    Get.toNamed(Routes.SERVICE_SELECTION);
  }
}
