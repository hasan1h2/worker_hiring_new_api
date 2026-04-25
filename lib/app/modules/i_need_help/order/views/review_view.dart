import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../routes/app_pages.dart';

class ReviewView extends StatefulWidget {
  const ReviewView({super.key});

  @override
  State<ReviewView> createState() => _ReviewViewState();
}

class _ReviewViewState extends State<ReviewView> {
  int _selectedRating = 0;
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          AppStrings.review.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              AppStrings.rateExperience.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              AppStrings.feedbackDesc.tr,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              AppStrings.rateMark.tr,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRating = index + 1;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.star_rounded,
                      size: 40,
                      color: index < _selectedRating
                          ? const Color(0xFFFFC107) // Amber/Gold
                          : const Color(0xFFE0E0E0), // Grey
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Container(
              height: 150,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _feedbackController,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: AppStrings.shareExperienceHint.tr,
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedRating == 0) {
                    Get.snackbar(
                      AppStrings.rateExpTitle.tr,
                      AppStrings.pleaseSelectRating.tr,
                    );
                    return;
                  }
                  // Double-Blind Protocol Mock
                  Get.back(); // Or Get.toNamed(Routes.FEEDBACK_SUCCESS);
                  Get.snackbar(
                    "Review Submitted", 
                    "Your review is saved but hidden.\nUnder the Double-Blind policy, it will only become public once the other party reviews you, or 14 days pass.",
                    duration: const Duration(seconds: 6),
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.blueGrey.shade800,
                    colorText: Colors.white,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  AppStrings.submitReview.tr,
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
    );
  }
}
