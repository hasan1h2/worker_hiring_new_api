import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper_profile_model.dart';
import 'helper_profile_provider.dart';

class HelperProfileController extends GetxController {
  final HelperProfileProvider _provider = HelperProfileProvider();
  
  Rx<HelperProfileModel?> profileData = Rx<HelperProfileModel?>(null);
  RxBool isLoading = false.obs;
  RxBool isAvailable = false.obs;

  // Controllers for Create / Edit Forms
  final companyNameController = TextEditingController();
  final hourlyRateController = TextEditingController();
  final minBookingHoursController = TextEditingController();
  final detailsController = TextEditingController();
  final serviceCategoryController = TextEditingController(); // For comma separated ints

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    companyNameController.dispose();
    hourlyRateController.dispose();
    minBookingHoursController.dispose();
    detailsController.dispose();
    serviceCategoryController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final response = await _provider.getHelperProfile();
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        
        if (decodedData['status'] == true && decodedData['data'] != null) {
           final parsedResponse = HelperProfileResponse.fromJson(decodedData);
           profileData.value = parsedResponse.data;
        } else {
           // Fallback for safety
           profileData.value = HelperProfileModel.fromJson(decodedData);
        }
      } else {
        Get.snackbar('Error', 'Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while fetching profile.');
    } finally {
      isLoading.value = false;
    }
  }

  void populateEditFields() {
    if (profileData.value != null) {
      final profile = profileData.value!;
      companyNameController.text = profile.companyName ?? '';
      
      if (profile.hourlyRate != null) {
        hourlyRateController.text = double.tryParse(profile.hourlyRate!)?.toStringAsFixed(2) ?? profile.hourlyRate!;
      } else {
        hourlyRateController.text = '';
      }
      
      if (profile.minBookingHours != null) {
        minBookingHoursController.text = double.tryParse(profile.minBookingHours!)?.toInt().toString() ?? profile.minBookingHours!;
      } else {
        minBookingHoursController.text = '';
      }
      
      detailsController.text = profile.details ?? '';
      
      isAvailable.value = profile.availabilityStatus ?? false;

      // Map the nested objects back to comma separated IDs
      if (profile.serviceCategory != null && profile.serviceCategory!.isNotEmpty) {
        serviceCategoryController.text = profile.serviceCategory!.map((e) => e.id).join(', ');
      } else {
        serviceCategoryController.text = '';
      }
    }
  }

  Future<void> createProfile() async {
    try {
      isLoading.value = true;
      
      List<int> categories = [];
      if (serviceCategoryController.text.isNotEmpty) {
        categories = serviceCategoryController.text
            .split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0)
            .where((e) => e != 0)
            .toList();
      }

      final payload = {
        "company_name": companyNameController.text,
        "hourly_rate": hourlyRateController.text,
        "min_booking_hours": int.tryParse(minBookingHoursController.text) ?? 1,
        "service_category": categories,
      };

      final response = await _provider.createHelperProfile(payload);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Profile created successfully');
        await fetchProfile(); // Refresh data
        Get.back(); // Navigate back after success
      } else {
        Get.snackbar('Error', 'Failed to create profile: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while creating profile.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      
      final payload = <String, dynamic>{};
      
      if (companyNameController.text.isNotEmpty) {
        payload['company_name'] = companyNameController.text;
      }
      if (hourlyRateController.text.isNotEmpty) {
        payload['hourly_rate'] = hourlyRateController.text;
      }
      if (minBookingHoursController.text.isNotEmpty) {
        payload['min_booking_hours'] = double.tryParse(minBookingHoursController.text);
      }
      if (detailsController.text.isNotEmpty) {
        payload['details'] = detailsController.text;
      }
      
      payload['availability_status'] = isAvailable.value;

      List<int> categories = [];
      if (serviceCategoryController.text.isNotEmpty) {
        categories = serviceCategoryController.text
            .split(',')
            .map((e) => int.tryParse(e.trim()) ?? 0)
            .where((e) => e != 0)
            .toList();
        payload['service_category'] = categories;
      }

      final response = await _provider.updateHelperProfile(payload);
      
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Profile updated successfully');
        await fetchProfile(); // Refresh data
        Get.back(); // Navigate back after success
      } else {
        Get.snackbar('Error', 'Failed to update profile: ${response.body}');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while updating profile.');
    } finally {
      isLoading.value = false;
    }
  }
}
