import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/contextual_warning_banner.dart';
import '../../payment/views/payment_view.dart';
import '../controllers/order_controller.dart';
import 'review_view.dart';

class OrderDetailView extends StatelessWidget {
  final OrderModel order;
  final isMainOrder = true;

  const OrderDetailView({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    String bannerMsg;
    Color bgCol;
    Color txtCol;
    Color icnCol;
    IconData icn;

    switch (order.status) {
      case OrderStatus.created:
        bannerMsg = "Your order is live. Wait sometimes for a request from workers.";
        bgCol = const Color(0xFFE5F0FF); // Light Blue
        txtCol = const Color(0xFF004085); // Dark Blue Text
        icnCol = const Color(0xFF007AFF); // Blue Icon
        icn = Icons.info_outline;
        break;
      case OrderStatus.progress:
        bannerMsg = "Don't share the completing OTP with your worker if the work is undone.";
        bgCol = const Color(0xFFFFE5E5); // Light Red/Pink
        txtCol = const Color(0xFFB30000); // Dark Red Text
        icnCol = const Color(0xFFFF3B30); // Red Icon
        icn = Icons.warning_amber_rounded;
        break;
      case OrderStatus.completed:
        bannerMsg = "Order completed successfully. Thank you for using our service!";
        bgCol = const Color(0xFFE8FCEC); // Light Green
        txtCol = const Color(0xFF155724); // Dark Green Text
        icnCol = const Color(0xFF28A745); // Green Icon
        icn = Icons.check_circle_outline;
        break;
      case OrderStatus.pendingConfirmation:
        bannerMsg = "Waiting for your confirmation. Please verify the completed work.";
        bgCol = const Color(0xFFFFF4E5); // Light Orange
        txtCol = const Color(0xFF663D00); // Dark Orange Text
        icnCol = const Color(0xFFFF9500); // Orange Icon
        icn = Icons.pending_actions;
        break;
      case OrderStatus.confirmed:
        bannerMsg = "Order confirmed! The worker will start the job soon.";
        bgCol = const Color(0xFFE8FCEC); // Light Green
        txtCol = const Color(0xFF155724); // Dark Green Text
        icnCol = const Color(0xFF28A745); // Green Icon
        icn = Icons.check_circle_outline;
        break;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.viewOrder.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600, // Medium-bold
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.transparent,
            ), // Hidden but maintains spacing or could be removed if design has no action icon here. I'll remove the action icon since the image has none on the right side.
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[],
          ),
        ],
      ),
      body: Column(
        children: [
          ContextualWarningBanner(
            message: bannerMsg,
            backgroundColor: bgCol,
            textColor: txtCol,
            iconColor: icnCol,
            icon: icn,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12), // Consistent tight spacing
                  _buildIconRow(order.categoryIcon, order.categoryName),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text(
                        "${AppStrings.postedBy.tr} ${order.userName ?? 'Nicolas'}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.verified,
                        color: Color(0xFF007AFF), // verified checkmark
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.location,
                        width: 14,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFF3B30), // Red map pin
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        order.location,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      SvgPicture.asset(
                        AppImages.calendar,
                        width: 14,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF6CA34D), // Greenish calendar
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat("d MMM, yyyy").format(order.date),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 16),
                      SvgPicture.asset(
                        AppImages.time,
                        width: 14,
                        colorFilter: const ColorFilter.mode(
                          Color(0xFF6CA34D), // Greenish clock
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _formatTime(order.time),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      ClipOval(
                        child: Image.asset(
                          order.userAvatar ?? AppImages.alexSmith,
                          width: 24,
                          height: 24,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        order.userName ?? "Alex Smith", // Assigned worker
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Price and Status Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.priceRange, // e.g. $90
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      _buildStatusChip(order.status),
                    ],
                  ),

                  const SizedBox(height: 12),
                  // Small grey OTP text
                  Text(
                    "${AppStrings.orderOtp.tr}: 456987",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Description Section
                  Text(
                    AppStrings
                        .details
                        .tr, // Uses the 'details' key which is now properly translated
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "I recently purchased an IKEA MICKE desk and need professional assistance with assembly. The desk is brand new and still in its original packaging. All parts, screws, and the instruction manual are included in the box.\n\nThe desk will be placed in my home office, which has enough space to work comfortably. I’m looking for someone with prior experience assembling IKEA furniture to ensure the desk is assembled correctly and securely.\n\nPlease bring your own basic tools, such as a screwdriver or power drill, to complete the assembly. All furniture parts will be ready on-site before you arrive. Free visitor parking and elevator access are available if needed.\n\nPlease bring your own basic tools (screwdriver or power drill). I’m available today after 5:00 PM, but the time is flexible if needed.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Dynamic Action Button at bottom
          if (order.status == OrderStatus.completed || order.status == OrderStatus.progress)
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (order.status == OrderStatus.completed) {
                        Get.to(() => const ReviewView(), arguments: order);
                      } else {
                        Get.to(() => const PaymentView());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6CA34D), // Leafy green
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      order.status == OrderStatus.completed
                          ? AppStrings.giveAFeedback.tr
                          : AppStrings.pay.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final int hour = time.hour == 0 ? 12 : (time.hour > 12 ? time.hour - 12 : time.hour);
    final String minute = time.minute.toString().padLeft(2, '0');
    final String period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Widget _buildIconRow(String icon, String text, {Color? iconColor}) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 18,
          colorFilter: iconColor != null
              ? ColorFilter.mode(iconColor, BlendMode.srcIn)
              : null,
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }

  Widget _buildStatusChip(OrderStatus status) {
    // Implementing purely the requested "Progress" pill style from the image instructions
    Color bg;
    Color text;
    String label;

    switch (status) {
      case OrderStatus.created:
        bg = const Color(0xFFE5F6FF);
        text = const Color(0xFF0091FF);
        label = AppStrings.created.tr;
        break;
      case OrderStatus.progress:
        bg = const Color(0xFFFFF4E5); // Light orange/peach background
        text = const Color(0xFFFF9500); // orange text
        label = AppStrings.progress.tr;
        break;
      case OrderStatus.completed:
        bg = const Color(0xFFE8FCEC);
        text = const Color(0xFF28A745);
        label = AppStrings.completed.tr;
        break;
      case OrderStatus.pendingConfirmation:
        bg = const Color(0xFFFFF4E5);
        text = const Color(0xFFFF9500);
        label = "Pending";
        break;
      case OrderStatus.confirmed:
        bg = const Color(0xFFE8FCEC);
        text = const Color(0xFF28A745);
        label = "Confirmed";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(100), // fully rounded corners
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
