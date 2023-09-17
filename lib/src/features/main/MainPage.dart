// ignore_for_file: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neways3/src/features/contacts/presentation/ContactScreen.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/notification/presentation/NotificationScreen.dart';
import 'package:neways3/src/features/phone_contact/controllers/PhoneContactController.dart';
import 'package:neways3/src/features/profile/presentation/ProfileScreen.dart';
import 'package:neways3/src/features/workplace/presentation/WorkplaceScreen.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import '../contacts/models/employee_response_model.dart';
//import '../message/controllers/SocketController.dart';
import '../employee_location/controller/LocationController.dart';
import '../message/models/OnlineEmployee.dart';
import '../profile/models/profile_response_model.dart';
import '../profile/services/profile_service.dart';

class MainPage extends StatefulWidget {
  final Socket socket;
  int index;
  MainPage(this.socket, this.index, {Key? key }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

getEmployeeData(Socket socket, Function(OnlineEmployee newOnlineEmployee) refreshMainPage){
  ProfileService.me().then((value) async {
    if (value is ProfileResponseModel) {
       EmployeeResponseModel currentEmployee = EmployeeResponseModel(
          employeeId: value.employeeId,
          roleName: value.roleName,
          designationName: value.designationName,
          departmentName: value.departmentName,
          fullName: value.fullName,
          personalPhone: value.personalPhone,
          email: value.email,
          photo: value.photo.toString().contains("http://erp.superhomebd.com/super_home/") ?
          value.photo: "http://erp.superhomebd.com/super_home/${value.photo!}" ,
          companyPhone: value.companyPhone,
          companyEmail: value.companyEmail,
          status: 0);
       convsController.setCurrentEmployee(currentEmployee);
    } else {
      return null;
    }
  });
}


class _MainPageState extends State<MainPage> {
  final LocationController locationController = Get.put(LocationController());

  refreshMainPage(OnlineEmployee newOnlineEmployee){
    setState(() {
      int onlineEmployeeIndex = onlineEmployees.indexWhere((element) => element.employeeId==newOnlineEmployee.employeeId);
      if(onlineEmployeeIndex > -1) {
        onlineEmployees.removeAt(onlineEmployeeIndex);
      }
      onlineEmployees.add(newOnlineEmployee);
    });
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));

    final box = GetStorage();

   // print("boxEmployeeId: ${box.read("employeeId")}");
    EmployeeResponseModel currentEmployee = EmployeeResponseModel(
      employeeId: box.read("employeeId"),
      roleName: box.read("roleName"),
      designationName: box.read("designationName"),
      departmentName: box.read("departmentName"),
      fullName: box.read("firstName"),
      personalPhone: null,
      email: null,
      photo: box.read("avater"),
      companyPhone: null,
      companyEmail: null,
      status: null,
      assign_group: null,
    );
    convsController.setCurrentEmployee(currentEmployee);

    widget.socket.clearListeners();
    setupAllSocketListeners();
    widget.socket.emit("Join", {"employee_id": box.read("employeeId"), 'socket_id': widget.socket.id, 'status': "1", 'lastCheckIn': "12345"});

    setUpJoinListener(convsController.currentEmployee!.employeeId!);
    setUpLeaveListener((newOnlineEmployee){
      refreshMainPage(newOnlineEmployee);
    });
    getEmployeeData(widget.socket, refreshMainPage);
    PhoneContactController().loadContacts(box.read("employeeId"), "employee");
    convsController.getConversationByUserId();
    setState(() {
    });
  }


  @override
  Widget build(BuildContext context) {



    final screens = [
      ChatScreen(widget.socket, locationController: locationController),
      const ContactScreen(),
      WorkplaceScreen(locationController),
      const NotificationScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
            indicatorColor: DColors.primary.withOpacity(0.2),
            labelTextStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey.shade700))),
        child: NavigationBar(
          height: 60,
          backgroundColor: const Color(0xFFf1f5fb),
          selectedIndex: widget.index,
          onDestinationSelected: ((value) => setState(() => widget.index = value)),
          animationDuration: const Duration(seconds: 1),
          // labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.message_outlined, size: 22),
                selectedIcon: Icon(
                  Icons.message_rounded,
                  color: DColors.primary,
                  size: 22,
                ),
                label: 'Message'),
            NavigationDestination(
                icon: Icon(Icons.contact_phone_outlined, size: 22),
                selectedIcon: Icon(
                  Icons.contact_phone_rounded,
                  color: DColors.primary,
                  size: 22,
                ),
                label: 'Contacts'),
            NavigationDestination(
                icon: Icon(Icons.dashboard_outlined, size: 22),
                selectedIcon: Icon(
                  Icons.dashboard_rounded,
                  color: DColors.primary,
                  size: 22,
                ),
                label: 'Workplace'),
            NavigationDestination(
                icon: Icon(Icons.notifications_outlined, size: 22),
                selectedIcon: Icon(
                  Icons.notifications_rounded,
                  color: DColors.primary,
                  size: 22,
                ),
                label: 'Notification'),
            NavigationDestination(
                icon: Icon(Icons.person_outline, size: 22),
                selectedIcon: Icon(
                  Icons.person_rounded,
                  color: DColors.primary,
                  size: 22,
                ),
                label: 'Me'),
          ],
        ),
      ),
    //  body: screens[index],
      body: screens[widget.index],
    );
  }
}
