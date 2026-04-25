// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
// import '../../../../routes/app_pages.dart';
// import '../../custom_offer/views/custom_offer_view.dart';
// import '../controllers/profile_controller.dart';
//
// class ProfileView extends GetView<ProfileController> {
//   const ProfileView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CustomAppBar(
//         title: AppStrings.profile.tr,
//         showLeading: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.menu, color: Colors.black87),
//             onPressed: () => Get.toNamed(Routes.SETTINGS),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildProfileHeader(),
//             const SizedBox(height: 32),
//             _buildBioSection(),
//             const SizedBox(height: 32),
//             _buildPricingSection(),
//             const SizedBox(height: 32),
//             _buildAvailabilitySection(),
//             const SizedBox(height: 32),
//             _buildSkillsSection(),
//             const SizedBox(height: 32),
//             _buildPortfolioSection(),
//             const SizedBox(height: 32),
//             _buildReviewsSection(),
//             const SizedBox(height: 40),
//           ],
//         ),
//       ),
//       bottomNavigationBar: _buildBottomButton(),
//     );
//   }
//
//   Widget _buildProfileHeader() {
//     return Center(
//       child: Column(
//         children: [
//           Container(
//             padding: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               border: Border.all(color: const Color(0xFF6CA34D).withOpacity(0.3), width: 2),
//             ),
//             child: Obx(
//                   () => CircleAvatar(
//                 radius: 44,
//                 backgroundImage: AssetImage(controller.avatar.value),
//               ),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             controller.nameController.text, // "Justin Leo"
//             style: const TextStyle(
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//               color: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBioSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Bio",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Text(
//           "Hi, I'm Justin! I've been providing dedicated assistance for 5 years, specializing in home organizing and personal care. I love making life easier for people.",
//           style: TextStyle(
//             fontSize: 14,
//             color: Colors.grey.shade700,
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPricingSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Pricing Details",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.all(16),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF9F9F9),
//             borderRadius: BorderRadius.circular(12),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: [
//               // এখানে \$ দিয়ে এরর ফিক্স করা হয়েছে
//               _buildPriceItem("Hourly Rate", "\$30/hr", Icons.payments_outlined),
//               Container(width: 1, height: 40, color: Colors.grey.shade300),
//               _buildPriceItem("Min. Booking", "2 Hours", Icons.timer_outlined),
//             ],
//           ),
//         )
//       ],
//     );
//   }
//
//   Widget _buildPriceItem(String title, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(icon, color: const Color(0xFF6CA34D), size: 24),
//         const SizedBox(height: 8),
//         Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//         const SizedBox(height: 4),
//         Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
//       ],
//     );
//   }
//
//   Widget _buildAvailabilitySection() {
//     final days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Availability",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: days.map((day) {
//             Color bgColor;
//             Color textColor;
//
//             if (day == "Sat" || day == "Sun") {
//               bgColor = Colors.grey.shade100;
//               textColor = Colors.grey.shade500;
//             } else if (day == "Tue") {
//               bgColor = Colors.red.shade50;
//               textColor = Colors.red.shade400;
//             } else {
//               bgColor = const Color(0xFFE8F5E9);
//               textColor = const Color(0xFF6CA34D);
//             }
//
//             return Container(
//               width: 42,
//               padding: const EdgeInsets.symmetric(vertical: 12),
//               decoration: BoxDecoration(
//                 color: bgColor,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: textColor.withOpacity(0.3)),
//               ),
//               child: Center(
//                 child: Text(
//                   day,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.bold,
//                     color: textColor,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             _buildLegendItem(const Color(0xFF6CA34D), "Available"),
//             const SizedBox(width: 16),
//             _buildLegendItem(Colors.red.shade400, "Booked"),
//             const SizedBox(width: 16),
//             _buildLegendItem(Colors.grey.shade400, "Unavailable"),
//           ],
//         )
//       ],
//     );
//   }
//
//   Widget _buildLegendItem(Color color, String label) {
//     return Row(
//       children: [
//         Container(
//           width: 10,
//           height: 10,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         const SizedBox(width: 6),
//         Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
//       ],
//     );
//   }
//
//   Widget _buildSkillsSection() {
//     final List<String> skillsList = [
//       'Home Organizing',
//       'Meal Prep',
//       'Errands',
//       'Pet Care',
//       'Personal Assistance'
//     ];
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Skills",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: skillsList.map((skill) {
//             return Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: const Color(0xFF6CA34D).withOpacity(0.5)),
//               ),
//               child: Text(
//                 skill,
//                 style: const TextStyle(fontSize: 13, color: Color(0xFF6CA34D), fontWeight: FontWeight.w600),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildPortfolioSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text(
//               "Portfolio",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             GestureDetector(
//               onTap: () {},
//               child: const Text(
//                 "View all",
//                 style: TextStyle(color: Color(0xFF6CA34D), fontWeight: FontWeight.bold),
//               ),
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         SizedBox(
//           height: 100,
//           child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: 4,
//             itemBuilder: (context, index) {
//               return Container(
//                 width: 100,
//                 margin: const EdgeInsets.only(right: 12),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: Colors.grey.shade300),
//                 ),
//                 child: Center(
//                   child: Icon(Icons.image_outlined, color: Colors.grey.shade400, size: 32),
//                 ),
//               );
//             },
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildReviewsSection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           "Reviews",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 16),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Text(
//                   "4.8",
//                   style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
//                 ),
//                 Row(
//                   children: List.generate(
//                     5,
//                         (index) => const Icon(Icons.star, color: Colors.amber, size: 14),
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "35 Reviews",
//                   style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
//                 ),
//               ],
//             ),
//             const SizedBox(width: 20),
//             Expanded(
//               child: SizedBox(
//                 height: 85,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: 3,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       width: 220,
//                       margin: const EdgeInsets.only(right: 12),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.grey.shade200),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.02),
//                               blurRadius: 5,
//                               offset: const Offset(0, 2),
//                             )
//                           ]
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 12)),
//                           ),
//                           const SizedBox(height: 6),
//                           Text(
//                             "\"Justin was amazing! He organized my kitchen in no time.\"",
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey.shade700,
//                               fontStyle: FontStyle.italic,
//                               height: 1.4,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBottomButton() {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, -4),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         child: ElevatedButton(
//           onPressed: () {
//             Get.to(
//                   () => const CreateCustomOfferView(),
//               arguments: {
//                 'workerID': 'w123', // Mock ID
//                 'workerName': controller.nameController.text,
//                 'workerAvatar': controller.avatar.value,
//                 'categoryID': 'General Help',
//               },
//             );
//           },
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color(0xFF6CA34D),
//             minimumSize: const Size(double.infinity, 56),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//             ),
//             elevation: 0,
//           ),
//           child: const Text(
//             "Request this helper",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }
// }