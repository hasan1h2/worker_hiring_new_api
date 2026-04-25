import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MapPickerView extends StatefulWidget {
  const MapPickerView({super.key});

  @override
  State<MapPickerView> createState() => _MapPickerViewState();
}

class _MapPickerViewState extends State<MapPickerView> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(23.758353, 90.374057); // Default: Dhaka
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => _isLoading = false);
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() => _isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => _isLoading = false);
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _selectedLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(_selectedLocation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location".tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Get.back(result: _selectedLocation);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: (latLng) {
              setState(() {
                _selectedLocation = latLng;
              });
            },
            markers: {
              Marker(
                markerId: const MarkerId("selected_location"),
                position: _selectedLocation,
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Get.back(result: _selectedLocation);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6CA34D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "Confirm Location".tr,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
