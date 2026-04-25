import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../main/controllers/main_controller.dart';
import '../views/widgets/location_list_bottom_sheet.dart';
import '../views/widgets/add_address_map_dialog.dart';

class HomeController extends GetxController {
  final _storage = GetStorage();
  final RxString selectedRole = AppStrings.iNeedHelp.obs;
  final RxInt currentBannerIndex = 0.obs;
  late final PageController bannerPageController;
  Timer? _timer;

  // --- Location Selection Logic ---
  final RxString currentAddress = 'San Francisco'.obs;
  final RxList<String> userAddresses = <String>[
    'San Francisco',
    '75 Wellington Street, ON K1A 0A2',
    'Home, 123 Main St, Apt 4B'
  ].obs;

  final Rx<LatLng?> selectedMapLocation = Rx<LatLng?>(null);
  Completer<GoogleMapController> mapController = Completer();

  final List<String> bannerImages = [
    AppImages.homeBanner,
    AppImages.homeBanner,
    AppImages.homeBanner,
  ];

  final List<Map<String, dynamic>> servicesCategories = [
    {'icon': AppImages.furnitureAssembly, 'label': AppStrings.furnitureAssembly},
    {'icon': AppImages.homeAssistance, 'label': AppStrings.homeAssistance},
    {'icon': AppImages.minorRepairs, 'label': AppStrings.minorRepairs},
    {'icon': AppImages.petServices, 'label': AppStrings.petServices},
    {'icon': AppImages.companionService, 'label': AppStrings.companionService},
    {'icon': AppImages.marketingPromotion, 'label': AppStrings.marketingPromotion},
    {'icon': AppImages.lockSmith, 'label': AppStrings.lockSmith},
    {'icon': AppImages.gardenCleaning, 'label': AppStrings.gardenCleaning},
  ];

  final RxString selectedCategory = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final savedRole = _storage.read('userRole');
    if (savedRole != null) {
      selectedRole.value = savedRole;
    }
    selectedCategory.value = '';
    bannerPageController = PageController(initialPage: 0);
    _startAutoPlay();
  }

  @override
  void onClose() {
    _timer?.cancel();
    bannerPageController.dispose();
    super.onClose();
  }

  // --- Navigation Location Handlers ---
  
  void selectAddress(String address) {
    currentAddress.value = address;
    Get.back(); // close bottom sheet
  }

  void deleteAddress(int index) {
    if (index >= 0 && index < userAddresses.length) {
      String addressToRemove = userAddresses[index];
      userAddresses.removeAt(index);
      
      if (currentAddress.value == addressToRemove) {
        if (userAddresses.isNotEmpty) {
          currentAddress.value = userAddresses.first;
        } else {
          currentAddress.value = 'Select an address';
        }
      }
    }
  }

  void openLocationList() {
    Get.bottomSheet(
      const LocationListBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void openAddNewAddressMap() {
    Get.back(); // Close previous bottom sheet first
    selectedMapLocation.value = const LatLng(37.7749, -122.4194); // Default SF
    Get.bottomSheet(
      const AddAddressMapDialog(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false, // Ensure inner map gestuers work nicely
    );
  }

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
       mapController.complete(controller);
    }
  }

  void updateMapPin(LatLng position) {
    selectedMapLocation.value = position;
  }

  Future<void> fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('Error', 'Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Error', 'Location permissions are denied');
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Error', 'Location permissions are permanently denied.');
      return;
    } 

    Get.snackbar('Loading', 'Fetching GPS location...', snackPosition: SnackPosition.TOP);
    
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    
    LatLng currentLatLng = LatLng(position.latitude, position.longitude);
    selectedMapLocation.value = currentLatLng;
    
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: currentLatLng, zoom: 16),
    ));
  }

  Future<void> confirmNewLocation() async {
    if (selectedMapLocation.value == null) {
      Get.snackbar("Error", "Please drop a pin on the map first.");
      return;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      
      // Reverse Geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        selectedMapLocation.value!.latitude, 
        selectedMapLocation.value!.longitude
      );
      
      Get.back(); // close loading

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String formattedAddress = "${place.street}, ${place.locality}, ${place.administrativeArea}";
        
        userAddresses.add(formattedAddress);
        currentAddress.value = formattedAddress;
        
        Get.back(); // close map sheet
        Get.snackbar("Success", "New address saved!");
      } else {
        Get.snackbar("Error", "Could not fetch address for this location.");
      }
    } catch (e) {
      Get.back(); // close loading if errored
      
      // Fallback for demo testing specifically if Keys aren't configured yet
      String fallbackAddress = "Custom Location (${selectedMapLocation.value!.latitude.toStringAsFixed(2)}, ${selectedMapLocation.value!.longitude.toStringAsFixed(2)})";
      userAddresses.add(fallbackAddress);
      currentAddress.value = fallbackAddress;
      
      Get.back();
      Get.snackbar("Notice", "Geocoding failed (likely missing API keys). Location saved as raw coordinate point safely.");
    }
  }

  // --- Banner & General ---

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (currentBannerIndex.value < bannerImages.length - 1) {
        currentBannerIndex.value++;
      } else {
        currentBannerIndex.value = 0;
      }
      if (bannerPageController.hasClients) {
        bannerPageController.animateToPage(
          currentBannerIndex.value,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  void onBannerPageChanged(int index) {
    currentBannerIndex.value = index;
  }

  void setRole(String role) {
    selectedRole.value = role;
    _storage.write('userRole', role);
    if (role == AppStrings.iWantToWork) {
      if (Get.isRegistered<MainController>()) {
        Get.find<MainController>().changePhase(2);
      } else {
        Get.offAllNamed('/dashboard'); 
      }
    } else {
      if (Get.isRegistered<MainController>()) {
        Get.find<MainController>().changePhase(1);
      }
    }
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void changeLanguage(String langCode) {
    if (langCode == 'en') {
      Get.updateLocale(const Locale('en', 'US'));
      _storage.write('lang', 'en');
    } else {
      Get.updateLocale(const Locale('zh', 'CN'));
      _storage.write('lang', 'zh');
    }
  }

  void createAccount() {
    Get.toNamed('/sign-up');
  }

  void proceedToCreateTask() {
    if (selectedCategory.value.isEmpty) {
      Get.toNamed('/create-task');
    } else {
      Get.toNamed(
        '/create-task',
        arguments: {'category': selectedCategory.value},
      );
    }
  }

  void onBannerChanged(int index) {
    currentBannerIndex.value = index;
  }
}
