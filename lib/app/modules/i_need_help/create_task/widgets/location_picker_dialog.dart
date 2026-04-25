import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_strings.dart';

class LocationPickerDialog extends StatelessWidget {
  final VoidCallback onLocationSelected;

  const LocationPickerDialog({
    super.key,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Map Section
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  'http://googleusercontent.com/image_collection/image_retrieval/15724683379604930525_0',
                  height: 280,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 280,
                      width: double.infinity,
                      color: const Color(0xFFEDF1F5),
                      child: const Center(
                        child: Icon(Icons.map_outlined, size: 54, color: Color(0xFF9E9E9E)),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Search TextField
              const TextField(
                decoration: InputDecoration(
                  hintText: "Search location manually...",
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),

              // Confirm Location Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onLocationSelected,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6CA34D), // Dark leafy green
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.confirmLocation.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // My Location Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Mock GPS detection
                    Get.snackbar("GPS", "Location detected successfully.");
                    onLocationSelected();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF96D268), // Light green
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    AppStrings.myLocation.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}
