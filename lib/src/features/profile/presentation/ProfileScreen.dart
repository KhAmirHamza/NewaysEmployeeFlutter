// ignore_for_file: file_names, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:material_dialogs/shared/types.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:neways3/src/features/attendence/presentation/AttendenceScreen.dart';
import 'package:neways3/src/features/profile/controller/ProfileController.dart';
import 'package:neways3/src/features/profile/presentation/MyHolidayCalender.dart';
import 'package:neways3/src/features/profile/presentation/MyHolidaysScreen.dart';
import 'package:neways3/src/features/salary/presentation/SalaryScreen.dart';
import 'package:neways3/src/features/wallet/presentation/WalletScreen.dart';
import 'package:neways3/src/features/wifi/controller/MyWifiController.dart';
import 'package:neways3/src/utils/constants.dart';
import 'package:neways3/src/utils/size_config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/functions.dart';
import '../../increament/components/IncreamentScreen.dart';
import '../../linked_devices/presentation/LinkedDeviceScreen.dart';
import '../../password_change/SecurityScreen.dart';
import '../../update_apps/UpdateAppsScreen.dart';
import 'ProfileDetailsScreen.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:store_redirect/store_redirect.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final MyWifiController myWifiController = Get.put(MyWifiController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (controller) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                    top: DPadding.full,
                    left: DPadding.full,
                    right: DPadding.full),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeightSpace(height: DPadding.full),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(DPadding.half),
                          child: CachedNetworkImage(
                            imageUrl: controller.box.read('avater').toString(),
                            width: 65,
                            height: 65,
                            fit: BoxFit.fill,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: DColors.background,
                              highlightColor: Colors.blueGrey.shade100,
                              child: Container(
                                color: DColors.background,
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        WidthSpace(width: DPadding.full),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.box.read('name'),
                                  style: DTextStyle.textTitleStyle),
                              HeightSpace(height: DPadding.half / 2),
                              Text(
                                  "🎉 ${controller.box.read('designationName')}",
                                  style: DTextStyle.textSubTitleStyle),
                              if(false)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5.0),
                                child: LinearPercentIndicator(
                                  barRadius: Radius.circular(15),
                                  width: 121.0,
                                  animation: true,
                                  animationDuration: 1500,
                                  lineHeight: 16.0,
                                  leading: Text("🎉 ${controller.box.read('designationName')}",
                                      style: DTextStyle.textSubTitleStyle),
                                  trailing: InkWell(
                                    onTap: (){

                                      Dialogs.materialDialog(
                                          color: Colors.white,
                                          msg: '"ABC-DEF" is your next designation',
                                          title: 'ABC-DEF',
                                          titleStyle: const TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                                          lottieBuilder: Lottie.asset(
                                            'assets/lottie/congratulations.json',
                                            fit: BoxFit.contain,
                                          ),
                                          context: context,
                                          actions: [
                                            IconsButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              text: 'Okay',
                                              iconData: Icons.done,
                                              color: DColors.primary,
                                              textStyle: const TextStyle(color: Colors.white),
                                              iconColor: Colors.white,
                                            ),
                                          ]);

                                    },
                                    child: Text("Next"),
                                  ),
                                  percent: 0.7,
                                  center:  const Text(
                                    "70.0%",
                                    style: TextStyle(fontSize: 12.0),
                                  ),
                                  progressColor: DColors.secondary,
                                  backgroundColor: DColors.background,

                                ),
                              ),

                              const HeightSpace(height: 4),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: DPadding.full,
                                    vertical: DPadding.half / 2),
                                decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.2),
                                    borderRadius:
                                        BorderRadius.circular(DPadding.full)),
                                child: Text(
                                    controller.box.read('departmentName'),
                                    style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    HeightSpace(height: DPadding.full),
                    // Align(
                    //   alignment: Alignment.center,
                    //   child: TextButton.icon(
                    //     onPressed: () {
                    //       controller.logOut();
                    //       Navigator.pushReplacement(
                    //           context,
                    //           MaterialPageRoute(
                    //               builder: (context) => const LoginScreen()));
                    //     },
                    //     style: TextButton.styleFrom(
                    //       backgroundColor: DColors.background,
                    //       padding:
                    //           EdgeInsets.symmetric(horizontal: DPadding.full),
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(29.0),
                    //       ),
                    //     ),
                    //     icon: const Icon(Icons.power_settings_new_rounded),
                    //     label: const Text("Log Out"),
                    //   ),
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            HeightSpace(height: DPadding.full),
                            const Divider(),
                            Column(children: [
                              Row(children: [
                                const Text("Auto Connect "),
                                Expanded(
                                  child: Switch(
                                    // This bool value toggles the switch.
                                    value: myWifiController.wifiAutoConnect,
                                    activeColor: Colors.red,
                                    onChanged: (bool value) {
                                      setState(() {
                                        myWifiController.initializeMyWifiController(context);
                                        myWifiController.wifiAutoConnect = value;
                                        myWifiController.isWifiConnecting = !value;
                                      });
                                    },
                                  ),
                                ),
                              ],),
                            ],) ,

                            HeightSpace(height: DPadding.full),
                            const Divider(),
                            ProfileListTile(
                              icon: 'profile.svg',
                              title: 'Profile',
                              onPress: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ProfileDetailsScreen()))),
                            ),
                            const Divider(),
                            ProfileListTile(
                              icon: 'wallet.svg',
                              title: 'Wallet',
                              onPress: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WalletScreen()))),
                            ),
                            const Divider(),
                            ProfileListTile(
                              icon: 'money.svg',
                              title: 'Salary Payslip',
                              onPress: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SalaryScreen()))),
                            ),
                            const Divider(),
                            ProfileListTile(
                              icon: 'attendence.svg',
                              title: 'Attendence',
                              onPress: (() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AttendenceScreen()))),
                            ),const Divider(),
                            ProfileListTile(
                              icon: 'holiday.svg',
                              title: 'My Holidays',
                              onPress: (()
                              {

                              controller.getHolidays();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyHolidayCalender(controller)));
                                  }),
                            ),
                            const Divider(),
                            ProfileListTile(
                              icon: 'increament.svg',
                              title: 'Increament',
                              onPress: (() => Get.to(IncreamentScreen())),
                            ),
                            const Divider(),
                            ProfileListTile(
                              icon: 'desktop-login.svg',
                              title: 'Linked Devices',
                              onPress: (() =>
                                  Get.to(const LinkedDeviceScreen())),
                            ),
                            const Divider(),
                            ProfileListTile(
                              icon: 'security.svg',
                              title: 'Security',
                              onPress: (() => Get.to(const SecurityScreen())),
                            ),
                            const Divider(),
                            ProfileListTile(
                              icon: 'new.svg',
                              title: "What's New",
                              onPress: (() {
                                defaultDialog(
                                  title: "What's New Updated Version!",
                                  okPress: () async {
                                    Get.back();
                                  },
                                  isAction: false,
                                  widget: Column(
                                    children: [
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                        horizontalTitleGap: 0,
                                        title: Text("Added Wallet Amount"),
                                      ),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                        horizontalTitleGap: 0,
                                        title: Text(
                                            "Created Increment/Decrement Data"),
                                      ),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                        horizontalTitleGap: 0,
                                        title: Text(
                                            "Created Security Page(password change)"),
                                      ),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                        horizontalTitleGap: 0,
                                        title: Text("Create Forgot Password"),
                                      ),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                        horizontalTitleGap: 0,
                                        title: Text("Some Design Change"),
                                      ),
                                      const ListTile(
                                        contentPadding: EdgeInsets.zero,
                                        dense: true,
                                        leading: Icon(
                                          Icons.check_box,
                                          color: Colors.green,
                                          size: 16,
                                        ),
                                        horizontalTitleGap: 0,
                                        title: Text("Bug Fixed"),
                                      ),
                                      const Divider(),
                                      TextButton(
                                          onPressed: () => Get.back(),
                                          style: TextButton.styleFrom(
                                              foregroundColor:
                                                  DColors.highLight,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: DPadding.full),
                                              backgroundColor: DColors.highLight
                                                  .withOpacity(0.2)),
                                          child: const Text('Close')),
                                    ],
                                  ),
                                );
                              }),
                            ),
                            const Divider(),
                            ProfileListTile(
                                icon: 'update.svg',
                                title: 'Update',
                                onPress: (() async {
                                  //PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                  //Get.to(UpdateAppsScreen(title: '', version:  packageInfo.version));
                                  StoreRedirect.redirect();
                                }
                                )),
                            const Divider(),
                            // ProfileListTile(
                            //   icon: 'setting.svg',
                            //   title: 'Setting',
                            //   onPress: (() {}),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final String icon;
  final String title;
  bool trailing;
  VoidCallback onPress;
  ProfileListTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onPress,
    this.trailing = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      dense: true,
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0,
      leading: SvgPicture.asset("assets/icons/$icon", width: 24, height: 24),
      title: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.grey.shade900),
      ),
      trailing: trailing
          ? Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: Colors.grey.shade600,
            )
          : const SizedBox(),
    );
  }
}
