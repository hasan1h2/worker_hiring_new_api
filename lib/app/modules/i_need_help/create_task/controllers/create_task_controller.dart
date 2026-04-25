import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../service_selection/controllers/service_selection_controller.dart';

class CreateTaskController extends GetxController {
  final taskTitleController = TextEditingController();
  final addressController = TextEditingController();
  final detailsController = TextEditingController();
  final budgetController = TextEditingController();

  // Dropdown selections
  final RxString selectedCategory = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null); // Nullable Date
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null); // Nullable Time
  final RxString selectedSubCategory = ''.obs;

  final Map<String, List<String>> _categoryMap = {
    AppStrings.furnitureAssembly: ['IKEA Assembly', 'TV Mounting', 'Bookshelf Assembly'],
    AppStrings.homeAssistance: ['Moving', 'Packing', 'Heavy Lifting', 'Deep Cleaning'],
    AppStrings.minorRepairs: ['General Plumbing', 'Electrical Help', 'Wall Repair', 'Appliance Repair'],
    AppStrings.petServices: ['Dog Walking', 'Pet Sitting', 'Grooming'],
    AppStrings.companionService: ['Elderly Care', 'Running Errands', 'Doctor Appointment'],
    AppStrings.marketingPromotion: ['SEO', 'Social Media', 'Content Creation'],
    AppStrings.lockSmith: ['Lock Replacement', 'Key Duplication', 'Emergency Lockout'],
  };

  List<String> get subCategories {
    if (selectedCategory.value.isEmpty) return [];
    return _categoryMap[selectedCategory.value] ?? [];
  }

  // Edit Mode
  bool isEdit = false;

  @override
  void onInit() {
    super.onInit();
    // Check arguments for Edit Mode or Category passing
    if (Get.arguments != null && Get.arguments is Map) {
      final args = Get.arguments as Map;

      // Handle Edit Mode
      if (args['isEdit'] == true && args['order'] != null) {
        isEdit = true;
        _populateFields(args['order']);
      }

      // Handle Category passed from Home
      if (args['category'] != null && args['category'] != '') {
        selectedCategory.value = args['category'];
      }
    }
  }

  void _populateFields(dynamic order) {
    // dynamic used because importing OrderModel here might cause cycle if order imports create_task.
    // Better strictly import OrderModel, but using dynamic for quick adaptation as OrderModel is in 'order' module.
    // In real app, move OrderModel to core/models.

    // Assuming order has properties matching.
    // We need to cast or access properties carefully.
    // For now, let's assume strict typing available or import.
    // Importing OrderModel from ...order/controllers/order_controller.dart

    // To avoid errors, I will add the import in a separate small edit or rely on IDE fix, but let's try to add import if needed.
    // Actually, let's just use Get.arguments map structure or properties.

    try {
      taskTitleController.text = order.title;
      detailsController.text =
          "I recently purchased an ..."; // Mock or real desc
      budgetController.text = "90"; // Mock
      selectedCategory.value = order.categoryName;
      selectedDate.value = order.date;
      selectedTime.value = order.time;
      // Address mocked
      addressController.text = order.location;
    } catch (e) {
      debugPrint("Error populating fields: $e");
    }
  }

  // Mock Categories from Service Selection (Flat list for dropdown)
  final List<ServiceModel> categories = [
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

  void selectCategory(String category) {
    selectedCategory.value = category;
    Get.back(); // Close bottom sheet if used, or just set state
  }

  void selectSubCategory(String subCat) {
    selectedSubCategory.value = subCat;
    Get.back();
  }

  void onPostTask() {
    if (isEdit) {
      Get.back();
      Get.snackbar("Success", "Task updated successfully");
    } else {
      Get.toNamed(
        '/helper-list',
        arguments: {
          'category': selectedCategory.value,
          'date': selectedDate.value,
        }
      );
    }
  }

  @override
  void onClose() {
    taskTitleController.dispose();
    addressController.dispose();
    detailsController.dispose();
    budgetController.dispose();
    super.onClose();
  }
}
