// ignore_for_file: file_names, must_be_immutable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:neways3/src/features/contacts/presentation/ContactScreen.dart';
import 'package:neways3/src/features/employee_location/screens/EmployeeLocationScreen.dart';
import 'package:neways3/src/features/fired_employee/components/FiredApproveScreen.dart';
import 'package:neways3/src/features/leave/components/LeaveApproveScreen.dart';
import 'package:neways3/src/features/leave/components/LeaveScreen.dart';
import 'package:neways3/src/features/fired_employee/components/FiredEmployeeScreen.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/prebook/widgets/PrebookScreen.dart';
import 'package:neways3/src/features/purchase_money/components/PurchaseMoneyApproveScreen.dart';
import 'package:neways3/src/features/purchase_money/components/PurchaseMoneyScreen.dart';
import 'package:neways3/src/features/requisition/components/view_availablle_requisition.dart';
import 'package:neways3/src/features/task/components/DHeadTaskApproval.dart';
import 'package:neways3/src/features/workplace/controller/WorkplaceController.dart';
import 'package:neways3/src/features/workplace/model/PendingApproval.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/functions.dart';

import '../../advance_salary/components/AdvanceSalaryApproveScreen.dart';
import '../../advance_salary/components/AdvanceSalaryScreen.dart';
import '../../employee_location/controller/LocationController.dart';
import '../../leave/components/LeaveBossApproveScreen.dart';
import '../../employee_location/MyLocation.dart';
import '../../requisition/controllers/RequisitionController.dart';
import '../../resign/components/ResignAppliedScreen.dart';
import '../../resign/components/ResignApproveScreen.dart';
import '../../ta_da/components/TADAApprovalScreen.dart';
import '../../ta_da/components/TADAScreen.dart';
import '../../emergency_work/components/EmergencyWorkScreen.dart';
import '../../emergency_work/components/EmergencyWorkApproveScreen.dart';
import '../../task/components/TaskScreen.dart';

class WorkplaceScreen extends StatefulWidget {
  LocationController locationController;
  WorkplaceScreen( this.locationController, {Key? key}) : super(key: key);

  @override
  State<WorkplaceScreen> createState() => _WorkplaceScreenState();
}

class _WorkplaceScreenState extends State<WorkplaceScreen> {
  final scrollController = ScrollController();

