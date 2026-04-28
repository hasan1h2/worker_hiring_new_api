import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'verification_model.dart';
import 'verification_provider.dart';

class VerificationController extends GetxController {
  final VerificationProvider _provider = VerificationProvider();
  
  Rx<VerificationModel?> verificationData = Rx<VerificationModel?>(null);
  RxBool isLoading = false.obs;
  
  RxString selectedDocType = 'NID'.obs;
  final List<String> documentTypes = ['NID', 'PASSPORT', 'DRIVING LICENSE'];
  
  RxList<File> selectedFiles = <File>[].obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    fetchStatus();
  }

  Future<void> fetchStatus() async {
    try {
      isLoading.value = true;
      final response = await _provider.getVerificationStatus();
      
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final verificationResponse = VerificationResponse.fromJson(decodedData);
        verificationData.value = verificationResponse.data;
      } else if (response.statusCode == 404) {
        verificationData.value = null;
      } else {
        Get.snackbar('Error', 'Failed to fetch status: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching verification status.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();
      if (images != null && images.isNotEmpty) {
        for (var image in images) {
          selectedFiles.add(File(image.path));
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: $e');
    }
  }

  void removeImage(int index) {
    selectedFiles.removeAt(index);
  }

  Future<void> submitDocuments() async {
    if (selectedFiles.isEmpty) {
      Get.snackbar('Error', 'Please select at least one document to upload.');
      return;
    }

    try {
      isLoading.value = true;
      final response = await _provider.submitVerificationDocuments(
        selectedDocType.value, 
        selectedFiles
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Documents submitted successfully!');
        selectedFiles.clear();
        await fetchStatus(); // Refresh the status after successful submission
      } else {
        final responseData = await response.stream.bytesToString();
        Get.snackbar('Error', 'Failed to submit documents: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while submitting documents.');
    } finally {
      isLoading.value = false;
    }
  }
}
