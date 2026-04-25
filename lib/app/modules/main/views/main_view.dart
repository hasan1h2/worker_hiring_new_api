import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../i_need_help/dashboard/views/dashboard_view.dart';
import '../../i_want_to_work/dashboard/views/worker_dashboard_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => IndexedStack(
            index: controller.activePhase.value - 1,
            children: const [DashboardView(), WorkerDashboardView()],
          ),
        ),
      ),
    );
  }
}
