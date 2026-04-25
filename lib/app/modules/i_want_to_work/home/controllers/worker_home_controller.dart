import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../routes/app_pages.dart';
import '../widgets/task_detail_sheet.dart';
import '../widgets/filter_modal.dart';
import '../widgets/proposal_modal.dart';

enum SlotState { available, booked, unset }

class WorkerHomeController extends GetxController {
  final _storage = GetStorage();

  final selectedRole = 'I want to work'.obs; // Default for this view
  final isVerified = false.obs;
  final isVerifyBannerVisible = true.obs;

  // Availability state
  final RxInt selectedYear = DateTime.now().year.obs;
  final RxInt selectedMonth = DateTime.now().month.obs;
  final RxString selectedHour = ''.obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  // Daily Available Time state
  final RxString startTime = '09:00 AM'.obs;
  final RxString endTime = '05:00 PM'.obs;

  void setDailyAvailableTime() {
    // TODO: API call to update helper availability time.
    Get.snackbar(
      "Success",
      "Work time updated successfully!",
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF6CA34D),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
  
  
  final RxMap<DateTime, Map<String, SlotState>> slotStates = <DateTime, Map<String, SlotState>>{}.obs;

  final List<String> allTimeSlots = [
    '08:00 AM - 09:00 AM',
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '11:00 AM - 12:00 PM',
    '12:00 PM - 01:00 PM',
    '01:00 PM - 02:00 PM',
    '02:00 PM - 03:00 PM',
    '03:00 PM - 04:00 PM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
    '06:00 PM - 07:00 PM',
    '07:00 PM - 08:00 PM',
  ];

  // Computed properties for summary
  int get totalAvailableDays {
    return slotStates.keys.where((date) {
      if (date.year != selectedYear.value || date.month != selectedMonth.value) return false;
      return slotStates[date]!.values.any((s) => s == SlotState.available);
    }).length;
  }

  int get totalAvailableSlots {
    int count = 0;
    for (var date in slotStates.keys) {
      if (date.year == selectedYear.value && date.month == selectedMonth.value) {
        count += slotStates[date]!.values.where((s) => s == SlotState.available).length;
      }
    }
    return count;
  }

  @override
  void onInit() {
    super.onInit();
    final now = DateTime.now();
    final normalizedToday = DateTime(now.year, now.month, now.day);
    selectedDate.value = normalizedToday;
    selectedYear.value = now.year;
    selectedMonth.value = now.month;
    
    // Initialize with some demo data
    
    // Inject at least 2 random completely "Not Available" dates
    final day1 = DateTime(now.year, now.month, 10);
    final day2 = DateTime(now.year, now.month, 15);
    
    slotStates[day1] = {
      for (var slot in allTimeSlots) slot: SlotState.booked
    };
    slotStates[day2] = {
      for (var slot in allTimeSlots) slot: SlotState.booked
    };
    
    // Default selected date with mix of booked and available slots
    slotStates[normalizedToday] = {
      '08:00 AM - 09:00 AM': SlotState.available,
      '09:00 AM - 10:00 AM': SlotState.booked,
      '12:00 PM - 01:00 PM': SlotState.available,
      '02:00 PM - 03:00 PM': SlotState.booked,
    };
  }

  void selectDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (selectedDate.value == normalizedDate) {
      selectedDate.value = null; // Deselect if tapped again
    } else {
      selectedDate.value = normalizedDate;
      if (!slotStates.containsKey(normalizedDate)) {
        slotStates[normalizedDate] = {};
      }
    }
  }

  void toggleTimeSlot(String slot) {
    if (selectedDate.value == null) return;
    final date = selectedDate.value!;
    
    if (!slotStates.containsKey(date)) {
      slotStates[date] = {};
    }
    
    final states = slotStates[date]!;
    final currentState = states[slot] ?? SlotState.unset;
    
    if (currentState == SlotState.unset) {
      states[slot] = SlotState.available;
    } else if (currentState == SlotState.available) {
      states[slot] = SlotState.unset;
    }
    // Booked slots are unclickable, so we don't change them
    
    slotStates[date] = Map.from(states); // Trigger map reactivity
  }

  // Proposal modal specific
  final proposedBudget = ''.obs;
  double get clientPays => double.tryParse(proposedBudget.value) ?? 0.0;
  double get serviceFee => clientPays * 0.20;
  double get workerRevenue => clientPays * 0.80;

  // Book a job and add a mandatory 30-minute buffer
  void bookJobWithBuffer(DateTime date, String timeSlot) {
    if (!slotStates.containsKey(date)) {
      slotStates[date] = {};
    }

    final states = slotStates[date]!;
    states[timeSlot] = SlotState.booked;

    // Buffer logic: 30-minute buffer extends into the next time slot,
    // thereby locking the next immediate hour slot.
    int currentIndex = allTimeSlots.indexOf(timeSlot);
    if (currentIndex != -1 && currentIndex + 1 < allTimeSlots.length) {
      String nextSlot = allTimeSlots[currentIndex + 1];
      states[nextSlot] = SlotState.booked;
    }

    slotStates[date] = Map.from(states); // Trigger map reactivity
  }

