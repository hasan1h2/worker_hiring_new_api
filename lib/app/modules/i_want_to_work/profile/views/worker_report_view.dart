import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/custom_appBar/custom_app_bar.dart';
import '../../../../core/constants/app_strings.dart';
import '../controllers/worker_report_controller.dart';

class WorkerReportView extends GetView<WorkerReportController> {
  const WorkerReportView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WorkerReportController());
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Earnings and Transactions',
          showLeading: true,
          bottom: TabBar(
            labelColor: const Color(0xFF6A9B5D),
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFF6A9B5D),
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: AppStrings.overview.tr),
              Tab(text: AppStrings.transactionHistory.tr),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildOverviewTab(), _buildTransactionHistoryTab()],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEarningSummaryCard(),
          const SizedBox(height: 32),
          const Text(
            "Latest Reports",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.latestReports.isEmpty) {
              return const Center(
                child: Text("No reports available yet.", style: TextStyle(color: Colors.grey)),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.latestReports.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, index) {
                final report = controller.latestReports[index];
                final isAvailable = report.status.toLowerCase() == 'available';
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  title: Text(
                    report.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      report.date,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        report.amount,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        report.status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isAvailable ? AppColors.primary : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildEarningSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          // Top Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                icon: Icons.account_balance_wallet,
                title: "Total\nPayouts",
                amountObx: controller.totalPayoutsAmount,
              ),
              _buildSummaryVerticalDivider(),
              _buildSummaryItem(
                icon: Icons.pending_actions,
                title: "Upcoming\nPayouts",
                amountObx: controller.upcomingAmount,
              ),
            ],
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: const Divider(height: 1, color: AppColors.border),
          ),
          
          // Bottom Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                icon: Icons.check_circle_outline,
                title: "Paid\nPayouts",
                amountObx: controller.paidAmount,
              ),
              _buildSummaryVerticalDivider(),
              _buildSummaryItem(
                icon: Icons.account_balance_wallet_outlined,
                title: "Available\nPayouts",
                amountObx: controller.availableAmount,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryVerticalDivider() {
    return Container(
      height: 60,
      width: 1,
      color: AppColors.border,
    );
  }

  Widget _buildSummaryItem({
    required IconData icon,
    required String title,
    required RxString amountObx,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(() => Text(
                amountObx.value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTransactionHistoryTab() {
    final List<Map<String, dynamic>> transactions = [
      {
        'date': 'Jan 10, 2026',
        'items': [
          {
            'refId': '778855203',
            'type': AppStrings.serviceFee.tr,
            'amount': '-\$10.24',
          },
          {
            'refId': '778855203',
            'type': AppStrings.deposit.tr,
            'amount': '\$80',
          },
        ],
      },
      {
        'date': 'Jan 12, 2026',
        'items': [
          {
            'refId': '778855203',
            'type': AppStrings.serviceFee.tr,
            'amount': '-\$28.01',
          },
          {
            'refId': '778855203',
            'type': AppStrings.deposit.tr,
            'amount': '\$180',
          },
        ],
      },
      {
        'date': 'Jan 18, 2026',
        'items': [
          {
            'refId': '778855203',
            'type': AppStrings.serviceFee.tr,
            'amount': '-\$9.80',
          },
          {
            'refId': '778855203',
            'type': AppStrings.deposit.tr,
            'amount': '\$85',
          },
        ],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final group = transactions[index];
        final items = group['items'] as List<Map<String, dynamic>>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              width: double.infinity,
              color: const Color(0xFFF9F9F9),
              child: Text(
                group['date'].toString(),
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.background),
            ...items.map((item) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.refId.trParams({'id': item['refId']}),
                              style: const TextStyle(
                                color: Color(0xFF6A9B5D),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['type'],
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          item['amount'],
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0.5, color: AppColors.textSecondary),
                ],
              );
            }),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
