import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'verification_controller.dart';

class VerificationView extends GetView<VerificationController> {
  const VerificationView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(VerificationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Provider Verification', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.grey[50],
      body: Obx(() {
        if (controller.isLoading.value && controller.verificationData.value == null) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
          );
        }

        final status = controller.verificationData.value?.status;
        final isVerified = controller.verificationData.value?.isVerified ?? false;

        if (status == 'APPROVED' || isVerified) {
          return _buildSuccessScreen();
        } else if (status == 'REVIEW') {
          return _buildPendingScreen();
        } else {
          // Status is null or 'REJECTED'
          return _buildSubmissionForm();
        }
      }),
    );
  }

  Widget _buildSuccessScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 100),
            SizedBox(height: 24),
            Text(
              'You are verified!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Your documents have been approved. You can now access all provider features.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.access_time_filled, color: Colors.orangeAccent, size: 100),
            SizedBox(height: 24),
            Text(
              'Under Review',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              'Your documents are currently under review. This usually takes 1-2 business days. We will notify you once the process is complete.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmissionForm() {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.verificationData.value?.status == 'REJECTED')
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Your previous submission was rejected. Please upload valid documents.',
                          style: TextStyle(color: Colors.red.shade800),
                        ),
                      ),
                    ],
                  ),
                ),

              const Text(
                'Submit Documents',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please provide valid identification to verify your provider account.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              const Text(
                'Document Type',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedDocType.value,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        controller.selectedDocType.value = newValue;
                      }
                    },
                    items: controller.documentTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Upload Images',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              
              InkWell(
                onTap: () => controller.pickImages(),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 12),
                      const Text(
                        'Tap to select images',
                        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'JPG, PNG (Max 5MB)',
                        style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              if (controller.selectedFiles.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: controller.selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = controller.selectedFiles[index];
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            file,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: InkWell(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.close, color: Colors.white, size: 12),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),

              const SizedBox(height: 40),
              
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.submitDocuments(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50), // Green Primary Button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Submit Documents',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
        if (controller.isLoading.value)
          Container(
            color: Colors.black.withOpacity(0.1),
            child: const Center(
              child: CircularProgressIndicator(color: Color(0xFF4CAF50)),
            ),
          ),
      ],
    );
  }
}
