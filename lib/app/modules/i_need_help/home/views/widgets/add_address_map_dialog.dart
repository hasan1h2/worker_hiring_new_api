import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/home_controller.dart';

class AddAddressMapDialog extends GetView<HomeController> {
  const AddAddressMapDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Add New Address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 16),
          
          // Search Bar Placeholder
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300)
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search location manually...",
                hintStyle: TextStyle(color: Colors.grey),
                icon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Interactive Map Area
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                children: [
                  Obx(() {
                    final position = controller.selectedMapLocation.value ?? const LatLng(37.7749, -122.4194);
                    return GoogleMap(
                        initialCameraPosition: CameraPosition(target: position, zoom: 14),
                        onMapCreated: controller.onMapCreated,
                        onTap: controller.updateMapPin,
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        markers: {
                          Marker(
                            markerId: const MarkerId('selected_pin'),
                            position: position,
                            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                          )
                        },
                      );
                  }),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
               Expanded(
                child: OutlinedButton(
                  onPressed: controller.fetchCurrentLocation,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    side: const BorderSide(color: Color(0xFF6CA34D), width: 1.5),
                    foregroundColor: const Color(0xFF6CA34D),
                  ),
                  child: const Text("My Location", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: controller.confirmNewLocation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6CA34D),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("Confirm Location", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ]
      )
    );
  }
}
