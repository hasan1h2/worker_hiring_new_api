import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../controllers/payout_controller.dart';

class PayoutView extends GetView<PayoutController> {
  const PayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PayoutController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            "Payout Methods",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            isScrollable: true,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: "Payout Settings"),
              Tab(text: "Tax Documents"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPayoutSettingsTab(),
            _buildTaxDocumentsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          "Payout Methods",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.account_balance, color: AppColors.primary),
          title: const Text("Bank Account ending in 1234"),
          subtitle: const Text("Primary Method"),
          trailing: TextButton(onPressed: () {}, child: const Text("Edit")),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text("Add Payment Method"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTaxDocumentsTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text(
          "Tax Information",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        _buildTextField("Name"),
        const SizedBox(height: 16),
        _buildTextField("Date submitted", hint: "MM/DD/YYYY"),
        const SizedBox(height: 16),
        _buildTextField("Tax country/region"),
        const SizedBox(height: 16),
        _buildTextField("Tax ID number / SIN"),
        const SizedBox(height: 16),
        _buildTextField("Date of Birth", hint: "MM/DD/YYYY"),
        const SizedBox(height: 16),
        _buildTextField("Country/Region of Birth"),
        const SizedBox(height: 16),
        _buildTextField("Primary Residence Address", maxLines: 3),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: const Text(
            "Save Tax Documents",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, {String? hint, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint ?? label,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}
