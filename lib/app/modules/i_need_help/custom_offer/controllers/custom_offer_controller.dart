import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../message/controllers/message_controller.dart';
import '../../../message/views/chat_view.dart';
class CustomOfferController extends GetxController {
  // Arguments
  String workerID = '';
  String workerName = '';
  String workerAvatar = '';
  String categoryID = '';

  // Form Controllers
  final taskTitleController = TextEditingController();
  final addressController = TextEditingController();
  final detailsController = TextEditingController();
  final budgetController = TextEditingController(text: "50");

  // Observable Options
  final RxString selectedCategory = ''.obs;
  final RxString selectedSubCategory = ''.obs;
  final Rx<DateTime?> selectedDate = Rx<DateTime?>(null);
  final Rx<TimeOfDay?> selectedTime = Rx<TimeOfDay?>(null);
  final RxDouble budget = 50.0.obs;
  final RxList<String> photos = <String>[].obs;

  // Lists matching CreateTaskController structure
  final RxList<String> subCategories = [
    'Furniture Assembly',
    'TV Mounting',
    'Wall Hanging',
    'General Repairs'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      workerID = Get.arguments['workerID'] ?? '';
      workerName = Get.arguments['workerName'] ?? 'Unknown Worker';
      workerAvatar = Get.arguments['workerAvatar'] ?? '';
      categoryID = Get.arguments['categoryID'] ?? '';

      selectedCategory.value = categoryID;
    }

    // Sync budget controller and observable
    budgetController.addListener(() {
      final val = double.tryParse(budgetController.text);
      if (val != null && val != budget.value) {
        budget.value = val.clamp(0, 500);
      }
    });
  }

  void updateBudget(double value) {
    budget.value = value;
    budgetController.text = value.toInt().toString();
  }

  void selectSubCategory(String subCategory) {
    selectedSubCategory.value = subCategory;
    Get.back(); // close bottom sheet
  }

  void startQuoteExpiryTimer() {
    // TODO: Trigger this timer logic on the backend or state manager once the helper responds.
    debugPrint("startQuoteExpiryTimer placeholder called");
  }

  void onSendOffer() {
    if (taskTitleController.text.isEmpty) {
      Get.snackbar("Error", "Please fill out the task title", colorText: Colors.red);
      return;
    }

    final msgCtrl = Get.put(MessageController());

    // Find or create chat
    ChatModel chat;
    try {
      chat = msgCtrl.chats.firstWhere((c) => c.name == workerName);
    } catch (_) {
      chat = ChatModel(
        name: workerName,
        avatar: workerAvatar.isNotEmpty ? workerAvatar : 'assets/images/user.png',
        lastMessage: 'Request Form Sent',
        timeAgo: 'Just now',
      );
      msgCtrl.chats.add(chat);
    }

    // Add offer message
    final offerMsg = MessageModel(
      text: 'Request Form',
      isMe: true,
      time: 'Now',
      type: MessageType.offer,
      taskTitle: taskTitleController.text,
      category: selectedCategory.value,
      address: addressController.text,
      date: selectedDate.value,
      timeSlot: selectedTime.value != null ? "${selectedTime.value!.hour}:${selectedTime.value!.minute.toString().padLeft(2, '0')}" : '',
      proposedBudget: budget.value,
      offerStatus: 'sent', // Hardcoded as per instructions
      job_state: 'sent',   // Hardcoded as per instructions
    );

    chat.messages.add(offerMsg);

    // Placeholder for timer logic
    startQuoteExpiryTimer();

    // Close bottom sheet if any
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }

    // Navigate to ChatView
    Get.off(() => ChatView(chat: chat));
  }

  @override
  void onClose() {
    taskTitleController.dispose();
    addressController.dispose();
    detailsController.dispose();
    budgetController.dispose();
    super.onClose();
  }
}
