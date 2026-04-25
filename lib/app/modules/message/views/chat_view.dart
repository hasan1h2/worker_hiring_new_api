import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../controllers/message_controller.dart';
import '../../main/controllers/main_controller.dart';

// --- COUNTER OFFER BOTTOM SHEET ---
void showCounterOfferBottomSheet(
    BuildContext context,
    MessageModel msg,
    MessageController controller,
    ChatModel chat,
    String currentRole,
    ) {
  final priceController = TextEditingController();
  final messageController = TextEditingController();
  final budgetAmount = 0.0.obs;

  if (msg.proposedBudget != null) {
    priceController.text = msg.proposedBudget!.toStringAsFixed(0);
    budgetAmount.value = msg.proposedBudget!;
  } else if (msg.budget != null) {
    priceController.text = msg.budget!.toStringAsFixed(0);
    budgetAmount.value = msg.budget!;
  }

  priceController.addListener(() {
    budgetAmount.value = double.tryParse(priceController.text) ?? 0.0;
  });

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter Counteroffer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Propose a new budget to the other party.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: r"$ ",
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final fee = budgetAmount.value * 0.20;
              final net = budgetAmount.value - fee;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Platform Fee (20%):",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        "-\$${fee.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Net Amount:",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${net.toStringAsFixed(2)}",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),

            const Text(
              "Message / Description",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter details about your proposal...",
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final price = double.tryParse(priceController.text) ?? 0.0;
                  final message = messageController.text.trim();

                  if (price > 0 && message.isNotEmpty) {
                    controller.sendCounterOffer(chat, msg, price, currentRole, message);
                    Get.back();
                  } else {
                    Get.snackbar(
                      "Error",
                      "Please enter a valid price and a message.",
                      backgroundColor: Colors.red.shade100,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Send Counter",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    isScrollControlled: true,
  );
}

// --- MAIN CHAT VIEW ---
class ChatView extends GetView<MessageController> {
  final ChatModel chat;
  const ChatView({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: chat.name),
      body: Column(
        children: [
          _buildTopProfileAndStatusSection(),
          Expanded(
            child: Obx(() {
              final isClientMode = Get.find<MainController>().activePhase.value == 1;
              final messageList = chat.messages.toList();

              // 🎯 ডাইনামিক লিস্ট তৈরি করা হচ্ছে ফেজ অনুযায়ী
              List<Widget> staticCards = [];

              if (isClientMode) {
                // ক্লায়েন্ট ফেজে শুধু ক্লায়েন্টের কার্ড দেখাবে
                staticCards.add(const StaticClientCounterOfferCard());
                staticCards.add(const StaticTimeChangeRequestCard());
              } else {
                // ওয়ার্কার ফেজে শুধু ওয়ার্কারের কার্ড দেখাবে
                staticCards.add(const StaticWorkerCounterOfferCard());
              }

              final totalItemCount = staticCards.length + messageList.length;

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: totalItemCount,
                itemBuilder: (context, index) {
                  // প্রথমে স্ট্যাটিক কার্ডগুলো দেখাবে
                  if (index < staticCards.length) {
                    return staticCards[index];
                  }
                  // এরপর ডাইনামিক মেসেজগুলো দেখাবে
                  return _buildMessageBubble(context, messageList[index - staticCards.length]);
                },
              );
            }),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildTopProfileAndStatusSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(chat.avatar),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat.name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (chat.isOnline)
                    Text(
                      "10 task completed",
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ],
          ),
          // CLIENT SPECIFIC CANCEL BUTTON
          Obx(() {
            final isClientMode =
                Get.find<MainController>().activePhase.value == 1;
            if (!isClientMode) return const SizedBox.shrink();

            final hasPendingRequest = chat.messages.any(
                  (m) =>
              (m.type == MessageType.offer ||
                  m.type == MessageType.quote) &&
                  m.senderRole == 'client' &&
                  (m.offerStatus == 'pending' || m.offerStatus == 'sent'),
            );

            if (!hasPendingRequest) return const SizedBox.shrink();

            return Column(
              children: [
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  alignment: Alignment.center,
                  child: const Text(
                    "STATUS: WAITING FOR RESPONSE",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(BuildContext context, MessageModel msg) {
    if (msg.quoteExpiryTime != null &&
        DateTime.now().isAfter(msg.quoteExpiryTime!) &&
        msg.offerStatus == 'pending') {
      msg.offerStatus = 'expired';
    }

    if (msg.offerStatus == 'paid') {
      return PaymentCompletedCardWidget(msg: msg);
    }
    if (msg.offerStatus == 'accepted') {
      final isClientMode = Get.find<MainController>().activePhase.value == 1;
      return QuoteAcceptedWidget(
        msg: msg,
        controller: controller,
        chat: chat,
        isClient: isClientMode,
      );
    }
    if (msg.type == MessageType.offer || msg.type == MessageType.quote) {
      return NegotiationCardWidget(
        msg: msg,
        controller: controller,
        chat: chat,
      );
    }

    return Align(
      alignment: msg.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: msg.isMe ? const Color(0xFFF2FBF0) : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: msg.isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: msg.isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Text(
          msg.text,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.border),
                ),
                child: Obx(() {
                  final isDeclinedState = controller.isDeclined.value;
                  return TextField(
                    enabled: !isDeclinedState,
                    decoration: InputDecoration(
                      hintText: isDeclinedState
                          ? "Chat deactivated"
                          : "Type a message...",
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (val) => controller.sendMessage(val),
                  );
                }),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              backgroundColor: const Color(0xFF6A9B5D),
              radius: 22,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 18),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- NEGOTIATION CARD (For Client and Worker) ---
class NegotiationCardWidget extends StatefulWidget {
  final MessageModel msg;
  final MessageController controller;
  final ChatModel chat;

  const NegotiationCardWidget({
    super.key,
    required this.msg,
    required this.controller,
    required this.chat,
  });

  @override
  State<NegotiationCardWidget> createState() => _NegotiationCardWidgetState();
}

class _NegotiationCardWidgetState extends State<NegotiationCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isClientMode = Get.find<MainController>().activePhase.value == 1;
    final currentRole = isClientMode ? 'client' : 'worker';

    final isSender = widget.msg.senderRole == currentRole;
    final hasCounterMsg = widget.msg.counterMessage != null && widget.msg.counterMessage!.isNotEmpty;

    final isTimeChange = widget.msg.isRescheduleRequest;

    final double price = widget.msg.proposedBudget ?? widget.msg.budget ?? 0.0;
    final isPending = widget.msg.offerStatus == 'pending' || widget.msg.offerStatus == 'sent';
    final isCancelled = widget.msg.offerStatus == 'cancelled';
    final isDeclined = widget.msg.offerStatus == 'declined';

    String headerText = "NEW JOB REQUEST";
    Color headerBgColor = const Color(0xFFF9F9F9);
    Color headerTextColor = Colors.black87;
    IconData headerIcon = Icons.request_quote_outlined;
    Color iconColor = AppColors.primary;

    if (isTimeChange) {
      headerText = isSender ? "YOUR TIME CHANGE REQUEST" : "TIME CHANGE REQUEST";
      headerBgColor = isSender ? Colors.purple.shade50 : Colors.purple.shade100;
      headerTextColor = Colors.purple.shade900;
      iconColor = Colors.purple.shade700;
      headerIcon = Icons.update;
    } else if (hasCounterMsg) {
      headerText = isSender ? "YOUR COUNTER OFFER" : "COUNTER OFFER RECEIVED";
      headerBgColor = isSender ? Colors.blue.shade50 : Colors.orange.shade50;
      headerTextColor = isSender ? Colors.blue.shade900 : Colors.orange.shade900;
      iconColor = isSender ? Colors.blue.shade700 : Colors.orange.shade800;
      headerIcon = Icons.handshake_outlined;
    } else if (isSender) {
      headerText = "SENT REQUEST SUMMARY";
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        width: Get.width * 0.88,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🎯 HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: headerBgColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                border: const Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Icon(headerIcon, size: 18, color: iconColor),
                  const SizedBox(width: 8),
                  Text(headerText, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: headerTextColor, letterSpacing: 0.5)),
                  const Spacer(),
                  if (isPending)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(12)),
                      child: Text(isSender ? "SENT" : "WAITING", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: headerTextColor)),
                    ),
                ],
              ),
            ),

            // 🎯 BODY
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50, width: 50,
                        decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.build_circle, color: Colors.grey, size: 30),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.msg.taskTitle ?? 'Task Details', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(widget.msg.clientRating?.toString() ?? "4.8", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  if (isTimeChange) ...[
                    Row(
                      children: [
                        Icon(Icons.history, size: 15, color: Colors.grey.shade500),
                        const SizedBox(width: 8),
                        Text("Old Time: ${widget.msg.timeSlot}", style: const TextStyle(color: Colors.grey, fontSize: 13, decoration: TextDecoration.lineThrough)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.update, size: 15, color: Colors.purple.shade600),
                        const SizedBox(width: 8),
                        Text("New Time: ${widget.msg.proposedTimeSlot}", style: TextStyle(color: Colors.purple.shade700, fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ] else ...[
                    _buildInfoRow(Icons.calendar_today_outlined, "${widget.msg.date?.toString().split(' ')[0] ?? 'Date'} @ ${widget.msg.timeSlot ?? ''}"),
                  ],

                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.location_on_outlined, widget.msg.address ?? "Location"),
                  const SizedBox(height: 6),
                  _buildInfoRow(Icons.payments_outlined, "Budget/Price: ৳${price.toStringAsFixed(0)}", isBold: true),
                  const SizedBox(height: 16),

                  const Text("Job Description", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                  const SizedBox(height: 4),
                  Text(
                    widget.msg.description ?? "Please review details.",
                    maxLines: _isExpanded ? null : 2,
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(_isExpanded ? "See less" : "See more", style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🎯 PROMINENT REASON / MESSAGE BOX
                  if (hasCounterMsg)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isSender ? Colors.blue.shade50 : (isTimeChange ? Colors.purple.shade50 : Colors.orange.shade50),
                        borderRadius: BorderRadius.circular(12),
                        border: Border(
                          left: BorderSide(
                              color: isSender ? Colors.blue.shade400 : (isTimeChange ? Colors.purple.shade400 : Colors.orange.shade400),
                              width: 5
                          ),
                          top: BorderSide(color: Colors.grey.shade200),
                          right: BorderSide(color: Colors.grey.shade200),
                          bottom: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                  Icons.format_quote_rounded,
                                  size: 18,
                                  color: isSender ? Colors.blue.shade800 : (isTimeChange ? Colors.purple.shade800 : Colors.orange.shade900)
                              ),
                              const SizedBox(width: 8),
                              Text(
                                isSender ? "Your Note / Reason:" : (isTimeChange ? "Reason for Time Change:" : "Message from Worker:"),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isSender ? Colors.blue.shade900 : (isTimeChange ? Colors.purple.shade900 : Colors.orange.shade900),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\"${widget.msg.counterMessage}\"",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              fontStyle: FontStyle.italic,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // STATUS / ACTIONS
                  if (isCancelled)
                    Column(
                      children: [
                        _buildStatus("REQUEST CANCELLED", Colors.grey),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.cancel_outlined, size: 22, color: Colors.red.shade600),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Order Cancelled", style: TextStyle(color: Colors.red.shade800, fontSize: 14, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Text("Reason: ${widget.msg.cancellationReason ?? 'No reason provided'}", style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.w500, height: 1.3)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  else if (isDeclined)
                    _buildStatus("OFFER DECLINED", Colors.red)
                  else if (!isSender && isPending)
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _buildButton("Accept", const Color(0xFF4CAF50), () => widget.controller.onAcceptQuote(widget.msg, widget.chat))),
                              const SizedBox(width: 10),
                              Expanded(child: _buildButton("Counter / Change", const Color(0xFF9E9E9E), () => showCounterOfferBottomSheet(context, widget.msg, widget.controller, widget.chat, currentRole))),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildButton("Decline", Colors.white, () => widget.controller.onDeclineQuote(widget.msg, widget.chat), isOutlined: true, textColor: Colors.red),
                        ],
                      )
                    else if (isSender && isPending)
                        _buildButton("Cancel Request", Colors.white, () => widget.controller.cancelRequest(widget.msg, widget.chat), isOutlined: true, textColor: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
    );
  }

  Widget _buildButton(String label, Color color, VoidCallback onPressed, {bool isOutlined = false, Color? textColor}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutlined ? Colors.white : color,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 12),
          side: isOutlined ? BorderSide(color: textColor ?? Colors.grey.shade400) : null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(label, style: TextStyle(color: isOutlined ? (textColor ?? Colors.black87) : Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: isBold ? Colors.black87 : AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(color: isBold ? Colors.black87 : AppColors.textSecondary, fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal))),
        ],
      ),
    );
  }
}

// --- PAY AND CONFIRM CARD (Step 10) ---
class QuoteAcceptedWidget extends StatefulWidget {
  final MessageModel msg;
  final MessageController controller;
  final ChatModel chat;
  final bool isClient;

  const QuoteAcceptedWidget({
    super.key,
    required this.msg,
    required this.controller,
    required this.chat,
    this.isClient = true,
  });

  @override
  State<QuoteAcceptedWidget> createState() => _QuoteAcceptedWidgetState();
}

class _QuoteAcceptedWidgetState extends State<QuoteAcceptedWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final double total = widget.msg.proposedBudget ?? widget.msg.budget ?? 0.0;
    final isPaid = widget.msg.offerStatus == 'paid';

    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, top: 8),
        width: Get.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4CAF50), width: 1.5),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F5E9),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Text(
                isPaid ? "STATUS: PAID SECURELY" : "STATUS: AWAITING PAYMENT",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: widget.msg.photoUrl != null
                            ? Image.network(
                          widget.msg.photoUrl!,
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/images/cleaning_service.png',
                          height: 60,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                height: 60,
                                width: 60,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.grey,
                                ),
                              ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.msg.taskTitle ?? 'Task Details',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  widget.msg.clientRating?.toString() ?? "4.8",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "JOB SUMMARY",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryItem(
                          "Category: ",
                          widget.msg.category ?? "General",
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryItem(
                          "Date: ",
                          widget.msg.date?.toString().split(' ')[0] ?? "Date Not Set",
                        ),
                        const SizedBox(height: 8),
                        _buildSummaryItem(
                          "Duration: ",
                          widget.msg.duration ?? "3 hrs",
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Job Description",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.msg.description ??
                        "This job involves general assistance. Please review the details carefully.",
                    maxLines: _isExpanded ? null : 2,
                    overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _isExpanded = !_isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        _isExpanded ? "See less" : "See more",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Final Price: \$${total.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (!isPaid) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFECB3)),
                      ),
                      child: const Text(
                        "Cancellation Policy: Full refund if canceled 24h before job start; 50% refund after 24h.",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF795548),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (widget.isClient) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => widget.controller.processPayment(widget.msg, widget.chat),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Pay and Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            widget.controller.cancelRequest(widget.msg, widget.chat);
                          },
                          child: const Text(
                            "Cancel Booking",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ] else ...[
                    Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                "Payment Completed",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 🎯 "SET HOURS" BUTTON LOGIC SEPARATION (Only Worker will see this)
                        if (!widget.isClient)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => _showSetHoursDialog(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Set Hours",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// 🎯 NEW STATIC CARDS FOR DEMONSTRATION (BASED ON PROVIDED IMAGES)
// =========================================================================

// 1. Static Card: Worker sent counter offer (Blue theme - image_de0a64.png)
class StaticWorkerCounterOfferCard extends StatelessWidget {
  const StaticWorkerCounterOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎯 TOP IDENTIFIER BADGE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  "WORKER'S SCREEN VIEW",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12),
                ),
              ],
            ),
          ),
          // Header (Blue)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              border: const Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Icon(Icons.handshake_outlined, size: 18, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  "YOUR COUNTER OFFER",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.1,
                    color: Colors.blue.shade900,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    "SENT",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/cleaning_service.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 60,
                          width: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "House Deep Cleaning",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text("4.8", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRow(Icons.category_outlined, "Furniture assembly"),
                _buildRow(Icons.location_on_outlined, "San Francisco CA"),
                _buildRow(Icons.calendar_today_outlined, "2026-04-14 @ 23:26"),

                // 🎯 Strikethrough for Old Budget & Show New Budget
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.payments_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              r"Old Budget: $50",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              r"New Budget: $40",
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const Text("Request Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  "This job involves general assistance. Please review the details carefully.",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("See more", style: TextStyle(color: Color(0xFF6DA54B), fontWeight: FontWeight.bold, fontSize: 13)),
                ),

                const SizedBox(height: 16),

                // 🎯 Reason Box + Highlighted Old/New Budget Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16, color: Colors.blue.shade800),
                          const SizedBox(width: 8),
                          Text("Budget Change Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blue.shade900)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text("Old Budget: ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(r"$50", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text("New Budget: ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(r"$40", style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Colors.black12),
                      ),
                      const Text(
                        "Reason: \"I need \$40 because of the extra cleaning supplies required for this specific task.\"",
                        style: TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.snackbar("Action", "Request Cancelled"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.red.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Cancel Request", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Static Card: Client received counter offer (Orange theme - image_de0a6b.png)
class StaticClientCounterOfferCard extends StatelessWidget {
  const StaticClientCounterOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎯 TOP IDENTIFIER BADGE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  "CLIENT'S SCREEN VIEW",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8E1), // Light Orange
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: const Row(
              children: [
                Icon(Icons.handshake_outlined, size: 18, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  "COUNTER OFFER RECEIVED",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                    letterSpacing: 1.1,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/cleaning_service.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 60,
                          width: 60,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "House Deep Cleaning",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text("4.8", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRow(Icons.category_outlined, "Furniture assembly"),
                _buildRow(Icons.location_on_outlined, "San Francisco CA"),
                _buildRow(Icons.calendar_today_outlined, "2026-04-14 @ 23:26"),

                // 🎯 Strikethrough for Old Budget & Show New Budget
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.payments_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              r"Old Budget: $50",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              r"New Budget: $40",
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                const Text("Request Details", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(
                  "This job involves general assistance. Please review the details carefully.",
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("See more", style: TextStyle(color: Color(0xFF6DA54B), fontWeight: FontWeight.bold, fontSize: 13)),
                ),

                const SizedBox(height: 16),

                // 🎯 Orange Reason Box + Highlighted Old/New Budget Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.chat_bubble_outline, size: 16, color: Colors.deepOrange),
                          SizedBox(width: 8),
                          Text("Budget Change Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.deepOrange)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text("Old Budget: ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(r"$50", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text("New Budget: ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text(r"$40", style: TextStyle(color: Colors.orange.shade900, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Colors.black12),
                      ),
                      const Text(
                        "Reason: \"I can do this job perfectly, but I charge a bit extra for the travel distance to San Francisco.\"",
                        style: TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic, height: 1.4),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.snackbar("Action", "Accepted"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Accept", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.snackbar("Action", "Counter Option Clicked"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9E9E9E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Counter", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.snackbar("Action", "Declined"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.red.shade400),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text("Decline", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 3. Static Card: Time Change Request (Image de0b21.png style)
class StaticTimeChangeRequestCard extends StatelessWidget {
  const StaticTimeChangeRequestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🎯 TOP IDENTIFIER BADGE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.visibility, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text(
                  "CLIENT'S SCREEN VIEW",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12),
                ),
              ],
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFF9F9F9),
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.description, size: 18, color: Color(0xFF4CAF50)),
                const SizedBox(width: 8),
                const Text(
                  "NEW JOB REQUEST",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1.1, color: AppColors.textPrimary),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(100)),
                  child: const Text("12h 00m", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/images/cleaning_service.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 60, width: 60, color: Colors.grey.shade200,
                          child: const Icon(Icons.image_outlined, color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Assemble an IKEA Desk", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text("4.8 (32 reviews)", style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildRow(Icons.category_outlined, "Furniture assembly"),
                _buildRow(Icons.location_on_outlined, "San Francisco CA"),

                // 🎯 Strikethrough for Old Date/Time & Show New Time
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              "Old Date & Time: 12 Feb, 2026 @ 10:00 AM",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "New Date and Time: 12:00 PM, 12 Feb, 2026",
                              style: TextStyle(
                                color: Colors.red.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                _buildRow(Icons.payments_outlined, r"Budget: $50"),

                const SizedBox(height: 12),
                const Text("Job Description", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(
                  "This job involves assembling a large IKEA Bekant corner desk. All tools are provided, but experience with furniture assembly is preferred. The task should take approximately 2 hours.",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Text("See more", style: TextStyle(color: Color(0xFF6DA54B), fontWeight: FontWeight.bold, fontSize: 13)),
                ),

                const SizedBox(height: 16),

                // Highlighted Red Text
                const Text(
                  'Request for new date and time for the job',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.error),
                ),
                const SizedBox(height: 10),

                // 🎯 Reason Box + Highlighted Old/New Time Details
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.history, size: 16, color: Colors.red.shade800),
                          const SizedBox(width: 8),
                          Text("Time Change Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.red.shade900)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Text("Old Date & Time: ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text("12 Feb, 2026 @ 10:00 AM", style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough, fontSize: 13)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text("New Date and Time: ", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w600)),
                          Text("12:00 PM, 12 Feb, 2026", style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Divider(height: 1, color: Colors.black12),
                      ),
                      const Text(
                        "Reason: \"I have another booking at 10:00 AM. Can we schedule this at 12:00 PM instead?\"",
                        style: TextStyle(fontSize: 14, color: Colors.black87, fontStyle: FontStyle.italic, height: 1.4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.snackbar("Accepted", "Job request accepted!"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Accept", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Get.snackbar("Declined", "Job request declined."),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF9E9E9E),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Decline", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildRow(IconData icon, String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}

// --- HELPER DIALOGS ---
void _showSetHoursDialog(BuildContext context) {
  final hoursController = TextEditingController();
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set Hours Worked",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "Enter the actual hours spent on the task.",
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: hoursController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                suffixText: "hrs ",
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final hours = hoursController.text;
                  if (hours.isNotEmpty) {
                    Get.back();
                    Get.snackbar(
                      "Saved",
                      "Total hours set to $hours",
                      backgroundColor: Colors.green.shade100,
                      colorText: Colors.green.shade900,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// --- STATIC PAYMENT COMPLETED CARD ---
class PaymentCompletedCardWidget extends StatefulWidget {
  final MessageModel? msg;

  const PaymentCompletedCardWidget({super.key, this.msg});

  @override
  State<PaymentCompletedCardWidget> createState() => _PaymentCompletedCardWidgetState();
}

class _PaymentCompletedCardWidgetState extends State<PaymentCompletedCardWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final double total = widget.msg?.proposedBudget ?? widget.msg?.budget ?? 50.0;

    // 🎯 Client check for the payment completed screen
    final isClientMode = Get.find<MainController>().activePhase.value == 1;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Paid Securely
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Center(
              child: Text(
                "STATUS: PAID SECURELY",
                style: TextStyle(
                  color: Color(0xFF2E7D32),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Part 1: Job Photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: widget.msg?.photoUrl != null
                          ? Image.network(
                        widget.msg!.photoUrl!,
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      )
                          : Image.asset(
                        'assets/images/cleaning_service.png',
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Container(
                              height: 60,
                              width: 60,
                              color: Colors.grey.shade200,
                              child: const Icon(
                                Icons.image_outlined,
                                color: Colors.grey,
                              ),
                            ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.msg?.taskTitle ?? 'Furniture Assembly',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF1E1E1E),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Part 2: Client Rating
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.msg?.clientRating?.toString() ?? "4.8",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Job Summary Grey Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        Icons.work_outline,
                        "Category: ${widget.msg?.category ?? "Furniture Assembly"}",
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        Icons.calendar_today_outlined,
                        "Date: ${widget.msg?.date?.toString().split(' ')[0] ?? "2026-04-17"}",
                      ),
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        Icons.access_time,
                        "Duration: ${widget.msg?.duration ?? "3 hrs"}",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Expandable Description
                const Text(
                  "Job Description",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF757575),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.msg?.description ??
                      "This job involves assembling a large IKEA Bekant corner desk. All tools are provided, but experience with furniture assembly is preferred.",
                  maxLines: _isExpanded ? null : 2,
                  overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.4,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _isExpanded = !_isExpanded),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      _isExpanded ? "See less" : "See more",
                      style: const TextStyle(
                        color: Color(0xFF6DA54B),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Final Price
                Center(
                  child: Text(
                    "Final Price: \$${total.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Payment Completed Badge
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF2E7D32),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Payment Completed",
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 🎯 Set Hours Action Button (ONLY VISIBLE TO WORKER PHASE)
                if (!isClientMode)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showSetLogHoursBottomSheet(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A237E), // Deep Blue
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Set Hours",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF757575)),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF1E1E1E),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

void _showSetLogHoursBottomSheet(BuildContext context) {
  String? selectedHours;
  final TextEditingController notesController = TextEditingController();

  Get.bottomSheet(
    isScrollControlled: true,
    StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    "Set Logged Hours",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "Set Work Hours Required for This Task",
                    style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 32),
                const Text(
                  "Select Hours",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: selectedHours,
                  hint: const Text(
                    "Select hours",
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  items:
                  [
                    '1 Hour',
                    '1.5 Hours',
                    '2 Hours',
                    '2.5 Hours',
                    '3 Hours',
                    '4 Hours',
                    '5 Hours',
                    '6 Hours',
                    '7 Hours',
                    '8 Hours',
                    '9 Hours',
                    '10+ Hours',
                  ].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedHours = newValue;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Additional Notes (Optional)",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: "Enter details about the work performed...",
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (selectedHours == null) {
                        Get.snackbar(
                          "Error",
                          "Please select the hours worked.",
                          backgroundColor: Colors.redAccent,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      Get.back();
                      Get.snackbar(
                        "Status Updated",
                        "Work hours ($selectedHours) logged successfully!",
                        backgroundColor: Colors.green.shade100,
                        colorText: Colors.green.shade900,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6DA54B),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Confirm Hours",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    ),
  );
}