  final requisitionController = Get.put(RequisitionController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: DColors.primary,
        statusBarIconBrightness: Brightness.light));


    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
    //   //determinePosition();
    //   // MyLocation.getLocationUpdates((Position position){
    //   //   print('2: ${position.latitude.toString()}, ${position.longitude.toString()}');
    //   //
    //   //   // WorkplaceController.updateLocation(position);
    //   // });
    //
    //   // await locationController.checkPermission();
    //   // //await locationController.getCurrentLocation();
    //   // //await locationController.getAddressFromLocationData();
    //   // await locationController.getContinuousLocationCallback((locationData) async {
    //   //
    //   //   if(locationController.placeMarks !=null && locationController.placeMarks!.isNotEmpty)
    //   //     {
    //   //       Placemark element = locationController.placeMarks![0];
    //   //
    //   //       String address = '${element.street!}, ${element.subLocality!}, ${element.locality!}, ${element.country!}';
    //   //       print(address);
    //   //
    //   //       showInSnackBar(context, address);
    //   //     }
    //   //
    //   //     // for (var element in locationController.placeMarks!) {
    //   //     //
    //   //     //
    //   //     //
    //   //     // }
    //   //
    //   // });
    // });

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
                              width: 120,
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
                        visible: (isDepHead && !controller.isHidden && !isBoss),
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
                                    pendingCount: controller.dHeadPendingApprovals.leave!,
                                    color: Colors.amberAccent,
                                    icon: Icons.airplane_ticket_outlined,
                                    onPress: () =>
                                        Get.to(const LeaveApproveScreen()),
                                    title: 'Leave',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.dHeadPendingApprovals.purchase!,
                                    color: Colors.lightBlueAccent,
                                    icon: Icons.shopping_cart_outlined,
                                    onPress: () => Get.to(
                                        const PurchaseMoneyApproveScreen()),
                                    title: 'Purchase',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.dHeadPendingApprovals.taDa!,
                                    color: Colors.blueAccent,
                                    icon: Icons.request_quote_outlined,
                                    onPress: () =>
                                        Get.to(const TADAApprovalScreen()),
                                    title: 'TA/DA',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.dHeadPendingApprovals.advance!,
                                    color: Colors.deepPurpleAccent,
                                    icon: Icons.payments_outlined,
                                    onPress: () => Get.to(
                                        const AdvanceSalaryApproveScreen()),
                                    title: 'Advance Salary',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.dHeadPendingApprovals.emergencyWork!,
                                    color: Colors.yellow,
                                    icon: Icons.emergency_share_rounded,
                                    onPress: () => Get.to(
                                        const EmergencyWorkApproveScreen()),
                                    title: 'Emergency Work',
                                  ),
                                  DashboardGrid(
                                    //endingCount: controller.dHeadPendingApprovals.car!,
                                    color: Colors.pinkAccent,
                                    icon: Icons.car_rental,
                                    onPress: () {},
                                    title: 'Car Requisition',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.dHeadPendingApprovals.resign!,
                                    color: Colors.teal,
                                    icon: Icons.work_off,
                                    onPress: () =>
                                        Get.to(const ResignApproveScreen()),
                                    title: 'Resign',
                                  ),

                                  DashboardGrid(
                                    pendingCount: controller.dHeadPendingApprovals.fired!,
                                    color: Colors.red,
                                    icon: Icons.directions_off,
                                    onPress: () =>
                                        Get.to(const FiredEmployeeScreen()),
                                    title: 'Fired',
                                  ),



                                  DashboardGrid(
                                    //pendingCount: controller.dHeadPendingApprovals.requisition!,
                                    color: Colors.green,
                                    icon: Icons.request_page_outlined,
                                    onPress: () {
                                      requisitionController.getAllAvailableRequisition(1, 3);
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) => ViewAvailableRequisition(requisitionController, 1, 3))
                                      );
                                    }, title: 'Requisition Approval',
                                  ),

                                  DashboardGrid(
                                    pendingCount: 0,
                                    color: Colors.blueAccent,
                                    icon: Icons.location_on_outlined,
                                    onPress: () =>
                                        Get.to(EmployeeLocationScreen(widget.locationController)),
                                    title: 'Location',
                                  ),

                                  // DashboardGrid(
                                  //   color: Colors.green,
                                  //   icon: Icons.work_off_outlined,
                                  //   onPress: () {
                                  //     Get.to(() => DHeadTaskApproval());,
                                  //

                                  //   }, title: 'Task Approval',
                                  // ),
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
                                    pendingCount: controller.bossPendingApprovals.leave!,
                                    color: Colors.amberAccent,
                                    icon: Icons.airplane_ticket_outlined,
                                    onPress: () =>
                                        Get.to(const LeaveBossApproveScreen()),
                                    title: 'Leave',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.bossPendingApprovals.purchase!,
                                    color: Colors.lightBlueAccent,
                                    icon: Icons.shopping_cart_outlined,
                                    onPress: () => Get.to(
                                        const PurchaseMoneyApproveScreen()),
                                    title: 'Purchase',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.bossPendingApprovals.taDa!,
                                    color: Colors.blueAccent,
                                    icon: Icons.request_quote_outlined,
                                    onPress: () =>
                                        Get.to(const TADAApprovalScreen()),
                                    title: 'TA/DA',
                                  ),
                                  DashboardGrid(
                                    pendingCount: controller.bossPendingApprovals.advance!,
                                    color: Colors.deepPurpleAccent,
                                    icon: Icons.payments_outlined,
                                    onPress: () => Get.to(
                                        const AdvanceSalaryApproveScreen()),
                                    title: 'Advance Salary',
                                  ),

                                  //if(controller.box.read("employeeId")== '72505')
                                  DashboardGrid(
                                    pendingCount: controller.bossPendingApprovals.emergencyWork!,
                                    color: Colors.yellow,
                                    icon: Icons.emergency_share_rounded,
                                    onPress: () => Get.to(
                                        const EmergencyWorkApproveScreen()),
                                    title: 'Emergency Work',
                                  ),
                                  if(controller.box.read("employeeId")== '72505')
                                  DashboardGrid(
                                    //pendingCount: controller.bossPendingApprovals!.car!,
                                    color: Colors.pinkAccent,
                                    icon: Icons.car_rental,
                                    onPress: () {},
                                    title: 'Car Requisition',
                                  ),
                                  //if(controller.box.read("employeeId")== '72505')
                                  DashboardGrid(
                                    pendingCount: controller.bossPendingApprovals.resign!,
                                    color: Colors.teal,
                                    icon: Icons.work_off,
                                    onPress: () =>
                                        Get.to(const ResignApproveScreen()),
                                    title: 'Resign',
                                  ),
                                  //if(controller.box.read("employeeId")== '72505')
                                  DashboardGrid(
                                    pendingCount: controller.bossPendingApprovals.fired!,
                                    color: Colors.red,
                                    icon: Icons.directions_off,
                                    onPress: () =>
                                        Get.to(const FiredApproveScreen()),//FiredEmployeeScreen()
                                    title: 'Fired',
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
  int pendingCount;
  DashboardGrid({
    required this.color,
    required this.icon,
    required this.title,
    required this.onPress,
    this.iconColor = Colors.white,
    this.pendingCount = 0,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(5),
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
          ),

          if(pendingCount>0)
          Positioned(
            top: 0,
            right: 7,
            child: Container(
              height: 20,
              width: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: color,
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.4),
                    spreadRadius: 1.2,
                    blurRadius:5,
                    offset: const Offset(4, -1), // changes position of shadow
                  ),
                ],
              ),
              child: Text("$pendingCount",style: const TextStyle(color: DColors.white, fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
    );
  }
}
