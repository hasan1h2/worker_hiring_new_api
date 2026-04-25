import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../core/constants/app_strings.dart';

class MainController extends GetxController {
  final _storage = GetStorage();

  // Observable variable to track the active phase (1: I Need Help, 2: I Want to Work)
  // Using RxInt allows GetX to reactively update the UI when value changes
  final RxInt activePhase = 1.obs;

  @override
  void onInit() {
    super.onInit();
    final savedRole = _storage.read('userRole');
    if (savedRole == AppStrings.iWantToWork) {
      activePhase.value = 2;
    } else {
      activePhase.value = 1;
    }
  }

  // Function to switch between phases
  void changePhase(int phaseIndex) {
    if (activePhase.value == phaseIndex) return; // redundant check for safety
    activePhase.value = phaseIndex;
    if (phaseIndex == 1) {
      _storage.write('userRole', AppStrings.iNeedHelp);
    } else if (phaseIndex == 2) {
      _storage.write('userRole', AppStrings.iWantToWork);
    }
  }
}
