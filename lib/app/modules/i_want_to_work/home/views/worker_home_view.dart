import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/home_header.dart';
import '../controllers/worker_home_controller.dart';

class WorkerHomeView extends GetView<WorkerHomeController> {
  const WorkerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Obx(() {
                      bool showBanner = controller.isVerifyBannerVisible.value && !controller.isVerified.value;
                      if (!showBanner) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Stack(
                          children: [
                            _buildVerificationBanner(),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.black54, size: 20),
                                onPressed: () => controller.isVerifyBannerVisible.value = false,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    _buildDailyAvailableTime(),
                    const SizedBox(height: 20),
                    _buildTopFilters(),
                    const SizedBox(height: 20),
                    _buildCalendarSection(context),
                    const SizedBox(height: 20), // Space for bottom padding



                    const RecentActivitySection(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }






















  Widget _buildTopFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final year = controller.selectedYear.value;
        final month = controller.selectedMonth.value;
        final hour = controller.selectedHour.value;
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: DropdownButtonFormField<int>(
                isExpanded: true,
                value: year,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
                dropdownColor: Colors.white,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                items: [2024, 2025, 2026, 2027].map((y) => DropdownMenuItem(value: y, child: Text(y.toString(), overflow: TextOverflow.ellipsis))).toList(),
                onChanged: (val) => controller.selectedYear.value = val!,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<int>(
                isExpanded: true,
                value: month,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
                dropdownColor: Colors.white,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                items: List.generate(12, (index) {
                  final m = index + 1;
                  return DropdownMenuItem(
                    value: m,
                    child: Text(DateFormat('MMMM').format(DateTime(2020, m)), overflow: TextOverflow.ellipsis),
                  );
                }),
                onChanged: (val) => controller.selectedMonth.value = val!,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                value: hour.isEmpty ? null : hour,
                hint: const Text('Hour', style: TextStyle(fontSize: 14), overflow: TextOverflow.ellipsis),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  isDense: true,
                ),
                dropdownColor: Colors.white,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                items: [
                  const DropdownMenuItem(value: '', child: Text('All')),
                  ...controller.allTimeSlots.map((h) => DropdownMenuItem(value: h, child: Text(h.split(' - ')[0], overflow: TextOverflow.ellipsis)))
                ],
                onChanged: (val) => controller.selectedHour.value = val ?? '',
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    return Obx(() {
      final year = controller.selectedYear.value;
      final month = controller.selectedMonth.value;
      final now = DateTime.now();

      final firstDayOfMonth = DateTime(year, month, 1);
      final lastDayOfMonth = DateTime(year, month + 1, 0);

      int firstWeekDay = firstDayOfMonth.weekday;
      final daysInMonth = lastDayOfMonth.day;
      final totalSlots = daysInMonth + (firstWeekDay - 1);

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manage Availability",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Tap on dates to toggle your availability.",
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(firstDayOfMonth),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Wrap(
                          alignment: WrapAlignment.end,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 4,
                          children: [
                            const Icon(Icons.circle, size: 10, color: Color(0xFF6CA34D)),
                            const Text("Available", style: TextStyle(fontSize: 12)),
                            const SizedBox(width: 8),
                            const Icon(Icons.circle, size: 10, color: Color(0xFFEF5350)),
                            const Text("Not Available / Booked", style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Days of week header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: ['M', 'T', 'W', 'T', 'F', 'S', 'S'].map((day) {
                      return SizedBox(
                        width: 36,
                        child: Center(
                          child: Text(
                            day,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Calendar Grid
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: totalSlots,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      if (index < firstWeekDay - 1) {
                        return const SizedBox(); // Empty slots before the 1st
                      }

                      final dayNumber = index - (firstWeekDay - 1) + 1;
                      final currentDate = DateTime(year, month, dayNumber);

                      return Obx(() {
                        final states = controller.slotStates[currentDate] ?? {};
                        final hasAvailable = states.values.any((s) => s == SlotState.available);
                        final isFullyBooked = states.isNotEmpty && states.values.every((s) => s == SlotState.booked);

                        final isSelected = controller.selectedDate.value == currentDate;

                        Color bgColor = const Color(0xFFF5F5F5);
                        Color borderColor = Colors.transparent;
                        Color textColor = Colors.black87;

                        if (hasAvailable) {
                          bgColor = const Color(0xFFE8F5E9);
                          borderColor = const Color(0xFF6CA34D).withValues(alpha: 0.5);
                          textColor = const Color(0xFF2E7D32);
                        } else if (isFullyBooked) {
                          bgColor = const Color(0xFFFFEBEE);
                          borderColor = const Color(0xFFEF5350).withValues(alpha: 0.5);
                          textColor = const Color(0xFFEF5350);
                        }

                        if (isSelected) {
                          borderColor = hasAvailable ? const Color(0xFF2E7D32) : (isFullyBooked ? const Color(0xFFC62828) : Colors.black87);
                        }

                        return GestureDetector(
                          onTap: () => controller.selectDate(currentDate),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: borderColor,
                                width: isSelected ? 2.5 : 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                dayNumber.toString(),
                                style: TextStyle(
                                  color: textColor,
                                  fontWeight: (hasAvailable || isSelected || isFullyBooked) ? FontWeight.bold : FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Obx(() {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: controller.selectedDate.value == null
                    ? const SizedBox(width: double.infinity)
                    : _buildTimeSlotPanel(),
              );
            }),

            const SizedBox(height: 24),

            // Summary Card
            Obx(() {
              final daysCount = controller.totalAvailableDays;
              final slotsCount = controller.totalAvailableSlots;
              final dayString = daysCount == 1 ? "day" : "days";
              
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6CA34D), Color(0xFF4B7B32)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4B7B32).withValues(alpha: 0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.event_available, color: Color(0xFF4B7B32), size: 32),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Availability Summary",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Available on $daysCount $dayString",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Total $slotsCount open slots this month",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    });
  }

  Widget _buildVerificationBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.error,
            size: 32,
          ),
          const SizedBox(height: 12),
          const Text(
            "Your account isn't verified yet.\nTo send work requests and get hired, please\ncomplete your verification.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary, // Or slightly lighter? Matches screenshot mostly black
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () => controller.showVerificationUi(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E1E1E), // Black button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Verify now",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotPanel() {
    final date = controller.selectedDate.value!;
    final dateStr = DateFormat('MMM d, yyyy').format(date);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Slots for $dateStr",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () => controller.selectedDate.value = null,
                child: const Icon(Icons.close, size: 20, color: Colors.grey),
              )
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: controller.allTimeSlots.map((slot) {
              final slotState = controller.slotStates[date]?[slot] ?? SlotState.unset;
              final bool isAvailable = slotState == SlotState.available;
              final bool isBooked = slotState == SlotState.booked;
              final bool matchesFilter = controller.selectedHour.value == slot;

              Color bgColor = const Color(0xFFF5F5F5); // light grey for unset
              Color textColor = AppColors.textPrimary;
              Color borderColor = Colors.transparent;
              TextDecoration textDecoration = TextDecoration.none;

              if (isAvailable) {
                bgColor = const Color(0xFF6CA34D); // Solid Green
                textColor = Colors.white;
                borderColor = const Color(0xFF6CA34D);
              } else if (isBooked) {
                bgColor = const Color(0xFFEF5350); // Solid Soft Red
                textColor = Colors.white;
                borderColor = const Color(0xFFEF5350);
                textDecoration = TextDecoration.none;
              }

              if (matchesFilter) {
                borderColor = isAvailable ? Colors.white : Colors.blueAccent;
              }

              return GestureDetector(
                onTap: isBooked ? null : () => controller.toggleTimeSlot(slot),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: matchesFilter ? Colors.blueAccent : borderColor,
                      width: matchesFilter ? 2.0 : 1.0,
                    ),
                    boxShadow: matchesFilter ? [
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ] : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isAvailable) ...[
                        const Icon(Icons.check, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                      ],
                      if (isBooked) ...[
                        const Icon(Icons.block, color: Colors.white54, size: 16),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        slot,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: (isAvailable || matchesFilter) ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                          decoration: textDecoration,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyAvailableTime() {
    final List<String> hoursList = [
      '06:00 AM', '07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM', '11:00 AM',
      '12:00 PM', '01:00 PM', '02:00 PM', '03:00 PM', '04:00 PM', '05:00 PM',
      '06:00 PM', '07:00 PM', '08:00 PM', '09:00 PM', '10:00 PM'
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set Daily Available Time",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.startTime.value,
                        decoration: InputDecoration(
                          labelText: 'Start Time',
                          labelStyle: const TextStyle(fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          isDense: true,
                        ),
                        items: hoursList
                            .map((h) => DropdownMenuItem(
                                value: h,
                                child: Text(h, style: const TextStyle(fontSize: 14))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) controller.startTime.value = val;
                        },
                      )),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text("-",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                ),
                Expanded(
                  child: Obx(() => DropdownButtonFormField<String>(
                        value: controller.endTime.value,
                        decoration: InputDecoration(
                          labelText: 'Ending Time',
                          labelStyle: const TextStyle(fontSize: 12),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          isDense: true,
                        ),
                        items: hoursList
                            .map((h) => DropdownMenuItem(
                                value: h,
                                child: Text(h, style: const TextStyle(fontSize: 14))))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) controller.endTime.value = val;
                        },
                      )),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.setDailyAvailableTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6CA34D),
                  elevation: 0,
                  minimumSize: const Size(double.infinity, 48),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Set Daily Available Time",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {"title": "Gardening – starts in 2h 15m", "time": "2 hours ago", "icon": Icons.schedule},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Next job",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(activity["icon"] as IconData, color: Colors.blue, size: 20),
                ),
                title: Text(activity["title"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text(activity["time"], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              );
            },
          )
        ],
      ),
    );
  }
}
