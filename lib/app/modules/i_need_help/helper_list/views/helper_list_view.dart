import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../controllers/helper_list_controller.dart';
import '../../../message/views/chat_view.dart';
import '../../../message/controllers/message_controller.dart';
import '../../custom_offer/views/custom_offer_view.dart';

class HelperListView extends GetView<HelperListController> {
  const HelperListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: controller.categoryName.value),
      body: Column(
        children: [
          _buildFilterSection(),
          _buildSortSection(context), // Context পাস করা হয়েছে
          Expanded(
            child: Obx(
                    () {
                  if (controller.displayedHelpers.isEmpty) {
                    return const Center(
                        child: Text("No helpers match your filter criteria.", style: TextStyle(color: Colors.grey))
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    itemCount: controller.displayedHelpers.length,
                    itemBuilder: (context, index) {
                      final helper = controller.displayedHelpers[index];
                      return _buildHelperCard(helper);
                    },
                  );
                }
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search in this category...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: () {
              // Copy active values to temporary state
              controller.tempMaxDistance.value = controller.maxDistance.value;
              controller.tempMinRating.value = controller.minRating.value;
              controller.tempSelectedCategoryFilter.value = controller.selectedCategoryFilter.value;
              controller.tempSelectedDate.value = controller.selectedDate.value;
              controller.tempSelectedTime.value = controller.selectedTime.value;
              controller.tempLocation.value = controller.location.value;
              controller.tempMinBudget.value = controller.minBudget.value;
              controller.tempMaxBudget.value = controller.maxBudget.value;
              controller.tempShowAvailableOnly.value = controller.showAvailableOnly.value;

              Get.bottomSheet(
                const ExtendedFilterBottomSheet(),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              );
            },
            icon: const Icon(Icons.tune, size: 18),
            label: const Text(
              'Filter',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFE8F8F5),
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: Color(0xFFA3D5C0), width: 1.2),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  // মডার্ন Sort Section
  Widget _buildSortSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => Text(
            "${controller.displayedHelpers.length} Helpers Found",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87),
          )),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            ),
            child: PopupMenuButton<String>(
              offset: const Offset(0, 35),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              color: Colors.white,
              onSelected: (val) {
                controller.selectedSort.value = val;
                controller.applySort();
              },
              itemBuilder: (context) => [
                _buildSortMenuItem("Rating (High-Low)", Icons.star_rounded),
                _buildSortMenuItem("Price (Low-High)", Icons.attach_money_rounded),
                _buildSortMenuItem("Distance (Nearest)", Icons.location_on_rounded),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() => Text(
                      controller.selectedSort.value,
                      style: const TextStyle(color: Color(0xFF6CA34D), fontWeight: FontWeight.w600, fontSize: 13),
                    )),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6CA34D), size: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // পপ-আপ মেনুর ডিজাইন
  PopupMenuItem<String> _buildSortMenuItem(String value, IconData icon) {
    return PopupMenuItem<String>(
      value: value,
      child: Obx(() {
        final isSelected = controller.selectedSort.value == value;
        return Row(
          children: [
            Icon(
                icon,
                size: 18,
                color: isSelected ? const Color(0xFF6CA34D) : Colors.grey.shade500
            ),
            const SizedBox(width: 10),
            Text(
                value,
                style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? const Color(0xFF6CA34D) : Colors.black87,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500
                )
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Filter Helpers",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          const SizedBox(height: 24),

          const Text("Category",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.availableCategories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = controller.availableCategories[index];
                return Obx(() {
                  final isSelected =
                      controller.tempSelectedCategoryFilter.value == category;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        controller.tempSelectedCategoryFilter.value = category;
                      }
                    },
                    selectedColor: const Color(0xFF6CA34D),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    backgroundColor: Colors.grey.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected
                            ? const Color(0xFF6CA34D)
                            : Colors.grey.shade300,
                      ),
                    ),
                    showCheckmark: false,
                  );
                });
              },
            ),
          ),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Maximum Distance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Obx(() => Text("${controller.tempMaxDistance.value.toInt()} km", style: const TextStyle(color: Color(0xFF6CA34D), fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Slider(
            value: controller.tempMaxDistance.value,
            min: 1.0,
            max: 50.0,
            divisions: 49,
            activeColor: const Color(0xFF6CA34D),
            onChanged: (value) => controller.tempMaxDistance.value = value,
          )),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Minimum Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Obx(() => Text("${controller.tempMinRating.value.toStringAsFixed(1)} ⭐️", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() => Slider(
            value: controller.tempMinRating.value,
            min: 1.0,
            max: 5.0,
            divisions: 8,
            activeColor: Colors.amber,
            onChanged: (value) => controller.tempMinRating.value = value,
          )),
          const SizedBox(height: 32),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.clearFilters,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Clear/Reset"),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6CA34D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Apply Filters"),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHelperCard(helper) {
    return GestureDetector(
      onTap: () => controller.navigateToProfile(helper),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
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
          children: [
            // Top Section (Category & Availability)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.categoryName.value,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: helper.totalTasks % 2 != 0 ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: helper.totalTasks % 2 != 0 ? Colors.green.shade200 : Colors.red.shade200),
                  ),
                  child: Text(
                    helper.totalTasks % 2 != 0 ? "AVAILABLE NOW" : "BOOKED",
                    style: TextStyle(
                      color: helper.totalTasks % 2 != 0 ? Colors.green.shade700 : Colors.red.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Profile Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(helper.avatarUrl),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        helper.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: AppColors.textPrimary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            helper.rating.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "(${helper.totalTasks} tasks)",
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.redAccent, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "San Francisco CA • ${helper.distance} away",
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(
                  "1h", // Mocked Time Elapsed
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Details Section (Calendar, Price, Bio)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text("12 Jan, 2026", style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text("10:00 AM", style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                    const Spacer(),
                    Text(
                        "\$${(helper.rating * 10).toInt()} /hr",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF6CA34D))
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Bio Section
                Text(
                  "Top-rated service provider with proven experience in ${controller.categoryName.value.toLowerCase()}..",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600, height: 1.4),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    "See more",
                    style: TextStyle(fontSize: 13, color: Color(0xFF6CA34D), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Availability Badge
            Obx(() {
              if (controller.requestedDate.value != null) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBEFB6)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle, color: Color(0xFF2E7D32), size: 12),
                        const SizedBox(width: 4),
                        const Text(
                          "Available on your date",
                          style: TextStyle(color: Color(0xFF2E7D32), fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 4),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.to(() => ChatView(
                        chat: ChatModel(
                          name: helper.name,
                          avatar: helper.avatarUrl,
                          lastMessage: 'Let\'s discuss your project...',
                          timeAgo: 'Just now',
                          isOnline: true,
                          messages: [],
                        ),
                      ));
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      foregroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Send Message', style: TextStyle(fontWeight: FontWeight.w600,
                    fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.to(
                            () => const CreateCustomOfferView(),
                        arguments: {
                          'workerID': helper.id,
                          'workerName': helper.name,
                          'workerAvatar': helper.avatarUrl,
                          'categoryID': controller.categoryName.value,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF6CA34D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 48),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const FittedBox(
                      child: Text('Request This Helper',
                          style: TextStyle(fontWeight: FontWeight.w600,
                          fontSize: 14)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}




class ExtendedFilterBottomSheet extends StatelessWidget {
  const ExtendedFilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HelperListController>();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Detailed Filters",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                )
              ],
            ),
            const SizedBox(height: 24),

            const Text("Category ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.availableCategories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = controller.availableCategories[index];
                  return Obx(() {
                    final isSelected = controller.tempSelectedCategoryFilter.value == category;
                    return ChoiceChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          controller.tempSelectedCategoryFilter.value = category;
                          controller.applyFilters();
                        } else {
                          controller.tempSelectedCategoryFilter.value = "";
                          controller.applyFilters();
                        }
                      },
                      selectedColor: const Color(0xFF6CA34D),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      backgroundColor: Colors.grey.shade100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF6CA34D)
                              : Colors.grey.shade300,
                        ),
                      ),
                      showCheckmark: false,
                    );
                  });
                },
              ),
            ),

            const SizedBox(height: 24),
            // Date Selection
            const Text("Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Obx(() => TextFormField(
              decoration: InputDecoration(
                hintText: controller.tempSelectedDate.value != null
                    ? "${controller.tempSelectedDate.value!.year}-${controller.tempSelectedDate.value!.month.toString().padLeft(2, '0')}-${controller.tempSelectedDate.value!.day.toString().padLeft(2, '0')}"
                    : "Select Date",
                hintStyle: TextStyle(color: controller.tempSelectedDate.value != null ? Colors.black87 : Colors.grey),
                prefixIcon: const Icon(Icons.calendar_today, size: 18, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: controller.tempSelectedDate.value ?? DateTime.now(),
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
                  controller.tempSelectedDate.value = picked;
                }
              },
            )),
            const SizedBox(height: 20),

            // Time Slot
            const Text("Time", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Obx(() => TextFormField(
              decoration: InputDecoration(
                hintText: controller.tempSelectedTime.value != null
                    ? controller.tempSelectedTime.value!.format(context)
                    : "Select Time",
                hintStyle: TextStyle(color: controller.tempSelectedTime.value != null ? Colors.black87 : Colors.grey),
                prefixIcon: const Icon(Icons.access_time, size: 18, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              readOnly: true,
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: controller.tempSelectedTime.value ?? TimeOfDay.now(),
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
                  controller.tempSelectedTime.value = picked;
                }
              },
            )),
            const SizedBox(height: 20),

            // Location + Map
            const Text("Location", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Obx(() => TextFormField(
              key: Key(controller.tempLocation.value),
              initialValue: controller.tempLocation.value,
              onChanged: (val) => controller.tempLocation.value = val,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on, size: 18, color: Colors.redAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
            )),
            const SizedBox(height: 8),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_outlined, size: 40, color: Colors.grey),
                    SizedBox(height: 4),
                    Text("Interactive Map Area", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Budget
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Budget", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Obx(() => Text("\$${controller.tempMinBudget.value.toInt()} - \$${controller.tempMaxBudget.value.toInt()}+", style: const TextStyle(color: Color(0xFF6CA34D), fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => RangeSlider(
              values: RangeValues(controller.tempMinBudget.value, controller.tempMaxBudget.value),
              min: 10,
              max: 200,
              activeColor: const Color(0xFF6CA34D),
              inactiveColor: Colors.grey.shade200,
              onChanged: (values) {
                controller.tempMinBudget.value = values.start;
                controller.tempMaxBudget.value = values.end;
              },
            )),
            const SizedBox(height: 20),

            // Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Minimum Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Obx(() => Text("${controller.tempMinRating.value.toStringAsFixed(1)} ⭐️", style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold))),
              ],
            ),
            const SizedBox(height: 8),
            Obx(() => Slider(
              value: controller.tempMinRating.value,
              min: 1.0,
              max: 5.0,
              divisions: 8,
              activeColor: Colors.amber,
              inactiveColor: Colors.grey.shade200,
              onChanged: (value) => controller.tempMinRating.value = value,
            )),
            const SizedBox(height: 20),

            // Availability Toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Show Available Only", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Obx(() => Switch(
                  value: controller.tempShowAvailableOnly.value,
                  onChanged: (val) {
                    controller.tempShowAvailableOnly.value = val;
                  },
                  activeColor: const Color(0xFF6CA34D),
                )),
              ],
            ),
            const SizedBox(height: 32),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.applyFilters();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6CA34D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text("Apply Filters", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}