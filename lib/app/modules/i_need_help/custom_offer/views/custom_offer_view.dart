import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_images.dart';
import '../../create_task/widgets/location_picker_dialog.dart';
import '../controllers/custom_offer_controller.dart';

class CreateCustomOfferView extends StatelessWidget {
  const CreateCustomOfferView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inject the controller instance
    final controller = Get.put(CustomOfferController());
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const SizedBox(), 
        title: const Text(
          "Request Form",
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
            // Worker Profile Section
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                   // Avatar
                   CircleAvatar(
                     radius: 28,
                     backgroundColor: Colors.grey.shade200,
                     backgroundImage: controller.workerAvatar.isNotEmpty 
                        ? AssetImage(controller.workerAvatar) 
                        : null,
                     child: controller.workerAvatar.isEmpty
                        ? const Icon(Icons.person, color: Colors.grey)
                        : null,
                   ),
                   const SizedBox(width: 16),
                   // Name
                   Expanded(
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                          const Text(
                            "Requesting help from",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.workerName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                       ],
                     ),
                   ),
                ],
              ),
            ),

            _buildLabel("Task title"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.taskTitleController,
              hint: "e.g. Assemble an IKEA Desk",
            ),

            const SizedBox(height: 16),

            _buildLabel("Description"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.detailsController,
              hint: "Describe the work",
              minLines: 4,
              maxLines: 4,
            ),

            const SizedBox(height: 16),

            _buildLabel("Add Photos (Optional)"),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildPhotoPlaceholder(Icons.camera_alt_outlined),
                  const SizedBox(width: 12),
                  _buildPhotoPlaceholder(Icons.image_outlined),
                  const SizedBox(width: 12),
                  _buildAddPhotoButton(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildLabel("Date"),
            const SizedBox(height: 8),
            _buildDateField(context, controller),
            const SizedBox(height: 16),
            _buildLabel("Time"),
            const SizedBox(height: 8),
            _buildTimeField(context, controller),

            const SizedBox(height: 16),

            _buildLabel("Location"),
            const SizedBox(height: 8),
            _buildTextField(
              controller: controller.addressController,
              hint: "e.g. San Francisco CA",
              readOnly: true,
              onTap: () {
                Get.dialog(
                  LocationPickerDialog(
                    onLocationSelected: () {
                      controller.addressController.text = "San Francisco CA";
                      Get.back();
                    },
                  ),
                  barrierDismissible: true,
                );
              },
              suffixIcon: const Icon(Icons.location_on, color: Colors.grey),
            ),

            const SizedBox(height: 24),

            _buildLabel("Optional Budget"),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E5E5)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Your Budget",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Container(
                        width: 85,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(r"$", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF6CA34D))),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 45,
                              child: TextField(
                                controller: controller.budgetController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Obx(() => SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: const Color(0xFF6CA34D),
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: Colors.white,
                      overlayColor: const Color(0xFF6CA34D).withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: controller.budget.value,
                      min: 0,
                      max: 500,
                      onChanged: (val) => controller.updateBudget(val),
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: controller.onSendOffer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6CA34D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Send Request",
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
  }) {
    return TextField(
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        suffixIcon: suffixIcon,
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
          color: Colors.white,
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

  Widget _buildDateField(BuildContext context, CustomOfferController controller) {
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


  Widget _buildPhotoPlaceholder(IconData icon) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
      ),
      child: Icon(icon, color: Colors.grey.shade400, size: 28),
    );
  }

  Widget _buildAddPhotoButton() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF6CA34D).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF6CA34D).withOpacity(0.3), style: BorderStyle.solid),
      ),
      child: const Icon(Icons.add, color: Color(0xFF6CA34D), size: 28),
    );
  }

  Widget _buildTimeField(BuildContext context, CustomOfferController controller) {
    return Obx(() {
      String? displayValue;
      if (controller.selectedTime.value != null) {
        displayValue = controller.selectedTime.value!.format(context);
      }

      return _buildDropdownLikeField(
        hint: "Select time",
        value: displayValue,
        leadingIcon: const Icon(Icons.access_time, size: 20, color: Color(0xFF676767)),
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
}
