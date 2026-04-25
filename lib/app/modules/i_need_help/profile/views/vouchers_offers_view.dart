import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/vouchers_offers_controller.dart';
import '../../../../data/models/voucher_model.dart';
import '../../../../core/constants/app_colors.dart';

class VouchersOffersView extends GetView<VouchersOffersController> {
  const VouchersOffersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Vouchers & offers',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Top Cards
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildTopCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() => Text(
                              'Tk ${controller.totalSaved.value.toInt()}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )),
                        const SizedBox(height: 4),
                        const Text(
                          'Saved this month',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => _showAddVoucherBottomSheet(context),
                    child: _buildTopCard(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.confirmation_num_outlined, color: Colors.black54),
                          const SizedBox(width: 8),
                          const Text(
                            'Add a Voucher',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Voucher List
          Expanded(
            child: Obx(() => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: controller.allVouchers.length,
                  itemBuilder: (context, index) {
                    return VoucherCard(voucher: controller.allVouchers[index]);
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCard({required Widget child}) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }

  Widget _buildFilterChip(String label, {bool isDropdown = false}) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == label;
      return GestureDetector(
        onTap: () => controller.setFilter(label),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF6A9B5D) : Colors.grey.shade300,
            ),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: Colors.black,
                ),
              ),
              if (isDropdown) ...[
                const SizedBox(width: 4),
                const Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey),
              ],
            ],
          ),
        ),
      );
    });
  }

  void _showAddVoucherBottomSheet(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    final RxBool isButtonEnabled = false.obs;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Add a Voucher',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                labelText: 'Voucher code',
                labelStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF6A9B5D)),
                ),
              ),
              onChanged: (value) {
                isButtonEnabled.value = value.trim().isNotEmpty;
              },
            ),
            const SizedBox(height: 24),
            Obx(() => SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: isButtonEnabled.value
                        ? () {
                            controller.addVoucher(codeController.text);
                            Get.back();
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A9B5D),
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Add',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isButtonEnabled.value ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class VoucherCard extends StatelessWidget {
  final VoucherModel voucher;

  const VoucherCard({super.key, required this.voucher});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ticket Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63), // Magenta match
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Icon(Icons.confirmation_num, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                // Voucher Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${voucher.code} : ${voucher.discountAmount.toInt()} TK OFF ON ${voucher.minSpend.toInt()}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Tk ${voucher.discountAmount.toInt()}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.info_outline, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            voucher.merchantName,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Dashed Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                30,
                (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
          // Bottom section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                    children: [
                      TextSpan(
                        text: 'Min. spend Tk ${voucher.minSpend.toInt()} • ',
                        style: const TextStyle(color: Colors.black54),
                      ),
                      TextSpan(
                        text: 'Expires on ${DateFormat('d MMM yyyy').format(voucher.expiryDate)}',
                        style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'Use now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6A9B5D),
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
}
