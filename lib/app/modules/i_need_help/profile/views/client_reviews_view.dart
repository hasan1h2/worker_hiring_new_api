import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../routes/app_pages.dart';
import '../../../../data/models/helper_model.dart';
import 'package:intl/intl.dart'; 

class ClientReviewsView extends StatelessWidget {
  const ClientReviewsView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock Data for "My Reviews" 
    final List<Map<String, dynamic>> myReviews = [
      {
        'reviewText': "Alex was fantastic! He assembled my furniture quickly and flawlessly. Very professional and polite.",
        'rating': 5.0,
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'helper': HelperModel(
          id: '1',
          name: 'Alex Smith',
          avatarUrl: AppImages.alexSmith,
          rating: 4.8,
          totalTasks: 120,
          location: 'San Francisco, CA',
          distance: '2.5 miles',
          bio: 'Expert in furniture assembly and heavy lifting.',
          category: 'Furniture Assembly',
          skills: [
            SkillModel(name: 'Assembly', icon: '', tasksCompleted: 50),
            SkillModel(name: 'Moving', icon: '', tasksCompleted: 70),
          ],
          reviews: [],
        ),
      },
      {
        'reviewText': "Priya helped with organizing my garage. She had great ideas but was a bit late.",
        'rating': 4.0,
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'helper': HelperModel(
          id: '2',
          name: 'Priya Sharma',
          avatarUrl: AppImages.priya,
          rating: 4.5,
          totalTasks: 85,
          location: 'San Jose, CA',
          distance: '5 miles',
          bio: 'Professional organizer and cleaner.',
          category: 'Home Assistance',
          skills: [
            SkillModel(name: 'Cleaning', icon: '', tasksCompleted: 40),
            SkillModel(name: 'Organizing', icon: '', tasksCompleted: 45),
          ],
          reviews: [],
        ),
      },
      {
        'reviewText': "David fixed the leaky faucet in no time. Highly recommended for minor plumbing issues.",
        'rating': 5.0,
        'date': DateTime.now().subtract(const Duration(days: 45)),
        'helper': HelperModel(
          id: '3',
          name: 'David Lee',
          avatarUrl: AppImages.david,
          rating: 4.9,
          totalTasks: 210,
          location: 'Oakland, CA',
          distance: '3.2 miles',
          bio: 'Handyman specializing in minor repairs and plumbing.',
          category: 'Minor Repairs',
          skills: [
            SkillModel(name: 'Plumbing', icon: '', tasksCompleted: 110),
            SkillModel(name: 'Repairs', icon: '', tasksCompleted: 100),
          ],
          reviews: [],
        ),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'My Reviews',
      ),
      body: myReviews.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_border, size: 60, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  Text(
                    "You haven't submitted any reviews yet.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: myReviews.length,
              itemBuilder: (context, index) {
                final reviewMap = myReviews[index];
                final reviewText = reviewMap['reviewText'] as String;
                final rating = reviewMap['rating'] as double;
                final date = reviewMap['date'] as DateTime;
                final helper = reviewMap['helper'] as HelperModel;

                return _buildReviewCard(
                  context: context,
                  reviewText: reviewText,
                  rating: rating,
                  date: date,
                  helper: helper,
                );
              },
            ),
    );
  }

  Widget _buildReviewCard({
    required BuildContext context,
    required String reviewText,
    required double rating,
    required DateTime date,
    required HelperModel helper,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Helper Info Section - Tappable
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              onTap: () {
                // Navigate to Helper Profile and pass the HelperModel
                Get.toNamed(Routes.HELPER_PROFILE, arguments: helper);
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage(helper.avatarUrl),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            helper.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Helper • ${helper.category}",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Color(0xFFBDBDBD),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFF0F0F0)),
          
          // Review Content Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating Stars
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating.floor() 
                              ? Icons.star 
                              : (index < rating ? Icons.star_half : Icons.star_border),
                          color: const Color(0xFF6CA34D), // Green-accented stars
                          size: 18,
                        );
                      }),
                    ),
                    // Date
                    Text(
                      DateFormat('MMM d, yyyy').format(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Review Text
                Text(
                  "\"$reviewText\"",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade800,
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
