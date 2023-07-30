// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:neways3/src/features/contacts/presentation/ContactScreen.dart';
import 'package:neways3/src/features/message/ChatScreen.dart';
import 'package:neways3/src/features/notification/presentation/NotificationScreen.dart';
import 'package:neways3/src/features/phone_contact/controllers/PhoneContactController.dart';
import 'package:neways3/src/features/profile/presentation/ProfileScreen.dart';
import 'package:neways3/src/features/workplace/presentation/WorkplaceScreen.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

import '../contacts/controllers/ContactController.dart';
import '../contacts/models/employee_response_model.dart';
import '../message/controllers/ConvsCntlr.dart';
import '../message/controllers/SocketController.dart';
import '../message/models/OnlineEmployee.dart';
import '../profile/models/profile_response_model.dart';
import '../profile/services/profile_service.dart';

class MainPage extends StatefulWidget {
  Socket socket;
  int index;
  MainPage(this.socket, this.index, {Key? key }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  EmployeeResponseModel? currentEmployee;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));

    socket!.clearListeners();
    setupAllSocketListeners();

    socket?.on("notifyLeave", (data) {
      print("notifyLeave called: ");
      if(data==null) return;
      var jsonMap = data as Map<String, dynamic>;
      jsonMap['status'] = "0";
      OnlineEmployee newOnlineEmployee = OnlineEmployee.fromJson(jsonMap);
      int onlineEmployeeIndex = onlineEmployees.indexWhere((element) => element.employeeId==newOnlineEmployee.employeeId);
      print("Json Data: $jsonMap");
      print("Online Employee: ${newOnlineEmployee.toJson()}");
      print("Online Employee Index: $onlineEmployeeIndex");
      print("Leave an employee: employeeId: ${newOnlineEmployee.employeeId!}, socketId: ${newOnlineEmployee.socketId}, status:  ${newOnlineEmployee.status}, index:  $onlineEmployeeIndex");

      if(onlineEmployeeIndex > -1) {
        onlineEmployees.removeAt(onlineEmployeeIndex);
      }
      onlineEmployees.add(newOnlineEmployee);
      //convsController.conversations.refresh();
      // print("All Online Employees: ");
      // for(int i=0; i<onlineEmployees.length; i++){
      //   print(jsonEncode(onlineEmployees[i]));
      // }
      print(onlineEmployees.length);
      setState(() {});
    });
  }

 // late int index = 2;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ProfileService.me().then((value) async {
        if (value is ProfileResponseModel) {
          currentEmployee = EmployeeResponseModel(
              employeeId: value!.employeeId,
              roleName: value!.roleName,
              designationName: value!.designationName,
              departmentName: value!.departmentName,
              fullName: value!.fullName,
              personalPhone: value!.personalPhone,
              email: value!.email,
              photo: value!.photo,
              companyPhone: value!.companyPhone,
              companyEmail: value!.companyEmail,
              status: 0);
          convsController.setCurrentEmployee(currentEmployee!);
          convsController.getConversationByUserId();
          socket!.emit("Join", {"employee_id": value.employeeId, 'socket_id': socket!.id, 'status': "1", 'lastCheckIn': "12345"});
          setUpJoinAndLeaveListener(
              convsController.currentEmployee!.employeeId!);
          PhoneContactController().loadContacts(value!.employeeId, "employee");
        } else {
          return null;
        }
      });
    });

    final screens = [
      ChatScreen(socket!),
      const ContactScreen(),
      WorkplaceScreen(),
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
