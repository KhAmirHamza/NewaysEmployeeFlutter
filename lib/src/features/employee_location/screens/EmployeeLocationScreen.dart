import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../workplace/model/EmployeeLocation.dart';
import '../controller/LocationController.dart';

class EmployeeLocationScreen extends StatefulWidget {

  LocationController controller;
  EmployeeLocationScreen(this.controller, {super.key});



  @override
  State<EmployeeLocationScreen> createState() => _EmployeeLocationScreenState();
}

class _EmployeeLocationScreenState extends State<EmployeeLocationScreen> {
  @override
  Widget build(BuildContext context) {
    widget.controller.getEmployeesLocation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Locations'),
      ),
      body: GetBuilder<LocationController>(
        init: LocationController(),
        builder: ((controller) => ListView.builder(
            itemCount: controller.employeeLocations.length,
            itemBuilder: (context, index){
              return EmployeeLocationItem(employeeLocation: controller.employeeLocations[index]);
            }
        )),
      )
    );
  }
}


class EmployeeLocationItem extends StatelessWidget {
  final EmployeeLocation employeeLocation;
  const EmployeeLocationItem({required this.employeeLocation, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipOval(
              child: Image.network(employeeLocation.photo!, fit: BoxFit.cover, height: 50, width: 50,),
            ),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(employeeLocation.fullName??"N/A"),
                    Text(employeeLocation.address??"N/A"),
                    Text('${employeeLocation.latitude??"N/A"}, ${employeeLocation.longitude??"N/A"}'),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

