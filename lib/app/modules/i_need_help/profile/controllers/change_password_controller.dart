import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  var obscureCurrent = true.obs;
  var obscureNew = true.obs;
  var obscureConfirm = true.obs;

  void toggleCurrent() => obscureCurrent.value = !obscureCurrent.value;
  void toggleNew() => obscureNew.value = !obscureNew.value;
  void toggleConfirm() => obscureConfirm.value = !obscureConfirm.value;

  void changePassword() {
    Get.back();
    Get.snackbar("Success", "Password changed successfully");
  }
}
