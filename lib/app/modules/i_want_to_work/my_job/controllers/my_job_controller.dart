import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/helper_model.dart';
import '../widgets/finish_work_sheet.dart';
import '../widgets/task_detail_sheet.dart';

class MyJobController extends GetxController {
  // Simulated Logged-In Helper for Strike Demo
  final currentHelper = HelperModel(
    id: 'mock_1',
    name: 'Nicolas',
    avatarUrl: '',
    rating: 5.0,
    totalTasks: 120,
    location: '',
    distance: '',
    bio: '',
    category: '',
    skills: [],
    reviews: []
  ).obs;

  @override
  void onInit() {
    super.onInit();
    verifyAutoCompletions();
  }

  void verifyAutoCompletions() {
    bool changed = false;
    for (var i = 0; i < completedJobs.length; i++) {
      var job = completedJobs[i];
      if (job['status'] == 'Pending Client Confirmation' && job['completionMarkedTime'] != null) {
        DateTime markedTime = job['completionMarkedTime'];
        if (DateTime.now().difference(markedTime).inHours >= 6) {
          var updatedJob = Map<String, dynamic>.from(job);
          updatedJob['status'] = 'Completed';
          completedJobs[i] = updatedJob;
          changed = true;
        }
      }
    }
    if (changed) {
      completedJobs.refresh();
      Get.snackbar(
        'Auto-Complete', 
        'Jobs pending client confirmation for 6+ hours have been auto-completed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final pendingJobs = <Map<String, dynamic>>[
    {
      'title': 'Assemble an IKEA Desk',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'status': 'Pending',
      'distance': '1.8 km',
      'postedBy': 'Nicolas',
    },
    {
      'title': 'Assemble an IKEA Desk',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'status': 'Pending',
      'distance': '2.5 km',
      'postedBy': 'Alex Smith',
    },
    {
      'title': 'Assemble an IKEA Desk',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'status': 'Pending',
      'distance': '1.2 km',
      'postedBy': 'John Doe',
    },
  ].obs;

  final acceptedJobs = <Map<String, dynamic>>[
    {
      'title': 'Assemble an IKEA Desk',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'status': 'Accepted',
      'distance': '3.1 km',
      'postedBy': 'Nicolas',
    },
  ].obs;

  final completedJobs = <Map<String, dynamic>>[
    {
      'title': 'Assemble an IKEA Desk',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'status': 'Completed',
      'distance': '0.8 km',
      'postedBy': 'Nicolas',
    },
    {
      'title': 'Assemble an IKEA Desk',
      'category': 'Home assistance',
      'location': 'San Francisco CA',
      'price': 90,
      'duration': '1h',
      'date': '12 Jan, 2026',
      'time': '10:00 AM',
      'status': 'Completed',
      'distance': '4.5 km',
      'postedBy': 'David Miller',
    },
  ].obs;

  void openTaskDetails(Map<String, dynamic> job) {
    Get.bottomSheet(
      TaskDetailSheet(job: job),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  // Move job from Accepted -> InProgress (Updating in place or moving lists if strict separation needed)
  // For simplicity, we just update the status in the accepted list item.
  // Ideally, if 'Accepted' tab only shows accepted, we might need an 'InProgress' tab or list.
  // The user didn't ask for a new tab, but the UI needs to show it.
  // Currently we only have Pending, Accepted, Completed tabs.
  // 'In Progress' usually sits in Accepted or active.
  // Let's keep it in acceptedJobs list but update status.

  Future<void> markAsInProgress(Map<String, dynamic> job) async {
    bool locationVerified = false;
    String? locationError;

    // Try location verification but don't let it block the flow
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.medium, // Lower accuracy is faster/safer
            timeLimit: const Duration(seconds: 5),
          );

          String address = job['location'] ?? '';
          if (address.isNotEmpty) {
            List<Location> locations = await locationFromAddress(address);
            if (locations.isNotEmpty) {
              double distanceInMeters = Geolocator.distanceBetween(
                position.latitude,
                position.longitude,
                locations.first.latitude,
                locations.first.longitude,
              );
              // TODO: Revert distance check (100m) for production.
              if (distanceInMeters <= 20000000) {
                locationVerified = true;
              } else {
                locationError =
                    "Distance: ${distanceInMeters.toStringAsFixed(0)}m (Limit: 20000000m)";
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Location verification failed: $e");
      // Intentionally silent catch to allow the UI state update to proceed
    }

    // ENFORCE Status Update to 'InProgress' regardless of verification outcome
    try {
      int index = acceptedJobs.indexOf(job);
      if (index == -1) {
        index = acceptedJobs.indexWhere((element) =>
            element['title'] == job['title'] && element['date'] == job['date']);
      }

      if (index != -1) {
        var updatedJob = Map<String, dynamic>.from(acceptedJobs[index]);
        updatedJob['status'] = 'InProgress';
        acceptedJobs[index] = updatedJob;
        acceptedJobs.refresh(); // Forces UI Update (Button becomes 'Completed')

        if (locationVerified) {
          Get.snackbar('Success', 'Geofencing verified! Job started.',
              backgroundColor: const Color(0xFF6CA34D),
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Job Started',
              locationError ?? 'Location check bypassed. Job set to In Progress.',
              backgroundColor: Colors.orangeAccent,
              colorText: Colors.black,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4));
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update job status: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  void openFinishWorkModal(Map<String, dynamic> job) {
    Get.bottomSheet(
      FinishWorkSheet(
        onComplete: (otp) {
          Get.back(); // Close sheet
          // Optional: Verify OTP here
          if (otp.length < 6) {
            Get.snackbar('Error', 'Please enter a valid 6-digit OTP');
            return;
          }
          // Verify OTP logic (simulated)
          if (otp == "123456") {
            // Redemption: Record success
            currentHelper.value.recordSuccessfulJob();
            currentHelper.refresh();

            // Move job to completed securely via identifier matching
            acceptedJobs.removeWhere(
              (element) =>
                  element['title'] == job['title'] &&
                  element['date'] == job['date'],
            );

            var completedJob = Map<String, dynamic>.from(job);
            completedJob['status'] = 'Pending Client Confirmation';
            completedJob['completionMarkedTime'] = DateTime.now();
            completedJobs.add(completedJob);
            Get.snackbar('Pending Confirmation', 'Work marked complete. Awaiting client or 6-hour timeout.\nStrikes: ${currentHelper.value.currentStrikes}');
          } else {
            Get.snackbar('Error', 'Invalid OTP. Try 123456');
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void verifyJobCompletionWithOtp(Map<String, dynamic> job, String otp) {
    // Verify OTP logic (simulated)
    if (otp == "123456") {
      // Redemption: Record success
      currentHelper.value.recordSuccessfulJob();
      currentHelper.refresh();

      // Move job to completed securely via identifier matching
      acceptedJobs.removeWhere(
        (element) =>
            element['title'] == job['title'] &&
            element['date'] == job['date'],
      );

      var completedJob = Map<String, dynamic>.from(job);
      completedJob['status'] = 'Pending Client Confirmation';
      completedJob['completionMarkedTime'] = DateTime.now();
      completedJobs.add(completedJob);
      
      Get.back(); // Back from OTP view
      
      Get.snackbar('Pending Confirmation', 'Work marked complete. Awaiting client or 6-hour timeout.\nStrikes: ${currentHelper.value.currentStrikes}');
    } else {
      Get.snackbar('Error', 'Invalid OTP. Try 123456');
    }
  }

  // Helper Cancellation Logic
  void cancelJob(Map<String, dynamic> job, {bool isMutual = false}) {
    if (isMutual) {
      Get.snackbar(
        'Mutual Cancellation', 
        'Job cancelled. 0 strikes added, no penalty.',
        snackPosition: SnackPosition.BOTTOM,
      );
      acceptedJobs.removeWhere((element) => element['title'] == job['title'] && element['date'] == job['date']);
      return;
    }

    try {
      // Parser date like '12 Jan, 2026' and time '10:00 AM'
      String dateStr = job['date'];
      String timeStr = job['time'];
      String combined = '$dateStr $timeStr';
      
      DateFormat format = DateFormat("dd MMM, yyyy hh:mm a");
      DateTime targetTime = format.parse(combined);
      
      int diffHours = targetTime.difference(DateTime.now()).inHours;
      
      if (diffHours > 24) {
        Get.snackbar(
          'Job Cancelled', 
          'Cancelled > 24h before job: No penalty strikes.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else if (diffHours >= 0 && diffHours <= 24) {
        currentHelper.value.addStrikes(1);
        currentHelper.refresh();
        Get.snackbar(
          'Job Cancelled', 
          '< 24h before job: 1 Strike added.\nTotal Strikes: ${currentHelper.value.currentStrikes}\nStatus: ${currentHelper.value.accountStatus}',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        currentHelper.value.addStrikes(2);
        currentHelper.refresh();
        Get.snackbar(
          'Job Cancelled', 
          'No-show: 2 Strikes added.\nTotal Strikes: ${currentHelper.value.currentStrikes}\nStatus: ${currentHelper.value.accountStatus}',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      acceptedJobs.removeWhere((element) => element['title'] == job['title'] && element['date'] == job['date']);

    } catch (e) {
      Get.snackbar('Error', 'Failed to parse job date. Cannot calculate penalties.');
    }
  }
}
