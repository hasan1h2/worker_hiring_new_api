import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_pages.dart';

class ServiceModel {
  final String icon;
  final String label;

  ServiceModel({required this.icon, required this.label});
}

class ServiceSelectionController extends GetxController {
  final _storage = GetStorage();

  final List<ServiceModel> services = [
    ServiceModel(
      icon: AppImages.furnitureAssembly,
      label: AppStrings.furnitureAssembly,
    ),
    ServiceModel(
      icon: AppImages.homeAssistance,
      label: AppStrings.homeAssistance,
    ),
    ServiceModel(icon: AppImages.minorRepairs, label: AppStrings.minorRepairs),
    ServiceModel(icon: AppImages.petServices, label: AppStrings.petServices),
    ServiceModel(
      icon: AppImages.companionService,
      label: AppStrings.companionService,
    ),
    ServiceModel(
      icon: AppImages.marketingPromotion,
      label: AppStrings.marketingPromotion,
    ),
    ServiceModel(icon: AppImages.lockSmith, label: AppStrings.lockSmith),
  ];

  final RxList<String> selectedServices = <String>[].obs;

  void toggleService(String label) {
    if (selectedServices.contains(label)) {
      selectedServices.remove(label);
    } else {
      selectedServices.add(label);
    }
  }

  void onDone() {
    // Only navigate if at least one category is selected
    if (selectedServices.isEmpty) {
      // Do nothing if no categories selected
      return;
    }

    // Store selected services
    _storage.write('selectedServices', selectedServices.toList());

    // Navigate to Home (Dashboard) and clear previous stack to prevent back navigation to setup
    Get.offAllNamed(Routes.MAIN);
  }

  void onSkip() {
    // Navigate to Home (Dashboard) and clear previous stack
    Get.offAllNamed(Routes.MAIN);
  }
}
