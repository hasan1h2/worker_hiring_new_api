import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/home_controller.dart';

class LocationListBottomSheet extends GetView<HomeController> {
  const LocationListBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Location',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          _buildAddressList(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.openAddNewAddressMap(),
              icon: const Icon(Icons.add),
              label: const Text('Add New Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6CA34D),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddressList() {
    return Obx(() {
      if (controller.userAddresses.isEmpty) {
        return const Padding(
           padding: EdgeInsets.symmetric(vertical: 20),
           child: Text("No saved addresses.", style: TextStyle(color: Colors.grey)),
        );
      }
      
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.userAddresses.length,
        separatorBuilder: (_, __) => const Divider(height: 1, color: Color(0xFFEEEEEE)),
        itemBuilder: (context, index) {
          final address = controller.userAddresses[index];
          final isSelected = address == controller.currentAddress.value;
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.location_on, 
              color: isSelected ? const Color(0xFF6CA34D) : Colors.grey.shade400
            ),
            title: Text(
              address, 
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.black : Colors.black87
              )
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF6CA34D)),
                if (isSelected) const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                  onPressed: () => controller.deleteAddress(index),
                ),
              ],
            ),
            onTap: () => controller.selectAddress(address),
          );
        },
      );
    });
  }
}
