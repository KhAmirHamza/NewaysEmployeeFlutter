import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import '../../contacts/models/employee_response_model.dart';

class ContactPerson extends StatelessWidget {
  final EmployeeResponseModel employee;
  final Function(EmployeeResponseModel selectedEmployee)? onItemTap;
  const ContactPerson({
    required this.employee,
    required this.onItemTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: DPadding.half / 2),
      child: InkWell(
        onTap: ()=>{
          onItemTap!(employee)
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(DPadding.half),
              child: CachedNetworkImage(
                  imageUrl: employee.photo!,
                  placeholder: (context, url) =>
                  const CircularProgressIndicator(),
                  errorWidget: ((context, error, stackTrace) => Center(
                    child: Text(
                      "No Image",
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade400),
                    ),
                  )),
                  width: 48,
                  height: 48,
                  fit: BoxFit.fill),
            ),
            const WidthSpace(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  employee.fullName!,
                  style: DTextStyle.textTitleStyle3,
                ),
                Text(
                  employee.designationName!,
                  style: TextStyle(color: Colors.grey.shade500),
                )
              ],
            ),
            const Spacer(),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: employee.status! == 1 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

