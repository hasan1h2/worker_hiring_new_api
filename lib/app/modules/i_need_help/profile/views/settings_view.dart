import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:worker_hiring/app/modules/i_need_help/profile/views/worker_billing_list_view.dart';

import '../../../../core/constants/app_images.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../routes/app_pages.dart';
import '../controllers/profile_controller.dart';
import 'edit_profile_view.dart';
import 'support_ticket_view.dart';
import 'support_ticket_history_view.dart';

class SettingsView extends GetView<ProfileController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Settings"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Menu Items
            _buildMenuItem(
              icon: AppImages.user,
              title: AppStrings.account.tr,
              subtitle: "justinleo@gmail.com",
              onTap: () => Get.to(() => const EditProfileView()),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: AppImages.lock,
              title: AppStrings.changePassword.tr,
              onTap: () => Get.toNamed(Routes.CHANGE_PASSWORD),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: AppImages.wallet,
              title: AppStrings.payment.tr,
              onTap: () => Get.to(() => const WorkerBillingListView())
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: Icons.local_offer_outlined,
              title: 'Vouchers & offers',
              onTap: () => Get.toNamed(Routes.VOUCHERS_OFFERS),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: Icons.support_agent,
              title: AppStrings.supportTicket.tr,
              onTap: () => Get.to(() => const SupportTicketView()),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: Icons.history,
              title: AppStrings.ticketHistory.tr,
              onTap: () => Get.to(() => const SupportTicketHistoryView()),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: Icons.person_add_outlined,
              title: "Invite a friend",
              onTap: () {
                Get.dialog(
                  AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text("Invite a friend", textAlign: TextAlign.center),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Share this code with your friends:", textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFE5E5E5)),
                          ),
                          child: const Text("WORKER-2026-XQZ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2)),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(onPressed: () => Get.back(), child: const Text("Close", style: TextStyle(color: Color(0xFF6A9B5D)))),
                    ],
                  ),
                );
              },
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: AppImages.info,
              title: AppStrings.about.tr,
              onTap: () => Get.toNamed(Routes.ABOUT),
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
            _buildMenuItem(
              icon: Icons.logout,
              title: AppStrings.signOut.tr,
              onTap: () {
                Get.dialog(
                  Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              color: Color(0xFFFFE5E5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.logout,
                                color: Color(0xFFFF3B30), size: 32),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            AppStrings.signOut.tr,
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            AppStrings.signOutConfirm.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black54,
                                height: 1.5),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Get.back(),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    side: const BorderSide(color: Color(0xFFE5E5E5)),
                                  ),
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.signOut();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 14),
                                    backgroundColor: const Color(0xFFFF3B30),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    "Sign Out",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const Divider(
              height: 1,
              color: Color(0xFFF0F0F0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required dynamic icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      onTap: onTap,
      leading: icon is IconData
          ? Icon(
              icon,
              color: Colors.black87,
              size: 24,
            )
          : SvgPicture.asset(
              icon,
              width: 24,
              colorFilter: const ColorFilter.mode(
                Colors.black87,
                BlendMode.srcIn,
              ),
            ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      trailing: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
              ),
            )
          : const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFBDBDBD),
            ),
    );
  }
}
