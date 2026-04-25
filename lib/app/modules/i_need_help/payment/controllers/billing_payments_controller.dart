import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentMethod {
  final String id;
  final String last4;
  final String type; // Visa, Mastercard, Amex
  final String icon;

  PaymentMethod({
    required this.id,
    required this.last4,
    required this.type,
    required this.icon,
  });
}

class VoucherModel {
  final String id;
  final String amount;
  final String title;
  final String code;

  VoucherModel({
    required this.id,
    required this.amount,
    required this.title,
    required this.code,
  });
}

class BillingPaymentsController extends GetxController {
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  
  // Voucher Reactive Variables
  final RxList<VoucherModel> availableVouchers = <VoucherModel>[].obs;
  final Rx<VoucherModel?> selectedVoucher = Rx<VoucherModel?>(null);
  final TextEditingController voucherCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
    _loadDummyVouchers();
  }

  void _loadDummyData() {
    // delay to simulate API
    Future.delayed(const Duration(milliseconds: 500), () {
      paymentMethods.value = [
        PaymentMethod(
          id: '1',
          last4: '9380',
          type: 'Visa',
          icon: 'assets/icons/icon_visa.svg',
        ),
      ];
    });
  }

  void _loadDummyVouchers() {
    availableVouchers.value = [
      VoucherModel(id: '1', amount: '\$100', title: '\$100 Discount', code: 'GET\$100'),
      VoucherModel(id: '2', amount: '\$200', title: '\$200 Discount', code: 'PROMO200'),
      VoucherModel(id: '3', amount: '\$300', title: '\$300 Discount', code: 'SAVE300'),
    ];
  }

  void selectVoucher(VoucherModel voucher) {
    selectedVoucher.value = voucher;
  }

  void applyNewVoucherCode(String code) {
    if (code.trim().isNotEmpty) {
      final newVoucher = VoucherModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: '\$50', // Default amount for new vouchers
        title: '\$50 Discount',
        code: code.trim().toUpperCase(),
      );
      availableVouchers.add(newVoucher);
      voucherCodeController.clear();
      Get.snackbar("Success", "Voucher $code applied successfully",
          snackPosition: SnackPosition.BOTTOM);
    } else {
      Get.snackbar("Error", "Please enter a voucher code",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void editPaymentMethod(String id) {
    // Logic to edit payment method
  }

  void removePaymentMethod(String id) {
    Get.defaultDialog(
      title: 'Remove Payment Method',
      middleText: 'Are you sure you want to remove this payment method?',
      textCancel: 'Cancel',
      textConfirm: 'Remove',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        paymentMethods.removeWhere((element) => element.id == id);
        Get.back();
      },
    );
  }

  @override
  void onClose() {
    voucherCodeController.dispose();
    super.onClose();
  }
}
