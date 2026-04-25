import '../../core/constants/app_images.dart';
import '../models/helper_model.dart';

class HelperMockData {
  static List<HelperModel> getHelpers() {
    return [
      HelperModel(
        id: '1',
        name: 'Alex Smith',
        avatarUrl: AppImages.alexSmith,
        rating: 5.0,
        totalTasks: 10,
        location: 'San Francisco CA',
        distance: '2.5 km',
        bio: 'Top-rated service provider with proven experience in furniture assembly and general maintenance.',
        isVerified: true,
        category: 'Furniture assembly',
        skills: [
          SkillModel(name: 'Home assistance', icon: AppImages.homeAssistance, tasksCompleted: 5),
          SkillModel(name: 'Furniture assembly', icon: AppImages.furnitureAssembly, tasksCompleted: 3),
          SkillModel(name: 'Lock smith', icon: AppImages.lockSmith, tasksCompleted: 2),
        ],
        reviews: [
          ReviewModel(
            id: 'r1',
            reviewerName: 'Courtney Henry',
            reviewerAvatar: AppImages.jason,
            rating: 5.0,
            timeAgo: '1 day ago',
            text: 'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullam.',
          ),
          ReviewModel(
            id: 'r2',
            reviewerName: 'Courtney Henry',
            reviewerAvatar: AppImages.priya,
            rating: 5.0,
            timeAgo: '1 day ago',
            text: 'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullam.',
          ),
          ReviewModel(
            id: 'r3',
            reviewerName: 'Courtney Henry',
            reviewerAvatar: AppImages.david,
            rating: 5.0,
            timeAgo: '1 day ago',
            text: 'Consequat velit qui adipisicing sunt do rependerit ad laborum tempor ullam.',
          ),
        ],
      ),
      HelperModel(
        id: '2',
        name: 'Michael Chen',
        avatarUrl: AppImages.michael,
        rating: 4.8,
        totalTasks: 45,
        location: 'San Jose CA',
        distance: '5.2 km',
        bio: 'Fast, reliable, and highly reviewed expert in minor repairs.',
        isVerified: true,
        category: 'Minor Repairs',
        skills: [
          SkillModel(name: 'Minor Repairs', icon: AppImages.minorRepairs, tasksCompleted: 45),
        ],
        reviews: [
          ReviewModel(
            id: 'r4',
            reviewerName: 'Sarah Jenkins',
            reviewerAvatar: AppImages.emily,
            rating: 4.0,
            timeAgo: '3 days ago',
            text: 'Great work, very fast.',
          ),
        ],
      ),
      HelperModel(
        id: '3',
        name: 'Emily Davis',
        avatarUrl: AppImages.emily,
        rating: 4.5,
        totalTasks: 120,
        location: 'Oakland CA',
        distance: '1.2 km',
        bio: 'Experienced pet sitter and dog walker with a deep love for animals.',
        isVerified: true,
        category: 'Pet Services',
        skills: [
          SkillModel(name: 'Pet Services', icon: AppImages.petServices, tasksCompleted: 120),
        ],
        reviews: [
          ReviewModel(
            id: 'r5',
            reviewerName: 'John Doe',
            reviewerAvatar: AppImages.alexSmith,
            rating: 4.5,
            timeAgo: '1 week ago',
            text: 'Emily was great with my dog. Highly recommend!',
          ),
        ],
      ),
      HelperModel(
        id: '4',
        name: 'David Wilson',
        avatarUrl: AppImages.david,
        rating: 4.9,
        totalTasks: 80,
        location: 'San Mateo CA',
        distance: '8.0 km',
        bio: 'Professional gardener delivering top quality garden cleaning and care.',
        isVerified: true,
        category: 'Garden Cleaning',
        skills: [
          SkillModel(name: 'Garden Cleaning', icon: AppImages.gardenCleaning, tasksCompleted: 80),
        ],
        reviews: [
          ReviewModel(
            id: 'r6',
            reviewerName: 'Alice Johnson',
            reviewerAvatar: AppImages.priya,
            rating: 5.0,
            timeAgo: '2 weeks ago',
            text: 'My garden looks amazing. Thanks David!',
          ),
        ],
      ),
    ];
  }
}
