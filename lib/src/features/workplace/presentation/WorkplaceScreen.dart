// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:neways3/src/features/leave/components/LeaveApproveScreen.dart';
import 'package:neways3/src/features/leave/components/LeaveScreen.dart';
import 'package:neways3/src/features/fired_employee/components/FiredEmployeeScreen.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/prebook/widgets/PrebookScreen.dart';
import 'package:neways3/src/features/purchase_money/components/PurchaseMoneyApproveScreen.dart';
import 'package:neways3/src/features/purchase_money/components/PurchaseMoneyScreen.dart';
import 'package:neways3/src/features/requisition/components/view_availablle_requisition.dart';
import 'package:neways3/src/features/workplace/controller/WorkplaceController.dart';
import 'package:neways3/src/utils/constants.dart';

import '../../advance_salary/components/AdvanceSalaryApproveScreen.dart';
import '../../advance_salary/components/AdvanceSalaryScreen.dart';
import '../../leave/components/LeaveBossApproveScreen.dart';
import '../../requisition/controllers/RequisitionController.dart';
import '../../resign/components/ResignAppliedScreen.dart';
import '../../resign/components/ResignApproveScreen.dart';
import '../../ta_da/components/TADAApprovalScreen.dart';
import '../../ta_da/components/TADAScreen.dart';
import '../../emergency_work/components/EmergencyWorkScreen.dart';
import '../../emergency_work/components/EmergencyWorkApproveScreen.dart';
import '../../task/components/TaskScreen.dart';

