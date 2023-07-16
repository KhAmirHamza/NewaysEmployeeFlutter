// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:neways3/src/utils/constants.dart';

import 'package:timeago/timeago.dart' as timeago;
import '../bloc/NotificationController.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<NotificationController>(
            init: NotificationController(),
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: DPadding.full, vertical: DPadding.half),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notifications",
                            style: DTextStyle.textTitleStyle2),
                        // InkWell(
                        //     onTap: (() => Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //             builder: (context) =>
                        //                 const AddContactScreen()))),
                        //     child: Icon(
                        //       Icons.notifications_active_outlined,
                        //       size: 24,
                        //       color: Colors.grey.shade800,
                        //     )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: DPadding.full, vertical: DPadding.half),
                    child: Text(
                      "Earlier",
                      style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Visibility(
                    visible: controller.notifications.isEmpty,
                    child: Expanded(
                        child: Center(
                            child: Container(
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(
                        Icons.notifications_off_outlined,
                        color: Colors.red.shade300,
                        size: 50,
                      ),
                    ))),
                  ),
                  Visibility(
                    visible: controller.notifications.isNotEmpty,
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: controller.notifications.length,
                        itemBuilder: (context, int index) {
                          var notification = controller.notifications[index];
                          print(notification);
                          return NotificationContainer(
                            img: notification["image"],
                            isRead: notification['read'],
                            onPress: () {},
                            time: timeago.format(DateTime.tryParse(
                                notification['time'].toString())!),
                            title: notification['title'],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class NotificationContainer extends StatelessWidget {
  bool isRead;
  String? img;
  String title;
  String time;
  VoidCallback onPress;
  NotificationContainer({
    required this.isRead,
    this.img,
    required this.time,
    required this.title,
    required this.onPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(img);
    return InkWell(
      onTap: onPress,
      child: Container(
        color: isRead ? Colors.white : DColors.background,
        padding: EdgeInsets.symmetric(
            horizontal: DPadding.full, vertical: DPadding.half),
        child: Row(
          children: [
            img != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      img.toString(),
                      fit: BoxFit.cover,
                      width: 62,
                      height: 62,
                      errorBuilder: ((context, error, stackTrace) {
                        return Container(
                          padding: EdgeInsets.all(DPadding.half),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(100)),
                          child: const Icon(
                            Icons.notifications_active,
                            color: Colors.blue,
                            size: 28,
                          ),
                        );
                      }),
                    ),
                  )
                : Container(
                    padding: EdgeInsets.all(DPadding.half),
                    decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(100)),
                    child: const Icon(
                      Icons.notifications_active,
                      color: Colors.blue,
                      size: 28,
                    ),
                  ),
            const WidthSpace(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const HeightSpace(),
                  RichText(
                    text: TextSpan(
                      style: DTextStyle.textSubTitleStyle,
                      children: [
                        WidgetSpan(
                            child: Icon(
                          Icons.alarm_outlined,
                          size: 17,
                          color: Colors.grey.shade400,
                        )),
                        TextSpan(text: " $time ago")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // InkWell(
            //   onTap: () {},
            //   child: Icon(
            //     Icons.more_horiz_rounded,
            //     size: 24,
            //     color: Colors.grey.shade800,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
