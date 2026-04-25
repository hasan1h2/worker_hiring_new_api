import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../routes/app_pages.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../common/payout/views/payout_view.dart';
import '../controllers/worker_profile_controller.dart';
import 'worker_account_view.dart';
import '../../../i_need_help/profile/views/worker_billing_list_view.dart';
import 'worker_report_view.dart';
import 'worker_support_ticket_view.dart';
import 'worker_support_ticket_history_view.dart';
import '../../saved_tasks/views/saved_tasks_view.dart';

class WorkerProfileView extends GetView<WorkerProfileController> {
  const WorkerProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: AppStrings.profile.tr,
        showLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Get.toNamed(Routes.WORKER_SETTINGS),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 32),
            _buildAboutSection(),
            const SizedBox(height: 32),
            _buildPricingSection(),
            const SizedBox(height: 32),
            _buildAccountStatusSection(),
            const SizedBox(height: 32),
            _buildAvailabilitySection(),
            const SizedBox(height: 32),
            _buildSkillsSection(),
            const SizedBox(height: 32),
            _buildPortfolioSection(),
            const SizedBox(height: 32),
            _buildReviewsSection(),
            const SizedBox(height: 100), // Spacing for bottom button
          ],
        ),
      ),
      // bottomNavigationBar: _buildBottomButton(),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF6CA34D),
                width: 1,
              ),
            ),
            child: const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(AppImages.alexSmith),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Alex Smith',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, color: Colors.redAccent, size: 16),
              SizedBox(width: 4),
              Text(
                'San Francisco, CA • 2.5 km away',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Professional house assistant with over 5 years of experience in furniture assembly and general maintenance. Dedicated to providing high-quality service and ensuring client satisfaction.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.account_balance_wallet_outlined,
                            color: Color(0xFF6CA34D), size: 24),
                        const SizedBox(height: 8),
                        const Text(
                          'Hourly Rate',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          r'$30/hr',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  width: 1,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.access_time,
                            color: Color(0xFF6CA34D), size: 24),
                        const SizedBox(height: 8),
                        const Text(
                          'Min. Booking',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '2 Hours',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.shade300,
                  thickness: 1,
                  width: 1,
                ),

                // --- CHANGED FROM STRIKES TO COMPLETE RATE ---
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Column(
                      children: [
                        const Icon(Icons.check_circle_outline, // Changed Icon
                            color: Color(0xFF6CA34D), size: 24), // Changed color to match theme
                        const SizedBox(height: 8),
                        const Text(
                          'Complete Rate', // Changed title
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          '${controller.completionRate.value}%', // Updated variable and added %
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ),
                ),
                // ----------------------------------------------

              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Status',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Current Strike Count',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Obx(() => Text(
                        '${controller.strikes.value}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Warning',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '1 more strike may reduce your visibility.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Availability',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: days.map((day) {
              Color bgColor;
              Color borderColor;
              Color textColor;

              if (day == 'Tue') {
                // Booked
                bgColor = Colors.red.shade50;
                borderColor = Colors.red.shade100;
                textColor = Colors.red.shade400;
              } else if (day == 'Sat' || day == 'Sun') {
                // Unavailable
                bgColor = Colors.grey.shade100;
                borderColor = Colors.grey.shade200;
                textColor = Colors.grey.shade400;
              } else {
                // Available
                bgColor = const Color(0xFFF0F9EA);
                borderColor = const Color(0xFF6CA34D).withOpacity(0.3);
                textColor = const Color(0xFF6CA34D);
              }

              return Container(
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildLegendItem(const Color(0xFF6CA34D), 'Available'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.red.shade400, 'Booked'),
            const SizedBox(width: 16),
            _buildLegendItem(Colors.grey.shade400, 'Unavailable'),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSkillsSection() {
    final skills = ['Home assistance', 'Furniture assembly', 'General cleaning'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Skills',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: skills.map((skill) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF6CA34D)),
              ),
              child: Text(
                skill,
                style: const TextStyle(
                  color: Color(0xFF6CA34D),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Portfolio',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View all',
                style: TextStyle(
                  color: Color(0xFF6CA34D),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.image_outlined,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: List.generate(
                    5,
                    (index) => const Icon(Icons.star,
                        color: Colors.amber, size: 16),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '35 Reviews',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 200,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              Icon(Icons.star, color: Colors.amber, size: 12),
                              Icon(Icons.star, color: Colors.amber, size: 12),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '"Very professional and efficient!"',
                            style: TextStyle(
                                fontSize: 12, fontStyle: FontStyle.italic),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Widget _buildBottomButton() {
  //   return Container(
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.05),
  //           blurRadius: 10,
  //           offset: const Offset(0, -5),
  //         ),
  //       ],
  //     ),
  //     // child: SafeArea(
  //     //   // child: ElevatedButton(
  //     //   //   onPressed: () {},
  //     //   //   style: ElevatedButton.styleFrom(
  //     //   //     backgroundColor: const Color(0xFF6CA34D),
  //     //   //     minimumSize: const Size(double.infinity, 56),
  //     //   //     shape: RoundedRectangleBorder(
  //     //   //       borderRadius: BorderRadius.circular(12),
  //     //   //     ),
  //     //   //     elevation: 0,
  //     //   //   ),
  //     //   //   child: const Text(
  //     //   //     'Request this helper',
  //     //   //     style: TextStyle(
  //     //   //       fontSize: 16,
  //     //   //       fontWeight: FontWeight.bold,
  //     //   //       color: Colors.white,
  //     //   //     ),
  //     //   //   ),
  //     //   // ),
  //     // ),
  //   );
  // }
}
