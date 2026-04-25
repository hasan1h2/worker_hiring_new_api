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
import 'worker_report_view.dart';
import 'worker_support_ticket_view.dart';
import 'worker_support_ticket_history_view.dart';
import '../../saved_tasks/views/saved_tasks_view.dart';

class WorkerSettingsView extends GetView<WorkerProfileController> {
  const WorkerSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: "Settings"),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          _buildMenuItem(
            icon: AppImages.user,
            title: AppStrings.account.tr,
            trailingText: 'alexsmith@gmail.com',
            onTap: () => Get.to(() => const WorkerAccountView()),
          ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.verified_user_outlined,
            isIconData: true,
            iconData: Icons.verified_user_outlined,
            title: AppStrings.accountVerification.tr,
            trailing: Obx(
              () => controller.isVerified.value
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.check, size: 16, color: AppColors.primary),
                          const SizedBox(width: 4),
                          Text(
                            AppStrings.verified.tr,
                            style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ),
            onTap: () => Get.toNamed(Routes.WORKER_ACCOUNT_VERIFICATION),
          ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          // _buildMenuItem(
          //   icon: Icons.bookmark_border,
          //   isIconData: true,
          //   iconData: Icons.bookmark_border,
          //   title: "Saved Tasks",
          //   onTap: () => Get.to(() => const SavedTasksView()),
          // ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.monetization_on_outlined,
            title: "Payout Methods",
            iconData: Icons.monetization_on_outlined,
            isIconData: true,
            onTap: () => Get.to(() => const PayoutView()),
          ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.bar_chart_outlined,
            isIconData: true,
            iconData: Icons.bar_chart_outlined,
            title: "Earnings and Transactions",
            onTap: () => Get.to(() => const WorkerReportView()),
          ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.support_agent,
            isIconData: true,
            iconData: Icons.support_agent,
            title: AppStrings.supportTicket.tr,
            onTap: () => Get.to(() => const WorkerSupportTicketView()),
          ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.history,
            isIconData: true,
            iconData: Icons.history,
            title: AppStrings.ticketHistory.tr,
            onTap: () => Get.to(() => const WorkerSupportTicketHistoryView()),
          ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.person_add_outlined,
            title: "Invite a friend",
            iconData: Icons.person_add_outlined,
            isIconData: true,
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
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.info_outline,
            title: AppStrings.about.tr,
            iconData: Icons.info_outline,
            isIconData: true,
            onTap: () => Get.toNamed(Routes.ABOUT),
          ),
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
          
          _buildMenuItem(
            icon: Icons.exit_to_app_outlined,
            title: AppStrings.signOut.tr,
            isIconData: true,
            iconData: Icons.exit_to_app_outlined,
            onTap: () {
              Get.dialog(
                Dialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(color: Color(0xFFFFE5E5), shape: BoxShape.circle),
                          child: const Icon(Icons.logout, color: Color(0xFFFF3B30), size: 32),
                        ),
                        const SizedBox(height: 20),
                        Text(AppStrings.signOut.tr, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black)),
                        const SizedBox(height: 12),
                        Text(AppStrings.signOutConfirm.tr, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.5)),
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
                                child: const Text("Cancel", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                                child: const Text("Sign Out", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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
          const Divider(height: .5, indent: 16, endIndent: 16, color: AppColors.secondary),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required dynamic icon,
    required String title,
    VoidCallback? onTap,
    String? trailingText,
    bool isIconData = false,
    IconData? iconData,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: const Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(8)),
        child: isIconData
            ? Icon(iconData, color: Colors.black54)
            : SvgPicture.asset(icon, width: 24, height: 24),
      ),
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      trailing: trailing ??
          (trailingText != null
              ? Text(trailingText, style: const TextStyle(color: Colors.grey, fontSize: 14))
              : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)),
      onTap: onTap,
    );
  }
}
