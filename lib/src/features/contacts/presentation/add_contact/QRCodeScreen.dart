// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:neways3/src/features/contacts/controllers/QRCodeController.dart';
// import 'package:neways3/src/features/widgets/Header.dart';
// import 'package:neways3/src/utils/constants.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class QRCodeScreen extends StatelessWidget {
//   const QRCodeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<QRCodeController>(
//         init: QRCodeController(),
//         builder: (controller) {
//           return Scaffold(
//             body: SafeArea(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                     horizontal: DPadding.full, vertical: DPadding.half),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     HeightSpace(height: DPadding.half),
//                     const Header(title: "My QRCode"),
//                     HeightSpace(height: DPadding.full),
//                     Container(
//                       padding: EdgeInsets.all(DPadding.full),
//                       decoration: BoxDecoration(
//                           color: DColors.background,
//                           borderRadius: BorderRadius.circular(DPadding.half)),
//                       child: Text(
//                         "Add colleagues or employees easily by sharing your QR code. Your personal code is below.",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(color: Colors.grey.shade600),
//                       ),
//                     ),
//                     HeightSpace(height: DPadding.full),
//                     Center(
//                       child: RepaintBoundary(
//                         key: controller.qrKey,
//                         child: Image.network(
//                           GetStorage().read('avater').toString(),
//                           fit: BoxFit.fill,
//                           loadingBuilder: (BuildContext context, Widget child,
//                               ImageChunkEvent? loadingProgress) {
//                             if (loadingProgress == null) {
//                               return QrImage(
//                                 data: {
//                                   "employeeId": GetStorage()
//                                       .read('employeeId')
//                                       .toString(),
//                                   "name": GetStorage().read('name').toString(),
//                                   "avatar":
//                                       GetStorage().read('avater').toString(),
//                                   "designation": GetStorage()
//                                       .read('designationName')
//                                       .toString()
//                                 }.toString(),
//                                 version: QrVersions.auto,
//                                 size: MediaQuery.of(context).size.width * .8,
//                                 gapless: false,
//                                 padding: EdgeInsets.all(DPadding.half),
//                                 foregroundColor: DColors.primary,
//                                 backgroundColor: Colors.white,
//                                 embeddedImage:
//                                     NetworkImage(GetStorage().read('avater')),
//                                 embeddedImageStyle: QrEmbeddedImageStyle(
//                                   size: const Size(60, 60),
//                                 ),
//                               );
//                             }
//                             return QrImage(
//                               data: {
//                                 "employeeId":
//                                     GetStorage().read('employeeId').toString(),
//                                 "name": GetStorage().read('name').toString(),
//                                 "avatar":
//                                     GetStorage().read('avater').toString(),
//                                 "designation": GetStorage()
//                                     .read('designationName')
//                                     .toString()
//                               }.toString(),
//                               version: QrVersions.auto,
//                               size: MediaQuery.of(context).size.width * .8,
//                               gapless: false,
//                               padding: EdgeInsets.all(DPadding.half),
//                               foregroundColor: DColors.primary,
//                               backgroundColor: Colors.white,
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     HeightSpace(height: DPadding.full),
//                     Center(
//                       child: Text(
//                         GetStorage().read('name'),
//                         style: const TextStyle(
//                           color: DColors.primary,
//                           fontSize: 24,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     HeightSpace(height: DPadding.full),
//                     Align(
//                       alignment: Alignment.center,
//                       child: TextButton.icon(
//                           style: TextButton.styleFrom(
//                             padding:
//                                 EdgeInsets.symmetric(horizontal: DPadding.full),
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(29)),
//                             backgroundColor: DColors.background,
//                           ),
//                           onPressed: () => controller.takeScreenShot(),
//                           icon: controller.isLoading
//                               ? const SizedBox()
//                               : const Icon(Icons.screenshot),
//                           label: controller.isLoading
//                               ? const SizedBox(
//                                   width: 14,
//                                   height: 14,
//                                   child: CircularProgressIndicator())
//                               : const Text("Save QR Code")),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
