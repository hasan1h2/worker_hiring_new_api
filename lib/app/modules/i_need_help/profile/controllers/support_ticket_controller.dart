import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/app_strings.dart';

class SupportTicketController extends GetxController {
  // Reactive boolean state for the Terms and Privacy checkbox
  final RxBool isTermsAccepted = false.obs;

  void toggleTermsAccepted() {
    isTermsAccepted.value = !isTermsAccepted.value;
  }

  // Ticket History
  final RxList<Map<String, dynamic>> ticketHistory = <Map<String, dynamic>>[
    {
      'id': '#1023',
      'subject': 'Payment failed',
      'status': 'Pending',
      'date': '12 Jan, 2026'
    },
    {
      'id': '#0982',
      'subject': 'App crash on map',
      'status': 'Resolved',
      'date': '05 Jan, 2026'
    },
  ].obs;

  // Selected order state
  final RxString selectedOrder = ''.obs;
  final List<String> pastOrders = [
    'Order #101 - IKEA Desk',
    'Order #102 - TV Mounting',
    'Order #103 - Plumbing Repair'
  ];

  void selectOrder(String order) {
    selectedOrder.value = order;
    Get.back();
  }

  // Attachment state
  final RxString attachedFileName = ''.obs;
  final RxString attachedFilePath = ''.obs;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null) {
        attachedFileName.value = image.name;
        attachedFilePath.value = image.path;
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> pickDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        attachedFileName.value = result.files.single.name;
        attachedFilePath.value = result.files.single.path ?? '';
        if (Get.isBottomSheetOpen ?? false) {
          Get.back();
        }
      }
    } catch (e) {
      debugPrint('Error picking document: $e');
    }
  }

  void showAttachmentOptions() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.black87),
              title: Text(AppStrings.camera.tr),
              onTap: () => pickImage(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.black87),
              title: Text(AppStrings.photoGallery.tr),
              onTap: () => pickImage(ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.insert_drive_file, color: Colors.black87),
              title: Text(AppStrings.document.tr),
              onTap: () => pickDocument(),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
    );
  }

  void submitTicket() {
    if (!isTermsAccepted.value) {
      Get.snackbar(
        AppStrings.attention.tr,
        AppStrings.acceptTermsWarning.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    // Implement submission logic here
    Get.back();
    Get.snackbar(
      AppStrings.success.tr,
      AppStrings.ticketSubmitted.tr,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
