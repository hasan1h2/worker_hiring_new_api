import 'package:get/get.dart';

import '../../../../core/constants/app_images.dart';


class TaskerModel {
  final String name;
  final String avatar;
  final double rating;
  final int completedTasks;
  final String price;
  final String description;
  final List<String> skills; // Simple list for UI
  final List<ReviewModel> reviews;
  final String timeAgo; // e.g. "1h"
  final Map<int, double>
  ratingCounts; // Star rating (1-5) -> count/percentage (0.0 - 1.0) or raw count

  TaskerModel({
    required this.name,
    required this.avatar,
    required this.rating,
    required this.completedTasks,
    required this.price,
    required this.description,
    required this.skills,
    required this.reviews,
    required this.timeAgo,
    required this.ratingCounts,
  });
}

class ReviewModel {
  final String reviewerName;
  final String reviewerAvatar; // Mock same avatar for now
  final double rating;
  final String timeAgo;
  final String comment;

  ReviewModel({
    required this.reviewerName,
    required this.reviewerAvatar,
    required this.rating,
    required this.timeAgo,
    required this.comment,
  });
}

class RequestController extends GetxController {
  final RxList<TaskerModel> candidates = <TaskerModel>[
    TaskerModel(
      name: 'Alex Smith',
      avatar: AppImages.alexSmith,
      rating: 5.0,
      completedTasks: 10,
      price: '\$90',
      description:
          'Top-rated service provider with proven experience in furniture assembly...',
      skills: [
        'Home assistance: 5 task completed',
        'Furniture assembly: 3 task completed',
        'Lock smith: 2 task completed',
      ],
      reviews: List.generate(
        3,
        (index) => ReviewModel(
          reviewerName: 'Courtney Henry',
          reviewerAvatar: AppImages.alexSmith, // Mock
          rating: 5.0,
          timeAgo: '1 day ago',
          comment:
              'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullam.',
        ),
      ),
      timeAgo: '1h',
      ratingCounts: {5: 1.0, 4: 0.8, 3: 0.4, 2: 0.2, 1: 0.1},
    ),
    TaskerModel(
      name: 'Jason Lee',
      avatar: AppImages.jason,
      rating: 5.0,
      completedTasks: 6,
      price: '\$90',
      description: 'Top-rated service provider...',
      skills: [],
      reviews: [],
      timeAgo: '3h',
      ratingCounts: {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0},
    ),
    TaskerModel(
      name: 'Priya Patel',
      avatar: AppImages.priya,
      rating: 5.0,
      completedTasks: 2,
      price: '\$90',
      description: 'Top-rated service provider...',
      skills: [],
      reviews: [],
      timeAgo: '4h',
      ratingCounts: {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0},
    ),
    TaskerModel(
      name: 'David Miller',
      avatar: AppImages.david,
      rating: 5.0,
      completedTasks: 4,
      price: '\$90',
      description: 'Top-rated service provider...',
      skills: [],
      reviews: [],
      timeAgo: '5h',
      ratingCounts: {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0},
    ),
    TaskerModel(
      name: 'Emily Johnson',
      avatar: AppImages.emily,
      rating: 5.0,
      completedTasks: 5,
      price: '\$90',
      description: 'Top-rated service provider...',
      skills: [],
      reviews: [],
      timeAgo: '6h',
      ratingCounts: {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0},
    ),
    TaskerModel(
      name: 'Ryan Patel',
      avatar: AppImages.ryan,
      rating: 5.0,
      completedTasks: 9,
      price: '\$90',
      description: 'Top-rated service provider...',
      skills: [],
      reviews: [],
      timeAgo: '7h',
      ratingCounts: {5: 0.0, 4: 0.0, 3: 0.0, 2: 0.0, 1: 0.0},
    ),
  ].obs;

  void onAccept(TaskerModel tasker) {
    Get.snackbar("Accepted", "You accepted ${tasker.name}");
  }

  void onMessage(TaskerModel tasker) {
    Get.snackbar("Message", "Chat with ${tasker.name}");
  }
}