  // Filter specific observables
  final filterCategory = 'Furniture assembly'.obs;
  final filterBudget = 'Highest to Lowest'.obs;
  final filterDate = 'Newest to Oldest'.obs;

  void showVerificationUi() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Verify your account to continue",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your account isn't verified yet.\nTo send work requests and get hired,\nplease complete your verification.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF6DA54B)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xFF6DA54B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(); // Close dialog
                        navigateToVerification();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6DA54B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Verify now",
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
    );
  }

  void navigateToVerification() {
    // Navigate to WorkerAccountVerificationView
    Get.toNamed(Routes.WORKER_ACCOUNT_VERIFICATION);
  }

  void openTaskDetails(Map<String, dynamic> job) {
    Get.bottomSheet(
      TaskDetailSheet(
        job: job,
        onPressedBtn: () => Get.dialog(const ProposalModal()),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Mock Data for Jobs
  final jobs = <Map<String, dynamic>>[
    {
      'title': 'Assemble an IKEA Desk',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'image': 'assets/images/user_avatar.png',
      'postedBy': 'Nicolas',
      'distance': '1.8 km',
    },
    {
      'title': 'In-Home Assistance Needed',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'image': 'assets/images/user_avatar.png',
      'postedBy': 'Alex Smith',
      'distance': '2.5 km',
    },
    {
      'title': 'In-Home Assistance Needed',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'image': 'assets/images/user_avatar.png',
      'postedBy': 'John Doe',
      'distance': '1.2 km',
    },
    {
      'title': 'In-Home Assistance Needed',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'image': 'assets/images/user_avatar.png',
      'postedBy': 'David Miller',
      'distance': '3.1 km',
    },
  ].obs;

  void setRole(String role) {
    if (role == 'I need help') {
      _storage.write('userRole', role);
      Get.offAllNamed(
        Routes.SERVICE_SELECTION,
      ); // Or HOME if that's the main entry
    }
    // Already here if 'I want to work'
  }

  void openFilter() {
    Get.bottomSheet(const FilterModal(), isScrollControlled: true);
  }

  void applyFilter() {
    // Original jobs backup for reference if needed, but we use the reactive list
    final allJobs = [
      {
        'title': 'Assemble an IKEA Desk',
        'category': 'Home assistance',
        'location': 'San Francisco CA',
        'price': 120,
        'duration': '1h',
        'date': '2026-01-12',
        'time': '10:00 AM',
        'image': 'assets/images/user_avatar.png',
        'postedBy': 'Nicolas',
        'distance': '1.8 km',
      },
      {
        'title': 'In-Home Assistance Needed',
        'category': 'Furniture assembly',
        'location': 'San Francisco CA',
        'price': 90,
        'duration': '1h',
        'date': '2026-01-10',
        'time': '10:00 AM',
        'image': 'assets/images/user_avatar.png',
        'postedBy': 'Alex Smith',
        'distance': '2.5 km',
      },
      {
        'title': 'Plumbing Fix',
        'category': 'Home assistance',
        'location': 'San Francisco CA',
        'price': 150,
        'duration': '1h',
        'date': '2026-01-15',
        'time': '10:00 AM',
        'image': 'assets/images/user_avatar.png',
        'postedBy': 'John Doe',
        'distance': '1.2 km',
      },
    ];

    var filtered = allJobs.where((job) {
      return job['category'] == filterCategory.value;
    }).toList();

    if (filterBudget.value == 'Highest to Lowest') {
      filtered.sort((a, b) => (b['price'] as int).compareTo(a['price'] as int));
    } else {
      filtered.sort((a, b) => (a['price'] as int).compareTo(b['price'] as int));
    }

    if (filterDate.value == 'Newest to Oldest') {
      filtered.sort((a, b) => (b['date'] as String).compareTo(a['date'] as String));
    } else {
      filtered.sort((a, b) => (a['date'] as String).compareTo(b['date'] as String));
    }

    jobs.assignAll(filtered);
    Get.back();
  }

  void resetFilter() {
    filterCategory.value = 'Furniture assembly';
    filterBudget.value = 'Highest to Lowest';
    filterDate.value = 'Newest to Oldest';
    applyFilter();
  }

  void openProposalModal(Map<String, dynamic> job) {
    proposedBudget.value = '';
    Get.dialog(const ProposalModal());
  }

  void submitProposal(String price) {
    // Submit logic
    Get.back();
  }
}
