// ignore_for_file: file_names, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neways3/src/utils/constants.dart';

import '../controller/ProfileDetailsController.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileDetailsController>(
          init: ProfileDetailsController(),
          builder: (controller) {
            return SafeArea(
              child: Column(
                children: [
                  HeightSpace(height: DPadding.half),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          margin: EdgeInsets.only(left: DPadding.half),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(DPadding.half),
                            color: DColors.background,
                          ),
                          child: const Icon(Icons.arrow_back,
                              color: DColors.primary),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Profile",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.quicksand(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                              color: DColors.primary),
                        ),
                      ),
                      const WidthSpace(),
                    ],
                  ),
                  HeightSpace(height: DPadding.full),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(DPadding.half / 2),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(100)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageUrl: controller.box.read('avater'),
                              width: 120,
                              height: 120,
                              fit: BoxFit.fill,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        HeightSpace(height: DPadding.half / 2),
                        Text(controller.box.read('name'),
                            style: DTextStyle.textTitleStyle2),
                        HeightSpace(height: DPadding.half / 2),
                        Text("🎉 ${controller.box.read('designationName')}",
                            style: DTextStyle.textSubTitleStyle),
                        const HeightSpace(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: DPadding.full,
                              vertical: DPadding.half / 2),
                          decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius:
                                  BorderRadius.circular(DPadding.full)),
                          child: Text(controller.box.read('departmentName'),
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                        ),
                        HeightSpace(height: DPadding.full),
                        if(controller.profile != null)
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(DPadding.half),
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.all(DPadding.full),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(DPadding.full),
                                        topRight:
                                            Radius.circular(DPadding.full))),
                                child: Column(
                                  children: [
                                    ProfileDetailsListTile(
                                      icon: Icons.person,
                                      title: 'Full Name',
                                      trailing: controller.profile!.fullName
                                          .toString(),
                                    ),
                                    const Divider(),
                                    ProfileDetailsListTile(
                                      icon: Icons.card_membership_rounded,
                                      title: 'Employee Id',
                                      trailing: controller.profile!.employeeId
                                          .toString(),
                                    ),
                                    const Divider(),
                                    ProfileDetailsListTile(
                                      icon: Icons.account_balance_rounded,
                                      title: 'Department',
                                      trailing:
                                          controller.profile!.departmentName,
                                    ),
                                    const Divider(),
                                    ProfileDetailsListTile(
                                      icon: Icons.work,
                                      title: 'Designation',
                                      trailing:
                                          controller.profile!.designationName,
                                    ),
                                    const Divider(),
                                    ProfileDetailsListTile(
                                      icon: Icons.call,
                                      title: 'Phone',
                                      trailing: controller
                                          .profile!.personalPhone
                                          .toString(),
                                    ),
                                    const Divider(),
                                    ProfileDetailsListTile(
                                      icon: Icons.email,
                                      title: 'Email',
                                      trailing:
                                          controller.profile!.email.toString(),
                                    ),
                                    const Divider(),
                                    ProfileDetailsListTile(
                                      icon: Icons.pages_rounded,
                                      title: 'Role',
                                      trailing: controller.profile!.roleName
                                          .toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class ProfileDetailsListTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String trailing;
  const ProfileDetailsListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: Icon(icon, size: 18),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.grey.shade900),
      ),
      trailing: Text(
        trailing,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Colors.grey.shade900),
      ),
    );
  }
}
