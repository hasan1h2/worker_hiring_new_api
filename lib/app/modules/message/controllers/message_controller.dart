import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:worker_hiring/app/routes/app_pages.dart';
import 'package:worker_hiring/app/modules/i_need_help/payment/views/payment_view.dart';
import 'package:worker_hiring/app/modules/i_need_help/order/controllers/order_controller.dart';

import '../../../core/constants/app_images.dart';
import '../../../core/constants/app_strings.dart';

enum MessageType { text, offer, quote }

class ChatModel {
  final String name;
  final String avatar;
  final String lastMessage;
  final String timeAgo;
  final bool isOnline;
  final bool hasUnread;

  final RxList<MessageModel> messages;

  ChatModel({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.timeAgo,
    this.isOnline = false,
    this.hasUnread = false,
    List<MessageModel> messages = const [],
  }) : messages = messages.obs;
}

class MessageModel {
  final String text;
  final bool isMe;
  final String senderRole; // 'client' or 'worker'
  final String time;
  final MessageType type;

  final String? taskTitle;
  final String? category;
  final String? address;
  final DateTime? date;
  String offerStatus;
  String? timeSlot;
  String? job_state;
  double? budget;
  double? proposedBudget;

  // 🎯 FIX: Added Missing Time Change Request Fields
  bool isRescheduleRequest;
  DateTime? proposedDate;
  String? proposedTimeSlot;

  double? laborCost;
  double? materialsCost;
  String? duration;
  DateTime? quoteExpiryTime;

  String? description;
  String? photoUrl;
  double? clientRating;
  String? cancellationReason; // For cancellation fix
  String? counterMessage; // For counter offer message fix

  MessageModel({
    required this.text,
    required this.isMe,
    this.senderRole = 'client', // Default is client
    required this.time,
    this.type = MessageType.text,
    this.taskTitle,
    this.category,
    this.address,
    this.date,
    this.offerStatus = 'pending',
    this.budget,
    this.proposedBudget,

    // 🎯 FIX: Added to constructor
    this.isRescheduleRequest = false,
    this.proposedDate,
    this.proposedTimeSlot,

    this.laborCost,
    this.materialsCost,
    this.duration,
    this.timeSlot,
    this.job_state,
    this.description,
    this.photoUrl,
    this.clientRating,
    this.cancellationReason,
    this.counterMessage,
    DateTime? quoteExpiryTime,
  }) {
    if ((type == MessageType.offer || type == MessageType.quote) && this.offerStatus == 'pending') {
      this.quoteExpiryTime = quoteExpiryTime ?? DateTime.now().add(const Duration(hours: 12));
    } else {
      this.quoteExpiryTime = quoteExpiryTime;
    }
  }
}

class MessageController extends GetxController {
  final List<ChatModel> chats = [
    ChatModel(
      name: 'Alex Smith',
      avatar: AppImages.alexSmith,
      lastMessage: 'Request sent to Alex...',
      timeAgo: 'Now',
      isOnline: true,
      messages: [],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    // Add mock paid message for demonstration purposes
    chats[0].messages.add(
      MessageModel(
        text: "Payment of \$50.00 confirmed.",
        isMe: false,
        time: "10:30 AM",
        type: MessageType.quote,
        offerStatus: 'paid',
        taskTitle: "Furniture Assembly",
        date: DateTime(2026, 4, 17),
        duration: "3 hrs",
        description: "This job involves assembling a large IKEA Bekant corner desk. All tools are provided, but experience with furniture assembly is preferred.",
        clientRating: 4.8,
      ),
    );
  }

  RxBool isDeclined = false.obs;
  RxBool isJobUnderNegotiation = false.obs;

  void onAcceptQuote(MessageModel quote, ChatModel chat) {
    quote.offerStatus = 'accepted';
    isJobUnderNegotiation.value = false;
    chat.messages.refresh();
    Get.snackbar("Accepted", "Job accepted successfully! Please proceed to payment.",
        backgroundColor: Colors.green.shade100, colorText: Colors.green.shade900);
  }

  // Updated to receive the message string
  void sendCounterOffer(ChatModel chat, MessageModel originalQuote, double newPrice, String currentRole, String message) {
    originalQuote.offerStatus = 'countered';
    isJobUnderNegotiation.value = true;

    final counterMsg = MessageModel(
      text: "Counteroffer: \$${newPrice.toStringAsFixed(2)}",
      isMe: true,
      senderRole: currentRole,
      time: "Now",
      type: MessageType.quote,

      taskTitle: originalQuote.taskTitle,
      category: originalQuote.category,
      address: originalQuote.address,
      date: originalQuote.date,
      timeSlot: originalQuote.timeSlot,

      proposedBudget: newPrice,
      laborCost: newPrice,
      materialsCost: 0,
      duration: originalQuote.duration ?? "3 hrs",
      offerStatus: 'pending',
      description: originalQuote.description,
      photoUrl: originalQuote.photoUrl,
      clientRating: originalQuote.clientRating,
      counterMessage: message, // Saving the counter message
    );

    chat.messages.add(counterMsg);
    chat.messages.refresh();
  }

  void onDeclineQuote(MessageModel quote, ChatModel chat) {
    quote.offerStatus = 'declined';
    chat.messages.refresh();
    Get.snackbar("Declined", "You have declined the offer.", backgroundColor: Colors.red.shade100);
  }

  // Updated to receive an optional reason string
  void cancelRequest(MessageModel msg, ChatModel chat, {String reason = "Client changed requirement"}) {
    msg.offerStatus = 'cancelled';
    msg.cancellationReason = reason;
    chat.messages.refresh();
    Get.snackbar("Cancelled", "Request cancelled successfully.", backgroundColor: Colors.grey.shade200);
  }

  void sendMessage(String text) {
    Get.snackbar("Sent", text);
  }

  void processPayment(MessageModel offerMessage, ChatModel chat) {
    final double total = offerMessage.proposedBudget ?? offerMessage.budget ?? 0.0;

    // Create a mock OrderModel to satisfy PaymentView's structure
    final mockOrder = OrderModel(
      title: offerMessage.taskTitle ?? "Negotiated Task",
      categoryIcon: AppImages.homeAssistance,
      categoryName: offerMessage.category ?? "Services",
      location: offerMessage.address ?? "San Francisco",
      date: offerMessage.date ?? DateTime.now(),
      time: const TimeOfDay(hour: 10, minute: 0),
      priceRange: "\$${total.toStringAsFixed(2)}",
      status: OrderStatus.confirmed,
    );

    Get.to(() => const PaymentView(), arguments: mockOrder)?.then((result) {
      if (result == true) {
        offerMessage.offerStatus = 'paid';
        chat.messages.refresh();
      }
    });
  }
}