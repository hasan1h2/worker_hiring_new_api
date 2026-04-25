import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/home_header.dart';
import '../../../main/controllers/main_controller.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/home_controller.dart';
import '../inner_widget/home_baner/home_banner.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(), // Added Header
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HomeBanner(),
                    const HomeSearchBar(),
                    const HomeMyActivitySection(),
                    _buildServiceGrid(),
                    const HomeCategoryGrid(),
                    const RecommendedHelpersSection(),
                    const RecentActivitySection(),
                    const SizedBox(
                      height: 120,
                    ), // Space for the floating button
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceGrid() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.serviceCategory.tr,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.servicesCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 1.1,
            ),
            itemBuilder: (context, index) {
              final service = controller.servicesCategories[index];

              return Obx(() {
                final isSelected =
                    controller.selectedCategory.value == service['label'];
                return InkWell(
                  onTap: () {
                    controller.selectCategory(service['label'] as String);
                    Get.toNamed(Routes.HELPER_LIST, arguments: (service['label'] as String).tr);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF6CA34D)
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                service['icon'] as String,
                                width: 40,
                                height: 40,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                (service['label'] as String).tr,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withAlpha(128), // 0.5 opacity
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.check_circle,
                                color: Color(0xFF6CA34D),
                                size: 32,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }
}

class HomeMyActivitySection extends StatelessWidget {
  const HomeMyActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activityData = [
      {
        "title": "Active Jobs",
        "value": "2",
        "icon": Icons.work_outline,
        "color": Colors.blue
      },
      {
        "title": "Completed",
        "value": "12",
        "icon": Icons.check_circle_outline,
        "color": Colors.green
      },
      {
        "title": "Total Spent",
        "value": r"$340",
        "icon": Icons.account_balance_wallet_outlined,
        "color": Colors.purple
      },
      {
        "title": "My Rating",
        "value": "4.8",
        "icon": Icons.star_outline,
        "color": Colors.orange
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "My Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activityData.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 2.2,
            ),
            itemBuilder: (context, index) {
              final data = activityData[index];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (data['color'] as Color).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        data['icon'] as IconData,
                        size: 20,
                        color: data['color'] as Color,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['title'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            data['value'] as String,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search for services, helpers...",
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

class HomeCategoryGrid extends StatelessWidget {
  const HomeCategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> extraCategories = [
      {'icon': Icons.cleaning_services, 'label': 'Cleaning'},
      {'icon': Icons.plumbing, 'label': 'Plumbing'},
      {'icon': Icons.electric_bolt, 'label': 'Electrical'},
      {'icon': Icons.local_shipping, 'label': 'Moving'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "More Categories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: extraCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              childAspectRatio: 0.8,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F9F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Icon(extraCategories[index]['icon'] as IconData, color: const Color(0xFF6CA34D)),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    extraCategories[index]['label'] as String,
                    style: const TextStyle(fontSize: 12),
                    textAlign: TextAlign.center,
                  )
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecommendedHelpersSection extends StatelessWidget {
  const RecommendedHelpersSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Formula: (rating * 0.4) + (response rate * 0.3) + (distance weight * 0.3)
    final List<Map<String, dynamic>> dummyHelpers = [
      {"name": "Alice Smith", "rating": 4.8, "responseRate": 4.5, "distanceWeight": 4.0, "avatar": "A"},
      {"name": "Bob Jones", "rating": 4.2, "responseRate": 4.8, "distanceWeight": 3.5, "avatar": "B"},
      {"name": "Charlie Day", "rating": 5.0, "responseRate": 5.0, "distanceWeight": 4.8, "avatar": "C"},
    ];

    dummyHelpers.sort((a, b) {
      double scoreA = (a["rating"] * 0.4) + (a["responseRate"] * 0.3) + (a["distanceWeight"] * 0.3);
      double scoreB = (b["rating"] * 0.4) + (b["responseRate"] * 0.3) + (b["distanceWeight"] * 0.3);
      return scoreB.compareTo(scoreA); // Descending order
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended Helpers",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dummyHelpers.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final helper = dummyHelpers[index];
              final double score = (helper["rating"] * 0.4) + (helper["responseRate"] * 0.3) + (helper["distanceWeight"] * 0.3);
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF6CA34D).withOpacity(0.2),
                      child: Text(helper["avatar"], style: const TextStyle(color: Color(0xFF6CA34D), fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(helper["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star, size: 14, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text("${helper["rating"]}  •  Smart Score: ${score.toStringAsFixed(2)}", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            ],
                          )
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Colors.grey),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> activities = [
      {"title": "Viewed Profile: Alice Smith", "time": "2 hours ago", "icon": Icons.person_search},
      {"title": "Searched for 'Plumbing'", "time": "5 hours ago", "icon": Icons.search},
      {"title": "Completed task: Home Cleaning", "time": "2 days ago", "icon": Icons.check_circle_outline},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recent Activity",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(activity["icon"] as IconData, color: Colors.blue, size: 20),
                ),
                title: Text(activity["title"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                subtitle: Text(activity["time"], style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              );
            },
          )
        ],
      ),
    );
  }
}