class WorkplaceScreen extends StatelessWidget {
  WorkplaceScreen({Key? key}) : super(key: key);
  final scrollController = ScrollController();
  final requisitionController = Get.put(RequisitionController());

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: DColors.primary,
        statusBarIconBrightness: Brightness.light));
    return SafeArea(
      child: GetBuilder<WorkplaceController>(
          init: WorkplaceController(),
          builder: (controller) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                title: RichText(
                  text: TextSpan(
                    text: "Welcome Back, ",
                    style: TextStyle(color: Colors.grey.shade200, fontSize: 18),
                    children: [
                      TextSpan(
                          text: "${controller.box.read('firstName')}!",
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold))
                    ],
                  ),
                ),
              ),
              body: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: EdgeInsets.all(DPadding.half),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeightSpace(height: DPadding.half),
                      Visibility(
                          visible: !isDepHead,
                          child: Text("DASHBOARD",
                              style: DTextStyle.textTitleStyle)),
                      Visibility(
                        visible: isDepHead && !isBoss,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("DASHBOARD", style: DTextStyle.textTitleStyle),
                            FlutterSwitch(
                              activeText: "APPROVEAL",
                              inactiveText: "DISABLE",
                              value: controller.isHidden,
                              valueFontSize: 13.0,
                              width: 100,
                              height: 32,
                              activeIcon: const Icon(Icons.check,
                                  color: DColors.primary),
                              inactiveIcon: const Icon(Icons.close_fullscreen,
                                  color: DColors.primary),
                              activeColor: DColors.primary,
                              activeTextColor: Colors.white,
                              inactiveColor: DColors.primary,
                              inactiveTextColor: Colors.white,
                              borderRadius: 30.0,
                              showOnOff: true,
                              onToggle: (val) {
                                controller.isHidden = val;
                                controller.update();
                              },
                            ),
                          ],
                        ),
                      ),
                      Visibility(visible: !isBoss, child: const HeightSpace()),
                      Visibility(
                        visible: !isBoss,
                        child: Container(
                          padding: EdgeInsets.all(DPadding.half),
                          decoration: BoxDecoration(
                              color: DColors.background,
                              borderRadius:
                                  BorderRadius.circular(DPadding.half)),
                          child: GridView.count(
                            controller: scrollController,
                            shrinkWrap: true,
                            crossAxisCount: 4,
                            children: [
                              DashboardGrid(
                                color: Colors.amber,
                                icon: Icons.airplane_ticket,
                                onPress: () => Get.to(const LeaveScreen()),
                                title: 'Leave',
                              ),
                              DashboardGrid(
                                color: Colors.blueGrey,
                                icon: Icons.shopping_cart,
                                onPress: () => Get.to(PurchaseMoneyScreen()),
                                title: 'Purchase',
                              ),
                              DashboardGrid(
                                color: Colors.blue,
                                icon: Icons.request_quote,
                                onPress: () => Get.to(const TADAScreen()),
                                title: 'TA/DA',
                              ),
                              DashboardGrid(
                                color: Colors.deepPurple,
                                icon: Icons.payments,
                                onPress: () =>
                                    Get.to(const AdvanceSalaryScreen()),
                                title: 'Advance Salary',
                              ),
                              DashboardGrid(
                                color: Colors.yellow,
                                icon: Icons.emergency_share_rounded,
                                onPress: () =>
                                    Get.to(const EmergencyWorkScreen()),
                                title: 'Emergency Work',
                              ),
                              DashboardGrid(
                                color: Colors.green,
                                icon: Icons.task_alt,
                                onPress: () async {
                                  await Get.to(const TaskScreen());
                                  SystemChrome.setSystemUIOverlayStyle(
                                      const SystemUiOverlayStyle(
                                          statusBarColor: DColors.primary,
                                          statusBarIconBrightness:
                                              Brightness.light));
                                  controller.update();
                                },
                                title: 'Task Manager',
                              ),
                              DashboardGrid(
                                color: Colors.cyan,
                                icon: Icons.local_atm,
                                onPress: () {},
                                title: 'Bill Submit',
                              ),
                              DashboardGrid(
                                color: Colors.brown,
                                icon: Icons.hourglass_empty,
                                onPress: () {},
                                title: 'Expense',
                              ),
                              DashboardGrid(
                                color: Colors.teal,
                                icon: Icons.work_off,
                                onPress: () =>
                                    Get.to(const ResignAppliedScreen()),
                                title: 'Resign',
                              ),
                              DashboardGrid(
                                color: Colors.white,
                                icon: Icons.add,
                                iconColor: Colors.black,
                                onPress: () {
                                  Get.snackbar(
                                      'New Module', "New model coming soon",
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(DPadding.full));
                                },
                                title: 'New Module',
                              ),
                              DashboardGrid(
                                color: Colors.white,
                                icon: Icons.add,
                                iconColor: Colors.black,
                                onPress: () {
                                  Get.snackbar(
                                      'New Module', "New model coming soon",
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(DPadding.full));
                                },
                                title: 'New Module',
                              ),
                              DashboardGrid(
                                color: Colors.white,
                                icon: Icons.add,
                                iconColor: Colors.black,
                                onPress: () {
                                  Get.snackbar(
                                      'New Module', "New model coming soon",
                                      snackPosition: SnackPosition.BOTTOM,
                                      margin: EdgeInsets.all(DPadding.full));
                                },
                                title: 'New Module',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Visibility(
                        visible: isDepHead && !controller.isHidden && !isBoss,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeightSpace(height: DPadding.full),
                            Text("APPROVAL", style: DTextStyle.textTitleStyle3),
                            const HeightSpace(),
                            Container(
                              padding: EdgeInsets.all(DPadding.half),
                              decoration: BoxDecoration(
                                  color: DColors.background,
                                  borderRadius:
                                      BorderRadius.circular(DPadding.half)),
                              child: GridView.count(
                                controller: scrollController,
                                shrinkWrap: true,
                                crossAxisCount: 4,
                                children: [
                                  DashboardGrid(
                                    color: Colors.amberAccent,
                                    icon: Icons.airplane_ticket_outlined,
                                    onPress: () =>
                                        Get.to(const LeaveApproveScreen()),
                                    title: 'Leave',
                                  ),
                                  DashboardGrid(
                                    color: Colors.lightBlueAccent,
                                    icon: Icons.shopping_cart_outlined,
                                    onPress: () => Get.to(
                                        const PurchaseMoneyApproveScreen()),
                                    title: 'Purchase',
                                  ),
                                  DashboardGrid(
                                    color: Colors.blueAccent,
                                    icon: Icons.request_quote_outlined,
                                    onPress: () =>
                                        Get.to(const TADAApprovalScreen()),
                                    title: 'TA/DA',
                                  ),
                                  DashboardGrid(
                                    color: Colors.deepPurpleAccent,
                                    icon: Icons.payments_outlined,
                                    onPress: () => Get.to(
                                        const AdvanceSalaryApproveScreen()),
                                    title: 'Advance Salary',
                                  ),
                                  DashboardGrid(
                                    color: Colors.yellow,
                                    icon: Icons.emergency_share_rounded,
                                    onPress: () => Get.to(
                                        const EmergencyWorkApproveScreen()),
                                    title: 'Emergency Work',
                                  ),
                                  DashboardGrid(
                                    color: Colors.pinkAccent,
                                    icon: Icons.car_rental,
                                    onPress: () {},
                                    title: 'Car Requisition',
                                  ),
                                  DashboardGrid(
                                    color: Colors.teal,
                                    icon: Icons.work_off,
                                    onPress: () =>
                                        Get.to(const ResignApproveScreen()),
                                    title: 'Resign',
                                  ),
                                  DashboardGrid(
                                    color: Colors.red,
                                    icon: Icons.work_off_outlined,
                                    onPress: () =>
                                        Get.to(const FiredEmployeeScreen()),
                                    title: 'Fired',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isBoss,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeightSpace(height: DPadding.full),
                            Text("REQUESTED",
                                style: DTextStyle.textTitleStyle3),
                            const HeightSpace(),
                            Container(
                              padding: EdgeInsets.all(DPadding.half),
                              decoration: BoxDecoration(
                                  color: DColors.background,
                                  borderRadius:
                                      BorderRadius.circular(DPadding.half)),
                              child: GridView.count(
                                controller: scrollController,
                                shrinkWrap: true,
                                crossAxisCount: 4,
                                children: [
                                  DashboardGrid(
                                    color: Colors.amberAccent,
                                    icon: Icons.airplane_ticket_outlined,
                                    onPress: () =>
                                        Get.to(const LeaveBossApproveScreen()),
                                    title: 'Leave',
                                  ),
                                  DashboardGrid(
                                    color: Colors.lightBlueAccent,
                                    icon: Icons.shopping_cart_outlined,
                                    onPress: () => Get.to(
                                        const PurchaseMoneyApproveScreen()),
                                    title: 'Purchase',
                                  ),
                                  DashboardGrid(
                                    color: Colors.blueAccent,
                                    icon: Icons.request_quote_outlined,
                                    onPress: () =>
                                        Get.to(const TADAApprovalScreen()),
                                    title: 'TA/DA',
                                  ),
                                  DashboardGrid(
                                    color: Colors.deepPurpleAccent,
                                    icon: Icons.payments_outlined,
                                    onPress: () => Get.to(
                                        const AdvanceSalaryApproveScreen()),
                                    title: 'Advance Salary',
                                  ),
                                  DashboardGrid(
                                    color: Colors.yellow,
                                    icon: Icons.emergency_share_rounded,
                                    onPress: () => Get.to(
                                        const EmergencyWorkApproveScreen()),
                                    title: 'Emergency Work',
                                  ),
                                  DashboardGrid(
                                    color: Colors.pinkAccent,
                                    icon: Icons.car_rental,
                                    onPress: () {},
                                    title: 'Car Requisition',
                                  ),
                                  DashboardGrid(
                                    color: Colors.teal,
                                    icon: Icons.work_off,
                                    onPress: () =>
                                        Get.to(const ResignApproveScreen()),
                                    title: 'Resign',
                                  ),
                                  DashboardGrid(
                                    color: Colors.red,
                                    icon: Icons.work_off_outlined,
                                    onPress: () =>
                                        Get.to(const FiredEmployeeScreen()),
                                    title: 'Fired',
                                  ),
                                  DashboardGrid(
                                    color: Colors.green,
                                    icon: Icons.work_off_outlined,
                                    onPress: () {
                                      requisitionController.getAllAvailableRequisition(1, 3);
                                    Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => ViewAvailableRequisition(requisitionController, 1, 3))
                                    );
                                    }, title: 'Requisition Approval',
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Lottie.asset(
                          'assets/lottie/office.json',
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * .8,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}

class DashboardGrid extends StatelessWidget {
  Color color;
  IconData icon;
  Color iconColor;
  String title;
  VoidCallback onPress;
  DashboardGrid({
    required this.color,
    required this.icon,
    required this.title,
    required this.onPress,
    this.iconColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(DPadding.full),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(DPadding.half),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  spreadRadius: 1.5,
                  blurRadius: 7,
                  offset: const Offset(8, 8), // changes position of shadow
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const HeightSpace(),
          Expanded(child: Text(title, style: DTextStyle.textSubTitleStyle2, textAlign: TextAlign.center, overflow: TextOverflow.fade, maxLines: 1,
            softWrap: false,),)
        ],
      ),
    );
  }
}
