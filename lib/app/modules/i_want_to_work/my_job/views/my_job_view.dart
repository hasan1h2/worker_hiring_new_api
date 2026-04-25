import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/my_job_controller.dart';
import '../widgets/my_job_card.dart';
import 'job_otp_verification_view.dart';

class MyJobView extends GetView<MyJobController> {
  const MyJobView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          toolbarHeight: 0,
          showLeading: false,
          bottom: TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            dividerHeight: 0,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: AppStrings.allJob.tr),
              Tab(text: AppStrings.accepted.tr),
              Tab(text: AppStrings.completed.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildJobList(controller.pendingJobs),
            _buildJobList(controller.acceptedJobs),
            _buildJobList(controller.completedJobs),
          ],
        ),
      ),
    );
  }

  Widget _buildJobList(List<Map<String, dynamic>> jobs) {
    return Obx(() {
      if (jobs.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.volunteer_activism_outlined,
                  size: 64, color: const Color(0xFF6CA34D).withOpacity(0.5)),
              const SizedBox(height: 16),
              Text(
                AppStrings.beFirstToHelp.tr,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.noRequestsRightNow.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return MyJobCard(
            job: job,
            status: job['status'],
            onTap: () => controller.openTaskDetails(job),
            onStartWork: () => controller.markAsInProgress(job),
            onCompleteWork: () =>
                Get.to(() => JobOtpVerificationView(job: job)),
            onCancel: index == 0
                ? () => _showCancelJobDialog(context, job)
                : null,
            // FIXED: Cleaned up the callback syntax to properly call the bottom sheet
            onProposeTime: index == 0
                ? () => _showProposeNewTimeSheet(context)
                : null,
          );
        },
      );
    });
  }

  // FIXED: Removed the unnecessary trailing comma in the parameters
  void _showProposeNewTimeSheet(BuildContext context) {
    TimeOfDay? selectedTime;
    DateTime? selectedDate; // Local state for Date
    final TextEditingController descriptionController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 24,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Propose New Time",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Suggest a new time for this order and provide a brief reason.",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),

                  // --- Date Picker Field ---
                  const Text("Select Date", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF6CA34D),
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedDate != null
                                ? "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}"
                                : "Tap to select date",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedDate != null ? Colors.black : Colors.grey,
                            ),
                          ),
                          const Icon(Icons.calendar_today, size: 18, color: Color(0xFF6CA34D)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Time Picker Field ---
                  const Text(
                    "Select Time",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            selectedTime != null
                                ? selectedTime!.format(context)
                                : "Tap to select time",
                            style: TextStyle(
                              fontSize: 16,
                              color: selectedTime != null ? Colors.black : Colors.grey,
                            ),
                          ),
                          const Icon(Icons.access_time, color: Color(0xFF6CA34D)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // --- Description Field ---
                  const Text(
                    "Description / Reason",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: "Enter your reason here...",
                      hintStyle: const TextStyle(color: Colors.grey),
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
                        borderSide: const BorderSide(color: Color(0xFF6CA34D), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- Action Buttons ---
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedDate == null) {
                              Get.snackbar("Error", "Please select a date",
                                  backgroundColor: Colors.redAccent, colorText: Colors.white);
                              return;
                            }
                            if (selectedTime == null) {
                              Get.snackbar("Error", "Please select a time",
                                  backgroundColor: Colors.redAccent, colorText: Colors.white);
                              return;
                            }
                            if (descriptionController.text.trim().isEmpty) {
                              Get.snackbar("Error", "Please provide a description",
                                  backgroundColor: Colors.redAccent, colorText: Colors.white);
                              return;
                            }

                            // TODO: Add your API call or controller logic here
                            // e.g., controller.submitNewTime(order.id, selectedDate!, selectedTime!, descriptionController.text);

                            Navigator.pop(context);
                            Get.snackbar(
                              "Success",
                              "New time proposed successfully!",
                              backgroundColor: const Color(0xFF6CA34D),
                              colorText: Colors.white,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF6CA34D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showCancelJobDialog(BuildContext context, Map<String, dynamic> job) {
    final TextEditingController reasonController = TextEditingController();
    // Reactive boolean for the checkbox
    final RxBool isAgreed = false.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cancel Job',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 10),

                // --- ADDED WARNING ICON HERE ---
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.redAccent,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This cancellation will result in 1 strike.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.redAccent,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
                // -------------------------------

                const SizedBox(height: 13),
                const Text(
                  'Are you sure you want to cancel this job? Frequent cancellations may affect your profile rating.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: reasonController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Please write your reason here...',
                    hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Checkbox Section
                Obx(() => Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: isAgreed.value,
                        activeColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: (bool? value) {
                          isAgreed.value = value ?? false;
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'I acknowledge that canceling this job will result in 1 strike.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary, // Use your AppColors here
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                )),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Validate reason
                          if (reasonController.text.trim().isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please provide a reason',
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          // Validate checkbox
                          if (!isAgreed.value) {
                            Get.snackbar(
                              'Error',
                              'Please check the acknowledgment box to proceed',
                              backgroundColor: Colors.redAccent,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            return;
                          }

                          // If all validations pass
                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Job cancellation submitted.',
                            backgroundColor: const Color(0xFF6CA34D),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}