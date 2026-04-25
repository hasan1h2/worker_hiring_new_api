import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../controllers/my_job_controller.dart';

class JobOtpVerificationView extends StatefulWidget {
  final Map<String, dynamic> job;
  const JobOtpVerificationView({super.key, required this.job});

  @override
  State<JobOtpVerificationView> createState() => _JobOtpVerificationViewState();
}

class _JobOtpVerificationViewState extends State<JobOtpVerificationView> {
  final MyJobController controller = Get.find<MyJobController>();
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _otp => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: const Text(
          'Verify Job Completion',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Please enter the OTP provided by the client to mark this job as completed.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 56,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    onChanged: (value) => _onOtpChanged(value, index),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    decoration: InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.zero,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Center(
              child: TextButton(
                onPressed: () {
                  Get.snackbar('OTP Sent', 'A fresh OTP has been sent to the client.',
                      backgroundColor: Colors.blue.shade100, colorText: Colors.blue.shade900);
                },
                child: const Text(
                  'Send OTP to Client',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Verify & Complete Job',
              onPressed: () {
                if (_otp.length < 6) {
                  Get.snackbar('Error', 'Please enter a valid 6-digit OTP',
                      backgroundColor: Colors.redAccent, colorText: Colors.white);
                  return;
                }
                controller.verifyJobCompletionWithOtp(widget.job, _otp);
              },
              height: 50,
              backgroundColor: const Color(0xFF589C3E),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
