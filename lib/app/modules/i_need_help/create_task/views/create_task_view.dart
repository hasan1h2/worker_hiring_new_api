import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../../main/controllers/main_controller.dart';
import '../controllers/create_task_controller.dart';
import '../widgets/location_picker_dialog.dart';
import '../../../../core/constants/app_strings.dart';


class CreateTaskView extends GetView<CreateTaskController> {
  const CreateTaskView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const SizedBox(), // Hide default back to align X
        title: const Text(
          "Find Helpers",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9), // Very light green
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFCBEFB6)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.security,
                          color: Color(0xFF2E7D32), size: 20),
                      const SizedBox(width: 8),
                      Text(AppStrings.securePayment.tr,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32))),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(AppStrings.paymentReleasedCompletion.tr,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black87)),
                  Text(AppStrings.beSpecificDetails.tr,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black87)),
                ],
              ),
            ),
            _buildLabel("Category"),
            const SizedBox(height: 8),
            _buildCategoryField(context),

            const SizedBox(height: 16),

            _buildLabel("Sub-Category"),
            const SizedBox(height: 8),
            Obx(() => _buildDropdownLikeField(
                  hint: "Choose sub-category",
                  value: controller.selectedSubCategory.value.isEmpty
                      ? null
                      : controller.selectedSubCategory.value,
                  trailingIcon: const Icon(Icons.keyboard_arrow_down,
                      color: Color(0xFF9E9E9E)),
                  onTap: () => _showSubCategorySheet(context),
                )),

            const SizedBox(height: 16),

            _buildLabel("Task title"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.taskTitleController,
              hint: "e.g. Assemble an IKEA Desk",
            ),

            const SizedBox(height: 16),

            _buildLabel("Address / Area"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.addressController,
              hint: "e.g. San Francisco CA",
              readOnly: true,
              onTap: () {
                Get.dialog(
                  LocationPickerDialog(
                    onLocationSelected: () {
                      // Simulating address selection
                      controller.addressController.text = "San Francisco CA";
                      Get.back();
                    },
                  ),
                  barrierDismissible: true,
                );
              },
              suffixIcon: const Icon(Icons.location_on, color: Colors.grey),
            ),

            if (Get.find<MainController>().activePhase.value != 2) ...[
              const SizedBox(height: 16),
              _buildLabel("Select date"),
              const SizedBox(height: 8),
              _buildDateField(context),

              const SizedBox(height: 16),
              _buildLabel("Select time"),
              const SizedBox(height: 8),
              _buildTimeField(context),
            ],

            const SizedBox(height: 16),

            _buildLabel("Details"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.detailsController,
              hint: "Describe the work",
              minLines: 5,
              maxLines: 5,
            ),

            const SizedBox(height: 16),

            _buildLabel("Budget"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.budgetController,
              hint: "80-100",
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixText: '\$ ',
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
            ),
            const SizedBox(height: 4),
            const Text(
              "+ service fee",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: Get.find<MainController>().activePhase.value == 2 ? const SizedBox.shrink() : SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: controller.onPostTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6CA34D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Find Helpers",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final int hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF535763),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int minLines = 1,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
        prefixText: prefixText,
        prefixStyle: const TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        hintStyle: const TextStyle(
          color: Color(0xFF9E9E9E),
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6CA34D)),
        ),
      ),
    );
  }

  Widget _buildDropdownLikeField({
    required String hint,
    required Widget trailingIcon,
    Widget? leadingIcon,
    VoidCallback? onTap,
    String? value,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            if (leadingIcon != null) ...[
              leadingIcon,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: Text(
                value ?? hint,
                style: TextStyle(
                  fontSize: 16,
                  color: value == null ? const Color(0xFF9E9E9E) : AppColors.textPrimary,
                ),
              ),
            ),
            trailingIcon,
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryField(BuildContext context) {
    return Obx(() {
      Widget? leadingIcon;
      String? displayValue;

      if (controller.selectedCategory.value.isNotEmpty) {
        final cat = controller.categories.firstWhere(
          (e) => e.label == controller.selectedCategory.value,
          orElse: () => controller.categories.first,
        );
        displayValue = cat.label.tr;
        leadingIcon = SvgPicture.asset(cat.icon, width: 20, height: 20);
      }

      return _buildDropdownLikeField(
        hint: "Choose category",
        value: displayValue,
        leadingIcon: leadingIcon,
        trailingIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E9E9E)),
        onTap: () => _showCategorySheet(context),
      );
    });
  }

  Widget _buildDateField(BuildContext context) {
    return Obx(() {
      String? displayValue;
      if (controller.selectedDate.value != null) {
        displayValue = DateFormat('d MMM, yyyy').format(controller.selectedDate.value!);
      }

      return _buildDropdownLikeField(
        hint: "Select date",
        value: displayValue,
        leadingIcon: SvgPicture.asset(
          AppImages.calendar,
          width: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF676767),
            BlendMode.srcIn,
          ),
        ),
        trailingIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E9E9E)),
        onTap: () async {
          final date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2030),
          );
          if (date != null) controller.selectedDate.value = date;
        },
      );
    });
  }

  Widget _buildTimeField(BuildContext context) {
    return Obx(() {
      String? displayValue;
      if (controller.selectedTime.value != null) {
        displayValue = _formatTime(controller.selectedTime.value!);
      }

      return _buildDropdownLikeField(
        hint: "Select time",
        value: displayValue,
        leadingIcon: SvgPicture.asset(
          AppImages.time,
          width: 20,
          colorFilter: const ColorFilter.mode(
            Color(0xFF676767),
            BlendMode.srcIn,
          ),
        ),
        trailingIcon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9E9E9E)),
        onTap: () async {
          final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );
          if (time != null) controller.selectedTime.value = time;
        },
      );
    });
  }

  void _showCategorySheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          shrinkWrap: true,
          children: controller.categories
              .map(
                (cat) => ListTile(
                  leading: SvgPicture.asset(cat.icon, width: 24),
                  title: Text(cat.label.tr),
                  onTap: () => controller.selectCategory(cat.label),
                ),
              )
              .toList(),
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _showSubCategorySheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView(
          shrinkWrap: true,
          children: controller.subCategories
              .map(
                (subCat) => ListTile(
                  title: Text(subCat),
                  onTap: () => controller.selectSubCategory(subCat),
                ),
              )
              .toList(),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
