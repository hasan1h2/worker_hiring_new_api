import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../data/models/helper_model.dart';

enum OrderStatus { created, progress, confirmed, pendingConfirmation, completed }

class OrderModel {
  final String title;
  final String categoryIcon;
  final String categoryName;
  final String location;
  final DateTime date;
  final TimeOfDay time;
  final String priceRange;
  OrderStatus status;
  final String? userName;
  final String? userAvatar;
  final int? requestsCount;
  final String distance;
  DateTime? completionMarkedTime;

  OrderModel({
    required this.title,
    required this.categoryIcon,
    required this.categoryName,
    required this.location,
    required this.date,
    required this.time,
    required this.priceRange,
    required this.status,
    this.userName,
    this.userAvatar,
    this.requestsCount,
    this.distance = '1.8 km',
    this.completionMarkedTime,
  });
}

class OrderController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    verifyAutoCompletions();
  }

  void verifyAutoCompletions() {
    bool changed = false;
    for (var order in allOrders) {
      if (order.status == OrderStatus.pendingConfirmation && order.completionMarkedTime != null) {
        if (DateTime.now().difference(order.completionMarkedTime!).inHours >= 6) {
          order.status = OrderStatus.completed;
          changed = true;
        }
      }
    }
    if (changed) {
      allOrders.refresh();
      Get.snackbar(
        'Auto-Complete',
        'Jobs pending client confirmation for 6+ hours have been auto-completed.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final allOrders = <OrderModel>[
    OrderModel(
      title: 'Assemble an IKEA Desk',
      categoryIcon: AppImages.homeAssistance,
      categoryName: 'Home assistance',
      location: 'San Francisco CA',
      date: DateTime(2026, 2, 12),
      time: const TimeOfDay(hour: 10, minute: 0),
      priceRange: '\$80-\$100',
      status: OrderStatus.created,
      requestsCount: 6,
      distance: '1.8 km',
    ),
    OrderModel(
      title: 'Paint Living Room Walls',
      categoryIcon: AppImages.homeAssistance,
      categoryName: 'Painting',
      location: 'Palo Alto CA',
      date: DateTime(2026, 2, 10),
      time: const TimeOfDay(hour: 09, minute: 0),
      priceRange: '\$350',
      status: OrderStatus.progress,
      userName: 'Michael Chen',
      userAvatar: AppImages.alexSmith,
      distance: '3.7 km',
    ),
    OrderModel(
      title: 'Carpet Cleaning - 3 Rooms',
      categoryIcon: AppImages.homeAssistance,
      categoryName: 'Cleaning',
      location: 'San Francisco CA',
      date: DateTime(2026, 1, 15),
      time: const TimeOfDay(hour: 13, minute: 0),
      priceRange: '\$180',
      status: OrderStatus.completed,
      userName: 'John Doe',
      userAvatar: AppImages.alexSmith,
      distance: '2.6 km',
    ),
    OrderModel(
      title: 'Fix Leaking Kitchen Faucet',
      categoryIcon: AppImages.minorRepairs,
      categoryName: 'Minor Repairs',
      location: 'San Mateo CA',
      date: DateTime.now().add(const Duration(hours: 12, minutes: 45)),
      time: TimeOfDay.fromDateTime(DateTime.now().add(const Duration(hours: 12, minutes: 45))),
      priceRange: '\$120',
      status: OrderStatus.confirmed,
      userName: 'David Wilson',
      userAvatar: AppImages.david,
      distance: '8.0 km',
    ),
  ].obs;

  List<OrderModel> get confirmOrders =>
      allOrders.where((o) => o.status == OrderStatus.progress || o.status == OrderStatus.confirmed).toList();
  List<OrderModel> get completedOrders =>
      allOrders.where((o) => o.status == OrderStatus.completed).toList();

  // Client Cancellation Logic
  void cancelOrder(OrderModel order, {bool isMutual = false}) {
    if (isMutual) {
      Get.snackbar(
        'Mutual Cancellation',
        'Order cancelled by mutual agreement. 100% full refund issued.',
        snackPosition: SnackPosition.BOTTOM,
      );
      allOrders.remove(order);
      return;
    }

    DateTime targetTime = DateTime(
      order.date.year,
      order.date.month,
      order.date.day,
      order.time.hour,
      order.time.minute,
    );

    int diffHours = targetTime.difference(DateTime.now()).inHours;

    if (diffHours > 24) {
      Get.snackbar(
        'Order Cancelled',
        '> 24h before job: 100% full refund issued. No fees charged.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else if (diffHours >= 0 && diffHours <= 24) {
      Get.snackbar(
        'Order Cancelled',
        '< 24h before job: 50% refund issued, 50% charged.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'No-Show / Cancelled',
        'After job start time: 100% charged. No refund.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    allOrders.remove(order);
  }

  // Moved outside of cancelOrder
  void navigateToProfile(HelperModel helper) {
    // Assuming you have a Routes file, or adjust to match your routing
    Get.toNamed('/helper_profile', arguments: helper);
  }

  void reportIssue(OrderModel order) {
    // Mocking report submission logic
    Get.snackbar(
      'Report Submitted',
      'Issue for "${order.title}" has been reported successfully. Our team will review it shortly.',
      backgroundColor: const Color(0xFF6CA34D),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}