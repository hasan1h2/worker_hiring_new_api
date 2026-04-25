import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/mock_data/helper_mock_data.dart';
import '../controllers/order_controller.dart';
import 'order_detail_view.dart';
import 'review_view.dart';
import '../../payment/views/payment_view.dart';
import '../../../../data/models/helper_model.dart';
import '../../../../routes/app_pages.dart';

class OrderView extends GetView<OrderController> {
  const OrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: TabBar(
            labelColor: const Color(0xFF6CA34D),
            unselectedLabelColor: const Color(0xFF999999),
            indicatorColor: const Color(0xFF6CA34D),
            indicatorWeight: 3,
            dividerHeight: 0,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: AppStrings.allOrder.tr),
              Tab(text: AppStrings.confirm.tr),
              Tab(text: AppStrings.completed.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Obx(() => _buildOrderList(
              context: context,
              orders: controller.allOrders.toList(),
              cardBuilder: _buildAllOrderCard,
            )),
            Obx(() => _buildOrderList(
              context: context,
              orders: controller.confirmOrders,
              cardBuilder: _buildConfirmOrderCard,
            )),
            Obx(() => _buildOrderList(
              context: context,
              orders: controller.completedOrders,
              cardBuilder: _buildCompletedOrderCard,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList({
    required BuildContext context,
    required List<OrderModel> orders,
    required Widget Function(BuildContext context, OrderModel order) cardBuilder,
  }) {
    if (orders.isEmpty) {
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
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: orders.length,
      separatorBuilder: (context, index) =>
      const Divider(height: 32, color: Color(0xFFE5E5E5), thickness: 1),
      itemBuilder: (context, index) {
        return cardBuilder(context, orders[index]);
      },
    );
  }

  void _navigateToProfile(OrderModel order) {
    if (order.userName == null) return;

    // Find helper from mock data
    final helpers = HelperMockData.getHelpers();
    final helper = helpers.firstWhere(
          (h) => h.name == order.userName,
      orElse: () => helpers.first,
    );

    Get.toNamed(Routes.HELPER_PROFILE, arguments: helper);
  }

  Widget _buildCountdownSection(OrderModel order) {
    if (order.status != OrderStatus.confirmed) return const SizedBox.shrink();

    final now = DateTime.now();
    final target = DateTime(
      order.date.year,
      order.date.month,
      order.date.day,
      order.time.hour,
      order.time.minute,
    );

    final difference = target.difference(now);
    if (difference.isNegative) return const SizedBox.shrink();

    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7EB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_outlined, size: 16, color: Color(0xFF6CA34D)),
          const SizedBox(width: 8),
          Text(
            "Starts in: ${hours}h ${minutes}m",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6CA34D),
            ),
          ),
        ],
      ),
    );
  }

  // --- NEW: Bottom Sheet Method for Propose New Time ---
  void _showProposeNewTimeSheet(BuildContext context, OrderModel order) {
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

                  // --- Date Picker Field (Fixed) ---
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

  void _showReportIssueSheet(BuildContext context, OrderModel order) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    String? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Report an Issue",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text("Select Issue Category",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      hint: const Text("Select a category",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      items: [
                        'Unprofessional Behavior',
                        'Service Not Completed',
                        'Payment Issue',
                        'Safety Concern',
                        'Other',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          selectedCategory = newValue;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          borderSide:
                              const BorderSide(color: Color(0xFF6CA34D), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Issue Title",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        hintText: "Enter issue title",
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
                          borderSide:
                              const BorderSide(color: Color(0xFF6CA34D), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Describe the issue",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Describe the issue in detail",
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
                          borderSide:
                              const BorderSide(color: Color(0xFF6CA34D), width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text("Upload Photo",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        // TODO: Implement image picker logic
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Icon(Icons.camera_alt_outlined,
                                size: 32, color: Colors.grey.shade400),
                            const SizedBox(height: 8),
                            Text(
                              "Upload Photo of the problem",
                              style:
                                  TextStyle(color: Colors.grey.shade500, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Check if category is selected
                          if (selectedCategory == null) {
                            Get.snackbar("Error", "Please select an issue category",
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white);
                            return;
                          }

                          // TODO: Implement report submission logic
                          Navigator.pop(context);
                          Get.snackbar(
                            "Report Submitted",
                            "Issue for \"${order.title}\" has been reported successfully under category \"$selectedCategory\".",
                            backgroundColor: const Color(0xFF6CA34D),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          "Submit Report",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- TAB 1: ALL ORDER CARD ---
  Widget _buildAllOrderCard(BuildContext context, OrderModel order) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Get.to(() => OrderDetailView(order: order)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        order.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(order.status),
                    _buildReportMenu(context, order),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset(order.categoryIcon, width: 18, height: 18),
                    const SizedBox(width: 6),
                    Text(
                      order.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Posted by You",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Color(0xFF007AFF), size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.location,
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF3B30),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order.location == 'San Francisco CA'
                          ? AppStrings.sanFranciscoCA.tr
                          : order.location,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.to(() => OrderDetailView(order: order)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.calendar,
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6CA34D),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat("d MMM, yyyy").format(order.date),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SvgPicture.asset(
                            AppImages.time,
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6CA34D),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(order.time),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _navigateToProfile(order),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              order.userAvatar ?? AppImages.alexSmith,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.userName ?? 'Pending Worker',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => OrderDetailView(order: order)),
                child: Text(
                  order.priceRange,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          if (order.status == OrderStatus.completed ||
              order.status == OrderStatus.progress ||
              order.status == OrderStatus.confirmed) ...[
            const SizedBox(height: 16),
            if (order.status == OrderStatus.completed)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => const ReviewView()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF6CA34D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.giveAFeedback.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            else if (order.status == OrderStatus.confirmed)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showCancelOrderDialog(context, order),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: const BorderSide(color: Colors.redAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showProposeNewTimeSheet(context, order),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: const Color(0xFF6CA34D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Propose new time",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      Get.to(() => const PaymentView(), arguments: order),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: const Color(0xFF6CA34D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.pay.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  // --- TAB 2: CONFIRM CARD ---
  Widget _buildConfirmOrderCard(BuildContext context, OrderModel order) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Get.to(() => OrderDetailView(order: order)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        order.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(order.status),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset(order.categoryIcon, width: 18, height: 18),
                    const SizedBox(width: 6),
                    Text(
                      order.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Posted by You",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Color(0xFF007AFF), size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.location,
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF3B30),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order.location == 'San Francisco CA'
                          ? AppStrings.sanFranciscoCA.tr
                          : order.location,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.to(() => OrderDetailView(order: order)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.calendar,
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6CA34D),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat("d MMM, yyyy").format(order.date),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SvgPicture.asset(
                            AppImages.time,
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6CA34D),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(order.time),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _navigateToProfile(order),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              order.userAvatar ?? AppImages.alexSmith,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.userName ?? AppStrings.alexSmith.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => OrderDetailView(order: order)),
                child: Text(
                  order.priceRange,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          _buildCountdownSection(order),
          const SizedBox(height: 16),
          if (order.status == OrderStatus.confirmed)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showCancelOrderDialog(context, order),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _showProposeNewTimeSheet(context, order),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: const Color(0xFF6CA34D),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Propose new time",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const PaymentView(), arguments: order);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: const Color(0xFF6CA34D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.pay.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- TAB 3: COMPLETED CARD ---
  Widget _buildCompletedOrderCard(BuildContext context, OrderModel order) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Get.to(() => OrderDetailView(order: order)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        order.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(OrderStatus.completed),
                    _buildReportMenu(context, order),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SvgPicture.asset(order.categoryIcon, width: 18, height: 18),
                    const SizedBox(width: 6),
                    Text(
                      order.categoryName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      "Posted by You",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.verified, color: Color(0xFF007AFF), size: 16),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      AppImages.location,
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFFFF3B30),
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      order.location == 'San Francisco CA'
                          ? AppStrings.sanFranciscoCA.tr
                          : order.location,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.to(() => OrderDetailView(order: order)),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppImages.calendar,
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6CA34D),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat("d MMM, yyyy").format(order.date),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SvgPicture.asset(
                            AppImages.time,
                            width: 14,
                            height: 14,
                            colorFilter: const ColorFilter.mode(
                              Color(0xFF6CA34D),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTime(order.time),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () => _navigateToProfile(order),
                      child: Row(
                        children: [
                          ClipOval(
                            child: Image.asset(
                              order.userAvatar ?? AppImages.alexSmith,
                              width: 20,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            order.userName ?? AppStrings.alexSmith.tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => Get.to(() => OrderDetailView(order: order)),
                child: Text(
                  order.priceRange,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.to(() => const ReviewView()),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                backgroundColor: const Color(0xFF6CA34D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Text(
                AppStrings.giveAFeedback.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bg;
    Color text;
    String label;

    switch (status) {
      case OrderStatus.created:
        bg = const Color(0xFFE5F0FF);
        text = const Color(0xFF007AFF);
        label = AppStrings.created.tr;
        break;
      case OrderStatus.progress:
        bg = const Color(0xFFE0F7FA);
        text = const Color(0xFF00BCD4);
        label = "In Progress";
        break;
      case OrderStatus.confirmed:
        bg = const Color(0xFFE8FCEC);
        text = const Color(0xFF28A745);
        label = "Confirmed";
        break;
      case OrderStatus.completed:
        bg = const Color(0xFFE8FCEC);
        text = const Color(0xFF28A745);
        label = AppStrings.completed.tr;
        break;
      case OrderStatus.pendingConfirmation:
        bg = Colors.orange.shade50;
        text = Colors.orange;
        label = "Pending";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = time.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  Widget _buildReportMenu(BuildContext context, OrderModel order) {
    return PopupMenuButton<String>(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        if (value == 'report') {
          _showReportIssueSheet(context, order);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'report',
          child: Row(
            children: [
              Icon(Icons.report_problem_outlined, size: 20, color: Colors.redAccent),
              SizedBox(width: 8),
              Text('Report Issue'),
            ],
          ),
        ),
      ],
    );
  }

  void _showCancelOrderDialog(BuildContext context, OrderModel order) {
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
                  'Cancel Order',
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
                        'You will be charged \$38 if you cancel now.',
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

                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to cancel this order? This action cannot be undone.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
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

                // Checkbox section
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
                        'I acknowledge that I will be charged \$38 for this cancellation.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
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
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Reason validation
                          if (reasonController.text.trim().isEmpty) {
                            Get.snackbar('Error', 'Please provide a reason',
                                backgroundColor: Colors.redAccent,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM);
                            return;
                          }

                          // Checkbox validation
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

                          Get.back();
                          Get.snackbar(
                            'Success',
                            'Order cancellation submitted.',
                            backgroundColor: const Color(0xFF6CA34D),
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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