// // ignore_for_file: must_be_immutable, file_names

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:neways3/src/features/contacts/controllers/QRCodeController.dart';
// import 'package:neways3/src/features/contacts/presentation/add_contact/QRCodeScreen.dart';
// import 'package:neways3/src/features/widgets/Header.dart';
// import 'package:neways3/src/utils/constants.dart';

// class AddContactScreen extends StatelessWidget {
//   const AddContactScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.symmetric(
//               horizontal: DPadding.full, vertical: DPadding.half),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               HeightSpace(height: DPadding.half),
//               const Header(title: "Add Contact"),
//               HeightSpace(height: DPadding.full),
//               Text(
//                 "Add Options",
//                 style: TextStyle(color: Colors.grey.shade600),
//               ),
//               Divider(thickness: 4, color: Colors.grey.shade100),
//               HeightSpace(height: DPadding.full),
//               AddContactOption(
//                 icon: Icons.search,
//                 color: Colors.blue,
//                 title: "Search",
//                 subtitle: "Add by company profile",
//                 onPress: () {},
//               ),
//               HeightSpace(height: DPadding.half),
//               const Divider(indent: 55),
//               HeightSpace(height: DPadding.half),
//               AddContactOption(
//                 icon: Icons.group_add,
//                 color: Colors.cyan,
//                 title: "Join Nearby Group",
//                 subtitle: "Join the same group you added",
//                 onPress: () {},
//               ),
//               HeightSpace(height: DPadding.half),
//               const Divider(indent: 55),
//               HeightSpace(height: DPadding.half),
//               AddContactOption(
//                 icon: Icons.qr_code_scanner_rounded,
//                 color: Colors.deepPurple,
//                 title: "Scan",
//                 subtitle: "Scan QR code card",
//                 onPress: () => Get.put(QRCodeController()).scanQR(),
//               ),
//               HeightSpace(height: DPadding.half),
//               const Divider(indent: 55),
//               HeightSpace(height: DPadding.half),
//               AddContactOption(
//                 icon: Icons.contact_phone,
//                 color: Colors.blue,
//                 title: "Phone Contacts",
//                 subtitle: "Add friends in your phone's contacts",
//                 onPress: () {},
//               ),
//               const Spacer(),
//               Align(
//                 alignment: Alignment.center,
//                 child: TextButton.icon(
//                     style: TextButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: DPadding.full),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(29)),
//                       backgroundColor: DColors.background,
//                     ),
//                     onPressed: () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => QRCodeScreen())),
//                     icon: const Icon(Icons.qr_code_rounded),
//                     label: const Text("My QR Code")),
//               ),
//               HeightSpace(height: DPadding.full * 2),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class AddContactOption extends StatelessWidget {
//   IconData icon;
//   Color color;
//   String title;
//   String subtitle;
//   VoidCallback onPress;
//   AddContactOption({
//     required this.icon,
//     required this.color,
//     required this.title,
//     required this.subtitle,
//     required this.onPress,
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: onPress,
//       child: Row(
//         children: [
//           Container(
//             padding: EdgeInsets.all(DPadding.half),
//             decoration: BoxDecoration(
//                 color: color,
//                 borderRadius: BorderRadius.circular(DPadding.half)),
//             child: Icon(
//               icon,
//               color: Colors.white,
//             ),
//           ),
//           WidthSpace(
//             width: DPadding.full,
//           ),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: DTextStyle.textTitleStyle3),
//               Text(
//                 subtitle,
//                 style: DTextStyle.textSubTitleStyle,
//               )
//             ],
//           ),
//           const Spacer(),
//           Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade500)
//         ],
//       ),
//     );
//   }
// }
