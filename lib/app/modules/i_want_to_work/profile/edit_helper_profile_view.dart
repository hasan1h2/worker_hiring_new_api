import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'helper_profile_controller.dart';

class EditHelperProfileView extends StatefulWidget {
  const EditHelperProfileView({Key? key}) : super(key: key);

  @override
  State<EditHelperProfileView> createState() => _EditHelperProfileViewState();
}

class _EditHelperProfileViewState extends State<EditHelperProfileView> {
  final HelperProfileController controller = Get.find<HelperProfileController>();

  @override
  void initState() {
    super.initState();
    // Populate form fields with existing profile data
    controller.populateEditFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Update Information',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Modify your profile details below.',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                  
                  _buildTextField(
                    controller: controller.companyNameController,
                    label: 'Company / Individual Name',
                    hint: 'Enter your name or company',
                  ),
                  const SizedBox(height: 20),
                  
                  _buildTextField(
                    controller: controller.detailsController,
                    label: 'Profile Details / Description',
                    hint: 'Write a brief description about your services',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: controller.hourlyRateController,
                          label: 'Hourly Rate',
                          hint: 'e.g. 25.00',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: controller.minBookingHoursController,
                          label: 'Min. Hours',
                          hint: 'e.g. 2',
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  
                  _buildTextField(
                    controller: controller.serviceCategoryController,
                    label: 'Service Categories (Enter IDs separated by comma)',
                    hint: 'e.g. 1, 2, 3',
                    keyboardType: TextInputType.text,
                  ),
                  const SizedBox(height: 24),
                  
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Availability Status',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        Switch(
                          value: controller.isAvailable.value,
                          onChanged: (val) => controller.isAvailable.value = val,
                          activeColor: const Color(0xFF4CAF50),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50), // Green Primary Button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value)
              Container(
                color: Colors.white.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF4CAF50), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
