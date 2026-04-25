import 'package:flutter/material.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../home/widgets/job_card.dart';

class SavedTasksView extends StatelessWidget {
  const SavedTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    // Single Mock saved task structure to populate array securely
    final savedJobs = [
      {
        'title': 'Assemble an IKEA Desk',
        'category': 'Home assistance',
        'location': 'San Francisco CA',
        'price': 90,
        'duration': '1h',
        'date': '12 Jan, 2026',
        'time': '10:00 AM',
        'image': 'assets/images/user_avatar.png',
        'postedBy': 'Nicolas',
        'distance': '1.8 km',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Saved Tasks"),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: savedJobs.length,
        itemBuilder: (context, index) {
          return JobCard(
            job: savedJobs[index],
            onRequest: () {},
            onTapCard: () {},
          );
        },
      ),
    );
  }
}
