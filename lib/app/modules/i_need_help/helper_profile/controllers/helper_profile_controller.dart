import 'package:get/get.dart';
import '../../../../data/models/helper_model.dart';

class HelperProfileController extends GetxController {
  late final HelperModel helper;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the passed helper object
    if (Get.arguments is HelperModel) {
      helper = Get.arguments as HelperModel;
    } else {
      // Fallback or error handling
      throw Exception('HelperProfileController needs a HelperModel argument.');
    }
  }

  // Double-Blind Review Filter
  List<ReviewModel> get visibleReviews {
    return helper.reviews.where((r) => r.isVisible).toList();
  }

  // Calculate review progress bar stats
  Map<int, double> getRatingPercentages() {
    final reviewsToCount = visibleReviews;
    if (reviewsToCount.isEmpty) {
       return {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    }

    final Map<int, int> counts = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (var review in reviewsToCount) {
      int score = review.rating.round();
      if (counts.containsKey(score)) {
        counts[score] = counts[score]! + 1;
      }
    }

    int total = reviewsToCount.length;
    return {
      5: counts[5]! / total,
      4: counts[4]! / total,
      3: counts[3]! / total,
      2: counts[2]! / total,
      1: counts[1]! / total,
    };
  }
}
