import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/mock_data/helper_mock_data.dart';
import '../../../../data/models/helper_model.dart';
import '../../../../routes/app_pages.dart';

class HelperListController extends GetxController {
  final categoryName = 'Helpers'.obs;

  final allHelpers = <HelperModel>[].obs;
  final displayedHelpers = <HelperModel>[].obs;

  final maxDistance = 50.0.obs;
  final minRating = 1.0.obs;
  final selectedCategoryFilter = 'All Categories'.obs;

  final tempMaxDistance = 50.0.obs;
  final tempMinRating = 1.0.obs;
  final tempSelectedCategoryFilter = 'All Categories'.obs;

  // সর্টিং এর ডিফল্ট ভ্যালু ফিক্স করা হয়েছে
  final selectedSort = 'Rating (High-Low)'.obs;

  // New Filter States
  final Rxn<DateTime> tempSelectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> tempSelectedTime = Rxn<TimeOfDay>();
  final tempLocation = 'San Francisco, CA'.obs;
  final tempMinBudget = 10.0.obs;
  final tempMaxBudget = 200.0.obs;
  final tempShowAvailableOnly = true.obs;

  // Real States
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();
  final location = 'San Francisco, CA'.obs;
  final minBudget = 10.0.obs;
  final maxBudget = 200.0.obs;
  final showAvailableOnly = true.obs;

  final List<String> availableCategories = [
    'All Categories',
    'Furniture assembly',
    'Home assistance',
    'Minor Repairs',
    'Pet Services',
    'Garden Cleaning',
    'Lock smith'
  ];

  final Rxn<DateTime> requestedDate = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments is Map) {
        final args = Get.arguments as Map;
        final argCategory = args['category']?.toString();
        if (argCategory != null && argCategory.isNotEmpty) {
          categoryName.value = argCategory;
          selectedCategoryFilter.value = argCategory;
          tempSelectedCategoryFilter.value = argCategory;
        }
        final argDate = args['date'];
        if (argDate != null && argDate is DateTime) {
          requestedDate.value = argDate;
        }
      } else {
        categoryName.value = Get.arguments.toString();
        selectedCategoryFilter.value = Get.arguments.toString();
        tempSelectedCategoryFilter.value = Get.arguments.toString();
      }
    }

    // Load mock data
    allHelpers.value = HelperMockData.getHelpers();
    applyFilters(isInitial: true);
  }

  void applyFilters({bool isInitial = false}) {
    if (!isInitial) {
      maxDistance.value = tempMaxDistance.value;
      minRating.value = tempMinRating.value;
      selectedCategoryFilter.value = tempSelectedCategoryFilter.value;
      selectedDate.value = tempSelectedDate.value;
      selectedTime.value = tempSelectedTime.value;
      location.value = tempLocation.value;
      minBudget.value = tempMinBudget.value;
      maxBudget.value = tempMaxBudget.value;
      showAvailableOnly.value = tempShowAvailableOnly.value;
    }

    final List<HelperModel> filteredList = allHelpers.where((helper) {
      // Condition 1: Category Filter
      bool matchesCategory = true;
      if (selectedCategoryFilter.value != 'All Categories') {
        matchesCategory = helper.category == selectedCategoryFilter.value;
      }

      if (!matchesCategory) return false;

      // Condition 2: Rating and Distance
      double distanceVal = 0.0;
      try {
        distanceVal = double.parse(helper.distance.replaceAll(RegExp(r'[^0-9.]'), ''));
      } catch (e) {
        distanceVal = 0.0; // Fail safe
      }

      double ratingVal = double.parse(helper.rating.toString());
      double minRatingVal = double.parse(minRating.value.toString());

      return ratingVal >= minRatingVal && distanceVal <= maxDistance.value;
    }).toList();

    displayedHelpers.value = filteredList;
    applySort();

    if (!isInitial) {
      Get.back(); // Close bottom sheet
    }
  }

  // সর্টিং লজিক ফিক্স করা হয়েছে (tryParse ব্যবহার করে)
  void applySort() {
    if (selectedSort.value == 'Rating (High-Low)') {
      displayedHelpers.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (selectedSort.value == 'Price (Low-High)') {
      displayedHelpers.sort((a, b) {
        double priceA = a.rating * 10;
        double priceB = b.rating * 10;
        return priceA.compareTo(priceB);
      });
    } else if (selectedSort.value == 'Distance (Nearest)') {
      displayedHelpers.sort((a, b) {
        double distA = double.tryParse(a.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
        double distB = double.tryParse(b.distance.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
        return distA.compareTo(distB);
      });
    }
    displayedHelpers.refresh();
  }

  void clearFilters() {
    maxDistance.value = 50.0;
    minRating.value = 1.0;
    selectedCategoryFilter.value = 'All Categories';
    selectedDate.value = null;
    selectedTime.value = null;
    location.value = 'San Francisco, CA';
    minBudget.value = 10.0;
    maxBudget.value = 200.0;
    showAvailableOnly.value = true;

    tempMaxDistance.value = 50.0;
    tempMinRating.value = 1.0;
    tempSelectedCategoryFilter.value = 'All Categories';
    tempSelectedDate.value = null;
    tempSelectedTime.value = null;
    tempLocation.value = 'San Francisco, CA';
    tempMinBudget.value = 10.0;
    tempMaxBudget.value = 200.0;
    tempShowAvailableOnly.value = true;

    displayedHelpers.assignAll(allHelpers);
    Get.back(); // Close bottom sheet
  }

  void navigateToProfile(HelperModel helper) {
    Get.toNamed(Routes.HELPER_PROFILE, arguments: helper);
  }
}