import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_strings.dart';
class TaskSuccessCoustomView extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subTitle1;
  final String subTitleNum1;
  final String subTitle2;
  final String subTitleNum2;
  final String buttonTitle;
  final bool isOrder;
  final VoidCallback onTap;
  const TaskSuccessCoustomView({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subTitle1,
    required this.subTitleNum1,
    required this.subTitle2,
    required this.subTitleNum2,
    required this.buttonTitle,
    required this.onTap,  this.isOrder=true,
  });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFCBEFB6,
      ), // Light green background from design
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 80),

              // "Let's Go" Text added to match design requirements and avoid image bleed
              Text(
                AppStrings.letsGo.tr,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1C1E),
                ),
              ),
              const SizedBox(height: 10),

              // "Let's Go" Image
              Image.asset(
                imagePath,
                height: 200,
                fit: BoxFit.contain,
              ), // Assuming 'successful.png' contains the text "Let's Go" logic or similar. If not, text widget.
              // Design shows big "Let's Go" which looks like graphic text.

              const Spacer(),
              Text(
                title.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Color(0xFF1B1C1E)),
              ),

              const SizedBox(height: 40),

              _buildStepRow(subTitleNum1, subTitle1.tr),
              const SizedBox(height: 16),
              _buildStepRow(subTitleNum2, subTitle2.tr),

              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B1C1E), // Black button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      buttonTitle.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Bottom Indicator bar simulation
              Container(
                width: 140,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepRow(String number, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 24,
          height: 24,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF1B1C1E),
            shape: BoxShape.circle,
          ),
          child: Text(
            number,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B1C1E),
          ),
        ),
      ],
    );
  }
}